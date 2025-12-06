// packages/now/lib/services/unity_metacity_service.dart
// Unity Metacity Service - High-level interface for quantum city management

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'unity_bridge_service.dart';

/// Unity Metacity Service - Manages the 3D quantum metacity
class UnityMetacityService {
  final UnityBridgeService _unityBridge;

  // State streams
  final StreamController<List<QuantumUser>> _usersController =
      StreamController<List<QuantumUser>>.broadcast();
  final StreamController<List<QuantumCluster>> _clustersController =
      StreamController<List<QuantumCluster>>.broadcast();
  final StreamController<MetacityPerformanceMetrics> _performanceController =
      StreamController<MetacityPerformanceMetrics>.broadcast();

  // Internal state
  final List<QuantumUser> _activeUsers = [];
  final List<QuantumCluster> _activeClusters = [];
  MetacityPerformanceMetrics? _lastPerformanceMetrics;

  UnityMetacityService(this._unityBridge) {
    _initializeUnityCallbacks();
  }

  // Public streams
  Stream<List<QuantumUser>> get usersStream => _usersController.stream;
  Stream<List<QuantumCluster>> get clustersStream => _clustersController.stream;
  Stream<MetacityPerformanceMetrics> get performanceStream => _performanceController.stream;

  // Getters
  List<QuantumUser> get activeUsers => List.unmodifiable(_activeUsers);
  List<QuantumCluster> get activeClusters => List.unmodifiable(_activeClusters);
  MetacityPerformanceMetrics? get lastPerformanceMetrics => _lastPerformanceMetrics;

  void _initializeUnityCallbacks() {
    // Listen to Unity messages
    _unityBridge.messageStream.listen((message) {
      _handleUnityMessage(message);
    });
  }

  void _handleUnityMessage(UnityMessage message) {
    switch (message.type) {
      case UnityMessageType.profileTapped:
        _handleUserFocused(message.data);
        break;
      case UnityMessageType.auraTapped:
        _handleUserInteraction(message.data);
        break;
      case UnityMessageType.mapTapped:
        _handleClusterUpdate(message.data);
        break;
      case UnityMessageType.cameraChanged:
        _handleCameraUpdate(message.data);
        break;
      case UnityMessageType.unityReady:
        debugPrint('🧩 Unity bridge ready');
        break;
      case UnityMessageType.unityError:
        debugPrint('⚠️ Unity error: ${message.data['error']}');
        break;
    }
  }

  // User Management
  Future<void> addUser(QuantumUser user) async {
    _activeUsers.add(user);

    final Color auraColor = user.auraColor ?? const Color(0xFF4DFFA3);

    final userData = {
      'userId': user.userId,
      'displayName': user.displayName,
      'position': {'x': user.position.longitude, 'y': 0.0, 'z': user.position.latitude},
      'heartRate': user.biometrics?.heartRate ?? 72.0,
      'arousalLevel': user.biometrics?.arousal ?? 0.5,
      'compatibility': user.compatibility ?? 0.5,
      'roleTags': user.roleTags,
      'auraColor': {
        'r': auraColor.r,
        'g': auraColor.g,
        'b': auraColor.b,
        'a': auraColor.a,
      },
      'isOnline': user.isOnline,
      'lastSeen': user.lastSeen?.millisecondsSinceEpoch ?? 0,
    };

    await _unityBridge.sendMessage('addQuantumUser', jsonEncode(userData));
    _usersController.add(_activeUsers);

    debugPrint('✨ Added quantum user to metacity: ${user.displayName}');
  }

  Future<void> removeUser(String userId) async {
    _activeUsers.removeWhere((user) => user.userId == userId);
    await _unityBridge.sendMessage('removeQuantumUser', userId);
    _usersController.add(_activeUsers);

    debugPrint('🌌 Removed quantum user from metacity: $userId');
  }

  Future<void> updateUserPosition(String userId, GeographicCoordinate newPosition) async {
    final userIndex = _activeUsers.indexWhere((user) => user.userId == userId);
    if (userIndex == -1) return;

    final user = _activeUsers[userIndex];
    final updatedUser = user.copyWith(position: newPosition);
    _activeUsers[userIndex] = updatedUser;

    final positionData = {
      'userId': userId,
      'position': {'x': newPosition.longitude, 'y': 0.0, 'z': newPosition.latitude},
    };

    await _unityBridge.sendMessage('updateUserPosition', jsonEncode(positionData));
    _usersController.add(_activeUsers);
  }

