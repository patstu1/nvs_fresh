// lib/features/now/presentation/widgets/dynamic_resolution_metacity_view.dart
// Dynamic Resolution Protocol Implementation - Pure Flutter Implementation
// Three-tier quantum reality system: Macro → Meso → Micro

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// === DATA MODELS FOR DYNAMIC RESOLUTION === //

/// Individual user data for all resolution tiers
class UserData {
  const UserData({
    required this.id,
    required this.lat,
    required this.lon,
    required this.profilePhotoUrl,
    required this.dominantAura,
    required this.presenceStrength,
    required this.socialDensity,
    required this.recentActivity,
    required this.isVip,
    required this.isOnline,
    required this.isInteracting,
    required this.username,
    required this.age,
  });
  final String id;
  final double lat;
  final double lon;
  final String profilePhotoUrl;
  final String dominantAura;
  final double presenceStrength;
  final double socialDensity;
  final double recentActivity;
  final bool isVip;
  final bool isOnline;
  final bool isInteracting;
  final String username;
  final int age;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'lat': lat,
      'lon': lon,
      'profilePhotoUrl': profilePhotoUrl,
      'dominantAura': dominantAura,
      'presenceStrength': presenceStrength,
      'socialDensity': socialDensity,
      'recentActivity': recentActivity,
      'isVip': isVip,
      'isOnline': isOnline,
      'isInteracting': isInteracting,
      'username': username,
      'age': age,
    };
  }
}

/// Cluster data for Tier 3 (macro view)
class UserCluster {
  const UserCluster({
    required this.id,
    required this.lat,
    required this.lon,
    required this.density,
    required this.aura,
    required this.userCount,
    required this.averageAge,
    required this.dominantInterests,
    required this.userIds,
  });
  final String id;
  final double lat;
  final double lon;
  final double density;
  final String aura;
  final int userCount;
  final int averageAge;
  final String dominantInterests;
  final List<String> userIds;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'lat': lat,
      'lon': lon,
      'density': density,
      'aura': aura,
      'userCount': userCount,
      'averageAge': averageAge,
      'dominantInterests': dominantInterests,
      'userIds': userIds,
    };
  }
}

