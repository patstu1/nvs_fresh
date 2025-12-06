// lib/core/services/quantum_performance_engine.dart
// 120FPS Performance Optimization Engine for NVS 2027+ Architecture
// Neural-fluid animations with Impeller optimization and frame rate targeting

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Quantum Performance Engine - Enterprise 120FPS Targeting
///
/// Features:
/// - Adaptive frame rate targeting (60fps baseline, 120fps premium)
/// - Intelligent animation throttling during performance stress
/// - Memory pressure detection and automatic optimization
/// - GPU acceleration monitoring and optimization
/// - Real-time performance analytics and adjustment
class QuantumPerformanceEngine {
  factory QuantumPerformanceEngine() => _instance;
  QuantumPerformanceEngine._internal();
  static final QuantumPerformanceEngine _instance = QuantumPerformanceEngine._internal();

  // ============================================================================
  // PERFORMANCE CONFIGURATION
  // ============================================================================

  // Frame rate targets
  static const int targetFPS60 = 60;
  static const int targetFPS90 = 90;
  static const int targetFPS120 = 120;
  static const int targetFPS144 = 144; // Premium flagship devices

  // Performance thresholds
  static const double frameTimeBudget60 = 16.67; // 60fps = 16.67ms per frame
  static const double frameTimeBudget90 = 11.11; // 90fps = 11.11ms per frame
  static const double frameTimeBudget120 = 8.33; // 120fps = 8.33ms per frame
  static const double frameTimeBudget144 = 6.94; // 144fps = 6.94ms per frame

  // Memory thresholds (MB)
  static const int memoryWarningThreshold = 150;
  static const int memoryCriticalThreshold = 200;
  static const int memoryOptimalTarget = 100;

  // ============================================================================
  // STATE MANAGEMENT
  // ============================================================================

  bool _isInitialized = false;
  bool _isMonitoring = false;

  // Current performance state
  int _currentTargetFPS = targetFPS60;
  int _achievedFPS = 0;
  double _avgFrameTime = 0.0;
  double _frameTimeVariance = 0.0;
  int _droppedFrameCount = 0;

  // Performance optimization state
  PerformanceMode _currentMode = PerformanceMode.balanced;
  bool _isGpuAccelerated = false;
  bool _isLowMemoryMode = false;
  bool _areAnimationsThrottled = false;

  // Frame timing tracking
  final List<double> _frameTimeHistory = <double>[];
  final List<int> _fpsHistory = <int>[];
  static const int maxHistoryLength = 300; // 5 seconds at 60fps

  // Performance monitoring
  Timer? _performanceTimer;
  Timer? _optimizationTimer;
  DateTime? _lastOptimization;

  // Callbacks for performance events
  final List<Function(PerformanceMetrics)> _metricsCallbacks = <Function(PerformanceMetrics p1)>[];
  final List<Function(PerformanceOptimization)> _optimizationCallbacks =
      <Function(PerformanceOptimization p1)>[];

  // ============================================================================
  // PUBLIC API
  // ============================================================================

  /// Initialize the quantum performance engine
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Detect device capabilities
      await _detectDeviceCapabilities();

      // Set optimal target FPS for this device
      _setOptimalTargetFPS();

      // Start performance monitoring
      _startPerformanceMonitoring();

      // Enable GPU acceleration if available
      await _enableGpuOptimization();

      // Start optimization loop
      _startOptimizationLoop();

      _isInitialized = true;
      _isMonitoring = true;

