import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'dart:math' as math;

class CyberpunkMapOverlay extends StatefulWidget {
  const CyberpunkMapOverlay({super.key});

  @override
  State<CyberpunkMapOverlay> createState() => _CyberpunkMapOverlayState();
}

class _CyberpunkMapOverlayState extends State<CyberpunkMapOverlay> with TickerProviderStateMixin {
  late AnimationController _atmosphereController;
  late AnimationController _scanlineController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Atmospheric breathing effect
    _atmosphereController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // Scanning lines effect
    _scanlineController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    // Floating particles
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: <Widget>[
          // Atmospheric glow overlay
          _buildAtmosphericGlow(),

          // Scanning lines
          _buildScanLines(),

          // Floating particles
          _buildFloatingParticles(),

          // Corner HUD elements
          _buildCornerHUD(),
        ],
      ),
    );
  }

  Widget _buildAtmosphericGlow() {
    return AnimatedBuilder(
      animation: _atmosphereController,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 1.5,
              colors: <Color>[
                Colors.transparent,
                NVSColors.primaryNeonMint.withOpacity(0.03 * _atmosphereController.value),
                NVSColors.turquoiseNeon.withOpacity(0.02 * _atmosphereController.value),
                Colors.transparent,
              ],
              stops: const <double>[0.0, 0.4, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScanLines() {
    return AnimatedBuilder(
      animation: _scanlineController,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ScanLinePainter(
            progress: _scanlineController.value,
            color: NVSColors.primaryNeonMint,
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlePainter(
            progress: _particleController.value,
            color: NVSColors.primaryNeonMint,
          ),
        );
      },
    );
  }

  Widget _buildCornerHUD() {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          // Top-left corner elements
          Positioned(
            top: 100,
            left: 20,
            child: _buildHUDElement(
              'SIGNAL STRENGTH',
              '█████████░',
              alignment: Alignment.topLeft,
            ),
          ),

          // Top-right corner elements
          Positioned(
            top: 100,
            right: 20,
            child: _buildHUDElement(
              'NETWORK STATUS',
              'CONNECTED',
              alignment: Alignment.topRight,
            ),
          ),

          // Bottom-left corner elements
          Positioned(
            bottom: 150,
            left: 20,
            child: _buildHUDElement(
              'ACTIVE USERS',
              '47 NEARBY',
              alignment: Alignment.bottomLeft,
            ),
          ),

          // Bottom-right corner elements
          Positioned(
            bottom: 150,
            right: 20,
            child: _buildHUDElement(
              'SCAN RADIUS',
              '5.0 KM',
              alignment: Alignment.bottomRight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHUDElement(String title, String value, {required Alignment alignment}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack.withOpacity(0.7),
        border: Border.all(
          color: NVSColors.primaryNeonMint.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.primaryNeonMint.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignment == Alignment.topRight || alignment == Alignment.bottomRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: NVSColors.ultraLightMint,
              fontSize: 8,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'BellGothic',
              color: NVSColors.primaryNeonMint,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _atmosphereController.dispose();
    _scanlineController.dispose();
    _particleController.dispose();
    super.dispose();
  }
}

class ScanLinePainter extends CustomPainter {
  ScanLinePainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Vertical scanning lines
    for (int i = 0; i < 5; i++) {
      final double x = (size.width / 5) * i + (progress * size.width * 0.1);
      if (x < size.width) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
        );
      }
    }

    // Horizontal scanning lines
    for (int i = 0; i < 3; i++) {
      final double y = (size.height / 3) * i + (progress * size.height * 0.1);
      if (y < size.height) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final math.Random random = math.Random(42); // Fixed seed for consistent particles

    // Draw floating particles
    for (int i = 0; i < 15; i++) {
      final double baseX = random.nextDouble() * size.width;
      final double baseY = random.nextDouble() * size.height;

      // Animate particle position
      final double animatedX = baseX + (math.sin(progress * 2 * math.pi + i) * 20);
      final double animatedY = baseY + (math.cos(progress * 2 * math.pi + i * 0.7) * 15);

      // Particle size varies with animation
      final double particleSize = 1 + (math.sin(progress * 4 * math.pi + i) * 0.5);

      canvas.drawCircle(
        Offset(animatedX, animatedY),
        particleSize,
        paint..color = color.withOpacity(0.3 + (math.sin(progress * 3 * math.pi + i) * 0.3)),
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