/// Comprehensive metacity data including all resolution tiers
class MetacityData {
  const MetacityData({
    required this.users,
    required this.clusters,
    required this.timestamp,
  });
  final List<UserData> users;
  final List<UserCluster> clusters;
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'users': users.map((UserData u) => u.toJson()).toList(),
      'clusters': clusters.map((UserCluster c) => c.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Camera state for altitude-based tier control
class CameraState {
  const CameraState({
    required this.altitude,
    required this.azimuth,
    required this.pitch,
    required this.currentTier,
    this.focusedUserId,
  });
  final double altitude;
  final double azimuth;
  final double pitch;
  final ResolutionTier currentTier;
  final String? focusedUserId;

  CameraState copyWith({
    double? altitude,
    double? azimuth,
    double? pitch,
    ResolutionTier? currentTier,
    String? focusedUserId,
  }) {
    return CameraState(
      altitude: altitude ?? this.altitude,
      azimuth: azimuth ?? this.azimuth,
      pitch: pitch ?? this.pitch,
      currentTier: currentTier ?? this.currentTier,
      focusedUserId: focusedUserId ?? this.focusedUserId,
    );
  }
}

enum ResolutionTier { tier1, tier2, tier3 }

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier()
      : super(
          const CameraState(
            altitude: 1000.0,
            azimuth: 0.0,
            pitch: -45.0,
            currentTier: ResolutionTier.tier2,
          ),
        );

  void updateAltitude(double altitude) {
    final ResolutionTier newTier = _calculateTierFromAltitude(altitude);
    state = state.copyWith(altitude: altitude, currentTier: newTier);
  }

  void updateOrientation(double azimuth, double pitch) {
    state = state.copyWith(azimuth: azimuth, pitch: pitch);
  }

  void focusOnUser(String userId) {
    state = state.copyWith(
      focusedUserId: userId,
      altitude: 25.0, // Tier 1 altitude for individual focus
      currentTier: ResolutionTier.tier1,
    );
  }

  void resetFocus() {
    state = state.copyWith(
      altitude: 500.0,
      currentTier: ResolutionTier.tier2,
    );
  }

  ResolutionTier _calculateTierFromAltitude(double altitude) {
    if (altitude < 50) {
      return ResolutionTier.tier1; // Micro: Holographic Avatars
    }
    if (altitude < 5000) return ResolutionTier.tier2; // Meso: Bubble Clusters
    return ResolutionTier.tier3; // Macro: Energy Clusters
  }
}

// === PROVIDERS === //

/// Enhanced data provider that handles all three tiers of the Dynamic Resolution Protocol
final StreamProvider<MetacityData> metacityDataProvider =
    StreamProvider<MetacityData>((StreamProviderRef<MetacityData> ref) async* {
  while (true) {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // High frequency for real-time feel

    // Generate comprehensive user data for all resolution tiers
    final List<UserData> users = _generateUserData();
    final List<UserCluster> clusters = _generateClusterData(users);

    yield MetacityData(
      users: users,
      clusters: clusters,
      timestamp: DateTime.now(),
    );
  }
});

/// Camera state provider for altitude-based tier control
final StateNotifierProvider<CameraStateNotifier, CameraState> cameraStateProvider =
    StateNotifierProvider<CameraStateNotifier, CameraState>(
        (StateNotifierProviderRef<CameraStateNotifier, CameraState> ref) {
  return CameraStateNotifier();
});

/// Mock city locations for realistic positioning
const Map<String, Map<String, double>> cityLocations = <String, Map<String, double>>{
  'Los Angeles': <String, double>{'lat': 34.0522, 'lon': -118.2437},
  'New York': <String, double>{'lat': 40.7128, 'lon': -74.0060},
  'San Francisco': <String, double>{'lat': 37.7749, 'lon': -122.4194},
  'Chicago': <String, double>{'lat': 41.8781, 'lon': -87.6298},
  'Miami': <String, double>{'lat': 25.7617, 'lon': -80.1918},
  'Dallas': <String, double>{'lat': 32.7767, 'lon': -96.7970},
  'Seattle': <String, double>{'lat': 47.6062, 'lon': -122.3321},
  'Denver': <String, double>{'lat': 39.7392, 'lon': -104.9903},
};

List<UserData> _generateUserData() {
  final math.Random random = math.Random();
  final List<String> cities = cityLocations.keys.toList();

  return List.generate(150, (int index) {
    // Generate density for Sniffies-style experience
    final String randomCity = cities[random.nextInt(cities.length)];
    final Map<String, double> cityData = cityLocations[randomCity]!;

    return UserData(
      id: 'user_$index',
      lat: cityData['lat']! + (random.nextDouble() - 0.5) * 0.01,
      lon: cityData['lon']! + (random.nextDouble() - 0.5) * 0.01,
      profilePhotoUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=user_$index',
      dominantAura: <String>[
        'social',
        'cruising',
        'chill',
        'live',
        'mysterious',
      ][random.nextInt(5)],
      presenceStrength: random.nextDouble(),
      socialDensity: random.nextDouble(),
      recentActivity: random.nextDouble(),
      isVip: random.nextBool(),
      isOnline: random.nextDouble() > 0.2, // 80% online
      isInteracting: random.nextDouble() > 0.7, // 30% actively interacting
      username: 'User$index',
      age: random.nextInt(30) + 18,
    );
  });
}

List<UserCluster> _generateClusterData(List<UserData> users) {
  final List<UserCluster> clusters = <UserCluster>[];

  // Group users by proximity for clustering
  final Map<String, List<UserData>> groupedUsers = <String, List<UserData>>{};
  for (final UserData user in users) {
    final String key = '${(user.lat * 100).floor()}_${(user.lon * 100).floor()}';
    groupedUsers.putIfAbsent(key, () => <UserData>[]).add(user);
  }

  // Create clusters from groups with 3+ users
  groupedUsers.forEach((String key, List<UserData> userGroup) {
    if (userGroup.length >= 3) {
      final double avgLat =
          userGroup.map((UserData u) => u.lat).reduce((double a, double b) => a + b) /
              userGroup.length;
      final double avgLon =
          userGroup.map((UserData u) => u.lon).reduce((double a, double b) => a + b) /
              userGroup.length;

      clusters.add(
        UserCluster(
          id: 'cluster_${clusters.length}',
          lat: avgLat,
          lon: avgLon,
          density: (userGroup.length / 20.0).clamp(0.0, 1.0),
          aura: _getDominantAura(userGroup),
          userCount: userGroup.length,
          averageAge: userGroup.map((UserData u) => u.age).reduce((int a, int b) => a + b) ~/
              userGroup.length,
          dominantInterests: 'mixed',
          userIds: userGroup.map((UserData u) => u.id).toList(),
        ),
      );
    }
  });

  return clusters;
}

String _getDominantAura(List<UserData> users) {
  final Map<String, int> auraCount = <String, int>{};
  for (final UserData user in users) {
    auraCount[user.dominantAura] = (auraCount[user.dominantAura] ?? 0) + 1;
  }
  return auraCount.entries
      .reduce(
        (MapEntry<String, int> a, MapEntry<String, int> b) => a.value > b.value ? a : b,
      )
      .key;
}

// === MAIN WIDGET === //

/// Dynamic Resolution Metacity View - Pure Flutter Implementation
/// This implements the three-tier reality system with advanced visual effects
class DynamicResolutionMetacityView extends ConsumerStatefulWidget {
  const DynamicResolutionMetacityView({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onUserTap,
    this.onClusterTap,
  });
  final double width;
  final double height;
  final Function(UserData)? onUserTap;
  final Function(UserCluster)? onClusterTap;

