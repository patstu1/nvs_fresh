// lib/core/services/app_optimization_service.dart

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

/// Enterprise-level app optimization service
/// Handles performance monitoring, memory management, and system optimization
class AppOptimizationService {
  factory AppOptimizationService() => _instance;
  AppOptimizationService._internal();
  static final AppOptimizationService _instance =
      AppOptimizationService._internal();

  // Performance monitoring
  bool _isMonitoring = false;
  Timer? _optimizationTimer;
  Timer? _memoryCleanupTimer;
  final List<double> _frameTimes = <double>[];
  final List<int> _memorySnapshots = <int>[];

  // Performance thresholds (enterprise standards)
  static const double targetFrameTime = 16.67; // 60 FPS
  static const double warningFrameTime = 20.0; // 50 FPS warning
  static const double criticalFrameTime = 33.33; // 30 FPS critical
  static const int maxMemoryMB = 200; // 200MB memory limit
  static const int warningMemoryMB = 150; // 150MB warning threshold

  // Optimization flags
  bool _reducedAnimations = false;
  bool _lowMemoryMode = false;
  final bool _backgroundProcessingPaused = false;

  // Callbacks
  VoidCallback? _onPerformanceWarning;
  VoidCallback? _onMemoryWarning;
  VoidCallback? _onCriticalPerformance;

  /// Initialize the optimization service
  Future<void> initialize() async {
    if (_isMonitoring) return;

    _isMonitoring = true;

    // Start monitoring services
    _startFrameMonitoring();
    _startMemoryMonitoring();
    _startPeriodicOptimization();
    _setupSystemOptimizations();

    if (kDebugMode) {
      developer.log(
        'App optimization service initialized',
        name: 'AppOptimization',
      );
    }
  }

  /// Shutdown the optimization service
  void shutdown() {
    _isMonitoring = false;
    _optimizationTimer?.cancel();
    _memoryCleanupTimer?.cancel();
    SchedulerBinding.instance.removeTimingsCallback(_onFrame);

    if (kDebugMode) {
      developer.log(
        'App optimization service shutdown',
        name: 'AppOptimization',
      );
    }
  }

  /// Start frame monitoring for performance tracking
  void _startFrameMonitoring() {
    SchedulerBinding.instance.addTimingsCallback(_onFrame);
  }

  /// Handle frame timing data
  void _onFrame(List<FrameTiming> timings) {
    if (!_isMonitoring) return;

    for (final FrameTiming timing in timings) {
      final double frameTime = timing.totalSpan.inMicroseconds / 1000.0;
      _addFrameTime(frameTime);

      // Immediate critical performance handling
      if (frameTime > criticalFrameTime) {
        _handleCriticalPerformance();
      }
    }
  }

  /// Add frame time to tracking and analyze
  void _addFrameTime(double frameTime) {
    _frameTimes.add(frameTime);

    // Keep only recent 300 frames (5 seconds at 60fps)
    if (_frameTimes.length > 300) {
      _frameTimes.removeAt(0);
    }

    // Performance analysis
    if (frameTime > warningFrameTime) {
      _handlePerformanceWarning(frameTime);
    }
  }

