import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:nvs/meatup_core.dart';
import '../../domain/models/connect_models.dart';

/// Advanced Skia-based visualization for user's unique "soul sphere"
/// Uses advanced shaders and animations to create fluid, rotating, glowing effects
class AuraSignature extends StatefulWidget {
  const AuraSignature({
    required this.userData,
    super.key,
    this.size = 280,
    this.interactive = true,
  });
  final AuraSignatureData userData;
  final double size;
  final bool interactive;

  @override
  State<AuraSignature> createState() => _AuraSignatureState();
}

class _AuraSignatureState extends State<AuraSignature> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulsationController;
  late AnimationController _particleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulsationAnimation;
  late Animation<double> _particleAnimation;

  // Interaction state
  Offset? _lastPanPosition;
  double _userRotationX = 0.0;
  double _userRotationY = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Main rotation
    _rotationController = AnimationController(
      duration: Duration(
        milliseconds: (3000 / widget.userData.rotationSpeed).round(),
      ),
      vsync: this,
    )..repeat();

    // Pulsation based on user's energy
    _pulsationController = AnimationController(
      duration: Duration(
        milliseconds: (2000 / widget.userData.pulsationRate).round(),
      ),
      vsync: this,
    )..repeat(reverse: true);

    // Particle movement
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulsationAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulsationController, curve: Curves.easeInOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
  }

  void _handlePanStart(DragStartDetails details) {
    if (!widget.interactive) return;
    _lastPanPosition = details.localPosition;
    HapticFeedback.lightImpact();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!widget.interactive || _lastPanPosition == null) return;

    final Offset delta = details.localPosition - _lastPanPosition!;
    setState(() {
      _userRotationX += delta.dy * 0.01;
      _userRotationY += delta.dx * 0.01;
      _userRotationX = _userRotationX.clamp(-math.pi / 4, math.pi / 4);
      _userRotationY = _userRotationY.clamp(-math.pi / 4, math.pi / 4);
    });

    _lastPanPosition = details.localPosition;
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!widget.interactive) return;
    _lastPanPosition = null;

    // Gentle spring back to center
    setState(() {
      _userRotationX *= 0.8;
      _userRotationY *= 0.8;
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulsationController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[
            _rotationAnimation,
            _pulsationAnimation,
            _particleAnimation,
          ]),
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              painter: AuraSignaturePainter(
                userData: widget.userData,
                rotationValue: _rotationAnimation.value,
                pulsationValue: _pulsationAnimation.value,
                particleValue: _particleAnimation.value,
                userRotationX: _userRotationX,
                userRotationY: _userRotationY,
              ),
              size: Size(widget.size, widget.size),
            );
          },
        ),
      ),
    );
  }
}

/// Custom painter for the aura signature using advanced Skia rendering
class AuraSignaturePainter extends CustomPainter {
  AuraSignaturePainter({
    required this.userData,
    required this.rotationValue,
    required this.pulsationValue,
    required this.particleValue,
    required this.userRotationX,
    required this.userRotationY,
  });
  final AuraSignatureData userData;
  final double rotationValue;
  final double pulsationValue;
  final double particleValue;
  final double userRotationX;
  final double userRotationY;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double baseRadius = size.width * 0.35;

    // Apply transformations
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Apply user interaction rotations
    _apply3DRotation(canvas, userRotationX, userRotationY);

    canvas.translate(-center.dx, -center.dy);

    // Draw multiple layers for depth
    _drawBackgroundGlow(canvas, center, baseRadius);
    _drawCoreOrb(canvas, center, baseRadius);
    _drawEnergyRings(canvas, center, baseRadius);
    _drawParticleField(canvas, center, baseRadius);
    _drawChakraPoints(canvas, center, baseRadius);