  Future<void> updateUserBiometrics(String userId, BiometricData biometrics) async {
    final userIndex = _activeUsers.indexWhere((user) => user.userId == userId);
    if (userIndex == -1) return;

    final user = _activeUsers[userIndex];
    final updatedUser = user.copyWith(biometrics: biometrics);
    _activeUsers[userIndex] = updatedUser;

    final biometricData = {
      userId: {
        'heartRate': biometrics.heartRate,
        'heartRateVariability': biometrics.heartRateVariability,
        'electrodermalActivity': biometrics.electrodermalActivity,
        'stress': biometrics.stress,
        'arousal': biometrics.arousal,
        'mood': biometrics.mood,
      },
    };

    await _unityBridge.sendMessage('updateBiometricData', jsonEncode(biometricData));
    _usersController.add(_activeUsers);
  }

  // Quantum Clustering
  Future<void> updateQuantumClusters(List<QuantumCluster> clusters) async {
    _activeClusters.clear();
    _activeClusters.addAll(clusters);

    final clusterData = clusters
        .map(
          (cluster) => {
            'center': {'x': cluster.center.longitude, 'y': 0.0, 'z': cluster.center.latitude},
            'radius': cluster.radius,
            'userCount': cluster.userCount,
            'energy': cluster.energy,
          },
        )
        .toList();

    await _unityBridge.sendMessage('updateQuantumClusters', jsonEncode(clusterData));
    _clustersController.add(_activeClusters);

    debugPrint('🌌 Updated quantum clusters: ${clusters.length} active');
  }

  // Camera Control
  Future<void> focusOnUser(String userId) async {
    await _unityBridge.sendMessage('focusOnUser', userId);
    debugPrint('🎯 Focused camera on user: $userId');
  }

  Future<void> setCameraPosition(GeographicCoordinate position, double altitude) async {
    final cameraData = {
      'position': {'x': position.longitude, 'y': altitude, 'z': position.latitude},
      'smooth': true,
    };

    await _unityBridge.sendMessage('setCameraPosition', jsonEncode(cameraData));
  }

  // Unity Message Handlers
  void _handleUserFocused(Map<String, dynamic> data) {
    final userId = data['userId'] as String?;
    if (userId != null) {
      debugPrint('👁️ User focused in Unity: $userId');
      // Could emit events here for UI updates
    }
  }

  void _handleUserInteraction(Map<String, dynamic> data) {
    final userId = data['userId'] as String?;
    final interactionType = data['interactionType'] as String?;

    if (userId != null && interactionType != null) {
      debugPrint('🤝 User interaction in Unity: $userId -> $interactionType');
      // Handle different interaction types (tap, long press, etc.)
    }
  }

  void _handleClusterUpdate(Map<String, dynamic> data) {
    final clusters = data['clusters'] as List?;
    if (clusters != null) {
      // Process cluster updates from Unity
      debugPrint('🌀 Cluster update from Unity: ${clusters.length} clusters');
    }
  }

  void _handleCameraUpdate(Map<String, dynamic> data) {
    final position = data['position'] as Map<String, dynamic>?;
    if (position != null) {
      // Update camera position in Flutter state if needed
      debugPrint('📹 Camera update from Unity');
    }
  }

  void _handlePerformanceUpdate(Map<String, dynamic> data) {
    final fps = (data['fps'] as num?)?.toDouble() ?? 0.0;
    final visibleUsers = data['visibleUsers'] as int? ?? 0;
    final activeTiles = data['activeTiles'] as int? ?? 0;
    final memoryUsage = data['memoryUsage'] as int? ?? 0;

    _lastPerformanceMetrics = MetacityPerformanceMetrics(
      fps: fps,
      visibleUsers: visibleUsers,
      activeTiles: activeTiles,
      memoryUsage: memoryUsage,
      timestamp: DateTime.now(),
    );

    _performanceController.add(_lastPerformanceMetrics!);

    debugPrint(
      '📊 Unity performance: ${fps.toStringAsFixed(1)} FPS, $visibleUsers users, $activeTiles tiles',
    );
  }

  // Batch Operations
  Future<void> updateUserBatch(List<QuantumUser> users) async {
    final userUpdates = users
        .map(
          (user) => {
            'userId': user.userId,
            'displayName': user.displayName,
            'position': {'x': user.position.longitude, 'y': 0.0, 'z': user.position.latitude},
            'heartRate': user.biometrics?.heartRate ?? 72.0,
            'arousalLevel': user.biometrics?.arousal ?? 0.5,
            'compatibility': user.compatibility ?? 0.5,
            'isOnline': user.isOnline,
          },
        )
        .toList();

    await _unityBridge.sendMessage('updateUserPositions', jsonEncode(userUpdates));

    // Update local state
    for (final user in users) {
      final index = _activeUsers.indexWhere((u) => u.userId == user.userId);
      if (index != -1) {
        _activeUsers[index] = user;
      }
    }

    _usersController.add(_activeUsers);
  }

  // Quality Settings
  Future<void> setQualityLevel(MetacityQualityLevel quality) async {
    final qualityData = {
      'level': quality.index,
      'maxUsers': quality.maxVisibleUsers,
      'maxTiles': quality.maxActiveTiles,
      'particleQuality': quality.particleQuality.index,
      'shaderComplexity': quality.shaderComplexity.index,
    };

    await _unityBridge.sendMessage('setQualityLevel', jsonEncode(qualityData));
    debugPrint('⚙️ Set Unity quality level: ${quality.name}');
  }