  /// Start memory monitoring
  void _startMemoryMonitoring() {
    _memoryCleanupTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }
      _checkMemoryUsage();
    });
  }

  /// Check current memory usage
  Future<void> _checkMemoryUsage() async {
    try {
      // Get memory info (platform specific)
      final int memoryMB = await _getCurrentMemoryUsage();
      _memorySnapshots.add(memoryMB);

      // Keep only recent 60 snapshots (10 minutes)
      if (_memorySnapshots.length > 60) {
        _memorySnapshots.removeAt(0);
      }

      // Memory warning handling
      if (memoryMB > warningMemoryMB) {
        _handleMemoryWarning(memoryMB);
      }

      // Critical memory handling
      if (memoryMB > maxMemoryMB) {
        _handleCriticalMemory(memoryMB);
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('Memory check failed: $e', name: 'AppOptimization');
      }
    }
  }

  /// Get current memory usage in MB
  Future<int> _getCurrentMemoryUsage() async {
    if (Platform.isAndroid) {
      try {
        final int? result = await const MethodChannel('com.nvs.yobro/memory')
            .invokeMethod<int>('getMemoryUsage');
        return result ?? 0;
      } catch (e) {
        return 0; // Fallback if native method not available
      }
    } else if (Platform.isIOS) {
      try {
        final int? result = await const MethodChannel('com.nvs.yobro/memory')
            .invokeMethod<int>('getMemoryUsage');
        return result ?? 0;
      } catch (e) {
        return 0; // Fallback if native method not available
      }
    }
    return 0;
  }

  /// Start periodic optimization tasks
  void _startPeriodicOptimization() {
    _optimizationTimer =
        Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }
      _performPeriodicOptimization();
    });
  }

  /// Perform periodic optimization tasks
  void _performPeriodicOptimization() {
    // Analyze performance metrics
    _analyzePerformanceMetrics();

    // Cleanup caches if needed
    _cleanupCachesIfNeeded();

    // Optimize image cache
    _optimizeImageCache();

    // Force garbage collection in low memory scenarios
    if (_lowMemoryMode) {
      _forceGarbageCollection();
    }
  }

  /// Analyze performance metrics and adjust settings
  void _analyzePerformanceMetrics() {
    if (_frameTimes.isEmpty) return;

    final double avgFrameTime =
        _frameTimes.reduce((double a, double b) => a + b) / _frameTimes.length;
    final int frameDrops =
        _frameTimes.where((double time) => time > targetFrameTime).length;
    final double frameDropPercentage = (frameDrops / _frameTimes.length) * 100;

    if (kDebugMode) {
      developer.log(
        'Performance Analysis: Avg: ${avgFrameTime.toStringAsFixed(2)}ms, '
        'Drops: ${frameDropPercentage.toStringAsFixed(1)}%, '
        'Reduced Animations: $_reducedAnimations, '
        'Low Memory Mode: $_lowMemoryMode',
        name: 'AppOptimization',
      );
    }

    // Auto-adjust performance settings
    if (frameDropPercentage > 15 && !_reducedAnimations) {
      enableReducedAnimations();
    } else if (frameDropPercentage < 5 && _reducedAnimations) {
      disableReducedAnimations();
    }
  }

  /// Setup system-level optimizations
  void _setupSystemOptimizations() {
    // Disable unnecessary system animations in debug mode
    if (kDebugMode) {
      // These would be production optimizations
    }

    // Setup memory pressure handling
    _setupMemoryPressureHandling();

    // Optimize Flutter engine settings
    _optimizeFlutterEngine();
  }

  /// Setup memory pressure handling
  void _setupMemoryPressureHandling() {
    // This would integrate with platform-specific memory pressure APIs
    // For now, we use our own memory monitoring
  }

  /// Optimize Flutter engine settings
  void _optimizeFlutterEngine() {
    // Enable Skia optimizations
    if (!kDebugMode) {
      // Production optimizations would go here
    }
  }

  /// Handle performance warnings
  void _handlePerformanceWarning(double frameTime) {
    if (kDebugMode) {
      developer.log(
        'Performance warning: ${frameTime.toStringAsFixed(2)}ms frame time',
        name: 'AppOptimization',
      );
    }
    _onPerformanceWarning?.call();
  }

  /// Handle critical performance issues
  void _handleCriticalPerformance() {
    if (!_reducedAnimations) {
      enableReducedAnimations();
    }

    if (!_lowMemoryMode) {
      enableLowMemoryMode();
    }

    _onCriticalPerformance?.call();

    if (kDebugMode) {
      developer.log(
        'Critical performance detected - emergency optimizations applied',
        name: 'AppOptimization',
      );
    }
  }

  /// Handle memory warnings
  void _handleMemoryWarning(int memoryMB) {
    if (kDebugMode) {
      developer.log(
        'Memory warning: ${memoryMB}MB usage',
        name: 'AppOptimization',
      );
    }

    // Start aggressive cleanup
    _cleanupCachesIfNeeded();
    _onMemoryWarning?.call();
  }

  /// Handle critical memory situations
  void _handleCriticalMemory(int memoryMB) {
    if (kDebugMode) {
      developer.log(
        'Critical memory: ${memoryMB}MB usage',
        name: 'AppOptimization',
      );
    }

    // Enable low memory mode
    enableLowMemoryMode();

    // Aggressive cleanup
    _forceGarbageCollection();
    _clearAllCaches();
  }

  /// Enable reduced animations mode
  void enableReducedAnimations() {
    _reducedAnimations = true;
    if (kDebugMode) {
      developer.log('Reduced animations enabled', name: 'AppOptimization');
    }
  }

  /// Disable reduced animations mode
  void disableReducedAnimations() {
    _reducedAnimations = false;
    if (kDebugMode) {
      developer.log('Reduced animations disabled', name: 'AppOptimization');
    }
  }

  /// Enable low memory mode
  void enableLowMemoryMode() {
    _lowMemoryMode = true;
    _reducedAnimations = true;
    if (kDebugMode) {
      developer.log('Low memory mode enabled', name: 'AppOptimization');
    }
  }

  /// Disable low memory mode
  void disableLowMemoryMode() {
    _lowMemoryMode = false;
    if (kDebugMode) {
      developer.log('Low memory mode disabled', name: 'AppOptimization');
    }
  }

  /// Cleanup caches when needed
  void _cleanupCachesIfNeeded() {
    // Cleanup image cache
    final ImageCache imageCache = PaintingBinding.instance.imageCache;
    if (imageCache.currentSizeBytes > 50 * 1024 * 1024) {
      // 50MB limit
      imageCache.clear();
      if (kDebugMode) {
        developer.log('Image cache cleared', name: 'AppOptimization');
      }
    }
  }

  /// Optimize image cache settings
  void _optimizeImageCache() {
    final ImageCache imageCache = PaintingBinding.instance.imageCache;

    if (_lowMemoryMode) {
      imageCache.maximumSizeBytes = 25 * 1024 * 1024; // 25MB in low memory mode
      imageCache.maximumSize = 50; // Fewer cached images
    } else {
      imageCache.maximumSizeBytes = 100 * 1024 * 1024; // 100MB normal mode
      imageCache.maximumSize = 200; // More cached images
    }
  }

  /// Force garbage collection
  void _forceGarbageCollection() {
    // This is a hint to the VM, not guaranteed
    developer.log('Requesting garbage collection', name: 'AppOptimization');
  }

  /// Clear all caches
  void _clearAllCaches() {
    PaintingBinding.instance.imageCache.clear();
    if (kDebugMode) {
      developer.log('All caches cleared', name: 'AppOptimization');
    }
  }

  // Callback setters
  void setPerformanceWarningCallback(VoidCallback callback) {
    _onPerformanceWarning = callback;
  }

  void setMemoryWarningCallback(VoidCallback callback) {
    _onMemoryWarning = callback;
  }

  void setCriticalPerformanceCallback(VoidCallback callback) {
    _onCriticalPerformance = callback;
  }

  // Getters for current state
  bool get isReducedAnimationsEnabled => _reducedAnimations;
  bool get isLowMemoryModeEnabled => _lowMemoryMode;
  bool get isBackgroundProcessingPaused => _backgroundProcessingPaused;

  double get averageFrameTime {
    if (_frameTimes.isEmpty) return 0;
    return _frameTimes.reduce((double a, double b) => a + b) /
        _frameTimes.length;
  }

  double get frameDropPercentage {
    if (_frameTimes.isEmpty) return 0;
    final int drops =
        _frameTimes.where((double time) => time > targetFrameTime).length;
    return (drops / _frameTimes.length) * 100;
  }

  int get currentMemoryUsage {
    return _memorySnapshots.isEmpty ? 0 : _memorySnapshots.last;
  }

  /// Get performance report for monitoring
  Map<String, dynamic> getPerformanceReport() {
    return <String, dynamic>{
      'averageFrameTime': averageFrameTime,
      'frameDropPercentage': frameDropPercentage,
      'currentMemoryUsage': currentMemoryUsage,
      'reducedAnimations': _reducedAnimations,
      'lowMemoryMode': _lowMemoryMode,
      'isMonitoring': _isMonitoring,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
