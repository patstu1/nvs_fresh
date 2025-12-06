import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class SpinningEarthWidget extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const SpinningEarthWidget({super.key, this.size = 150.0, this.onTap});

  @override
  State<SpinningEarthWidget> createState() => _SpinningEarthWidgetState();
}

class _SpinningEarthWidgetState extends State<SpinningEarthWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Continuous rotation animation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    // Pulsing glow animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pulseController]),
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159, // Full rotation
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.3, -0.3), // 3D lighting effect
                    colors: [
                      NVSColors.turquoiseNeon.withValues(alpha: 0.9),
                      NVSColors.turquoiseNeon.withValues(alpha: 0.6),
                      NVSColors.primaryNeonMint.withValues(alpha: 0.4),
                      NVSColors.pureBlack.withValues(alpha: 0.8),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                  border: Border.all(color: NVSColors.turquoiseNeon, width: 2),
                  boxShadow: [
                    // Main glow
                    BoxShadow(
                      color: NVSColors.turquoiseNeon.withValues(
                        alpha: _pulseAnimation.value,
                      ),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                    // Inner glow
                    BoxShadow(
                      color: NVSColors.primaryNeonMint.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                    // Sharp edge
                    BoxShadow(
                      color: NVSColors.turquoiseNeon.withValues(alpha: 0.8),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Earth icon with rotation effect
                    Icon(
                      Icons.public,
                      size: widget.size * 0.5,
                      color: NVSColors.primaryNeonMint,
                    ),
                    // Grid overlay for 3D effect
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: NVSColors.turquoiseNeon.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: CustomPaint(
                        size: Size(widget.size * 0.8, widget.size * 0.8),
                        painter: GlobGridPainter(
                          color: NVSColors.turquoiseNeon.withValues(alpha: 0.4),
                          rotation: _rotationAnimation.value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GlobGridPainter extends CustomPainter {
  final Color color;
  final double rotation;

  GlobGridPainter({required this.color, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw longitude lines with rotation effect
    for (int i = 0; i < 8; i++) {
      final angle = (i * 3.14159 / 4) + (rotation * 2 * 3.14159);
      final startX =
          center.dx +
          radius *
              0.3 *
              0.5 *
              (1 + 0.5 * (angle % (2 * 3.14159)) / (2 * 3.14159));
      final endX =
          center.dx -
          radius *
              0.3 *
              0.5 *
              (1 + 0.5 * (angle % (2 * 3.14159)) / (2 * 3.14159));

      final path = Path();
      path.moveTo(startX, center.dy - radius * 0.8);
      path.quadraticBezierTo(
        center.dx,
        center.dy,
        endX,
        center.dy + radius * 0.8,
      );
      canvas.drawPath(path, paint);
    }

    // Draw latitude lines
    for (int i = 1; i < 4; i++) {
      final y = center.dy - radius * 0.6 + (i * radius * 0.4);
      final ellipseWidth = radius * 1.4 * (1 - (i - 2).abs() * 0.3);
      final ellipseHeight = radius * 0.2;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, y),
          width: ellipseWidth,
          height: ellipseHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GlobGridPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
