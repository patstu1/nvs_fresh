// lib/core/services/error_handling_service.dart

import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Enterprise-level error handling service
/// Provides comprehensive error tracking, logging, and recovery mechanisms
class ErrorHandlingService {
  factory ErrorHandlingService() => _instance;
  ErrorHandlingService._internal();
  static final ErrorHandlingService _instance = ErrorHandlingService._internal();

  // Error tracking
  final List<AppError> _errorHistory = <AppError>[];
  final Map<String, int> _errorCounts = <String, int>{};
  Timer? _errorReportingTimer;

  // Error thresholds
  static const int maxErrorHistory = 100;
  static const int maxErrorsPerMinute = 10;
  static const int criticalErrorThreshold = 5;

  // Callbacks
  Function(AppError)? _onError;
  Function(List<AppError>)? _onCriticalErrors;
  Function(String)? _onRecoveryAction;

  /// Initialize the error handling service
  void initialize() {
    // Set up global error handling
    FlutterError.onError = _handleFlutterError;

    // Set up zone error handling for async errors
    runZonedGuarded(
      () {
        // App runs in this zone
      },
      _handleZoneError,
    );

    // Start periodic error analysis
    _startErrorAnalysis();

    if (kDebugMode) {
      developer.log(
        'Error handling service initialized',
        name: 'ErrorHandling',
      );
    }
  }

  /// Handle Flutter framework errors
  void _handleFlutterError(FlutterErrorDetails details) {
    final AppError error = AppError(
      type: ErrorType.framework,
      message: details.exception.toString(),
      stackTrace: details.stack?.toString(),
      timestamp: DateTime.now(),
      context: details.context?.toString(),
      library: details.library,
    );

    _recordError(error);

    // In debug mode, also use the default error handler
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  }

  /// Handle zone errors (uncaught async exceptions)
  void _handleZoneError(Object error, StackTrace stackTrace) {
    final AppError appError = AppError(
      type: ErrorType.async,
      message: error.toString(),
      stackTrace: stackTrace.toString(),
      timestamp: DateTime.now(),
    );

    _recordError(appError);
  }

  /// Record and analyze errors
  void _recordError(AppError error) {
    _errorHistory.add(error);

    // Maintain error history limit
    if (_errorHistory.length > maxErrorHistory) {
      _errorHistory.removeAt(0);
    }

    // Update error counts
    final String key = _getErrorKey(error);
    _errorCounts[key] = (_errorCounts[key] ?? 0) + 1;

    // Check for critical error patterns
    _analyzeCriticalErrors();

    // Notify error callback
    _onError?.call(error);

    // Log error
    _logError(error);

    // Attempt automatic recovery
    _attemptRecovery(error);
  }

