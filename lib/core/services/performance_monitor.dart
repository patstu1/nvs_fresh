import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Performance monitoring service for NVS app
/// Monitors memory usage, frame rates, and optimizes performance
class PerformanceMonitor {
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();

  bool _isMonitoring = false;
  Timer? _monitoringTimer;
  final List<double> _frameTimes = <double>[];

  // Performance thresholds
  static const double targetFrameTime = 16.67; // 60 FPS
  static const double warningFrameTime = 33.33; // 30 FPS
  static const int maxFrameTimeHistory = 120; // 2 seconds at 60fps

  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _startFrameMonitoring();
    _startPeriodicChecks();

    if (kDebugMode) {
      developer.log(
        'Performance monitoring started',
        name: 'PerformanceMonitor',
      );
    }
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    SchedulerBinding.instance.removeTimingsCallback(_onFrame);

    if (kDebugMode) {
      developer.log(
        'Performance monitoring stopped',
        name: 'PerformanceMonitor',
      );
    }
  }

  void _startFrameMonitoring() {
    SchedulerBinding.instance.addTimingsCallback(_onFrame);
  }

  void _onFrame(List<FrameTiming> timings) {
    if (!_isMonitoring) return;

    for (final FrameTiming timing in timings) {
      final double frameTime = timing.totalSpan.inMicroseconds / 1000.0;
      _addFrameTime(frameTime);
    }
  }

  void _addFrameTime(double frameTime) {
    _frameTimes.add(frameTime);

    // Keep only recent frame times
    if (_frameTimes.length > maxFrameTimeHistory) {
      _frameTimes.removeAt(0);
    }

    // Check for performance issues
    if (frameTime > warningFrameTime) {
      _handleSlowFrame(frameTime);
    }
  }

  void _startPeriodicChecks() {
    _monitoringTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }

      _analyzePerformance();
    });
  }

  void _analyzePerformance() {
    if (_frameTimes.isEmpty) return;

    final double avgFrameTime =
        _frameTimes.reduce((double a, double b) => a + b) / _frameTimes.length;
    final double maxFrameTime = _frameTimes.reduce((double a, double b) => a > b ? a : b);
    final int frameDrops = _frameTimes.where((double time) => time > targetFrameTime).length;
    final double frameDropPercentage = (frameDrops / _frameTimes.length) * 100;

    if (kDebugMode) {
      developer.log(
        'Performance: Avg: ${avgFrameTime.toStringAsFixed(2)}ms, '
        'Max: ${maxFrameTime.toStringAsFixed(2)}ms, '
        'Drops: ${frameDropPercentage.toStringAsFixed(1)}%',
        name: 'PerformanceMonitor',
      );
    }

    // Trigger optimization if performance is poor
    if (frameDropPercentage > 10 || avgFrameTime > warningFrameTime) {
      _triggerOptimization();
    }
  }

  void _handleSlowFrame(double frameTime) {
    if (kDebugMode) {
      developer.log(
        'Slow frame detected: ${frameTime.toStringAsFixed(2)}ms',
        name: 'PerformanceMonitor',
      );
    }
  }

  void _triggerOptimization() {
    if (kDebugMode) {
      developer.log(
        'Triggering performance optimization',
        name: 'PerformanceMonitor',
      );
    }

    // Notify the app to enable memory optimization
    _onPerformanceIssueDetected?.call();
  }

  // Callback for when performance issues are detected
  VoidCallback? _onPerformanceIssueDetected;

  void setPerformanceIssueCallback(VoidCallback callback) {
    _onPerformanceIssueDetected = callback;
  }

  // Getters for current performance metrics
  double get averageFrameTime {
    if (_frameTimes.isEmpty) return 0;
    return _frameTimes.reduce((double a, double b) => a + b) / _frameTimes.length;
  }

  double get frameDropPercentage {
    if (_frameTimes.isEmpty) return 0;
    final int drops = _frameTimes.where((double time) => time > targetFrameTime).length;
    return (drops / _frameTimes.length) * 100;
  }

  bool get isPerformanceGood => frameDropPercentage < 5 && averageFrameTime < targetFrameTime;
}
