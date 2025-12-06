import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

/// Location Optimizer Service - Intelligent user clustering for social discovery
/// Interfaces with Python backend for advanced clustering algorithms
class LocationOptimizerService {
  static const String _baseUrl = 'http://localhost:8003';
  static const int _requestTimeoutMs = 10000;

  // Cache for optimization results
  final Map<String, OptimizationResult> _cache = <String, OptimizationResult>{};
  final Duration _cacheTimeout = const Duration(minutes: 5);

  // Stream controllers for real-time updates
  final StreamController<List<UserCluster>> _clustersStreamController =
      StreamController<List<UserCluster>>.broadcast();
  final StreamController<OptimizationMetrics> _metricsStreamController =
      StreamController<OptimizationMetrics>.broadcast();

  Timer? _optimizationTimer;
  bool _isOptimizing = false;

  // Getters for public access
  Stream<List<UserCluster>> get clustersStream => _clustersStreamController.stream;
  Stream<OptimizationMetrics> get metricsStream => _metricsStreamController.stream;
  bool get isOptimizing => _isOptimizing;

  /// Initialize the location optimizer service
  Future<bool> initialize() async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: <String, String>{'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint(
          '🗺️ Location Optimizer initialized - Backend: ${data['status']}',
        );
        return true;
      }

      debugPrint('❌ Location Optimizer backend not available');
      return false;
    } catch (e) {
      debugPrint('❌ Location Optimizer initialization failed: $e');
      return false;
    }
  }

  /// Start continuous optimization with periodic updates
  void startContinuousOptimization({
    Duration interval = const Duration(minutes: 2),
  }) {
    _optimizationTimer?.cancel();
    _optimizationTimer = Timer.periodic(interval, (Timer timer) {
      _performPeriodicOptimization();
    });
    debugPrint('🗺️ Started continuous location optimization');
  }

  /// Stop continuous optimization
  void stopContinuousOptimization() {
    _optimizationTimer?.cancel();
    _optimizationTimer = null;
    debugPrint('🗺️ Stopped continuous location optimization');
  }

  /// Optimize user clustering for given locations
  Future<OptimizationResult?> optimizeUserClustering({
    required List<UserLocationData> users,
    int maxClusters = 10,
    int minClusterSize = 2,
    double maxDistanceKm = 5.0,
    OptimizationMethod method = OptimizationMethod.hybrid,
    bool useCache = true,
  }) async {
    if (users.isEmpty) return null;

    // Generate cache key
    final String cacheKey = _generateCacheKey(users, maxClusters, maxDistanceKm, method);

    // Check cache first
    if (useCache && _cache.containsKey(cacheKey)) {
      final OptimizationResult cached = _cache[cacheKey]!;
      if (DateTime.now().difference(cached.timestamp) < _cacheTimeout) {
        return cached;
      }
    }

    _isOptimizing = true;

    try {
      final Map<String, Object> request = <String, Object>{
        'users': users.map((UserLocationData u) => u.toJson()).toList(),
        'max_clusters': maxClusters,
        'min_cluster_size': minClusterSize,
        'max_distance_km': maxDistanceKm,
        'optimization_method': method.name,
      };

      final http.Response response = await http
          .post(
            Uri.parse('$_baseUrl/optimize'),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: json.encode(request),
          )
          .timeout(const Duration(milliseconds: _requestTimeoutMs));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final OptimizationResult result = OptimizationResult.fromJson(data);

        // Cache result
        _cache[cacheKey] = result;

        // Stream updates
        _clustersStreamController.add(result.clusters);
        _metricsStreamController.add(
          OptimizationMetrics(
            totalUsers: result.totalUsers,
            clustersFound: result.clusters.length,
            optimizationTimeMs: result.optimizationTimeMs,
            methodUsed: result.methodUsed,
            successRate: result.successRate,
          ),
        );

        debugPrint('🗺️ Optimization completed: ${result.clusters.length} clusters, '
            '${result.optimizationTimeMs.toStringAsFixed(1)}ms');

        return result;
      } else {
        debugPrint('❌ Optimization request failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Optimization error: $e');
      return null;
    } finally {
      _isOptimizing = false;
    }
  }

  /// Get current user location with permission handling
  Future<UserLocationData?> getCurrentUserLocation({
    required String userId,
    required String walletAddress,
    double activityLevel = 0.5,
    double socialOpenness = 0.5,
    int preferredGroupSize = 4,
  }) async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ Location permissions denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ Location permissions permanently denied');
        return null;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return UserLocationData(
        userId: userId,
        walletAddress: walletAddress,
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        activityLevel: activityLevel,
        socialOpenness: socialOpenness,
        preferredGroupSize: preferredGroupSize,
      );
    } catch (e) {
      debugPrint('❌ Failed to get current location: $e');
      return null;
    }
  }

  /// Calculate distance between two locations
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000.0; // km
  }

  /// Find optimal meeting point for a group of users
  MeetingPoint calculateOptimalMeetingPoint(List<UserLocationData> users) {
    if (users.isEmpty) {
      return const MeetingPoint(latitude: 0.0, longitude: 0.0, confidence: 0.0);
    }

    if (users.length == 1) {
      final UserLocationData user = users.first;
      return MeetingPoint(
        latitude: user.latitude,
        longitude: user.longitude,
        confidence: 1.0,
      );
    }

    // Weighted centroid based on activity and social openness
    double totalWeight = 0.0;
    double weightedLat = 0.0;
    double weightedLng = 0.0;

    for (final UserLocationData user in users) {
      final double weight = (user.activityLevel + user.socialOpenness) / 2.0;
      weightedLat += user.latitude * weight;
      weightedLng += user.longitude * weight;
      totalWeight += weight;
    }

    if (totalWeight == 0) {
      // Fallback to simple centroid
      final double avgLat =
          users.map((UserLocationData u) => u.latitude).reduce((double a, double b) => a + b) /
              users.length;
      final double avgLng =
          users.map((UserLocationData u) => u.longitude).reduce((double a, double b) => a + b) /
              users.length;
      return MeetingPoint(latitude: avgLat, longitude: avgLng, confidence: 0.5);
    }

    final double optimalLat = weightedLat / totalWeight;
    final double optimalLng = weightedLng / totalWeight;

    // Calculate confidence based on user spread
    final double maxDistance = users
        .map(
          (UserLocationData user) => calculateDistance(
            optimalLat,
            optimalLng,
            user.latitude,
            user.longitude,
          ),
        )
        .reduce(math.max);

    final double confidence = math.max(
      0.0,
      1.0 - (maxDistance / 10.0),
    ); // Confidence decreases with spread

    return MeetingPoint(
      latitude: optimalLat,
      longitude: optimalLng,
      confidence: confidence,
    );
  }

  /// Simulate user clustering for demo purposes
  Future<List<UserCluster>> simulateLocalClustering({
    required Position centerPosition,
    int numberOfUsers = 20,
    double radiusKm = 5.0,
  }) async {
    final List<UserLocationData> simulatedUsers =
        _generateSimulatedUsers(centerPosition, numberOfUsers, radiusKm);

    final OptimizationResult? result = await optimizeUserClustering(
      users: simulatedUsers,
      maxClusters: 6,
      maxDistanceKm: radiusKm,
    );

    return result?.clusters ?? <UserCluster>[];
  }

  /// Generate simulated users for testing
  List<UserLocationData> _generateSimulatedUsers(
    Position center,
    int count,
    double radiusKm,
  ) {
    final math.Random random = math.Random();
    final List<UserLocationData> users = <UserLocationData>[];

    for (int i = 0; i < count; i++) {
      // Generate random point within radius
      final double distance = random.nextDouble() * radiusKm;
      final double bearing = random.nextDouble() * 2 * math.pi;

      final double lat = center.latitude + (distance / 111.0) * math.cos(bearing);
      final double lng = center.longitude +
          (distance / (111.0 * math.cos(center.latitude * math.pi / 180))) * math.sin(bearing);

      users.add(
        UserLocationData(
          userId: 'user_$i',
          walletAddress: 'wallet_$i',
          latitude: lat,
          longitude: lng,
          timestamp: DateTime.now(),
          activityLevel: 0.3 + random.nextDouble() * 0.7,
          socialOpenness: 0.3 + random.nextDouble() * 0.7,
          preferredGroupSize: 2 + random.nextInt(6),
        ),
      );
    }

    return users;
  }

  /// Perform periodic optimization for continuous updates
  Future<void> _performPeriodicOptimization() async {
    // In a real implementation, this would:
    // 1. Get current user location
    // 2. Fetch nearby users from backend
    // 3. Run optimization
    // 4. Update streams with results

    debugPrint('🗺️ Performing periodic optimization...');

    // Simulate optimization for demo
    try {
      final Position position = await Geolocator.getCurrentPosition();
      final List<UserCluster> clusters = await simulateLocalClustering(
        centerPosition: position,
        numberOfUsers: 15,
        radiusKm: 3.0,
      );

      _clustersStreamController.add(clusters);
    } catch (e) {
      debugPrint('❌ Periodic optimization failed: $e');
    }
  }

  /// Generate cache key for optimization results
  String _generateCacheKey(
    List<UserLocationData> users,
    int maxClusters,
    double maxDistanceKm,
    OptimizationMethod method,
  ) {
    final String userIds = users.map((UserLocationData u) => u.userId).join(',');
    return '${userIds}_${maxClusters}_${maxDistanceKm}_${method.name}';
  }

  /// Get optimization metrics from backend
  Future<OptimizationMetrics?> getMetrics() async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$_baseUrl/metrics'),
        headers: <String, String>{'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return OptimizationMetrics(
          totalUsers: data['total_optimizations'] ?? 0,
          clustersFound: 0,
          optimizationTimeMs: data['avg_optimization_time_ms']?.toDouble() ?? 0.0,
          methodUsed: 'hybrid',
          successRate: data['quantum_success_rate']?.toDouble() ?? 0.95,
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to get metrics: $e');
    }
    return null;
  }

  /// Dispose of resources
  void dispose() {
    stopContinuousOptimization();
    _clustersStreamController.close();
    _metricsStreamController.close();
    _cache.clear();
  }
}

