import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as dartMath;
import 'dart:async';

class Cyberpunk3DGlobe extends StatefulWidget {
  final double size;
  final VoidCallback? onLocationFound;

  const Cyberpunk3DGlobe({
    super.key,
    this.size = 300,
    this.onLocationFound,
  });

  @override
  State<Cyberpunk3DGlobe> createState() => _Cyberpunk3DGlobeState();
}

class _Cyberpunk3DGlobeState extends State<Cyberpunk3DGlobe>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _zoomController;
  late AnimationController _pulseController;
  late AnimationController _atmosphereController;

  Position? userPosition;
  bool isZoomedIn = false;
  Timer? locationUpdateTimer;
  List<GlobePoint> networkNodes = [];

  // Cyberpunk neon colors
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color neonPink = Color(0xFFFF0080);
  static const Color deepBlack = Color(0xFF232901);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateNetworkNodes();
    _requestLocationPermission();
  }

  void _setupAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _zoomController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _atmosphereController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  void _generateNetworkNodes() {
    final random = dartMath.Random();
    networkNodes.clear();

    // Generate random points on sphere surface
    for (int i = 0; i < 50; i++) {
      final lat = (random.nextDouble() - 0.5) * dartMath.pi;
      final lng = random.nextDouble() * 2 * dartMath.pi;
      final intensity = random.nextDouble();

      networkNodes.add(GlobePoint(
        latitude: lat,
        longitude: lng,
        intensity: intensity,
        color: intensity > 0.7
            ? neonPink
            : (intensity > 0.4 ? neonCyan : neonGreen),
      ));
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _startLocationTracking();
    }
  }

  void _startLocationTracking() {
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _getCurrentLocation();
    });
    _getCurrentLocation(); // Initial location
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          userPosition = position;
        });

        if (!isZoomedIn) {
          _zoomToLocation(position);
        }

        widget.onLocationFound?.call();
      }
    } catch (e) {
      print('Error getting location: $e');
      // Use mock location for demo
      if (mounted) {
        setState(() {
          userPosition = Position(
            latitude: 37.7749,
            longitude: -122.4194,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
        });
        widget.onLocationFound?.call();
      }
    }
  }

  void _zoomToLocation(Position position) {
    isZoomedIn = true;
    _zoomController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _zoomController.dispose();
    _pulseController.dispose();
    _atmosphereController.dispose();
    locationUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer atmosphere glow
          AnimatedBuilder(
            animation: _atmosphereController,
            builder: (context, child) {
              return Container(
                width: widget.size * 1.3,
                height: widget.size * 1.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      neonCyan.withValues(alpha: 0.1),
                      neonGreen.withValues(alpha: 0.2 * _atmosphereController.value),
                      neonPink.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),

          // Main globe
          AnimatedBuilder(
            animation: Listenable.merge([
              _rotationController,
              _zoomController,
              _pulseController,
            ]),
            builder: (context, child) {
              final zoomScale = 1.0 + (_zoomController.value * 1.5);

              return Transform.scale(
                scale: zoomScale,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateY(_rotationController.value * 2 * dartMath.pi)
                    ..rotateX(dartMath
                            .sin(_rotationController.value * 2 * dartMath.pi) *
                        0.2),
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: CyberpunkGlobePainter(
                      rotationValue: _rotationController.value,
                      pulseValue: _pulseController.value,
                      userPosition: userPosition,
                      networkNodes: networkNodes,
                      zoomProgress: _zoomController.value,
                    ),
                  ),
                ),
              );
            },
          ),

          // Location info overlay
          if (userPosition != null && isZoomedIn)
            Positioned(
              bottom: 20,
              child: AnimatedOpacity(
                opacity: _zoomController.value,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: deepBlack.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: neonCyan.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    'LOCATION ACQUIRED\n${userPosition!.latitude.toStringAsFixed(4)}, ${userPosition!.longitude.toStringAsFixed(4)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: neonCyan,
                      fontSize: 10,
                      fontFamily: 'MagdaCleanMono',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GlobePoint {
  final double latitude;
  final double longitude;
  final double intensity;
  final Color color;

  GlobePoint({
    required this.latitude,
    required this.longitude,
    required this.intensity,
    required this.color,
  });
}

class CyberpunkGlobePainter extends CustomPainter {
  final double rotationValue;
  final double pulseValue;
  final Position? userPosition;
  final List<GlobePoint> networkNodes;
  final double zoomProgress;

  CyberpunkGlobePainter({
    required this.rotationValue,
    required this.pulseValue,
    this.userPosition,
    required this.networkNodes,
    required this.zoomProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.8;

    _drawGlobeBase(canvas, center, radius);
    _drawWireframe(canvas, center, radius);
    _drawNetworkNodes(canvas, center, radius);
    _drawUserLocation(canvas, center, radius);
    _drawAtmosphere(canvas, center, radius);
  }

  void _drawGlobeBase(Canvas canvas, Offset center, double radius) {
    // Inner dark sphere
    final basePaint = Paint()
      ..color = const Color(0xFF232901)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, basePaint);

    // Gradient overlay for 3D effect
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF001122).withValues(alpha: 0.8),
          const Color(0xFF232901),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, gradientPaint);
  }

  void _drawWireframe(Canvas canvas, Offset center, double radius) {
    final wireframePaint = Paint()
      ..color = const Color(0xFF00FFFF).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw latitude lines
    for (int i = 1; i < 6; i++) {
      final y = center.dy + (radius * 0.8 * dartMath.cos(i * dartMath.pi / 6));
      final ellipseRadius = radius * dartMath.sin(i * dartMath.pi / 6);

      if (ellipseRadius > 0) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(center.dx, y),
            width: ellipseRadius * 2,
            height: ellipseRadius * 2 * 0.3, // Perspective
          ),
          wireframePaint,
        );
      }
    }

    // Draw longitude lines
    for (int i = 0; i < 8; i++) {
      final path = Path();
      final angle = i * dartMath.pi / 4;

      for (double t = -dartMath.pi / 2; t <= dartMath.pi / 2; t += 0.1) {
        final x = radius *
            dartMath.cos(t) *
            dartMath.cos(angle + rotationValue * 2 * dartMath.pi);
        final y = radius * dartMath.sin(t);
        final z = radius *
            dartMath.cos(t) *
            dartMath.sin(angle + rotationValue * 2 * dartMath.pi);

        // Only draw visible part (z >= 0)
        if (z >= 0) {
          final screenX = center.dx + x;
          final screenY = center.dy + y;

          if (t == -dartMath.pi / 2) {
            path.moveTo(screenX, screenY);
          } else {
            path.lineTo(screenX, screenY);
          }
        }
      }

      canvas.drawPath(path, wireframePaint);
    }
  }

  void _drawNetworkNodes(Canvas canvas, Offset center, double radius) {
    for (final node in networkNodes) {
      final rotatedLng = node.longitude + rotationValue * 2 * dartMath.pi;

      // Convert to 3D coordinates
      final x = radius * dartMath.cos(node.latitude) * dartMath.cos(rotatedLng);
      final y = radius * dartMath.sin(node.latitude);
      final z = radius * dartMath.cos(node.latitude) * dartMath.sin(rotatedLng);

      // Only draw visible nodes (z >= 0)
      if (z >= 0) {
        final screenX = center.dx + x;
        final screenY = center.dy + y;

        final nodePaint = Paint()
          ..color =
              node.color.withValues(alpha: node.intensity * (0.5 + pulseValue * 0.5))
          ..style = PaintingStyle.fill;

        final nodeSize = 2.0 + (node.intensity * 3) + (pulseValue * 2);
        canvas.drawCircle(Offset(screenX, screenY), nodeSize, nodePaint);

        // Add glow effect
        final glowPaint = Paint()
          ..color = node.color.withValues(alpha: 0.3 * pulseValue)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(screenX, screenY), nodeSize * 2, glowPaint);
      }
    }
  }

  void _drawUserLocation(Canvas canvas, Offset center, double radius) {
    if (userPosition == null) return;

    final lat = userPosition!.latitude * (dartMath.pi / 180);
    final lng = userPosition!.longitude * (dartMath.pi / 180) +
        rotationValue * 2 * dartMath.pi;

    // Convert to 3D coordinates
    final x = radius * dartMath.cos(lat) * dartMath.cos(lng);
    final y = radius * dartMath.sin(lat);
    final z = radius * dartMath.cos(lat) * dartMath.sin(lng);

    // Only draw if visible
    if (z >= 0) {
      final screenX = center.dx + x;
      final screenY = center.dy + y;

      // Pulsing user marker
      final markerPaint = Paint()
        ..color = const Color(0xFFFF0080)
        ..style = PaintingStyle.fill;

      final markerSize = 6.0 + (pulseValue * 4);
      canvas.drawCircle(Offset(screenX, screenY), markerSize, markerPaint);

      // Pulsing ring
      final ringPaint = Paint()
        ..color = const Color(0xFFFF0080).withValues(alpha: 0.5 - pulseValue * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(Offset(screenX, screenY), markerSize * 2, ringPaint);

      // Location beam effect
      final beamPaint = Paint()
        ..color = const Color(0xFFFF0080).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawLine(
        Offset(screenX, screenY),
        Offset(screenX, screenY - 30),
        beamPaint,
      );
    }
  }

  void _drawAtmosphere(Canvas canvas, Offset center, double radius) {
    // Outer atmosphere glow
    final atmospherePaint = Paint()
      ..color = const Color(0xFF00FF88).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawCircle(center, radius + 5, atmospherePaint);

    // Multiple atmosphere layers
    for (int i = 1; i <= 3; i++) {
      final layerPaint = Paint()
        ..color = const Color(0xFF00FFFF).withValues(alpha: 0.1 / i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      canvas.drawCircle(center, radius + (i * 8), layerPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
