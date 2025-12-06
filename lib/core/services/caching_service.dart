// lib/core/services/caching_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

/// Enterprise-level caching service
/// Provides multi-level caching with automatic expiration and intelligent cleanup
class CachingService {
  factory CachingService() => _instance;
  CachingService._internal();
  static final CachingService _instance = CachingService._internal();

  // Memory cache (L1)
  final Map<String, CacheEntry> _memoryCache = <String, CacheEntry>{};

  // Disk cache directory
  Directory? _cacheDirectory;

  // Configuration
  static const int maxMemoryCacheSize = 100; // Number of entries
  static const int maxMemoryCacheSizeMB = 50; // Size in MB
  static const int maxDiskCacheSizeMB = 200; // Size in MB
  static const Duration defaultExpiration = Duration(hours: 24);
  static const Duration cleanupInterval = Duration(minutes: 30);

  // Timers
  Timer? _cleanupTimer;
  Timer? _memoryPressureTimer;

  // Statistics
  int _hitCount = 0;
  int _missCount = 0;
  int _evictionCount = 0;

  bool _isInitialized = false;

  /// Initialize the caching service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Setup cache directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      _cacheDirectory = Directory('${appDir.path}/nvs_cache');

      if (!await _cacheDirectory!.exists()) {
        await _cacheDirectory!.create(recursive: true);
      }

      // Start periodic cleanup
      _startPeriodicCleanup();

      // Load cache statistics
      await _loadCacheStatistics();

      _isInitialized = true;