// Supporting data classes

enum OptimizationMethod {
  classical,
  quantum,
  hybrid,
}

class UserLocationData {
  const UserLocationData({
    required this.userId,
    required this.walletAddress,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.activityLevel,
    required this.socialOpenness,
    required this.preferredGroupSize,
  });

  factory UserLocationData.fromJson(Map<String, dynamic> json) {
    return UserLocationData(
      userId: json['user_id'] as String,
      walletAddress: json['wallet_address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      activityLevel: (json['activity_level'] as num).toDouble(),
      socialOpenness: (json['social_openness'] as num).toDouble(),
      preferredGroupSize: json['preferred_group_size'] as int,
    );
  }
  final String userId;
  final String walletAddress;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double activityLevel;
  final double socialOpenness;
  final int preferredGroupSize;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user_id': userId,
      'wallet_address': walletAddress,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'activity_level': activityLevel,
      'social_openness': socialOpenness,
      'preferred_group_size': preferredGroupSize,
    };
  }
}

class UserCluster {
  const UserCluster({
    required this.clusterId,
    required this.centerLat,
    required this.centerLng,
    required this.userIds,
    required this.compatibilityScore,
    required this.optimalMeetingPoint,
    required this.socialEnergy,
  });

  factory UserCluster.fromJson(Map<String, dynamic> json) {
    return UserCluster(
      clusterId: json['cluster_id'] as String,
      centerLat: (json['center_lat'] as num).toDouble(),
      centerLng: (json['center_lng'] as num).toDouble(),
      userIds: List<String>.from(json['user_ids'] as List),
      compatibilityScore: (json['compatibility_score'] as num).toDouble(),
      optimalMeetingPoint: MeetingPoint.fromJson(json['optimal_meeting_point']),
      socialEnergy: (json['social_energy'] as num).toDouble(),
    );
  }
  final String clusterId;
  final double centerLat;
  final double centerLng;
  final List<String> userIds;
  final double compatibilityScore;
  final MeetingPoint optimalMeetingPoint;
  final double socialEnergy;
}