  /// Start periodic error analysis
  void _startErrorAnalysis() {
    _errorReportingTimer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      _analyzeErrorPatterns();
      _cleanupOldErrors();
    });
  }

  /// Analyze error patterns for critical issues
  void _analyzeCriticalErrors() {
    final List<AppError> recentErrors = _errorHistory
        .where(
          (AppError e) => DateTime.now().difference(e.timestamp).inMinutes < 1,
        )
        .toList();

    if (recentErrors.length >= maxErrorsPerMinute) {
      _handleCriticalErrorRate(recentErrors);
    }

    // Check for repeated critical errors
    final List<AppError> criticalErrors =
        _errorHistory.where((AppError e) => e.type == ErrorType.critical).toList();

    if (criticalErrors.length >= criticalErrorThreshold) {
      _onCriticalErrors?.call(criticalErrors);
    }
  }

  /// Analyze error patterns over time
  void _analyzeErrorPatterns() {
    final Map<ErrorType, int> errorsByType = <ErrorType, int>{};
    final Map<String, int> errorsByMessage = <String, int>{};

    for (final AppError error in _errorHistory) {
      errorsByType[error.type] = (errorsByType[error.type] ?? 0) + 1;
      errorsByMessage[error.message] = (errorsByMessage[error.message] ?? 0) + 1;
    }

    if (kDebugMode) {
      developer.log(
        'Error Analysis - Types: $errorsByType, Top Messages: ${_getTopErrors(errorsByMessage)}',
        name: 'ErrorHandling',
      );
    }
  }

  /// Get top error messages
  Map<String, int> _getTopErrors(Map<String, int> errorsByMessage) {
    final List<MapEntry<String, int>> sorted = errorsByMessage.entries.toList()
      ..sort(
        (MapEntry<String, int> a, MapEntry<String, int> b) => b.value.compareTo(a.value),
      );

    return Map.fromEntries(sorted.take(5));
  }

  /// Handle critical error rate
  void _handleCriticalErrorRate(List<AppError> recentErrors) {
    if (kDebugMode) {
      developer.log(
        'Critical error rate detected: ${recentErrors.length} errors in last minute',
        name: 'ErrorHandling',
      );
    }

    // Trigger emergency recovery
    _triggerEmergencyRecovery();
  }

  /// Trigger emergency recovery procedures
  void _triggerEmergencyRecovery() {
    // Clear caches
    PaintingBinding.instance.imageCache.clear();

    // Notify recovery action
    _onRecoveryAction?.call('Emergency recovery triggered - clearing caches');

    if (kDebugMode) {
      developer.log(
        'Emergency recovery procedures executed',
        name: 'ErrorHandling',
      );
    }
  }

  /// Attempt automatic recovery for specific error types
  void _attemptRecovery(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        _handleNetworkError(error);
        break;
      case ErrorType.memory:
        _handleMemoryError(error);
        break;
      case ErrorType.storage:
        _handleStorageError(error);
        break;
      case ErrorType.permission:
        _handlePermissionError(error);
        break;
      default:
        // No automatic recovery for other types
        break;
    }
  }

  /// Handle network errors
  void _handleNetworkError(AppError error) {
    // Implement network recovery logic
    _onRecoveryAction?.call('Network error recovery attempted');
  }

  /// Handle memory errors
  void _handleMemoryError(AppError error) {
    // Clear caches and trigger garbage collection
    PaintingBinding.instance.imageCache.clear();
    _onRecoveryAction?.call('Memory error recovery - caches cleared');
  }

  /// Handle storage errors
  void _handleStorageError(AppError error) {
    // Implement storage cleanup logic
    _onRecoveryAction?.call('Storage error recovery attempted');
  }

  /// Handle permission errors
  void _handlePermissionError(AppError error) {
    // Log permission error for user action
    _onRecoveryAction?.call('Permission error logged - user action required');
  }

  /// Log error details
  void _logError(AppError error) {
    if (kDebugMode) {
      developer.log(
        'Error [${error.type.name}]: ${error.message}',
        name: 'ErrorHandling',
        error: error.message,
        stackTrace: error.stackTrace != null ? StackTrace.fromString(error.stackTrace!) : null,
      );
    }

    // In production, send to error tracking service
    if (kReleaseMode) {
      _sendToErrorTrackingService(error);
    }
  }

  /// Send error to external error tracking service
  void _sendToErrorTrackingService(AppError error) {
    // Implementation for services like Sentry, Crashlytics, etc.
    // This would be configured based on the chosen error tracking service
  }

  /// Generate error key for counting
  String _getErrorKey(AppError error) {
    return '${error.type.name}_${error.message.hashCode}';
  }

  /// Clean up old errors from history
  void _cleanupOldErrors() {
    final DateTime cutoff = DateTime.now().subtract(const Duration(hours: 24));
    _errorHistory.removeWhere((AppError error) => error.timestamp.isBefore(cutoff));

    // Clean up error counts for old errors
    _errorCounts.clear();
  }

  /// Record custom error
  void recordError({
    required String message,
    ErrorType type = ErrorType.application,
    String? stackTrace,
    String? context,
    Map<String, dynamic>? metadata,
  }) {
    final AppError error = AppError(
      type: type,
      message: message,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      context: context,
      metadata: metadata,
    );

    _recordError(error);
  }

  /// Record network error
  void recordNetworkError(String message, {String? url, int? statusCode}) {
    recordError(
      message: message,
      type: ErrorType.network,
      metadata: <String, dynamic>{
        'url': url,
        'statusCode': statusCode,
      },
    );
  }

  /// Record authentication error
  void recordAuthError(String message, {String? userId}) {
    recordError(
      message: message,
      type: ErrorType.authentication,
      metadata: <String, dynamic>{
        'userId': userId,
      },
    );
  }

  /// Record validation error
  void recordValidationError(String field, String message) {
    recordError(
      message: 'Validation error in $field: $message',
      type: ErrorType.validation,
      metadata: <String, dynamic>{
        'field': field,
      },
    );
  }

  // Callback setters
  void setErrorCallback(Function(AppError) callback) {
    _onError = callback;
  }

  void setCriticalErrorsCallback(Function(List<AppError>) callback) {
    _onCriticalErrors = callback;
  }

  void setRecoveryActionCallback(Function(String) callback) {
    _onRecoveryAction = callback;
  }

  // Getters
  List<AppError> get errorHistory => List.unmodifiable(_errorHistory);
  Map<String, int> get errorCounts => Map.unmodifiable(_errorCounts);

  int get totalErrors => _errorHistory.length;
  int get recentErrorCount => _errorHistory
      .where(
        (AppError e) => DateTime.now().difference(e.timestamp).inMinutes < 5,
      )
      .length;

  /// Get error statistics
  Map<String, dynamic> getErrorStatistics() {
    final Map<String, int> errorsByType = <String, int>{};
    for (final AppError error in _errorHistory) {
      errorsByType[error.type.name] = (errorsByType[error.type.name] ?? 0) + 1;
    }

    return <String, dynamic>{
      'totalErrors': totalErrors,
      'recentErrors': recentErrorCount,
      'errorsByType': errorsByType,
      'topErrors': _getTopErrors(_errorCounts),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Shutdown the service
  void shutdown() {
    _errorReportingTimer?.cancel();
  }
}

/// Error types for categorization
enum ErrorType {
  framework,
  async,
  network,
  memory,
  storage,
  permission,
  authentication,
  validation,
  application,
  critical,
}

/// Error data model
class AppError {
  AppError({
    required this.type,
    required this.message,
    required this.timestamp,
    this.stackTrace,
    this.context,
    this.library,
    this.metadata,
  });
  final ErrorType type;
  final String message;
  final String? stackTrace;
  final DateTime timestamp;
  final String? context;
  final String? library;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.name,
      'message': message,
      'stackTrace': stackTrace,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
      'library': library,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'AppError(type: $type, message: $message, timestamp: $timestamp)';
  }
}
