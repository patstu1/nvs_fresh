// lib/core/services/quantum_120fps_engine.dart
// Ultra-High Performance 120FPS Engine for Quantum UI
// Adaptive performance optimization with bio-responsive frame rates

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// =============================================================================
// PERFORMANCE METRICS & MONITORING
// =============================================================================

class PerformanceMetrics {
  const PerformanceMetrics({
    required this.currentFPS,
    required this.averageFPS,
    required this.frameTime,
    required this.droppedFrames,
    required this.gpuUsage,
    required this.memoryUsage,
    required this.batteryImpact,
    required this.timestamp,
  });
  final double currentFPS;
  final double averageFPS;
  final double frameTime; // in milliseconds
  final int droppedFrames;
  final double gpuUsage;
  final double memoryUsage; // in MB
  final double batteryImpact;
  final DateTime timestamp;

  bool get isOptimal => currentFPS >= 115 && droppedFrames == 0;
  bool get isGood => currentFPS >= 90 && droppedFrames < 2;
  bool get needsOptimization => currentFPS < 60 || droppedFrames > 5;

  PerformanceLevel get level {
    if (isOptimal) return PerformanceLevel.ultra;
    if (isGood) return PerformanceLevel.high;
    if (currentFPS >= 60) return PerformanceLevel.medium;
    return PerformanceLevel.low;
  }
}

enum PerformanceLevel {
  ultra(120),
  high(90),
  medium(60),
  low(30);

  const PerformanceLevel(this.targetFPS);
  final int targetFPS;
}

enum OptimizationMode {
  performance, // Maximum FPS, higher battery usage
  balanced, // Good FPS with reasonable battery usage
  battery, // Lower FPS, optimized for battery life
  adaptive, // Auto-adjust based on biometric data and usage
}

// =============================================================================
// BIOMETRIC-RESPONSIVE PERFORMANCE
// =============================================================================

class BiometricPerformanceProfile {
  const BiometricPerformanceProfile({
    required this.heartRate,
    required this.stressLevel,
    required this.focusLevel,
    required this.isActivelyEngaging,
    required this.timestamp,
  });
  final double heartRate;
  final double stressLevel;
  final double focusLevel;
  final bool isActivelyEngaging;
  final DateTime timestamp;

  /// Calculate optimal FPS based on biometric state
  int get optimalFPS {
    if (isActivelyEngaging && stressLevel < 0.3 && focusLevel > 0.7) {
      return 120; // Maximum performance when user is focused and calm
    } else if (heartRate > 100 || stressLevel > 0.7) {
      return 90; // High performance when user is excited/stressed
    } else if (focusLevel < 0.3) {
      return 60; // Standard performance when user is not focused
    } else {
      return 90; // Default high performance
    }
  }

  /// Should enable advanced visual effects based on biometric state
  bool get shouldEnableAdvancedEffects {
    return isActivelyEngaging && stressLevel < 0.5 && focusLevel > 0.5;
  }
}

// =============================================================================
// QUANTUM 120FPS ENGINE
// =============================================================================

class Quantum120FPSEngine extends ChangeNotifier {
  Quantum120FPSEngine._() {
    _initialize();
  }
  static Quantum120FPSEngine? _instance;
  static Quantum120FPSEngine get instance => _instance ??= Quantum120FPSEngine._();

  // Performance monitoring
  PerformanceMetrics? _currentMetrics;
  final List<PerformanceMetrics> _metricsHistory = <PerformanceMetrics>[];
  OptimizationMode _optimizationMode = OptimizationMode.adaptive;
  PerformanceLevel _currentLevel = PerformanceLevel.high;
  BiometricPerformanceProfile? _biometricProfile;

  // Frame rate management
  Timer? _performanceMonitor;
  Timer? _optimizationTimer;
  Ticker? _frameTicker;
  int _frameCount = 0;
  int _droppedFrames = 0;
  DateTime _lastFrameTime = DateTime.now();
  final List<double> _frameTimes = <double>[];

  // Adaptive features
  bool _isAdaptiveMode = true;
  bool _usesBiometricData = false;
  bool _isHigh120FPSDevice = false;
  final double _thermalThrottlingThreshold = 0.8;

  // Animation management
  final Map<String, AnimationController> _activeAnimations = <String, AnimationController>{};
  final Set<String> _priorityAnimations = <String>{};