      if (kDebugMode) {
        developer.log('Caching service initialized', name: 'CachingService');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to initialize caching service: $e',
          name: 'CachingService',
        );
      }
      rethrow;
    }
  }

  /// Get value from cache
  Future<T?> get<T>(
    String key, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    _ensureInitialized();

    // Try memory cache first (L1)
    final CacheEntry? memoryEntry = _memoryCache[key];
    if (memoryEntry != null && !memoryEntry.isExpired) {
      _hitCount++;

      if (memoryEntry.data is T) {
        return memoryEntry.data as T;
      } else if (fromJson != null && memoryEntry.data is Map<String, dynamic>) {
        try {
          return fromJson(memoryEntry.data as Map<String, dynamic>);
        } catch (e) {
          if (kDebugMode) {
            developer.log(
              'Failed to deserialize cached data for key $key: $e',
              name: 'CachingService',
            );
          }
        }
      }
    }

    // Try disk cache (L2)
    final Map<String, dynamic>? diskData = await _getDiskCache(key);
    if (diskData != null) {
      _hitCount++;

      // Promote to memory cache
      _memoryCache[key] = CacheEntry(
        data: diskData['data'],
        expiration: DateTime.parse(diskData['expiration']),
        size: _calculateSize(diskData['data']),
      );

      // Apply memory cache size limit
      _enforceMemoryCacheLimit();

      if (diskData['data'] is T) {
        return diskData['data'] as T;
      } else if (fromJson != null && diskData['data'] is Map<String, dynamic>) {
        try {
          return fromJson(diskData['data'] as Map<String, dynamic>);
        } catch (e) {
          if (kDebugMode) {
            developer.log(
              'Failed to deserialize disk cached data for key $key: $e',
              name: 'CachingService',
            );
          }
        }
      }
    }

    _missCount++;
    return null;
  }

  /// Set value in cache
  Future<void> set<T>(
    String key,
    T value, {
    Duration? expiration,
    bool diskCache = true,
  }) async {
    _ensureInitialized();

    final DateTime expirationTime =
        DateTime.now().add(expiration ?? defaultExpiration);
    final int size = _calculateSize(value);

    // Store in memory cache (L1)
    _memoryCache[key] = CacheEntry(
      data: value,
      expiration: expirationTime,
      size: size,
    );

    // Enforce memory cache limits
    _enforceMemoryCacheLimit();

    // Store in disk cache (L2) if requested
    if (diskCache) {
      await _setDiskCache(key, value, expirationTime);
    }

    if (kDebugMode) {
      developer.log(
        'Cached data for key $key (size: ${size}B, disk: $diskCache)',
        name: 'CachingService',
      );
    }
  }

  /// Remove value from cache
  Future<void> remove(String key) async {
    _ensureInitialized();

    // Remove from memory cache
    _memoryCache.remove(key);

    // Remove from disk cache
    await _removeDiskCache(key);
  }

  /// Clear all cache
  Future<void> clear() async {
    _ensureInitialized();

    // Clear memory cache
    _memoryCache.clear();

    // Clear disk cache
    await _clearDiskCache();

    // Reset statistics
    _hitCount = 0;
    _missCount = 0;
    _evictionCount = 0;

    if (kDebugMode) {
      developer.log('All caches cleared', name: 'CachingService');
    }
  }

  /// Check if key exists in cache
  Future<bool> contains(String key) async {
    _ensureInitialized();

    // Check memory cache
    final CacheEntry? memoryEntry = _memoryCache[key];
    if (memoryEntry != null && !memoryEntry.isExpired) {
      return true;
    }

    // Check disk cache
    return _diskCacheContains(key);
  }

  /// Get cache statistics
  Map<String, dynamic> getStatistics() {
    final int totalRequests = _hitCount + _missCount;
    final double hitRate =
        totalRequests > 0 ? (_hitCount / totalRequests * 100) : 0.0;

    final int memorySize = _memoryCache.values
        .map((CacheEntry entry) => entry.size)
        .fold<int>(0, (int sum, int size) => sum + size);

    return <String, dynamic>{
      'hitCount': _hitCount,
      'missCount': _missCount,
      'evictionCount': _evictionCount,
      'hitRate': hitRate.toStringAsFixed(2),
      'memoryEntries': _memoryCache.length,
      'memorySizeBytes': memorySize,
      'memorySizeMB': (memorySize / (1024 * 1024)).toStringAsFixed(2),
      'isInitialized': _isInitialized,
    };
  }

  /// Start periodic cleanup
  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(cleanupInterval, (Timer timer) {
      _performCleanup();
    });
  }

  /// Perform cache cleanup
  Future<void> _performCleanup() async {
    if (kDebugMode) {
      developer.log('Starting cache cleanup', name: 'CachingService');
    }

    // Clean expired entries from memory cache
    final List<String> expiredKeys = _memoryCache.entries
        .where((MapEntry<String, CacheEntry> entry) => entry.value.isExpired)
        .map((MapEntry<String, CacheEntry> entry) => entry.key)
        .toList();

    for (final String key in expiredKeys) {
      _memoryCache.remove(key);
      _evictionCount++;
    }

    // Clean expired entries from disk cache
    await _cleanupDiskCache();

    // Enforce size limits
    _enforceMemoryCacheLimit();
    await _enforceDiskCacheLimit();

    if (kDebugMode) {
      developer.log(
        'Cache cleanup completed, removed ${expiredKeys.length} expired entries',
        name: 'CachingService',
      );
    }
  }

  /// Enforce memory cache size limits
  void _enforceMemoryCacheLimit() {
    // Limit by number of entries
    while (_memoryCache.length > maxMemoryCacheSize) {
      _evictLeastRecentlyUsed();
    }

    // Limit by memory size
    final int totalSize = _memoryCache.values
        .map((CacheEntry entry) => entry.size)
        .fold<int>(0, (int sum, int size) => sum + size);

    const int maxSizeBytes = maxMemoryCacheSizeMB * 1024 * 1024;
    while (totalSize > maxSizeBytes && _memoryCache.isNotEmpty) {
      _evictLeastRecentlyUsed();
    }
  }

  /// Evict least recently used entry
  void _evictLeastRecentlyUsed() {
    if (_memoryCache.isEmpty) return;

    // Find oldest entry (simple LRU based on creation time)
    MapEntry<String, CacheEntry>? oldestEntry;
    for (final MapEntry<String, CacheEntry> entry in _memoryCache.entries) {
      if (oldestEntry == null ||
          entry.value.expiration.isBefore(oldestEntry.value.expiration)) {
        oldestEntry = entry;
      }
    }

    if (oldestEntry != null) {
      _memoryCache.remove(oldestEntry.key);
      _evictionCount++;
    }
  }

  /// Get data from disk cache
  Future<Map<String, dynamic>?> _getDiskCache(String key) async {
    try {
      final File file = File('${_cacheDirectory!.path}/${_hashKey(key)}.cache');
      if (!await file.exists()) return null;

      final String content = await file.readAsString();
      final Map<String, dynamic> data =
          jsonDecode(content) as Map<String, dynamic>;

      // Check expiration
      final DateTime expiration = DateTime.parse(data['expiration']);
      if (DateTime.now().isAfter(expiration)) {
        await file.delete();
        return null;
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to read disk cache for key $key: $e',
          name: 'CachingService',
        );
      }
      return null;
    }
  }

  /// Set data in disk cache
  Future<void> _setDiskCache(
    String key,
    dynamic value,
    DateTime expiration,
  ) async {
    try {
      final File file = File('${_cacheDirectory!.path}/${_hashKey(key)}.cache');
      final Map<String, dynamic> data = <String, dynamic>{
        'data': value,
        'expiration': expiration.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to write disk cache for key $key: $e',
          name: 'CachingService',
        );
      }
    }
  }

  /// Remove data from disk cache
  Future<void> _removeDiskCache(String key) async {
    try {
      final File file = File('${_cacheDirectory!.path}/${_hashKey(key)}.cache');
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to remove disk cache for key $key: $e',
          name: 'CachingService',
        );
      }
    }
  }

  /// Check if disk cache contains key
  Future<bool> _diskCacheContains(String key) async {
    try {
      final File file = File('${_cacheDirectory!.path}/${_hashKey(key)}.cache');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Clear all disk cache
  Future<void> _clearDiskCache() async {
    try {
      if (await _cacheDirectory!.exists()) {
        await for (final FileSystemEntity file in _cacheDirectory!.list()) {
          if (file is File && file.path.endsWith('.cache')) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('Failed to clear disk cache: $e', name: 'CachingService');
      }
    }
  }

  /// Cleanup expired disk cache entries
  Future<void> _cleanupDiskCache() async {
    try {
      await for (final FileSystemEntity file in _cacheDirectory!.list()) {
        if (file is File && file.path.endsWith('.cache')) {
          try {
            final String content = await file.readAsString();
            final Map<String, dynamic> data =
                jsonDecode(content) as Map<String, dynamic>;
            final DateTime expiration = DateTime.parse(data['expiration']);

            if (DateTime.now().isAfter(expiration)) {
              await file.delete();
            }
          } catch (e) {
            // Delete corrupted cache files
            await file.delete();
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to cleanup disk cache: $e',
          name: 'CachingService',
        );
      }
    }
  }

  /// Enforce disk cache size limits
  Future<void> _enforceDiskCacheLimit() async {
    try {
      int totalSize = 0;
      final List<File> files = <File>[];

      await for (final FileSystemEntity file in _cacheDirectory!.list()) {
        if (file is File && file.path.endsWith('.cache')) {
          final FileStat stat = await file.stat();
          totalSize += stat.size;
          files.add(file);
        }
      }

      const int maxSizeBytes = maxDiskCacheSizeMB * 1024 * 1024;
      if (totalSize > maxSizeBytes) {
        // Sort files by last modified (oldest first)
        files.sort(
          (File a, File b) =>
              a.lastModifiedSync().compareTo(b.lastModifiedSync()),
        );

        // Delete oldest files until under limit
        for (final File file in files) {
          if (totalSize <= maxSizeBytes) break;

          final FileStat stat = await file.stat();
          totalSize -= stat.size;
          await file.delete();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to enforce disk cache limit: $e',
          name: 'CachingService',
        );
      }
    }
  }

  /// Hash key for disk storage
  String _hashKey(String key) {
    return sha256.convert(utf8.encode(key)).toString();
  }

  /// Calculate approximate size of object
  int _calculateSize(dynamic object) {
    try {
      return utf8.encode(jsonEncode(object)).length;
    } catch (e) {
      return 1024; // Default size estimate
    }
  }

  /// Load cache statistics from disk
  Future<void> _loadCacheStatistics() async {
    // Implementation for loading persistent statistics
    // This would store hit/miss ratios and other metrics
  }

  /// Ensure service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'CachingService not initialized. Call initialize() first.',
      );
    }
  }

  /// Shutdown the service
  Future<void> shutdown() async {
    _cleanupTimer?.cancel();
    _memoryPressureTimer?.cancel();
    _memoryCache.clear();
    _isInitialized = false;

    if (kDebugMode) {
      developer.log('Caching service shutdown', name: 'CachingService');
    }
  }
}

/// Cache entry model
class CacheEntry {
  CacheEntry({
    required this.data,
    required this.expiration,
    required this.size,
  }) : created = DateTime.now();
  final dynamic data;
  final DateTime expiration;
  final int size;
  final DateTime created;

  bool get isExpired => DateTime.now().isAfter(expiration);
}

/// Cache key helper
class CacheKeys {
  static const String userProfile = 'user_profile';
  static const String matchResults = 'match_results';
  static const String chatMessages = 'chat_messages';
  static const String liveRooms = 'live_rooms';
  static const String proximityUsers = 'proximity_users';

  static String userProfileKey(String userId) => '${userProfile}_$userId';
  static String matchResultsKey(String userId) => '${matchResults}_$userId';
  static String chatMessagesKey(String threadId) => '${chatMessages}_$threadId';
  static String liveRoomKey(String roomId) => '${liveRooms}_$roomId';
  static String proximityKey(double lat, double lng) =>
      '${proximityUsers}_${lat}_$lng';
}