  // Cleanup
  void dispose() {
    _usersController.close();
    _clustersController.close();
    _performanceController.close();
  }
}

// Performance metrics model
class MetacityPerformanceMetrics {
  final double fps;
  final int visibleUsers;
  final int activeTiles;
  final int memoryUsage;
  final DateTime timestamp;

  const MetacityPerformanceMetrics({
    required this.fps,
    required this.visibleUsers,
    required this.activeTiles,
    required this.memoryUsage,
    required this.timestamp,
  });
}

// Quality level configuration
enum MetacityQualityLevel {
  low(
    maxVisibleUsers: 100,
    maxActiveTiles: 500,
    particleQuality: ParticleQuality.low,
    shaderComplexity: ShaderComplexity.low,
  ),
  medium(
    maxVisibleUsers: 250,
    maxActiveTiles: 1000,
    particleQuality: ParticleQuality.medium,
    shaderComplexity: ShaderComplexity.medium,
  ),
  high(
    maxVisibleUsers: 500,
    maxActiveTiles: 2500,
    particleQuality: ParticleQuality.high,
    shaderComplexity: ShaderComplexity.high,
  ),
  ultra(
    maxVisibleUsers: 1000,
    maxActiveTiles: 5000,
    particleQuality: ParticleQuality.ultra,
    shaderComplexity: ShaderComplexity.ultra,
  );

  const MetacityQualityLevel({
    required this.maxVisibleUsers,
    required this.maxActiveTiles,
    required this.particleQuality,
    required this.shaderComplexity,
  });

  final int maxVisibleUsers;
  final int maxActiveTiles;
  final ParticleQuality particleQuality;
  final ShaderComplexity shaderComplexity;
}

enum ParticleQuality { low, medium, high, ultra }

enum ShaderComplexity { low, medium, high, ultra }

class GeographicCoordinate {
  const GeographicCoordinate({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  Map<String, double> toMap() => {'latitude': latitude, 'longitude': longitude};
}

class BiometricData {
  const BiometricData({
    this.heartRate,
    this.heartRateVariability,
    this.electrodermalActivity,
    this.stress,
    this.arousal,
    this.mood,
  });

  final double? heartRate;
  final double? heartRateVariability;
  final double? electrodermalActivity;
  final double? stress;
  final double? arousal;
  final String? mood;

  Map<String, dynamic> toJson() => {
        'heartRate': heartRate,
        'heartRateVariability': heartRateVariability,
        'electrodermalActivity': electrodermalActivity,
        'stress': stress,
        'arousal': arousal,
        'mood': mood,
      };
}

class QuantumUser {
  const QuantumUser({
    required this.userId,
    required this.displayName,
    required this.position,
    this.biometrics,
    this.compatibility,
    this.roleTags = const <String>[],
    this.auraColor,
    this.isOnline = false,
    this.lastSeen,
  });

  final String userId;
  final String displayName;
  final GeographicCoordinate position;
  final BiometricData? biometrics;
  final double? compatibility;
  final List<String> roleTags;
  final Color? auraColor;
  final bool isOnline;
  final DateTime? lastSeen;

  QuantumUser copyWith({
    String? userId,
    String? displayName,
    GeographicCoordinate? position,
    BiometricData? biometrics,
    double? compatibility,
    List<String>? roleTags,
    Color? auraColor,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return QuantumUser(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      position: position ?? this.position,
      biometrics: biometrics ?? this.biometrics,
      compatibility: compatibility ?? this.compatibility,
      roleTags: roleTags ?? this.roleTags,
      auraColor: auraColor ?? this.auraColor,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}

class QuantumCluster {
  const QuantumCluster({
    required this.center,
    required this.radius,
    required this.userCount,
    required this.energy,
  });

  final GeographicCoordinate center;
  final double radius;
  final int userCount;
  final double energy;
}

// Riverpod providers
final unityMetacityServiceProvider = Provider<UnityMetacityService>((ref) {
  final unityBridge = ref.watch(unityBridgeServiceProvider);
  return UnityMetacityService(unityBridge);
});

final metacityUsersProvider = StreamProvider<List<QuantumUser>>((ref) {
  final service = ref.watch(unityMetacityServiceProvider);
  return service.usersStream;
});

final metacityClustersProvider = StreamProvider<List<QuantumCluster>>((ref) {
  final service = ref.watch(unityMetacityServiceProvider);
  return service.clustersStream;
});

final metacityPerformanceProvider = StreamProvider<MetacityPerformanceMetrics>((ref) {
  final service = ref.watch(unityMetacityServiceProvider);
  return service.performanceStream;
});
