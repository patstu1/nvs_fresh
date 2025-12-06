// lib/features/now/presentation/widgets/quantum_metacity_view.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nvs/meatup_core.dart';

/// Quantum-clustered user data from the backend
class UserCluster {
  const UserCluster({
    required this.id,
    required this.lat,
    required this.lon,
    required this.density,
    required this.aura,
    required this.userCount,
    required this.intensity,
    this.dominantTags = const <String>[],
  });

  factory UserCluster.fromJson(Map<String, dynamic> json) {
    return UserCluster(
      id: json['id'],
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      density: (json['density'] as num).toDouble(),
      aura: json['aura'] ?? 'social',
      userCount: json['userCount'] ?? 1,
      intensity: (json['intensity'] as num?)?.toDouble() ?? 0.5,
      dominantTags: List<String>.from(json['dominantTags'] ?? <dynamic>[]),
    );
  }
  final String id;
  final double lat;
  final double lon;
  final double density; // 0.0 to 1.0
  final String aura; // 'social', 'cruising', 'chill', 'live'
  final int userCount;
  final double intensity;
  final List<String> dominantTags;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'lat': lat,
      'lon': lon,
      'density': density,
      'aura': aura,
      'userCount': userCount,
      'intensity': intensity,
      'dominantTags': dominantTags,
    };
  }

  Color get auraColor {
    switch (aura) {
      case 'social':
        return NVSColors.neonMint;
      case 'cruising':
        return NVSColors.neonPink;
      case 'chill':
        return NVSColors.hologramBlue;
      case 'live':
        return NVSColors.neonOrange;
      default:
        return NVSColors.neonPurple;
    }
  }
}

/// Mock data provider for quantum cluster data
/// In production, this would connect to the Qiskit quantum clustering backend
final StreamProvider<List<UserCluster>> metacityDataProvider =
    StreamProvider<List<UserCluster>>((StreamProviderRef<List<UserCluster>> ref) async* {
  // Simulate real-time quantum clustering updates
  while (true) {
    await Future.delayed(const Duration(seconds: 5));

    final List<UserCluster> clusters = _generateMockClusters();
    yield clusters;
  }
});

List<UserCluster> _generateMockClusters() {
  final math.Random random = math.Random();
  final List<UserCluster> clusters = <UserCluster>[];

  // Generate 8-15 clusters around major cities
  final List<Map<String, Object>> cityLocations = <Map<String, Object>>[
    <String, Object>{'lat': 34.0522, 'lon': -118.2437, 'name': 'Los Angeles'},
    <String, Object>{'lat': 40.7128, 'lon': -74.0060, 'name': 'New York'},
    <String, Object>{'lat': 37.7749, 'lon': -122.4194, 'name': 'San Francisco'},
    <String, Object>{'lat': 41.8781, 'lon': -87.6298, 'name': 'Chicago'},
    <String, Object>{'lat': 25.7617, 'lon': -80.1918, 'name': 'Miami'},
    <String, Object>{'lat': 32.7767, 'lon': -96.7970, 'name': 'Dallas'},
    <String, Object>{'lat': 47.6062, 'lon': -122.3321, 'name': 'Seattle'},
    <String, Object>{'lat': 39.7392, 'lon': -104.9903, 'name': 'Denver'},
  ];

  final List<String> auras = <String>['social', 'cruising', 'chill', 'live'];

  for (int i = 0; i < cityLocations.length; i++) {
    final Map<String, Object> city = cityLocations[i];
    final int clusterCount = random.nextInt(3) + 1; // 1-3 clusters per city

    for (int j = 0; j < clusterCount; j++) {
      // Add some randomness to position
      final double latOffset = (random.nextDouble() - 0.5) * 0.2;
      final double lonOffset = (random.nextDouble() - 0.5) * 0.2;

      clusters.add(
        UserCluster(
          id: 'cluster_${i}_$j',
          lat: (city['lat'] as double) + latOffset,
          lon: (city['lon'] as double) + lonOffset,
          density: random.nextDouble(),
          aura: auras[random.nextInt(auras.length)],
          userCount: random.nextInt(50) + 5,
          intensity: random.nextDouble(),
          dominantTags: _generateRandomTags(random),
        ),
      );
    }
  }

  return clusters;
}

List<String> _generateRandomTags(math.Random random) {
  final List<String> allTags = <String>[
    'athletic',
    'creative',
    'professional',
    'student',
    'artist',
    'tech',
    'music',
    'outdoor',
  ];
  final int tagCount = random.nextInt(3) + 1;
  final List<String> tags = <String>[];

  for (int i = 0; i < tagCount; i++) {
    tags.add(allTags[random.nextInt(allTags.length)]);
  }

  return tags.toSet().toList(); // Remove duplicates
}

