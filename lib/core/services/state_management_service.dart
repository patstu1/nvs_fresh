// lib/core/services/state_management_service.dart

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enterprise-level state management service
/// Provides centralized state persistence, synchronization, and optimization
class StateManagementService {
  factory StateManagementService() => _instance;
  StateManagementService._internal();
  static final StateManagementService _instance =
      StateManagementService._internal();

  late SharedPreferences _prefs;
  final Map<String, dynamic> _memoryCache = <String, dynamic>{};
  final Map<String, Timer> _saveTimers = <String, Timer>{};
  final Set<String> _persistedKeys = <String>{};

  // Configuration
  static const Duration saveDelay = Duration(milliseconds: 500);
  static const String statePrefix = 'nvs_state_';
  static const int maxCacheSize = 1000;

  bool _isInitialized = false;

  /// Initialize the state management service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadPersistedState();
      _isInitialized = true;

      if (kDebugMode) {
        developer.log(
          'State management service initialized',
          name: 'StateManagement',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to initialize state management: $e',
          name: 'StateManagement',
        );
      }
      rethrow;
    }
  }

  /// Load persisted state from storage
  Future<void> _loadPersistedState() async {
    try {
      final Iterable<String> keys =
          _prefs.getKeys().where((String key) => key.startsWith(statePrefix));

      for (final String key in keys) {
        final String? value = _prefs.getString(key);
        if (value != null) {
          try {
            final decoded = jsonDecode(value);
            final String stateKey = key.substring(statePrefix.length);
            _memoryCache[stateKey] = decoded;
            _persistedKeys.add(stateKey);
          } catch (e) {
            if (kDebugMode) {
              developer.log(
                'Failed to decode state for key $key: $e',
                name: 'StateManagement',
              );
            }
          }
        }
      }

      if (kDebugMode) {
        developer.log(
          'Loaded ${_persistedKeys.length} persisted state entries',
          name: 'StateManagement',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to load persisted state: $e',
          name: 'StateManagement',
        );
      }
    }
  }

  /// Get state value
  T? getState<T>(String key, {T? defaultValue}) {
    _ensureInitialized();

    final value = _memoryCache[key];
    if (value is T) {
      return value;
    }

    return defaultValue;
  }

  /// Set state value with optional persistence
  void setState<T>(String key, T value, {bool persist = false}) {
    _ensureInitialized();

    // Update memory cache
    _memoryCache[key] = value;

    // Manage cache size
    _manageCacheSize();

    // Handle persistence
    if (persist) {
      _persistedKeys.add(key);
      _scheduleSave(key, value);
    } else {
      _persistedKeys.remove(key);
      _removePersisted(key);
    }

    if (kDebugMode && persist) {
      developer.log(
        'State updated with persistence: $key',
        name: 'StateManagement',
      );
    }
  }

  /// Remove state value
  void removeState(String key) {
    _ensureInitialized();

    _memoryCache.remove(key);
    _persistedKeys.remove(key);
    _removePersisted(key);

    // Cancel any pending save
    _saveTimers[key]?.cancel();
    _saveTimers.remove(key);
  }

  /// Clear all state
  Future<void> clearAllState() async {
    _ensureInitialized();

    _memoryCache.clear();
    _persistedKeys.clear();

    // Cancel all pending saves
    for (final Timer timer in _saveTimers.values) {
      timer.cancel();
    }
    _saveTimers.clear();

    // Clear persisted state
    final Iterable<String> keys =
        _prefs.getKeys().where((String key) => key.startsWith(statePrefix));
    for (final String key in keys) {
      await _prefs.remove(key);
    }

    if (kDebugMode) {
      developer.log('All state cleared', name: 'StateManagement');
    }
  }

  /// Schedule delayed save to storage
  void _scheduleSave<T>(String key, T value) {
    // Cancel existing timer for this key
    _saveTimers[key]?.cancel();

    // Schedule new save
    _saveTimers[key] = Timer(saveDelay, () async {
      await _saveToStorage(key, value);
      _saveTimers.remove(key);
    });
  }

  /// Save value to persistent storage
  Future<void> _saveToStorage<T>(String key, T value) async {
    try {
      final String encoded = jsonEncode(value);
      await _prefs.setString('$statePrefix$key', encoded);

      if (kDebugMode) {
        developer.log('State persisted: $key', name: 'StateManagement');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to persist state for key $key: $e',
          name: 'StateManagement',
        );
      }
    }
  }

  /// Remove value from persistent storage
  Future<void> _removePersisted(String key) async {
    try {
      await _prefs.remove('$statePrefix$key');
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Failed to remove persisted state for key $key: $e',
          name: 'StateManagement',
        );
      }
    }
  }

  /// Manage cache size to prevent memory issues
  void _manageCacheSize() {
    if (_memoryCache.length > maxCacheSize) {
      // Remove non-persisted entries first
      final List<String> nonPersistedKeys = _memoryCache.keys
          .where((String key) => !_persistedKeys.contains(key))
          .take(
            _memoryCache.length - maxCacheSize + 100,
          ) // Remove extra to avoid frequent cleanup
          .toList();

      for (final String key in nonPersistedKeys) {
        _memoryCache.remove(key);
      }

      if (kDebugMode) {
        developer.log(
          'Cache cleaned up, removed ${nonPersistedKeys.length} entries',
          name: 'StateManagement',
        );
      }
    }
  }

  /// Ensure service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'StateManagementService not initialized. Call initialize() first.',
      );
    }
  }

  /// Force save all pending changes
  Future<void> forceSaveAll() async {
    _ensureInitialized();

    // Cancel all timers and save immediately
    for (final MapEntry<String, Timer> entry in _saveTimers.entries) {
      entry.value.cancel();
      if (_persistedKeys.contains(entry.key)) {
        final value = _memoryCache[entry.key];
        if (value != null) {
          await _saveToStorage(entry.key, value);
        }
      }
    }
    _saveTimers.clear();

    if (kDebugMode) {
      developer.log('All pending state changes saved', name: 'StateManagement');
    }
  }

  /// Get state statistics
  Map<String, dynamic> getStateStatistics() {
    return <String, dynamic>{
      'totalEntries': _memoryCache.length,
      'persistedEntries': _persistedKeys.length,
      'pendingSaves': _saveTimers.length,
      'cacheUtilization': (_memoryCache.length / maxCacheSize * 100).round(),
      'isInitialized': _isInitialized,
    };
  }

  /// Export state data (for debugging/backup)
  Map<String, dynamic> exportState() {
    _ensureInitialized();
    return Map.from(_memoryCache);
  }

  /// Import state data (for debugging/restore)
  Future<void> importState(
    Map<String, dynamic> state, {
    bool persist = false,
  }) async {
    _ensureInitialized();

    for (final MapEntry<String, dynamic> entry in state.entries) {
      setState(entry.key, entry.value, persist: persist);
    }

    if (persist) {
      await forceSaveAll();
    }

    if (kDebugMode) {
      developer.log(
        'Imported ${state.length} state entries',
        name: 'StateManagement',
      );
    }
  }

  /// Shutdown the service
  Future<void> shutdown() async {
    await forceSaveAll();
    _memoryCache.clear();
    _persistedKeys.clear();
    _saveTimers.clear();
    _isInitialized = false;

    if (kDebugMode) {
      developer.log(
        'State management service shutdown',
        name: 'StateManagement',
      );
    }
  }
}

