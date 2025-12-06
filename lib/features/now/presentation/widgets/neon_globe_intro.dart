import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'dart:math' as math;

class NeonGlobeIntro extends StatefulWidget {

  const NeonGlobeIntro({super.key, this.onComplete});
  final VoidCallback? onComplete;

  @override
  State<NeonGlobeIntro> createState() => _NeonGlobeIntroState();
}

class _NeonGlobeIntroState extends State<NeonGlobeIntro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        // Start very small and slowly zoom to large
        final double size = 20 + (_controller.value * 280); // Grows from 20 to 300

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                NVSColors.pureBlack,
                NVSColors.pureBlack.withOpacity(0.8),
                NVSColors.primaryNeonMint.withOpacity(0.1),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Realistic dotted neon globe that starts small and slowly zooms while spinning
                Transform.rotate(
                  angle: _controller.value *
                      8 *
                      math.pi, // Fast continuous spinning
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.primaryNeonMint
                              .withOpacity(_controller.value * 0.8),
                          blurRadius: 40 + (_controller.value * 60),
                          spreadRadius: 10 + (_controller.value * 20),
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      size: Size(size, size),
                      painter: DottedGlobePainter(
                        animationProgress: _controller.value,
                        glowIntensity: _controller.value,
                        color: NVSColors.primaryNeonMint,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Loading text
                const Text(
                  'CONNECTING TO YOUR LOCATION',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    color: NVSColors.primaryNeonMint,
                    letterSpacing: 2,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Pulsing loading indicator
                Container(
                  width: 100 + (_controller.value * 50),
                  height: 2,
                  decoration: BoxDecoration(
                    color: NVSColors.primaryNeonMint
                        .withOpacity(_controller.value),
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.primaryNeonMint
                            .withOpacity(_controller.value * 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DottedGlobePainter extends CustomPainter {

  DottedGlobePainter({
    required this.animationProgress,
    required this.glowIntensity,
    required this.color,
  });
  final double animationProgress;
  final double glowIntensity;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    // Create the dotted pattern like the reference video
    final Paint paint = Paint()
      ..color = color.withOpacity(0.8 + (glowIntensity * 0.2))
      ..style = PaintingStyle.fill;

    // Draw globe outline
    final Paint outlinePaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, outlinePaint);

    // Create latitude and longitude grid lines with dots
    final double dotRadius = 1.5 + (animationProgress * 1.0);

    // Longitude lines (vertical curves)
    for (int i = 0; i < 12; i++) {
      final double angle = (i * math.pi * 2 / 12) + (animationProgress * math.pi * 2);
      _drawLongitudeLine(canvas, center, radius, angle, dotRadius, paint);
    }

    // Latitude lines (horizontal curves)
    for (int i = 0; i < 8; i++) {
      final double latAngle = (i * math.pi / 8) - (math.pi / 2);
      _drawLatitudeLine(canvas, center, radius, latAngle, dotRadius, paint);
    }

    // Draw continent-like dot clusters (simplified)
    _drawContinentDots(canvas, center, radius, dotRadius, paint);

    // Add center glow
    final Paint glowPaint = Paint()
      ..color = color.withOpacity(glowIntensity * 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.8, glowPaint);
  }

  void _drawLongitudeLine(Canvas canvas, Offset center, double radius,
      double angle, double dotRadius, Paint paint,) {
    const int steps = 30;
    for (int i = 0; i < steps; i++) {
      final double t = i / (steps - 1);
      final double lat = (t - 0.5) * math.pi; // -π/2 to π/2

      // Calculate 3D position
      final double x = radius * math.cos(lat) * math.sin(angle);
      final double z = radius * math.cos(lat) * math.cos(angle);
      final double y = radius * math.sin(lat);

      // Simple perspective projection
      if (z > -radius * 0.3) {
        // Only draw visible dots
        final double screenX = center.dx + x;
        final double screenY = center.dy + y;

        // Fade dots based on distance from viewer
        final double opacity = (z + radius) / (2 * radius);
        final Paint dotPaint = Paint()
          ..color = paint.color.withOpacity(paint.color.opacity * opacity)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
            Offset(screenX, screenY), dotRadius * opacity, dotPaint,);
      }
    }
  }

  void _drawLatitudeLine(Canvas canvas, Offset center, double radius,
      double latAngle, double dotRadius, Paint paint,) {
    const int steps = 40;
    final double latRadius = radius * math.cos(latAngle);
    final double y = center.dy + radius * math.sin(latAngle);

    for (int i = 0; i < steps; i++) {
      final double angle =
          (i * 2 * math.pi / steps) + (animationProgress * math.pi * 2);
      final double x = center.dx + latRadius * math.cos(angle);
      final double z = latRadius * math.sin(angle);

      // Only draw visible dots
      if (z > -radius * 0.3) {
        final double opacity = (z + radius) / (2 * radius);
        final Paint dotPaint = Paint()
          ..color = paint.color.withOpacity(paint.color.opacity * opacity * 0.7)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(Offset(x, y), dotRadius * 0.8 * opacity, dotPaint);
      }
    }
  }

  void _drawContinentDots(Canvas canvas, Offset center, double radius,
      double dotRadius, Paint paint,) {
    // Simplified continent patterns with more density
    final List<Map<String, num>> continentData = <Map<String, num>>[
      // North America
      <String, num>{'lat': 0.7, 'lng': -1.8, 'density': 20},
      // Europe
      <String, num>{'lat': 0.9, 'lng': 0.2, 'density': 15},
      // Africa
      <String, num>{'lat': 0.2, 'lng': 0.3, 'density': 18},
      // Asia
      <String, num>{'lat': 0.6, 'lng': 1.8, 'density': 25},
      // Australia
      <String, num>{'lat': -0.5, 'lng': 2.5, 'density': 10},
      // South America
      <String, num>{'lat': -0.3, 'lng': -1.2, 'density': 12},
    ];

    for (final Map<String, num> continent in continentData) {
      final double lat = continent['lat'] as double;
      final double lng =
          (continent['lng'] as double) + (animationProgress * math.pi * 2);
      final int density = continent['density'] as int;

      // Calculate base position
      final double x = radius * math.cos(lat) * math.sin(lng);
      final double z = radius * math.cos(lat) * math.cos(lng);
      final double y = radius * math.sin(lat);

      if (z > -radius * 0.2) {
        // Add random dots around this position
        final math.Random random = math.Random(continent.hashCode);
        for (int i = 0; i < density; i++) {
          final double offsetX = (random.nextDouble() - 0.5) * radius * 0.3;
          final double offsetY = (random.nextDouble() - 0.5) * radius * 0.3;

          final double dotX = center.dx + x + offsetX;
          final double dotY = center.dy + y + offsetY;

          // Check if dot is within globe bounds
          final double distanceFromCenter = math.sqrt(
              math.pow(dotX - center.dx, 2) + math.pow(dotY - center.dy, 2),);

          if (distanceFromCenter < radius * 0.9) {
            final double opacity = (z + radius) / (2 * radius);
            final Paint dotPaint = Paint()
              ..color = paint.color.withOpacity(paint.color.opacity * opacity)
              ..style = PaintingStyle.fill;

            canvas.drawCircle(
                Offset(dotX, dotY),
                dotRadius * (0.8 + random.nextDouble() * 0.4) * opacity,
                dotPaint,);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(DottedGlobePainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.glowIntensity != glowIntensity;
  }
}