  @override
  ConsumerState<DynamicResolutionMetacityView> createState() =>
      _DynamicResolutionMetacityViewState();
}

class _DynamicResolutionMetacityViewState extends ConsumerState<DynamicResolutionMetacityView>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _transitionController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<MetacityData> metacityData = ref.watch(metacityDataProvider);
    final CameraState cameraState = ref.watch(cameraStateProvider);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF04FFF7).withOpacity(0.3)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF04FFF7).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: <Widget>[
            // Main metacity visualization
            Positioned.fill(
              child: metacityData.when(
                data: (MetacityData data) => _buildFlutterMetacity(data, cameraState),
                loading: _buildLoadingState,
                error: (Object error, StackTrace stack) => _buildErrorState(error),
              ),
            ),

            // Overlay UI Controls
            _buildMetacityControls(cameraState),

            // Resolution Tier Indicator
            _buildTierIndicator(cameraState.currentTier),
          ],
        ),
      ),
    );
  }

  Widget _buildFlutterMetacity(MetacityData data, CameraState cameraState) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[
        _rotationController,
        _pulseController,
        _transitionController,
      ]),
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: DynamicResolutionPainter(
            data: data,
            cameraState: cameraState,
            rotationValue: _rotationController.value,
            pulseValue: _pulseController.value,
            transitionValue: _transitionController.value,
            onUserTap: widget.onUserTap,
            onClusterTap: widget.onClusterTap,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF04FFF7).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF04FFF7)),
                strokeWidth: 1,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'INITIALIZING\nQUANTUM METACITY...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF04FFF7),
                fontSize: 12,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Color(0xFFFF073A),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'METACITY OFFLINE',
              style: TextStyle(
                color: Color(0xFFFF073A),
                fontSize: 16,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Error: ${error.toString()}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetacityControls(CameraState cameraState) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF04FFF7).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getTierColor(cameraState.currentTier),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: _getTierColor(cameraState.currentTier).withOpacity(0.6),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'DYNAMIC RESOLUTION',
                  style: TextStyle(
                    color: _getTierColor(cameraState.currentTier),
                    fontSize: 10,
                    fontFamily: 'MagdaCleanMono',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Altitude control slider
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.flight_land,
                  color: Color(0xFF04FFF7),
                  size: 12,
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 80,
                  child: Slider(
                    value: _normalizeAltitude(cameraState.altitude),
                    onChanged: (double value) {
                      final double altitude = _denormalizeAltitude(value);
                      ref.read(cameraStateProvider.notifier).updateAltitude(altitude);
                      _transitionController.forward(from: 0);
                    },
                    activeColor: const Color(0xFF04FFF7),
                    inactiveColor: const Color(0xFF04FFF7).withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.flight_takeoff,
                  color: Color(0xFF04FFF7),
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierIndicator(ResolutionTier tier) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getTierColor(tier).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _getTierName(tier),
              style: TextStyle(
                color: _getTierColor(tier),
                fontSize: 12,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getTierDescription(tier),
              style: TextStyle(
                color: _getTierColor(tier).withOpacity(0.7),
                fontSize: 8,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === UTILITY METHODS === //

  double _normalizeAltitude(double altitude) {
    // Normalize altitude from 10-10000 to 0-1
    return ((altitude - 10) / (10000 - 10)).clamp(0.0, 1.0);
  }

  double _denormalizeAltitude(double normalized) {
    // Convert 0-1 back to 10-10000 altitude range
    return 10 + (normalized * (10000 - 10));
  }

  Color _getTierColor(ResolutionTier tier) {
    switch (tier) {
      case ResolutionTier.tier1:
        return const Color(0xFFFF6B35); // Micro: Holographic Avatars
      case ResolutionTier.tier2:
        return const Color(0xFF04FFF7); // Meso: Bubble Clusters
      case ResolutionTier.tier3:
        return const Color(0xFF8A2BE2); // Macro: Energy Clusters
    }
  }

  String _getTierName(ResolutionTier tier) {
    switch (tier) {
      case ResolutionTier.tier1:
        return 'TIER 1: MICRO';
      case ResolutionTier.tier2:
        return 'TIER 2: MESO';
      case ResolutionTier.tier3:
        return 'TIER 3: MACRO';
    }
  }

  String _getTierDescription(ResolutionTier tier) {
    switch (tier) {
      case ResolutionTier.tier1:
        return 'Holographic Avatars';
      case ResolutionTier.tier2:
        return 'Bubble Clusters';
      case ResolutionTier.tier3:
        return 'Energy Clusters';
    }
  }
}

class DynamicResolutionPainter extends CustomPainter {
  DynamicResolutionPainter({
    required this.data,
    required this.cameraState,
    required this.rotationValue,
    required this.pulseValue,
    required this.transitionValue,
    this.onUserTap,
    this.onClusterTap,
  });
  final MetacityData data;
  final CameraState cameraState;
  final double rotationValue;
  final double pulseValue;
  final double transitionValue;
  final Function(UserData)? onUserTap;
  final Function(UserCluster)? onClusterTap;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw based on current tier
    switch (cameraState.currentTier) {
      case ResolutionTier.tier1:
        _drawTier1Micro(canvas, center, size);
        break;
      case ResolutionTier.tier2:
        _drawTier2Meso(canvas, center, size);
        break;
      case ResolutionTier.tier3:
        _drawTier3Macro(canvas, center, size);
        break;
    }
  }

  void _drawTier1Micro(Canvas canvas, Offset center, Size size) {
    // Individual holographic avatars with high detail
    for (final UserData user in data.users.take(20)) {
      final double angle = user.lat * 100; // Use lat as angle for positioning
      final double distance = (user.lon + 118) * 10; // Adjust distance based on lon

      final Offset position = Offset(
        center.dx + distance * math.cos(angle + rotationValue * 2 * math.pi),
        center.dy + distance * math.sin(angle + rotationValue * 2 * math.pi),
      );

      _drawHolographicAvatar(canvas, position, user);
    }
  }

  void _drawTier2Meso(Canvas canvas, Offset center, Size size) {
    // Bubble clusters of users
    for (final UserCluster cluster in data.clusters) {
      final double angle = cluster.lat * 100;
      final double distance = (cluster.lon + 118) * 15;

      final Offset position = Offset(
        center.dx + distance * math.cos(angle + rotationValue * math.pi),
        center.dy + distance * math.sin(angle + rotationValue * math.pi),
      );

      _drawBubbleCluster(canvas, position, cluster);
    }
  }

  void _drawTier3Macro(Canvas canvas, Offset center, Size size) {
    // Energy clusters with connections
    for (int i = 0; i < data.clusters.length; i++) {
      final UserCluster cluster = data.clusters[i];
      final double angle = (i / data.clusters.length) * 2 * math.pi + rotationValue * math.pi;
      final double distance = 100 + cluster.density * 80;

      final Offset position = Offset(
        center.dx + distance * math.cos(angle),
        center.dy + distance * math.sin(angle),
      );

      _drawEnergyCluster(canvas, position, cluster);

      // Draw connections between clusters
      if (i > 0) {
        final UserCluster prevCluster = data.clusters[i - 1];
        final double prevAngle =
            ((i - 1) / data.clusters.length) * 2 * math.pi + rotationValue * math.pi;
        final double prevDistance = 100 + prevCluster.density * 80;
        final Offset prevPosition = Offset(
          center.dx + prevDistance * math.cos(prevAngle),
          center.dy + prevDistance * math.sin(prevAngle),
        );

        _drawConnection(canvas, position, prevPosition);
      }
    }
  }

  void _drawHolographicAvatar(Canvas canvas, Offset position, UserData user) {
    final Paint paint = Paint()
      ..color = _getAuraColor(user.dominantAura).withOpacity(0.8 + pulseValue * 0.2)
      ..style = PaintingStyle.fill;

    // Main avatar circle
    canvas.drawCircle(position, 8 + user.presenceStrength * 4, paint);

    // Holographic ring
    final Paint ringPaint = Paint()
      ..color = _getAuraColor(user.dominantAura).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(position, 12 + pulseValue * 4, ringPaint);

    // Status indicator
    if (user.isOnline) {
      final Paint statusPaint = Paint()
        ..color = const Color(0xFF00FF9F)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(position.dx + 6, position.dy - 6),
        2,
        statusPaint,
      );
    }
  }

  void _drawBubbleCluster(Canvas canvas, Offset position, UserCluster cluster) {
    final double bubbleSize = 20 + cluster.density * 30;

    // Main bubble
    final Paint bubblePaint = Paint()
      ..color = _getAuraColor(cluster.aura).withOpacity(0.3 + pulseValue * 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, bubbleSize, bubblePaint);

    // Bubble outline
    final Paint outlinePaint = Paint()
      ..color = _getAuraColor(cluster.aura)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(position, bubbleSize, outlinePaint);

    // User count indicator
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: cluster.userCount.toString(),
        style: TextStyle(
          color: _getAuraColor(cluster.aura),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawEnergyCluster(Canvas canvas, Offset position, UserCluster cluster) {
    final double energySize = 15 + cluster.density * 20;

    // Energy core
    final Paint corePaint = Paint()
      ..color = _getAuraColor(cluster.aura)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, energySize * 0.3, corePaint);

    // Energy field
    final Paint fieldPaint = Paint()
      ..color = _getAuraColor(cluster.aura).withOpacity(0.2 + pulseValue * 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, energySize, fieldPaint);

    // Energy spikes
    for (int i = 0; i < 8; i++) {
      final double angle = (i / 8) * 2 * math.pi + rotationValue * 2 * math.pi;
      final Offset spikeEnd = Offset(
        position.dx + (energySize + 10) * math.cos(angle),
        position.dy + (energySize + 10) * math.sin(angle),
      );

      final Paint spikePaint = Paint()
        ..color = _getAuraColor(cluster.aura).withOpacity(0.6)
        ..strokeWidth = 2;

      canvas.drawLine(position, spikeEnd, spikePaint);
    }
  }

  void _drawConnection(Canvas canvas, Offset start, Offset end) {
    final Paint connectionPaint = Paint()
      ..color = const Color(0xFF04FFF7).withOpacity(0.3 + pulseValue * 0.2)
      ..strokeWidth = 1;

    canvas.drawLine(start, end, connectionPaint);
  }

  Color _getAuraColor(String aura) {
    switch (aura) {
      case 'social':
        return const Color(0xFF04FFF7);
      case 'cruising':
        return const Color(0xFFFF6B35);
      case 'chill':
        return const Color(0xFF00FF9F);
      case 'live':
        return const Color(0xFF8A2BE2);
      case 'mysterious':
        return const Color(0xFFFF073A);
      default:
        return const Color(0xFF04FFF7);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