  // =============================================================================
  // GETTERS
  // =============================================================================

  PerformanceMetrics? get currentMetrics => _currentMetrics;
  List<PerformanceMetrics> get metricsHistory => List.unmodifiable(_metricsHistory);
  OptimizationMode get optimizationMode => _optimizationMode;
  PerformanceLevel get currentLevel => _currentLevel;
  BiometricPerformanceProfile? get biometricProfile => _biometricProfile;
  bool get isAdaptiveMode => _isAdaptiveMode;
  bool get usesBiometricData => _usesBiometricData;
  bool get isHigh120FPSDevice => _isHigh120FPSDevice;

  double get currentFPS => _currentMetrics?.currentFPS ?? 60.0;
  bool get isPerformingOptimally => _currentMetrics?.isOptimal ?? false;
  bool get needsOptimization => _currentMetrics?.needsOptimization ?? false;

  int get targetFPS {
    if (_biometricProfile != null && _isAdaptiveMode) {
      return _biometricProfile!.optimalFPS;
    }
    return _currentLevel.targetFPS;
  }

  // =============================================================================
  // INITIALIZATION
  // =============================================================================

  Future<void> _initialize() async {
    try {
      // Detect device capabilities
      await _detectDeviceCapabilities();

      // Start performance monitoring
      _startPerformanceMonitoring();

      // Start frame tracking
      _startFrameTracking();

      // Initialize optimization timer
      _startOptimizationCycle();

      debugPrint('🚀 Quantum 120FPS Engine initialized');
      debugPrint('📱 High refresh rate device: $_isHigh120FPSDevice');
      debugPrint('🎯 Target FPS: $targetFPS');
    } catch (e) {
      debugPrint('❌ Failed to initialize 120FPS Engine: $e');
    }
  }

  Future<void> _detectDeviceCapabilities() async {
    try {
      // Check display refresh rate
      final ui.Display display = WidgetsBinding.instance.platformDispatcher.views.first.display;
      final double refreshRate = display.refreshRate;
      _isHigh120FPSDevice = refreshRate >= 120;

      debugPrint('📺 Display refresh rate: ${refreshRate}Hz');

      // Set appropriate performance level based on device
      if (_isHigh120FPSDevice) {
        _currentLevel = PerformanceLevel.ultra;
      } else {
        _currentLevel = PerformanceLevel.high;
      }
    } catch (e) {
      debugPrint('⚠️  Could not detect device capabilities: $e');
      _isHigh120FPSDevice = false;
      _currentLevel = PerformanceLevel.high;
    }
  }

  // =============================================================================
  // PERFORMANCE MONITORING
  // =============================================================================

