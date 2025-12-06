// lib/core/models/app_types.dart
// Core application types and enums for the NVS Quantum system

import 'package:flutter/material.dart';

/// App sections for navigation and state management
enum AppSection {
  grid('MEATUP'),
  now('NOW'),
  connect('CONNECT'),
  live('LIVE'),
  messages('MESSAGES'),
  search('SEARCH'),
  profile('PROFILE');

  const AppSection(this.displayName);
  final String displayName;
}

/// Section synchronization status for real-time data sync
enum SectionSyncStatus {
  synced,
  syncing,
  requiresSync,
  syncFailed,
  offline;

  bool get needsSync => this == SectionSyncStatus.requiresSync;
  bool get isSyncing => this == SectionSyncStatus.syncing;
  bool get isSynced => this == SectionSyncStatus.synced;
  bool get hasFailed => this == SectionSyncStatus.syncFailed;
}

/// Authentication status for user state management
enum AuthStatus {
  authenticated,
  unauthenticated,
  authenticating,
  expired,
  error;

  bool get isAuthenticated => this == AuthStatus.authenticated;
  bool get needsAuthentication => this == AuthStatus.unauthenticated || this == AuthStatus.expired;
}

/// User profile synchronization status
enum UserProfileSyncStatus {
  synchronized,
  synchronizing,
  pendingSync,
  syncError,
  offline;

  bool get isSynced => this == UserProfileSyncStatus.synchronized;
  bool get needsSync => this == UserProfileSyncStatus.pendingSync;
  bool get isError => this == UserProfileSyncStatus.syncError;
}

/// Profile synchronization information
class ProfileSyncInfo {
  const ProfileSyncInfo({
    required this.status,
    this.lastSync,
    this.errorMessage,
    this.isProfileSyncing = false,
    this.syncProgress = 0.0,
  });
  final UserProfileSyncStatus status;
  final DateTime? lastSync;
  final String? errorMessage;
  final bool isProfileSyncing;
  final double syncProgress;

  ProfileSyncInfo copyWith({
    UserProfileSyncStatus? status,
    DateTime? lastSync,
    String? errorMessage,
    bool? isProfileSyncing,
    double? syncProgress,
  }) {
    return ProfileSyncInfo(
      status: status ?? this.status,
      lastSync: lastSync ?? this.lastSync,
      errorMessage: errorMessage ?? this.errorMessage,
      isProfileSyncing: isProfileSyncing ?? this.isProfileSyncing,
      syncProgress: syncProgress ?? this.syncProgress,
    );
  }
}

/// Bio-responsive theme data for UI adaptation
class BioResponsiveThemeData {
  const BioResponsiveThemeData({
    required this.arousalLevel,
    required this.lastUpdate, this.heartRate,
    this.skinConductance,
    this.bodyTemperature,
    this.isRealTime = false,
  });
  final double arousalLevel; // 0.0 to 1.0
  final int? heartRate; // BPM
  final double? skinConductance; // μS
  final double? bodyTemperature; // °C
  final bool isRealTime;
  final DateTime lastUpdate;

  bool get isActive => isRealTime && DateTime.now().difference(lastUpdate).inMinutes < 5;

  BioResponsiveThemeData copyWith({
    double? arousalLevel,
    int? heartRate,
    double? skinConductance,
    double? bodyTemperature,
    bool? isRealTime,
    DateTime? lastUpdate,
  }) {
    return BioResponsiveThemeData(
      arousalLevel: arousalLevel ?? this.arousalLevel,
      heartRate: heartRate ?? this.heartRate,
      skinConductance: skinConductance ?? this.skinConductance,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
      isRealTime: isRealTime ?? this.isRealTime,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

/// Performance metrics for the quantum performance engine
class PerformanceMetrics {
  const PerformanceMetrics({
    required this.currentFPS,
    required this.targetFPS,
    required this.averageFPS,
    required this.memoryUsageMB,
    required this.batteryLevel,
    required this.isMeetingTarget,
    required this.performanceGrade,
    required this.timestamp,
  });
  final double currentFPS;
  final double targetFPS;
  final double averageFPS;
  final double memoryUsageMB;
  final double batteryLevel;
  final bool isMeetingTarget;
  final PerformanceGrade performanceGrade;
  final DateTime timestamp;
}

/// Performance grades for adaptive UI optimization
enum PerformanceGrade {
  flagship, // 120fps capable
  premium, // 90fps capable
  standard, // 60fps capable
  budget, // 30fps capable
  minimal; // Basic functionality only

  int get targetFPS {
    switch (this) {
      case PerformanceGrade.flagship:
        return 120;
      case PerformanceGrade.premium:
        return 90;
      case PerformanceGrade.standard:
        return 60;
      case PerformanceGrade.budget:
        return 30;
      case PerformanceGrade.minimal:
        return 15;
    }
  }

  bool get supportsQuantumEffects {
    return this == PerformanceGrade.flagship || this == PerformanceGrade.premium;
  }

  bool get supportsComplexAnimations {
    return index <= PerformanceGrade.standard.index;
  }
}

/// Navigation animation curves for quantum interface
class QuantumCurves {
  static const Cubic quantumEase = Cubic(0.25, 0.46, 0.45, 0.94);
  static const Cubic bioResponse = Cubic(0.68, -0.55, 0.265, 1.55);
  static const Cubic neuralPulse = Cubic(0.175, 0.885, 0.32, 1.275);
  static const Cubic holographicTransition = Cubic(0.19, 1, 0.22, 1);
}

/// Error handling types for quantum error boundary
class QuantumError {
  const QuantumError({
    required this.message,
    required this.timestamp, required this.severity, this.stackTrace,
    this.section,
  });
  final String message;
  final String? stackTrace;
  final AppSection? section;
  final DateTime timestamp;
  final QuantumErrorSeverity severity;
}

enum QuantumErrorSeverity {
  info,
  warning,
  error,
  critical;
}

/// Connection status for real-time features
enum ConnectionStatus {
  connected,
  connecting,
  disconnected,
  reconnecting,
  failed;

  bool get isConnected => this == ConnectionStatus.connected;
  bool get isDisconnected => this == ConnectionStatus.disconnected;
  bool get canAttemptReconnect =>
      this == ConnectionStatus.disconnected || this == ConnectionStatus.failed;
}
