import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/location_optimizer_service.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';
import '../../../../core/widgets/quantum_glow_engine.dart';

/// Location Clusters View - Displays optimized user clusters on the map
/// Shows real-time clustering results with social energy visualization
class LocationClustersView extends ConsumerStatefulWidget {
  const LocationClustersView({
    super.key,
    this.mapWidth = 400.0,
    this.mapHeight = 300.0,
    this.onClusterTapped,
  });
  final double mapWidth;
  final double mapHeight;
  final Function(UserCluster)? onClusterTapped;

  @override
  ConsumerState<LocationClustersView> createState() => _LocationClustersViewState();
}

class _LocationClustersViewState extends ConsumerState<LocationClustersView>
    with TickerProviderStateMixin {
  final LocationOptimizerService _locationService = LocationOptimizerService();

  // Animation controllers for cluster visualization
  late AnimationController _pulseController;
  late AnimationController _energyController;
  late AnimationController _connectionController;

  // Animations
  late Animation<double> _pulseAnimation;
  late Animation<double> _energyAnimation;
  late Animation<double> _connectionAnimation;

  // Current state
  List<UserCluster> _clusters = <UserCluster>[];
  OptimizationMetrics? _metrics;
  bool _isLoading = false;

  // Stream subscriptions
  StreamSubscription<List<UserCluster>>? _clustersSubscription;
  StreamSubscription<OptimizationMetrics>? _metricsSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeLocationService();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _energyController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _connectionController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _energyAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _energyController, curve: Curves.linear),
    );

    _connectionAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _connectionController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _energyController.repeat();
    _connectionController.repeat(reverse: true);
  }

  Future<void> _initializeLocationService() async {
    setState(() => _isLoading = true);

    final bool initialized = await _locationService.initialize();
    if (initialized) {
      // Subscribe to cluster updates
      _clustersSubscription = _locationService.clustersStream.listen((List<UserCluster> clusters) {
        setState(() {
          _clusters = clusters;
          _isLoading = false;
        });
      });

      // Subscribe to metrics updates
      _metricsSubscription = _locationService.metricsStream.listen((OptimizationMetrics metrics) {
        setState(() => _metrics = metrics);
      });

      // Start continuous optimization
      _locationService.startContinuousOptimization();

      // Load initial data
      _loadInitialClusters();
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadInitialClusters() async {
    try {
      // Get user's current location and simulate nearby clusters
      final UserLocationData? userLocation = await _locationService.getCurrentUserLocation(
        userId: 'current_user',
        walletAddress: 'current_wallet',
        activityLevel: 0.7,
        socialOpenness: 0.8,
      );

      if (userLocation != null) {
        final UserLocationData? position = await _locationService.getCurrentUserLocation(
          userId: 'temp',
          walletAddress: 'temp',
        );

        if (position != null) {
          final List<UserCluster> clusters = await _locationService.simulateLocalClustering(
            centerPosition: await import('package:geolocator/geolocator.dart')
                .then((_) => Geolocator.getCurrentPosition()),
            numberOfUsers: 18,
            radiusKm: 4.0,
          );

          setState(() {
            _clusters = clusters;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Failed to load initial clusters: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.mapWidth,
      height: widget.mapHeight,
      decoration: BoxDecoration(
        color: QuantumDesignTokens.pureBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: QuantumDesignTokens.neonMint.withValues(alpha: 0.3),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: <Widget>[
            // Background grid
            _buildBackgroundGrid(),

            // Cluster visualization
            if (_clusters.isNotEmpty) _buildClustersVisualization(),

            // Loading overlay
            if (_isLoading) _buildLoadingOverlay(),

            // Metrics overlay
            if (_metrics != null) _buildMetricsOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGrid() {
    return AnimatedBuilder(
      animation: _energyAnimation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: LocationGridPainter(
            energyPhase: _energyAnimation.value,
            gridColor: QuantumDesignTokens.deepGray.withValues(alpha: 0.3),
          ),
          size: Size(widget.mapWidth, widget.mapHeight),
        );
      },
    );
  }

  Widget _buildClustersVisualization() {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[_pulseAnimation, _connectionAnimation]),
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: ClustersPainter(
            clusters: _clusters,
            mapWidth: widget.mapWidth,
            mapHeight: widget.mapHeight,
            pulseValue: _pulseAnimation.value,
            connectionValue: _connectionAnimation.value,
          ),
          size: Size(widget.mapWidth, widget.mapHeight),
        );
      },
    );
  }

  Widget _buildLoadingOverlay() {
    return ColoredBox(
      color: QuantumDesignTokens.pureBlack.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            QuantumGlowContainer(
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: QuantumDesignTokens.primaryGradient,
                ),
                child: const Icon(
                  Icons.location_searching,
                  color: QuantumDesignTokens.pureBlack,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'OPTIMIZING LOCATIONS...',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontSM,
                fontWeight: QuantumDesignTokens.weightBold,
                color: QuantumDesignTokens.neonMint,
                glowIntensity: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsOverlay() {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: QuantumDesignTokens.deepGray.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: QuantumDesignTokens.electricBlue.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '${_clusters.length} GROUPS',
              style: QuantumDesignTokens.createQuantumTextStyle(
                fontSize: QuantumDesignTokens.fontNano,
                fontWeight: QuantumDesignTokens.weightBold,
                color: QuantumDesignTokens.electricBlue,
              ),
            ),
            if (_metrics != null) ...<Widget>[
              Text(
                '${_metrics!.optimizationTimeMs.toStringAsFixed(0)}ms',
                style: QuantumDesignTokens.createQuantumTextStyle(
                  fontSize: QuantumDesignTokens.fontNano,
                  color: QuantumDesignTokens.textTertiary,
                ),
              ),
              Text(
                '${(_metrics!.successRate * 100).toStringAsFixed(0)}% SUCCESS',
                style: QuantumDesignTokens.createQuantumTextStyle(
                  fontSize: QuantumDesignTokens.fontNano,
                  color: QuantumDesignTokens.neonMint,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _energyController.dispose();
    _connectionController.dispose();
    _clustersSubscription?.cancel();
    _metricsSubscription?.cancel();
    _locationService.dispose();
    super.dispose();
  }
}

/// Custom painter for location grid background
class LocationGridPainter extends CustomPainter {
  LocationGridPainter({
    required this.energyPhase,
    required this.gridColor,
  });
  final double energyPhase;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw grid lines with energy animation
    const double gridSpacing = 30.0;
    final double energyOffset = math.sin(energyPhase) * 5.0;

    // Vertical lines
    for (double x = 0; x <= size.width; x += gridSpacing) {
      final double adjustedX = x + energyOffset;
      canvas.drawLine(
        Offset(adjustedX, 0),
        Offset(adjustedX, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += gridSpacing) {
      final double adjustedY = y + energyOffset;
      canvas.drawLine(
        Offset(0, adjustedY),
        Offset(size.width, adjustedY),
        paint,
      );
    }

    // Draw energy nodes at intersections
    paint.style = PaintingStyle.fill;
    paint.color = QuantumDesignTokens.neonMint.withValues(alpha: 0.2);

    for (double x = 0; x <= size.width; x += gridSpacing * 2) {
      for (double y = 0; y <= size.height; y += gridSpacing * 2) {
        final double nodeSize = 2.0 + math.sin(energyPhase + x + y) * 1.0;
        canvas.drawCircle(
          Offset(x + energyOffset, y + energyOffset),
          nodeSize,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(LocationGridPainter oldDelegate) {
    return oldDelegate.energyPhase != energyPhase;
  }
}

/// Custom painter for cluster visualization
class ClustersPainter extends CustomPainter {
  ClustersPainter({
    required this.clusters,
    required this.mapWidth,
    required this.mapHeight,
    required this.pulseValue,
    required this.connectionValue,
  });
  final List<UserCluster> clusters;
  final double mapWidth;
  final double mapHeight;
  final double pulseValue;
  final double connectionValue;

  @override
  void paint(Canvas canvas, Size size) {
    if (clusters.isEmpty) return;

    // Find bounds for coordinate mapping
    final List<double> latitudes = clusters.map((UserCluster c) => c.centerLat).toList();
    final List<double> longitudes = clusters.map((UserCluster c) => c.centerLng).toList();

    final double minLat = latitudes.reduce(math.min);
    final double maxLat = latitudes.reduce(math.max);
    final double minLng = longitudes.reduce(math.min);
    final double maxLng = longitudes.reduce(math.max);

    // Add padding
    final double latRange = (maxLat - minLat) * 1.2;
    final double lngRange = (maxLng - minLng) * 1.2;

    // Map coordinates to screen space
    Offset mapToScreen(double lat, double lng) {
      final double x = ((lng - minLng) / lngRange) * size.width;
      final double y = size.height - ((lat - minLat) / latRange) * size.height;
      return Offset(x.clamp(0, size.width), y.clamp(0, size.height));
    }

    // Draw connections between nearby clusters
    _drawClusterConnections(canvas, clusters, mapToScreen);

    // Draw clusters
    for (int i = 0; i < clusters.length; i++) {
      final UserCluster cluster = clusters[i];
      final Offset position = mapToScreen(cluster.centerLat, cluster.centerLng);

      _drawCluster(canvas, cluster, position, i);
    }
  }

  void _drawClusterConnections(
    Canvas canvas,
    List<UserCluster> clusters,
    Offset Function(double, double) mapToScreen,
  ) {
    final Paint connectionPaint = Paint()
      ..color = QuantumDesignTokens.electricBlue.withValues(alpha: 0.3 * connectionValue)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < clusters.length; i++) {
      for (int j = i + 1; j < clusters.length; j++) {
        final UserCluster cluster1 = clusters[i];
        final UserCluster cluster2 = clusters[j];

        final Offset pos1 = mapToScreen(cluster1.centerLat, cluster1.centerLng);
        final Offset pos2 = mapToScreen(cluster2.centerLat, cluster2.centerLng);

        final double distance = (pos1 - pos2).distance;

        // Only draw connections for nearby clusters
        if (distance < 80) {
          canvas.drawLine(pos1, pos2, connectionPaint);
        }
      }
    }
  }

  void _drawCluster(
    Canvas canvas,
    UserCluster cluster,
    Offset position,
    int index,
  ) {
    // Cluster size based on user count and social energy
    final double baseSize = 12.0 + (cluster.userIds.length * 3.0);
    final double energyMultiplier = 0.5 + (cluster.socialEnergy * 0.5);
    final double clusterSize = baseSize * energyMultiplier * pulseValue;

    // Color based on compatibility score
    Color clusterColor;
    if (cluster.compatibilityScore >= 0.8) {
      clusterColor = QuantumDesignTokens.neonMint;
    } else if (cluster.compatibilityScore >= 0.6) {
      clusterColor = QuantumDesignTokens.electricBlue;
    } else if (cluster.compatibilityScore >= 0.4) {
      clusterColor = QuantumDesignTokens.warningAmber;
    } else {
      clusterColor = QuantumDesignTokens.crimsonAlert;
    }

    // Draw cluster glow
    final Paint glowPaint = Paint()
      ..color = clusterColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(position, clusterSize * 1.5, glowPaint);

    // Draw cluster core
    final Paint corePaint = Paint()
      ..color = clusterColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(position, clusterSize, corePaint);

    // Draw cluster border
    final Paint borderPaint = Paint()
      ..color = clusterColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(position, clusterSize, borderPaint);

    // Draw user count indicator
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: cluster.userIds.length.toString(),
        style: QuantumDesignTokens.createQuantumTextStyle(
          fontSize: 12,
          fontWeight: QuantumDesignTokens.weightBold,
          color: QuantumDesignTokens.pureBlack,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    // Draw energy rings for high-energy clusters
    if (cluster.socialEnergy > 0.7) {
      final Paint energyPaint = Paint()
        ..color = clusterColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      for (int ring = 1; ring <= 3; ring++) {
        final double ringRadius = clusterSize + (ring * 8 * pulseValue);
        canvas.drawCircle(position, ringRadius, energyPaint);
      }
    }
  }

  @override
  bool shouldRepaint(ClustersPainter oldDelegate) {
    return oldDelegate.clusters != clusters ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.connectionValue != connectionValue;
  }
}