  void _startPerformanceMonitoring() {
    _performanceMonitor = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updatePerformanceMetrics();
    });
  }

  void _updatePerformanceMetrics() {
    final DateTime now = DateTime.now();
    final int timeDelta = now.difference(_lastFrameTime).inMilliseconds;

    // Calculate FPS
    double currentFPS = 60.0;
    if (_frameTimes.isNotEmpty) {
      final double averageFrameTime =
          _frameTimes.reduce((double a, double b) => a + b) / _frameTimes.length;
      currentFPS = averageFrameTime > 0 ? 1000.0 / averageFrameTime : 60.0;
    }

    // Calculate average FPS
    double averageFPS = currentFPS;
    if (_metricsHistory.isNotEmpty) {
      final Iterable<PerformanceMetrics> recentMetrics = _metricsHistory.take(10);
      averageFPS = recentMetrics
              .map((PerformanceMetrics m) => m.currentFPS)
              .reduce((double a, double b) => a + b) /
          recentMetrics.length;
    }

    // Create metrics
    final PerformanceMetrics metrics = PerformanceMetrics(
      currentFPS: currentFPS.clamp(0, 120),
      averageFPS: averageFPS.clamp(0, 120),
      frameTime: _frameTimes.isNotEmpty ? _frameTimes.last : 16.67,
      droppedFrames: _droppedFrames,
      gpuUsage: _estimateGPUUsage(),
      memoryUsage: _estimateMemoryUsage(),
      batteryImpact: _estimateBatteryImpact(currentFPS),
      timestamp: now,
    );

    _currentMetrics = metrics;
    _metricsHistory.add(metrics);

    // Keep history manageable
    if (_metricsHistory.length > 60) {
      _metricsHistory.removeAt(0);
    }

    // Clear frame times for next calculation
    _frameTimes.clear();
    _droppedFrames = 0;

    notifyListeners();
  }

  void _startFrameTracking() {
    _frameTicker = Ticker((Duration elapsed) {
      final DateTime now = DateTime.now();
      final double frameDelta = now.difference(_lastFrameTime).inMilliseconds.toDouble();

      _frameTimes.add(frameDelta);

      // Detect dropped frames
      final double expectedFrameTime = 1000.0 / targetFPS;
      if (frameDelta > expectedFrameTime * 1.5) {
        _droppedFrames++;
      }

      _lastFrameTime = now;
      _frameCount++;

      // Keep frame times buffer manageable
      if (_frameTimes.length > 120) {
        _frameTimes.removeAt(0);
      }
    });

    _frameTicker?.start();
  }

  // =============================================================================
  // BIOMETRIC INTEGRATION
  // =============================================================================

  void updateBiometricProfile(BiometricPerformanceProfile profile) {
    _biometricProfile = profile;
    _usesBiometricData = true;

    if (_isAdaptiveMode) {
      _adaptPerformanceToProfileProfile(profile);
    }

    debugPrint('💓 Updated biometric profile - Target FPS: ${profile.optimalFPS}');
    notifyListeners();
  }

  void _adaptPerformanceToProfileProfile(BiometricPerformanceProfile profile) {
    final int optimalFPS = profile.optimalFPS;

    // Adjust performance level based on biometric data
    if (optimalFPS >= 120 && _isHigh120FPSDevice) {
      _currentLevel = PerformanceLevel.ultra;
    } else if (optimalFPS >= 90) {
      _currentLevel = PerformanceLevel.high;
    } else if (optimalFPS >= 60) {
      _currentLevel = PerformanceLevel.medium;
    } else {
      _currentLevel = PerformanceLevel.low;
    }

    // Enable/disable advanced visual effects
    _updateVisualEffectsBasedOnProfile(profile);
  }

  void _updateVisualEffectsBasedOnProfile(BiometricPerformanceProfile profile) {
    // This would integrate with the visual effects system
    // For now, we'll just log the decision
    final bool shouldEnable = profile.shouldEnableAdvancedEffects;
    debugPrint('✨ Advanced effects: ${shouldEnable ? "ENABLED" : "DISABLED"}');
  }

  // =============================================================================
  // OPTIMIZATION MODES
  // =============================================================================

  void setOptimizationMode(OptimizationMode mode) {
    _optimizationMode = mode;
    _isAdaptiveMode = mode == OptimizationMode.adaptive;

    switch (mode) {
      case OptimizationMode.performance:
        _currentLevel = _isHigh120FPSDevice ? PerformanceLevel.ultra : PerformanceLevel.high;
        break;
      case OptimizationMode.balanced:
        _currentLevel = PerformanceLevel.high;
        break;
      case OptimizationMode.battery:
        _currentLevel = PerformanceLevel.medium;
        break;
      case OptimizationMode.adaptive:
        // Will be handled by biometric updates
        break;
    }

    debugPrint('⚙️ Optimization mode: $mode (Target: ${_currentLevel.targetFPS}fps)');
    notifyListeners();
  }

  void _startOptimizationCycle() {
    _optimizationTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _performAutomaticOptimization();
    });
  }

  void _performAutomaticOptimization() {
    if (_currentMetrics == null) return;

    final PerformanceMetrics metrics = _currentMetrics!;

    // Auto-optimize based on performance
    if (metrics.needsOptimization) {
      _optimizeForLowPerformance();
    } else if (metrics.isOptimal && _optimizationMode != OptimizationMode.performance) {
      _optimizeForHighPerformance();
    }

    // Thermal throttling
    if (metrics.batteryImpact > _thermalThrottlingThreshold) {
      _applyThermalThrottling();
    }
  }

  void _optimizeForLowPerformance() {
    debugPrint('🔧 Optimizing for low performance...');

    // Reduce animation complexity
    _throttleAnimations();

    // Lower performance level if not already at minimum
    if (_currentLevel != PerformanceLevel.low) {
      final PerformanceLevel newLevel = PerformanceLevel
          .values[(_currentLevel.index + 1).clamp(0, PerformanceLevel.values.length - 1)];
      _currentLevel = newLevel;
      debugPrint('📉 Reduced to ${newLevel.name} (${newLevel.targetFPS}fps)');
    }
  }

  void _optimizeForHighPerformance() {
    debugPrint('🚀 Optimizing for high performance...');

    // Enable more complex animations
    _enableAdvancedAnimations();

    // Increase performance level if device supports it
    if (_currentLevel != PerformanceLevel.ultra && _isHigh120FPSDevice) {
      final PerformanceLevel newLevel = PerformanceLevel
          .values[(_currentLevel.index - 1).clamp(0, PerformanceLevel.values.length - 1)];
      _currentLevel = newLevel;
      debugPrint('📈 Increased to ${newLevel.name} (${newLevel.targetFPS}fps)');
    }
  }

  void _applyThermalThrottling() {
    debugPrint('🌡️ Applying thermal throttling...');

    // Temporarily reduce performance
    if (_currentLevel != PerformanceLevel.low) {
      _currentLevel = PerformanceLevel.medium;
    }

    // Reduce animation complexity
    _throttleAnimations();
  }

  // =============================================================================
  // ANIMATION MANAGEMENT
  // =============================================================================

  void registerAnimation(String id, AnimationController controller, {bool isPriority = false}) {
    _activeAnimations[id] = controller;

    if (isPriority) {
      _priorityAnimations.add(id);
    }

    debugPrint('🎬 Registered animation: $id (Priority: $isPriority)');
  }

  void unregisterAnimation(String id) {
    _activeAnimations.remove(id);
    _priorityAnimations.remove(id);
    debugPrint('🎬 Unregistered animation: $id');
  }

  void _throttleAnimations() {
    for (final MapEntry<String, AnimationController> entry in _activeAnimations.entries) {
      final String id = entry.key;
      final AnimationController controller = entry.value;

      // Don't throttle priority animations
      if (_priorityAnimations.contains(id)) continue;

      // Reduce animation frame rate
      if (controller.duration != null) {
        final Duration newDuration = Duration(
          milliseconds: (controller.duration!.inMilliseconds * 1.5).round(),
        );
        controller.duration = newDuration;
      }
    }

    debugPrint('🎬 Throttled ${_activeAnimations.length - _priorityAnimations.length} animations');
  }

  void _enableAdvancedAnimations() {
    for (final MapEntry<String, AnimationController> entry in _activeAnimations.entries) {
      final String id = entry.key;
      final AnimationController controller = entry.value;

      // Reset to normal speed
      if (controller.duration != null) {
        final Duration newDuration = Duration(
          milliseconds: (controller.duration!.inMilliseconds / 1.5).round(),
        );
        controller.duration = newDuration;
      }
    }

    debugPrint('🎬 Enabled advanced animations for ${_activeAnimations.length} controllers');
  }

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  double _estimateGPUUsage() {
    // Simplified GPU usage estimation
    if (_currentMetrics == null) return 0.3;

    final double fps = _currentMetrics!.currentFPS;
    final int droppedFrames = _currentMetrics!.droppedFrames;

    final double baseUsage = fps / 120.0; // Base usage based on FPS
    final double droppedFramesPenalty = droppedFrames * 0.1; // Penalty for dropped frames

    return (baseUsage + droppedFramesPenalty).clamp(0.0, 1.0);
  }

  double _estimateMemoryUsage() {
    // Simplified memory usage estimation in MB
    final int animationCount = _activeAnimations.length;
    const double baseMemory = 50.0; // Base app memory
    final double animationMemory = animationCount * 5.0; // 5MB per animation

    return baseMemory + animationMemory;
  }

  double _estimateBatteryImpact(double fps) {
    // Simplified battery impact estimation (0-1 scale)
    final double baseBatteryUsage = fps / 120.0; // Higher FPS = more battery
    final double gpuUsage = _estimateGPUUsage();

    return (baseBatteryUsage * 0.7 + gpuUsage * 0.3).clamp(0.0, 1.0);
  }

  // =============================================================================
  // PUBLIC API
  // =============================================================================

  /// Force a specific performance level
  void setPerformanceLevel(PerformanceLevel level) {
    _currentLevel = level;
    _optimizationMode = OptimizationMode.performance;
    _isAdaptiveMode = false;

    debugPrint('🎯 Set performance level: ${level.name} (${level.targetFPS}fps)');
    notifyListeners();
  }

  /// Get performance recommendation based on current metrics
  String getPerformanceRecommendation() {
    if (_currentMetrics == null) return 'Initializing performance monitoring...';

    final PerformanceMetrics metrics = _currentMetrics!;

    if (metrics.isOptimal) {
      return 'Performance is optimal! 🚀';
    } else if (metrics.isGood) {
      return 'Performance is good. Minor optimizations available.';
    } else if (metrics.needsOptimization) {
      return 'Performance needs optimization. Consider reducing visual effects.';
    } else {
      return 'Performance is acceptable.';
    }
  }

  /// Enable/disable biometric adaptive performance
  void setBiometricAdaptiveMode(bool enabled) {
    _usesBiometricData = enabled;
    _isAdaptiveMode = enabled;

    if (enabled) {
      _optimizationMode = OptimizationMode.adaptive;
    }

    debugPrint('💓 Biometric adaptive mode: ${enabled ? "ENABLED" : "DISABLED"}');
    notifyListeners();
  }

  // =============================================================================
  // CLEANUP
  // =============================================================================

  @override
  void dispose() {
    _performanceMonitor?.cancel();
    _optimizationTimer?.cancel();
    _frameTicker?.dispose();
    _activeAnimations.clear();
    _priorityAnimations.clear();
    super.dispose();
  }
}