/// Riverpod provider for state management service
final Provider<StateManagementService> stateManagementServiceProvider =
    Provider<StateManagementService>((ProviderRef<StateManagementService> ref) {
  return StateManagementService();
});

/// Base class for state-aware providers
abstract class StateAwareNotifier<T> extends Notifier<T> {
  StateAwareNotifier(this.stateKey) {
    // Initialization will be handled in build()
  }

  final String stateKey;
  final StateManagementService _stateService = StateManagementService();

  /// Build initial state from persistence
  @override
  T build() {
    final savedState = _stateService.getState<T>(stateKey);
    return savedState ?? buildInitialState();
  }

  /// Override this to provide initial state when no saved state exists
  T buildInitialState();

  /// Update state with automatic persistence
  void updateState(T newState) {
    state = newState;
    _stateService.setState(stateKey, newState, persist: shouldPersist);
  }

  /// Override to control persistence
  bool get shouldPersist => true;

  /// Force save current state
  Future<void> saveState() async {
    _stateService.setState(stateKey, state, persist: true);
    await _stateService.forceSaveAll();
  }

  /// Clear saved state
  void clearState() {
    _stateService.removeState(stateKey);
  }
}

/// Persistent state provider helper
class PersistentStateProvider<T> extends StateNotifier<T> {
  PersistentStateProvider({
    required this.key,
    required T initialState,
    this.validator,
  }) : super(initialState) {
    _loadState();
  }

  final String key;
  final T Function(dynamic)? validator;
  final StateManagementService _stateService = StateManagementService();

  void _loadState() {
    final saved = _stateService.getState(key);
    if (saved != null) {
      try {
        final validated = validator != null ? validator!(saved) : saved as T;
        state = validated;
      } catch (e) {
        if (kDebugMode) {
          developer.log(
            'Failed to validate saved state for $key: $e',
            name: 'StateManagement',
          );
        }
      }
    }
  }

  @override
  set state(T value) {
    super.state = value;
    _stateService.setState(key, value, persist: true);
  }

  void clearPersistedState() {
    _stateService.removeState(key);
  }
}