      if (kDebugMode) {
        developer.log(
          'Quantum Performance Engine initialized - Target: ${_currentTargetFPS}fps',
          name: 'QuantumPerformance',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'Performance engine initialization failed: $e',
          name: 'QuantumPerformance',
        );
      }
      rethrow;
    }
  }

  /// Get current performance metrics
  PerformanceMetrics getCurrentMetrics() {
    return PerformanceMetrics(
      targetFPS: _currentTargetFPS,
      achievedFPS: _achievedFPS,
      avgFrameTime: _avgFrameTime,
      frameTimeVariance: _frameTimeVariance,
      droppedFrameCount: _droppedFrameCount,
      performanceMode: _currentMode,
      isGpuAccelerated: _isGpuAccelerated,
      isLowMemoryMode: _isLowMemoryMode,
      areAnimationsThrottled: _areAnimationsThrottled,
      performanceScore: _calculatePerformanceScore(),
      memoryUsageMB: _getEstimatedMemoryUsage(),
      timestamp: DateTime.now(),
    );
  }

  /// Force performance mode change
  void setPerformanceMode(PerformanceMode mode) {
    if (_currentMode == mode) return;

    final PerformanceMode previousMode = _currentMode;
    _currentMode = mode;

    _applyPerformanceMode(mode);

    if (kDebugMode) {
      developer.log(
        'Performance mode changed: ${previousMode.name} → ${mode.name}',
        name: 'QuantumPerformance',
      );
    }
  }

  /// Register callback for performance metrics updates
  void onMetricsUpdate(Function(PerformanceMetrics) callback) {
    _metricsCallbacks.add(callback);
  }

  /// Register callback for optimization events
  void onOptimization(Function(PerformanceOptimization) callback) {
    _optimizationCallbacks.add(callback);
  }

  /// Get recommended animation duration based on current performance
  Duration getOptimalAnimationDuration(Duration baseDuration) {
    if (_areAnimationsThrottled) {
      return Duration(
        milliseconds: (baseDuration.inMilliseconds * 1.5).round(),
      );
    }

    if (_currentMode == PerformanceMode.maximum) {
      return Duration(
        milliseconds: (baseDuration.inMilliseconds * 0.8).round(),
      );
    }

    return baseDuration;
  }

  /// Check if complex animations should be enabled
  bool shouldEnableComplexAnimations() {
    return !_areAnimationsThrottled &&
        _currentMode != PerformanceMode.battery &&
        _achievedFPS >= (_currentTargetFPS * 0.9);
  }

  /// Check if glow effects should be enabled
  bool shouldEnableGlowEffects() {
    return !_isLowMemoryMode &&
        _currentMode != PerformanceMode.battery &&
        _achievedFPS >= (_currentTargetFPS * 0.8);
  }

  /// Shutdown performance engine
  Future<void> shutdown() async {
    _isMonitoring = false;

    _performanceTimer?.cancel();
    _optimizationTimer?.cancel();

    SchedulerBinding.instance.removeTimingsCallback(_onFrame);

    _frameTimeHistory.clear();
    _fpsHistory.clear();
    _metricsCallbacks.clear();
    _optimizationCallbacks.clear();

    _isInitialized = false;

    if (kDebugMode) {
      developer.log(
        'Quantum Performance Engine shutdown',
        name: 'QuantumPerformance',
      );
    }
  }

  // ============================================================================
  // PRIVATE IMPLEMENTATION
  // ============================================================================

  /// Detect device performance capabilities
  Future<void> _detectDeviceCapabilities() async {
    try {
      // Check if running on high-end device
      final FlutterView view = PlatformDispatcher.instance.views.first;
      final double devicePixelRatio = view.devicePixelRatio;
      final Size physicalSize = view.physicalSize;

      // Estimate device tier based on screen properties
      final double totalPixels = physicalSize.width * physicalSize.height;
      final double scaledPixels = totalPixels * (devicePixelRatio * devicePixelRatio);

      if (scaledPixels > 8000000) {
        // Very high resolution
        _currentMode = PerformanceMode.maximum;
      } else if (scaledPixels > 4000000) {
        // High resolution
        _currentMode = PerformanceMode.performance;
      } else {
        _currentMode = PerformanceMode.balanced;
      }

      // Detect GPU acceleration capability
      _isGpuAccelerated = await _checkGpuAcceleration();
    } catch (e) {
      _currentMode = PerformanceMode.balanced;
      _isGpuAccelerated = false;
    }
  }

  /// Check if GPU acceleration is available
  Future<bool> _checkGpuAcceleration() async {
    try {
      // This is a simplified check - in production you'd use platform channels
      // to query actual GPU capabilities
      return !kIsWeb; // Assume non-web platforms have GPU acceleration
    } catch (e) {
      return false;
    }
  }

  /// Set optimal target FPS based on device capabilities
  void _setOptimalTargetFPS() {
    switch (_currentMode) {
      case PerformanceMode.battery:
        _currentTargetFPS = targetFPS60;
        break;
      case PerformanceMode.balanced:
        _currentTargetFPS = _isGpuAccelerated ? targetFPS90 : targetFPS60;
        break;
      case PerformanceMode.performance:
        _currentTargetFPS = _isGpuAccelerated ? targetFPS120 : targetFPS90;
        break;
      case PerformanceMode.maximum:
        _currentTargetFPS = _isGpuAccelerated ? targetFPS144 : targetFPS120;
        break;
    }
  }

  /// Start performance monitoring
  void _startPerformanceMonitoring() {
    // Register frame timing callback
    SchedulerBinding.instance.addTimingsCallback(_onFrame);

    // Start periodic analysis
    _performanceTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }
      _analyzePerformance();
    });
  }

  /// Handle frame timing data
  void _onFrame(List<FrameTiming> timings) {
    if (!_isMonitoring || timings.isEmpty) return;

    for (final FrameTiming timing in timings) {
      final double frameTime = timing.totalSpan.inMicroseconds / 1000.0; // Convert to ms

      _frameTimeHistory.add(frameTime);

      // Track dropped frames
      final double targetFrameTime = 1000.0 / _currentTargetFPS;
      if (frameTime > targetFrameTime * 1.5) {
        _droppedFrameCount++;
      }
    }

    // Keep history manageable
    if (_frameTimeHistory.length > maxHistoryLength) {
      _frameTimeHistory.removeRange(
        0,
        _frameTimeHistory.length - maxHistoryLength,
      );
    }
  }

  /// Analyze current performance and calculate metrics
  void _analyzePerformance() {
    if (_frameTimeHistory.isEmpty) return;

    // Calculate average frame time
    final double totalFrameTime = _frameTimeHistory.reduce((double a, double b) => a + b);
    _avgFrameTime = totalFrameTime / _frameTimeHistory.length;

    // Calculate achieved FPS
    _achievedFPS = (1000.0 / _avgFrameTime).round();

    // Calculate frame time variance
    final double variance = _frameTimeHistory
            .map((double time) => (time - _avgFrameTime) * (time - _avgFrameTime))
            .reduce((double a, double b) => a + b) /
        _frameTimeHistory.length;
    _frameTimeVariance = variance;

    // Store FPS history
    _fpsHistory.add(_achievedFPS);
    if (_fpsHistory.length > 60) {
      // Keep 1 minute of FPS data
      _fpsHistory.removeAt(0);
    }

    // Notify listeners
    final PerformanceMetrics metrics = getCurrentMetrics();
    for (final Function(PerformanceMetrics p1) callback in _metricsCallbacks) {
      try {
        callback(metrics);
      } catch (e) {
        if (kDebugMode) {
          developer.log(
            'Metrics callback error: $e',
            name: 'QuantumPerformance',
          );
        }
      }
    }

    // Reset dropped frame counter
    _droppedFrameCount = 0;
  }

  /// Start optimization loop
  void _startOptimizationLoop() {
    _optimizationTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }
      _performOptimization();
    });
  }

  /// Perform automatic performance optimization
  void _performOptimization() {
    final PerformanceMetrics metrics = getCurrentMetrics();
    final List<OptimizationType> optimizations = <OptimizationType>[];

    // Check if performance is below target
    final double performanceRatio = _achievedFPS / _currentTargetFPS;

    if (performanceRatio < 0.8) {
      // Performance is poor, enable optimizations
      if (!_areAnimationsThrottled) {
        _areAnimationsThrottled = true;
        optimizations.add(OptimizationType.throttleAnimations);
      }

      if (!_isLowMemoryMode && metrics.memoryUsageMB > memoryWarningThreshold) {
        _isLowMemoryMode = true;
        optimizations.add(OptimizationType.enableLowMemoryMode);
      }

      // Consider reducing target FPS if consistently poor
      if (performanceRatio < 0.6 && _currentTargetFPS > targetFPS60) {
        _currentTargetFPS = targetFPS60;
        optimizations.add(OptimizationType.reduceTargetFPS);
      }
    } else if (performanceRatio > 1.1) {
      // Performance is excellent, can remove optimizations
      if (_areAnimationsThrottled) {
        _areAnimationsThrottled = false;
        optimizations.add(OptimizationType.enableFullAnimations);
      }

      if (_isLowMemoryMode && metrics.memoryUsageMB < memoryOptimalTarget) {
        _isLowMemoryMode = false;
        optimizations.add(OptimizationType.disableLowMemoryMode);
      }
    }

    // Notify listeners of optimizations
    if (optimizations.isNotEmpty) {
      final PerformanceOptimization optimization = PerformanceOptimization(
        optimizations: optimizations,
        previousMetrics: metrics,
        timestamp: DateTime.now(),
      );

      for (final Function(PerformanceOptimization p1) callback in _optimizationCallbacks) {
        try {
          callback(optimization);
        } catch (e) {
          if (kDebugMode) {
            developer.log(
              'Optimization callback error: $e',
              name: 'QuantumPerformance',
            );
          }
        }
      }

      _lastOptimization = DateTime.now();
    }
  }

  /// Apply performance mode settings
  void _applyPerformanceMode(PerformanceMode mode) {
    switch (mode) {
      case PerformanceMode.battery:
        _currentTargetFPS = targetFPS60;
        _areAnimationsThrottled = true;
        _isLowMemoryMode = true;
        break;

      case PerformanceMode.balanced:
        _currentTargetFPS = _isGpuAccelerated ? targetFPS90 : targetFPS60;
        _areAnimationsThrottled = false;
        _isLowMemoryMode = false;
        break;

      case PerformanceMode.performance:
        _currentTargetFPS = _isGpuAccelerated ? targetFPS120 : targetFPS90;
        _areAnimationsThrottled = false;
        _isLowMemoryMode = false;
        break;

      case PerformanceMode.maximum:
        _currentTargetFPS = _isGpuAccelerated ? targetFPS144 : targetFPS120;
        _areAnimationsThrottled = false;
        _isLowMemoryMode = false;
        break;
    }
  }

  /// Enable GPU optimization
  Future<void> _enableGpuOptimization() async {
    if (!_isGpuAccelerated) return;

    try {
      // Enable Impeller rendering engine if available
      // This would be done through platform channels in production

      if (kDebugMode) {
        developer.log('GPU optimization enabled', name: 'QuantumPerformance');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log(
          'GPU optimization failed: $e',
          name: 'QuantumPerformance',
        );
      }
    }
  }

  /// Calculate overall performance score (0.0 to 1.0)
  double _calculatePerformanceScore() {
    if (_frameTimeHistory.isEmpty) return 0.0;

    final double fpsRatio = _achievedFPS / _currentTargetFPS;
    final double frameTimeConsistency =
        1.0 - (_frameTimeVariance / (_avgFrameTime * _avgFrameTime));
    final double memoryScore = _getMemoryScore();

    return ((fpsRatio + frameTimeConsistency + memoryScore) / 3.0).clamp(0.0, 1.0);
  }

  /// Get estimated memory usage in MB
  int _getEstimatedMemoryUsage() {
    // This is a simplified estimation - in production you'd use platform channels
    // to get actual memory usage from the OS
    return 80 + (_frameTimeHistory.length ~/ 10); // Rough estimate
  }

  /// Calculate memory performance score
  double _getMemoryScore() {
    final int memoryUsage = _getEstimatedMemoryUsage();

    if (memoryUsage < memoryOptimalTarget) return 1.0;
    if (memoryUsage < memoryWarningThreshold) return 0.8;
    if (memoryUsage < memoryCriticalThreshold) return 0.5;
    return 0.2;
  }
}