// =============================================================================
// FLUTTER WIDGET INTEGRATION
// =============================================================================

class QuantumPerformanceWidget extends StatefulWidget {
  const QuantumPerformanceWidget({
    required this.child,
    super.key,
    this.enablePerformanceMonitoring = true,
    this.optimizationMode,
  });
  final Widget child;
  final bool enablePerformanceMonitoring;
  final OptimizationMode? optimizationMode;

  @override
  State<QuantumPerformanceWidget> createState() => _QuantumPerformanceWidgetState();
}

class _QuantumPerformanceWidgetState extends State<QuantumPerformanceWidget>
    with TickerProviderStateMixin {
  late final Quantum120FPSEngine _engine;

  @override
  void initState() {
    super.initState();
    _engine = Quantum120FPSEngine.instance;

    if (widget.optimizationMode != null) {
      _engine.setOptimizationMode(widget.optimizationMode!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _engine,
      builder: (BuildContext context, Widget? child) {
        return widget.child;
      },
    );
  }
}

// =============================================================================
// PERFORMANCE DEBUG OVERLAY
// =============================================================================

class QuantumPerformanceOverlay extends StatelessWidget {
  const QuantumPerformanceOverlay({
    required this.child,
    super.key,
    this.showOverlay = false,
  });
  final Widget child;
  final bool showOverlay;

  @override
  Widget build(BuildContext context) {
    if (!showOverlay) return child;

    return Stack(
      children: <Widget>[
        child,
        Positioned(
          top: 50,
          right: 16,
          child: ListenableBuilder(
            listenable: Quantum120FPSEngine.instance,
            builder: (BuildContext context, _) {
              final Quantum120FPSEngine engine = Quantum120FPSEngine.instance;
              final PerformanceMetrics? metrics = engine.currentMetrics;

              if (metrics == null) {
                return const SizedBox.shrink();
              }

              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF00FFF0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'QUANTUM PERFORMANCE',
                      style: TextStyle(
                        color: Color(0xFF00FFF0),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FPS: ${metrics.currentFPS.toStringAsFixed(1)}',
                      style: TextStyle(
                        color: _getFPSColor(metrics.currentFPS),
                        fontSize: 12,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                    Text(
                      'Target: ${engine.targetFPS}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                    Text(
                      'Level: ${engine.currentLevel.name.toUpperCase()}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getFPSColor(double fps) {
    if (fps >= 115) return const Color(0xFF00FF88); // Neon green
    if (fps >= 90) return const Color(0xFFFFFF00); // Neon yellow
    if (fps >= 60) return const Color(0xFFFF8800); // Neon orange
    return const Color(0xFFFF4444); // Neon red
  }
}
