// lib/features/connect/presentation/widgets/visual_radar_widget.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/compatibility_match.dart';
import 'package:nvs/meatup_core.dart';

/// Cyberpunk holo-chart visualizing compatibility as orbiting nodes
/// This is the neural interface to the social fabric of the user base
class VisualRadarWidget extends ConsumerStatefulWidget {
  const VisualRadarWidget({
    required this.matches,
    super.key,
    this.onNodeTap,
    this.width = 400,
    this.height = 400,
  });
  final List<CompatibilityMatch> matches;
  final Function(CompatibilityMatch)? onNodeTap;
  final double width;
  final double height;

  @override
  ConsumerState<VisualRadarWidget> createState() => _VisualRadarWidgetState();
}

class _VisualRadarWidgetState extends ConsumerState<VisualRadarWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _scanController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation animation for orbital movement
    _rotationController = AnimationController(
      duration: const Duration(seconds: 60), // Slow, hypnotic rotation
      vsync: this,
    )..repeat();

    // Pulse animation for node glow
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Scanning animation for radar sweep
    _scanController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(parent: _rotationController, curve: Curves.linear));

    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _scanAnimation = Tween<double>(begin: 0, end: 2 * math.pi)
        .animate(CurvedAnimation(parent: _scanController, curve: Curves.linear));
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
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(widget.width / 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.neonMint.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation:
            Listenable.merge(<Listenable?>[_rotationAnimation, _pulseAnimation, _scanAnimation]),
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: VisualRadarPainter(
              matches: widget.matches,
              rotationAngle: _rotationAnimation.value,
              pulseIntensity: _pulseAnimation.value,
              scanAngle: _scanAnimation.value,
              onNodeTap: widget.onNodeTap,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter that renders the cyberpunk compatibility radar
class VisualRadarPainter extends CustomPainter {
  VisualRadarPainter({
    required this.matches,
    required this.rotationAngle,
    required this.pulseIntensity,
    required this.scanAngle,
    this.onNodeTap,
  });
  final List<CompatibilityMatch> matches;
  final double rotationAngle;
  final double pulseIntensity;
  final double scanAngle;
  final Function(CompatibilityMatch)? onNodeTap;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = math.min(size.width, size.height) / 2 - 20;

    // Draw radar grid
    _drawRadarGrid(canvas, center, maxRadius);

    // Draw scanning beam
    _drawScanBeam(canvas, center, maxRadius);

    // Draw compatibility nodes
    _drawCompatibilityNodes(canvas, center, maxRadius);

    // Draw center core
    _drawCenterCore(canvas, center);
  }

  void _drawRadarGrid(Canvas canvas, Offset center, double maxRadius) {
    final Paint gridPaint = Paint()
      ..color = NVSColors.neonMint.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Concentric circles (compatibility tiers)
    for (int i = 1; i <= 4; i++) {
      final double radius = (maxRadius / 4) * i;
      canvas.drawCircle(center, radius, gridPaint);
    }

    // Radial lines (angular divisions)
    for (int i = 0; i < 12; i++) {
      final double angle = (i * 30) * (math.pi / 180);
      final Offset endPoint = Offset(
        center.dx + maxRadius * math.cos(angle),
        center.dy + maxRadius * math.sin(angle),
      );
      canvas.drawLine(center, endPoint, gridPaint);
    }
  }

  void _drawScanBeam(Canvas canvas, Offset center, double maxRadius) {
    final Paint beamPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: <Color>[
          NVSColors.neonMint.withOpacity(0.3),
          NVSColors.neonMint.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

    // Draw scanning beam as a rotating sector
    final Path path = Path();
    path.moveTo(center.dx, center.dy);
    path.arcTo(
      Rect.fromCircle(center: center, radius: maxRadius),
      scanAngle - 0.2, // Beam width
      0.4,
      false,
    );
    path.close();

    canvas.drawPath(path, beamPaint);
  }

  void _drawCompatibilityNodes(Canvas canvas, Offset center, double maxRadius) {
    for (final CompatibilityMatch match in matches) {
      // Calculate node position based on compatibility score and orbital angle
      final double baseAngle = match.orbitalAngle + rotationAngle;
      final double distance = match.orbitalDistance.clamp(40.0, maxRadius - 20);

      final Offset position = Offset(
        center.dx + distance * math.cos(baseAngle),
        center.dy + distance * math.sin(baseAngle),
      );

      _drawCompatibilityNode(canvas, position, match);
    }
  }

  void _drawCompatibilityNode(Canvas canvas, Offset position, CompatibilityMatch match) {
    final double nodeSize = match.nodeSize * pulseIntensity;
    final double glowIntensity = match.glowIntensity * pulseIntensity;

    // Draw glow effect
    final Paint glowPaint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..shader = RadialGradient(
        colors: <Color>[
          match.tier.color.withOpacity(glowIntensity),
          match.tier.color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: position, radius: nodeSize + 20));

    canvas.drawCircle(position, nodeSize + 10, glowPaint);

    // Draw core node
    final Paint nodePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = match.tier.color.withOpacity(0.9);

    canvas.drawCircle(position, nodeSize / 2, nodePaint);

    // Draw node border
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = match.tier.color
      ..strokeWidth = 2;

    canvas.drawCircle(position, nodeSize / 2, borderPaint);

    // Draw compatibility score text
    if (nodeSize > 15) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${(match.score * 100).toInt()}%',
          style: TextStyle(
            color: Colors.white,
            fontSize: math.min(nodeSize / 4, 12),
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

    // Draw orbital trail for high-compatibility matches
    if (match.score > 0.8) {
      _drawOrbitalTrail(canvas, position, match);
    }
  }

  void _drawOrbitalTrail(Canvas canvas, Offset position, CompatibilityMatch match) {
    final Paint trailPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = match.tier.color.withOpacity(0.3 * pulseIntensity)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // Draw a fading trail behind the node
    for (int i = 1; i <= 10; i++) {
      final double trailAngle = match.orbitalAngle + rotationAngle - (i * 0.1);
      final double distance = match.orbitalDistance.clamp(40.0, 180.0);

      final Offset trailPosition = Offset(
        position.dx + distance * math.cos(trailAngle) - position.dx,
        position.dy + distance * math.sin(trailAngle) - position.dy,
      );

      final double opacity = (1.0 - (i / 10)) * 0.5 * pulseIntensity;
      final Paint trailDotPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = match.tier.color.withOpacity(opacity);

      canvas.drawCircle(
        Offset(position.dx + trailPosition.dx, position.dy + trailPosition.dy),
        2.0 - (i * 0.1),
        trailDotPaint,
      );
    }
  }

  void _drawCenterCore(Canvas canvas, Offset center) {
    // Draw central user indicator
    final Paint corePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: <Color>[
          NVSColors.neonMint,
          NVSColors.neonMint.withOpacity(0.5),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 20));

    canvas.drawCircle(center, 15 * pulseIntensity, corePaint);

    // Draw core border
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = NVSColors.neonMint
      ..strokeWidth = 3;

    canvas.drawCircle(center, 15 * pulseIntensity, borderPaint);

    // Draw user icon or initials
    final TextPainter iconPainter = TextPainter(
      text: const TextSpan(
        text: 'YOU',
        style: TextStyle(
          color: Colors.black,
          fontSize: 8,
          fontFamily: 'MagdaCleanMono',
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(VisualRadarPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.pulseIntensity != pulseIntensity ||
        oldDelegate.scanAngle != scanAngle ||
        oldDelegate.matches != matches;
  }
}

/// Radar legend showing compatibility tiers
class RadarLegend extends StatelessWidget {
  const RadarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSColors.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NVSColors.neonMint.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'NEURAL COMPATIBILITY MATRIX',
            style: TextStyle(
              color: NVSColors.neonMint,
              fontSize: 12,
              fontFamily: 'MagdaCleanMono',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...CompatibilityTier.values.map(_buildLegendItem),
        ],
      ),
    );
  }

  Widget _buildLegendItem(CompatibilityTier tier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: tier.color,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: tier.color.withOpacity(0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            tier.label,
            style: const TextStyle(
              color: NVSColors.textSecondary,
              fontSize: 10,
              fontFamily: 'MagdaCleanMono',
            ),
          ),
        ],
      ),
    );
  }
}