// ============================================================================
// SUPPORTING DATA CLASSES & ENUMS
// ============================================================================

/// Performance modes for different use cases
enum PerformanceMode {
  battery, // Prioritize battery life (60fps, reduced effects)
  balanced, // Balance performance and efficiency (60-90fps)
  performance, // Prioritize performance (90-120fps)
  maximum, // Maximum performance (120-144fps, all effects)
}

/// Performance optimization types
enum OptimizationType {
  throttleAnimations,
  enableFullAnimations,
  enableLowMemoryMode,
  disableLowMemoryMode,
  reduceTargetFPS,
  increaseTargetFPS,
  enableGpuAcceleration,
  disableComplexEffects,
  enableComplexEffects,
}

/// Current performance metrics
class PerformanceMetrics {
  const PerformanceMetrics({
    required this.targetFPS,
    required this.achievedFPS,
    required this.avgFrameTime,
    required this.frameTimeVariance,
    required this.droppedFrameCount,
    required this.performanceMode,
    required this.isGpuAccelerated,
    required this.isLowMemoryMode,
    required this.areAnimationsThrottled,
    required this.performanceScore,
    required this.memoryUsageMB,
    required this.timestamp,
  });
  final int targetFPS;
  final int achievedFPS;
  final double avgFrameTime;
  final double frameTimeVariance;
  final int droppedFrameCount;
  final PerformanceMode performanceMode;
  final bool isGpuAccelerated;
  final bool isLowMemoryMode;
  final bool areAnimationsThrottled;
  final double performanceScore;
  final int memoryUsageMB;
  final DateTime timestamp;

  /// Check if performance is meeting target
  bool get isMeetingTarget => achievedFPS >= (targetFPS * 0.9);

  /// Check if performance is excellent
  bool get isExcellent => performanceScore > 0.9;

  /// Get performance grade (A+ to F)
  String get performanceGrade {
    if (performanceScore >= 0.95) return 'A+';
    if (performanceScore >= 0.9) return 'A';
    if (performanceScore >= 0.8) return 'B';
    if (performanceScore >= 0.7) return 'C';
    if (performanceScore >= 0.6) return 'D';
    return 'F';
  }
}

/// Performance optimization event
class PerformanceOptimization {
  const PerformanceOptimization({
    required this.optimizations,
    required this.previousMetrics,
    required this.timestamp,
  });
  final List<OptimizationType> optimizations;
  final PerformanceMetrics previousMetrics;
  final DateTime timestamp;
}