class MeetingPoint {
  const MeetingPoint({
    required this.latitude,
    required this.longitude,
    required this.confidence,
  });

  factory MeetingPoint.fromJson(Map<String, dynamic> json) {
    return MeetingPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      confidence: 1.0, // Backend doesn't provide confidence yet
    );
  }
  final double latitude;
  final double longitude;
  final double confidence;
}

class OptimizationResult {
  const OptimizationResult({
    required this.clusters,
    required this.totalUsers,
    required this.optimizationTimeMs,
    required this.methodUsed,
    required this.successRate,
    required this.timestamp,
  });

  factory OptimizationResult.fromJson(Map<String, dynamic> json) {
    return OptimizationResult(
      clusters: (json['clusters'] as List).map((c) => UserCluster.fromJson(c)).toList(),
      totalUsers: json['total_users'] as int,
      optimizationTimeMs: (json['optimization_time_ms'] as num).toDouble(),
      methodUsed: json['method_used'] as String,
      successRate: (json['success_rate'] as num).toDouble(),
      timestamp: DateTime.now(),
    );
  }
  final List<UserCluster> clusters;
  final int totalUsers;
  final double optimizationTimeMs;
  final String methodUsed;
  final double successRate;
  final DateTime timestamp;
}

class OptimizationMetrics {
  const OptimizationMetrics({
    required this.totalUsers,
    required this.clustersFound,
    required this.optimizationTimeMs,
    required this.methodUsed,
    required this.successRate,
  });
  final int totalUsers;
  final int clustersFound;
  final double optimizationTimeMs;
  final String methodUsed;
  final double successRate;
}