/// The quantum metacity visualization widget
/// This replaces the spinning globe with a live, interactive 3D city
class QuantumMetacityView extends ConsumerStatefulWidget {
  const QuantumMetacityView({
    super.key,
    this.width = 400,
    this.height = 400,
    this.onClusterTap,
  });
  final double width;
  final double height;
  final Function(UserCluster)? onClusterTap;

  @override
  ConsumerState<QuantumMetacityView> createState() => _QuantumMetacityViewState();
}

class _QuantumMetacityViewState extends ConsumerState<QuantumMetacityView>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _scanController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  UserCluster? selectedCluster;

  @override
  void initState() {
    super.initState();

    // Slow rotation for the city view
    _rotationController = AnimationController(
      duration: const Duration(seconds: 120),
      vsync: this,
    )..repeat();

    // Pulse animation for cluster breathing
    _pulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // Scanning beam animation
    _scanController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<UserCluster>> clustersAsync = ref.watch(metacityDataProvider);

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NVSColors.neonMint.withOpacity(0.3)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.neonMint.withOpacity(0.1),
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
              child: clustersAsync.when(
                data: _buildMetacityVisualization,
                loading: _buildLoadingMetacity,
                error: (Object error, StackTrace stack) => _buildErrorMetacity(error),
              ),
            ),

            // Overlay UI elements
            _buildMetacityOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetacityVisualization(List<UserCluster> clusters) {
    return AnimatedBuilder(
      animation: Listenable.merge(
        <Listenable?>[_rotationAnimation, _pulseAnimation, _scanAnimation],
      ),
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: QuantumMetacityPainter(
            clusters: clusters,
            rotationAngle: _rotationAnimation.value,
            pulseIntensity: _pulseAnimation.value,
            scanAngle: _scanAnimation.value,
            onClusterTap: widget.onClusterTap,
          ),
        );
      },
    );
  }

  Widget _buildLoadingMetacity() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: NVSColors.neonMint.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(NVSColors.neonMint),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'QUANTUM CLUSTERING...',
            style: TextStyle(
              color: NVSColors.neonMint,
              fontSize: 14,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMetacity(Object error) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: NVSColors.error,
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'METACITY OFFLINE',
            style: TextStyle(
              color: NVSColors.error,
              fontSize: 16,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetacityOverlay() {
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
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NVSColors.neonMint.withOpacity(0.3)),
            ),
            child: const Text(
              'LIVE METACITY',
              style: TextStyle(
                color: NVSColors.neonMint,
                fontSize: 10,
                fontFamily: 'MagdaCleanMono',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: NVSColors.neonMint,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'QUANTUM',
                  style: TextStyle(
                    color: NVSColors.neonMint,
                    fontSize: 8,
                    fontFamily: 'MagdaCleanMono',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the quantum metacity visualization
class QuantumMetacityPainter extends CustomPainter {
  QuantumMetacityPainter({
    required this.clusters,
    required this.rotationAngle,
    required this.pulseIntensity,
    required this.scanAngle,
    this.onClusterTap,
  });
  final List<UserCluster> clusters;
  final double rotationAngle;
  final double pulseIntensity;
  final double scanAngle;
  final Function(UserCluster)? onClusterTap;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2 - 20;

    // Draw the metacity base grid
    _drawMetacityGrid(canvas, center, radius);

    // Draw scanning beams
    _drawQuantumScanBeams(canvas, center, radius);

    // Draw user clusters as holographic towers
    _drawUserClusters(canvas, center, radius);

    // Draw information streams
    _drawDataStreams(canvas, center, radius);
  }

  void _drawMetacityGrid(Canvas canvas, Offset center, double radius) {
    final Paint gridPaint = Paint()
      ..color = NVSColors.neonMint.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Concentric circles representing city zones
    for (int i = 1; i <= 5; i++) {
      final double zoneRadius = (radius / 5) * i;
      canvas.drawCircle(center, zoneRadius, gridPaint);
    }

    // Radial city sectors
    for (int i = 0; i < 24; i++) {
      final double angle = (i * 15) * (math.pi / 180);
      final Offset endPoint = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, gridPaint);
    }

    // Draw hexagonal overlay for quantum field structure
    _drawHexagonalPattern(canvas, center, radius);
  }

  void _drawHexagonalPattern(Canvas canvas, Offset center, double radius) {
    final Paint hexPaint = Paint()
      ..color = NVSColors.neonMint.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final double hexSize = radius / 8;
    for (int i = 0; i < 6; i++) {
      final Path path = Path();
      for (int j = 0; j < 6; j++) {
        final double angle = (j * 60) * (math.pi / 180);
        final double x = center.dx + hexSize * math.cos(angle);
        final double y = center.dy + hexSize * math.sin(angle);
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, hexPaint);
    }
  }

  void _drawQuantumScanBeams(Canvas canvas, Offset center, double radius) {
    final Paint beamPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: <Color>[
          NVSColors.neonMint.withOpacity(0.2),
          NVSColors.neonMint.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Primary scanning beam
    final Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      scanAngle - 0.3,
      0.6,
      false,
    );
    path.close();
    canvas.drawPath(path, beamPaint);

    // Secondary beam offset by 180 degrees
    final Path path2 = Path();
    path2.moveTo(center.dx, center.dy);
    path2.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      scanAngle + math.pi - 0.2,
      0.4,
      false,
    );
    path2.close();
    canvas.drawPath(path2, beamPaint);
  }

  void _drawUserClusters(Canvas canvas, Offset center, double radius) {
    for (final UserCluster cluster in clusters) {
      // Convert lat/lon to polar coordinates for circular city layout
      final double angle = ((cluster.lon + 180) / 360) * 2 * math.pi + rotationAngle;
      final double distance = ((cluster.lat + 90) / 180) * radius * 0.8;

      final Offset position = Offset(
        center.dx + distance * math.cos(angle),
        center.dy + distance * math.sin(angle),
      );

      _drawClusterTower(canvas, position, cluster);
    }
  }

  void _drawClusterTower(Canvas canvas, Offset position, UserCluster cluster) {
    final double intensity = cluster.intensity * pulseIntensity;
    final double height = cluster.density * 30 + 10;
    final double width = cluster.userCount.clamp(3, 15).toDouble();

    // Draw the holographic tower base
    final Paint basePaint = Paint()
      ..color = cluster.auraColor.withOpacity(0.3 * intensity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, width, basePaint);

    // Draw the tower structure
    final Paint towerPaint = Paint()
      ..color = cluster.auraColor.withOpacity(0.8 * intensity)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final Rect towerRect = Rect.fromCenter(
      center: Offset(position.dx, position.dy - height / 2),
      width: width * 0.6,
      height: height,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(towerRect, const Radius.circular(2)),
      towerPaint,
    );

    // Draw the energy field around the tower
    final Paint fieldPaint = Paint()
      ..color = cluster.auraColor.withOpacity(0.2 * intensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(position, width + 5, fieldPaint);

    // Draw cluster information
    if (width > 8) {
      _drawClusterInfo(canvas, position, cluster);
    }
  }

  void _drawClusterInfo(Canvas canvas, Offset position, UserCluster cluster) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: cluster.userCount.toString(),
        style: TextStyle(
          color: cluster.auraColor,
          fontSize: 8,
          fontFamily: 'MagdaCleanMono',
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

  void _drawDataStreams(Canvas canvas, Offset center, double radius) {
    final Paint streamPaint = Paint()
      ..color = NVSColors.neonMint.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // Draw flowing data streams between clusters
    for (int i = 0; i < clusters.length - 1; i++) {
      final UserCluster cluster1 = clusters[i];
      final UserCluster cluster2 = clusters[i + 1];

      final double angle1 = ((cluster1.lon + 180) / 360) * 2 * math.pi + rotationAngle;
      final double distance1 = ((cluster1.lat + 90) / 180) * radius * 0.8;
      final Offset pos1 = Offset(
        center.dx + distance1 * math.cos(angle1),
        center.dy + distance1 * math.sin(angle1),
      );

      final double angle2 = ((cluster2.lon + 180) / 360) * 2 * math.pi + rotationAngle;
      final double distance2 = ((cluster2.lat + 90) / 180) * radius * 0.8;
      final Offset pos2 = Offset(
        center.dx + distance2 * math.cos(angle2),
        center.dy + distance2 * math.sin(angle2),
      );

      // Draw curved connection
      final Path path = Path();
      path.moveTo(pos1.dx, pos1.dy);
      path.quadraticBezierTo(
        center.dx,
        center.dy,
        pos2.dx,
        pos2.dy,
      );

      canvas.drawPath(path, streamPaint);
    }
  }

  @override
  bool shouldRepaint(QuantumMetacityPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.pulseIntensity != pulseIntensity ||
        oldDelegate.scanAngle != scanAngle ||
        oldDelegate.clusters != clusters;
  }
}