    canvas.restore();
  }

  void _apply3DRotation(Canvas canvas, double rotX, double rotY) {
    // Simplified 3D rotation effect using 2D transforms
    final Matrix4 matrix = Matrix4.identity();
    matrix.setEntry(3, 2, 0.001); // Perspective
    matrix.rotateX(rotX);
    matrix.rotateY(rotY);

    // Apply the transformation
    canvas.transform(matrix.storage);
  }

  void _drawBackgroundGlow(Canvas canvas, Offset center, double radius) {
    final double glowRadius = radius * pulsationValue * 1.5;

    final Paint glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        glowRadius,
        <Color>[
          userData.color1.withValues(alpha: userData.glowIntensity * 0.3),
          userData.color2.withValues(alpha: userData.glowIntensity * 0.2),
          userData.color3.withValues(alpha: userData.glowIntensity * 0.1),
          Colors.transparent,
        ],
        <double>[0.0, 0.4, 0.7, 1.0],
      );

    canvas.drawCircle(center, glowRadius, glowPaint);
  }

  void _drawCoreOrb(Canvas canvas, Offset center, double radius) {
    final double coreRadius = radius * pulsationValue * 0.6;

    final Paint corePaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        coreRadius,
        <Color>[
          userData.color1.withValues(alpha: 0.8),
          userData.color2.withValues(alpha: 0.6),
          userData.color3.withValues(alpha: 0.4),
          userData.color1.withValues(alpha: 0.2),
        ],
        <double>[0.0, 0.3, 0.6, 1.0],
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(center, coreRadius, corePaint);

    // Inner core with rotation effect
    final Paint innerCorePaint = Paint()
      ..color = userData.color1.withValues(alpha: 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final double innerRadius = coreRadius * 0.4;
    canvas.drawCircle(center, innerRadius, innerCorePaint);
  }

  void _drawEnergyRings(Canvas canvas, Offset center, double radius) {
    const int ringCount = 3;

    for (int i = 0; i < ringCount; i++) {
      final double ringRadius = radius * (0.7 + i * 0.2) * pulsationValue;
      final double ringRotation = rotationValue * (i % 2 == 0 ? 1 : -1) * (i + 1);

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(ringRotation);
      canvas.translate(-center.dx, -center.dy);

      _drawEnergyRing(canvas, center, ringRadius, i);

      canvas.restore();
    }
  }

  void _drawEnergyRing(
    Canvas canvas,
    Offset center,
    double radius,
    int ringIndex,
  ) {
    final int segmentCount = 8 + (ringIndex * 4);
    final double segmentAngle = 2 * math.pi / segmentCount;

    for (int i = 0; i < segmentCount; i++) {
      final double angle = i * segmentAngle;
      final double alpha = (math.sin(angle + rotationValue * 3) + 1) * 0.5;

      final Paint segmentPaint = Paint()
        ..color = userData.color2.withValues(
          alpha: alpha * userData.glowIntensity * 0.4,
        )
        ..strokeWidth = 2.0 + ringIndex.toDouble()
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      final double startAngle = angle - segmentAngle * 0.3;
      final double sweepAngle = segmentAngle * 0.6;

      final Rect rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, startAngle, sweepAngle, false, segmentPaint);
    }
  }

  void _drawParticleField(Canvas canvas, Offset center, double radius) {
    final int particleCount = (userData.particleDensity * 50).round();

    for (int i = 0; i < particleCount; i++) {
      final double particleAngle = (i / particleCount) * 2 * math.pi + particleValue;
      final double particleRadius = radius * (0.5 + (i % 3) * 0.3);
      final double particleDistance =
          particleRadius * (0.8 + math.sin(particleValue * 2 + i) * 0.2);

      final double particleX = center.dx + math.cos(particleAngle) * particleDistance;
      final double particleY = center.dy + math.sin(particleAngle) * particleDistance;

      final int particleSize = 2 + (i % 3);
      final double particleAlpha = (math.sin(particleValue * 3 + i * 0.5) + 1) * 0.5;

      final Paint particlePaint = Paint()
        ..color = userData.color3.withValues(alpha: particleAlpha * 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(
        Offset(particleX, particleY),
        particleSize.toDouble(),
        particlePaint,
      );
    }
  }

  void _drawChakraPoints(Canvas canvas, Offset center, double radius) {
    final int chakraCount = userData.energyLevels.length;

    for (int i = 0; i < chakraCount; i++) {
      final double angle = (i / chakraCount) * 2 * math.pi + rotationValue * 0.5;
      final double chakraRadius = radius * 0.9;
      final double energyLevel = userData.energyLevels[i];

      final double chakraX = center.dx + math.cos(angle) * chakraRadius;
      final double chakraY = center.dy + math.sin(angle) * chakraRadius;

      final Paint chakraPaint = Paint()
        ..color = userData.color1.withValues(alpha: energyLevel * 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      final double chakraSize = 4.0 + energyLevel * 6.0;
      canvas.drawCircle(
        Offset(chakraX, chakraY),
        chakraSize * pulsationValue,
        chakraPaint,
      );
    }
  }

  @override
  bool shouldRepaint(AuraSignaturePainter oldDelegate) {
    return oldDelegate.rotationValue != rotationValue ||
        oldDelegate.pulsationValue != pulsationValue ||
        oldDelegate.particleValue != particleValue ||
        oldDelegate.userRotationX != userRotationX ||
        oldDelegate.userRotationY != userRotationY;
  }
}

/// Comparison widget for showing two aura signatures side by side
class AuraComparison extends StatelessWidget {
  const AuraComparison({
    required this.userAura,
    required this.matchAura,
    required this.compatibilityScore,
    super.key,
  });
  final AuraSignatureData userAura;
  final AuraSignatureData matchAura;
  final double compatibilityScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          const Text(
            'AURA COMPATIBILITY',
            style: TextStyle(
              fontFamily: 'MagdaClean',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: NVSColors.ultraLightMint,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  AuraSignature(
                    userData: userAura,
                    size: 120,
                    interactive: false,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You',
                    style: TextStyle(
                      fontFamily: 'MagdaClean',
                      fontSize: 14,
                      color: NVSColors.secondaryText,
                    ),
                  ),
                ],
              ),

              // Compatibility indicator
              Column(
                children: <Widget>[
                  Text(
                    '${(compatibilityScore * 100).round()}%',
                    style: const TextStyle(
                      fontFamily: 'MagdaClean',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: NVSColors.neonMint,
                    ),
                  ),
                  const Text(
                    'MATCH',
                    style: TextStyle(
                      fontFamily: 'MagdaClean',
                      fontSize: 12,
                      color: NVSColors.secondaryText,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              Column(
                children: <Widget>[
                  AuraSignature(
                    userData: matchAura,
                    size: 120,
                    interactive: false,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Match',
                    style: TextStyle(
                      fontFamily: 'MagdaClean',
                      fontSize: 14,
                      color: NVSColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
