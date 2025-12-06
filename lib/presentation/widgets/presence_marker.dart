// packages/now/lib/presentation/widgets/presence_marker.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

enum SignalQuality { perfect, weak, echo }

class PresenceMarker extends StatefulWidget {
  final SignalQuality quality;
  final double size;

  const PresenceMarker({super.key, required this.quality, this.size = 24.0});

  @override
  State<PresenceMarker> createState() => _PresenceMarkerState();
}

class _PresenceMarkerState extends State<PresenceMarker>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glitchController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glitchAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glitchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.elasticOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    switch (widget.quality) {
      case SignalQuality.perfect:
        _pulseController.repeat(reverse: true);
        break;
      case SignalQuality.weak:
        _pulseController.repeat(reverse: true);
        // Add occasional glitch
        Future.delayed(
          Duration(milliseconds: math.Random().nextInt(3000) + 1000),
          () {
            if (mounted) {
              _glitchController.forward().then(
                (_) => _glitchController.reset(),
              );
            }
          },
        );
        break;
      case SignalQuality.echo:
        _pulseController.repeat(reverse: true);
        // More frequent glitches
        _scheduleGlitch();
        break;
    }
  }

  void _scheduleGlitch() {
    if (widget.quality == SignalQuality.echo && mounted) {
      Future.delayed(
        Duration(milliseconds: math.Random().nextInt(1000) + 500),
        () {
          if (mounted) {
            _glitchController.forward().then((_) {
              _glitchController.reset();
              _scheduleGlitch();
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  Color _getBaseColor() {
    switch (widget.quality) {
      case SignalQuality.perfect:
        return const Color(0xFF00FFAA); // Perfect mint
      case SignalQuality.weak:
        return const Color(0xFFFFAA00); // Warning orange
      case SignalQuality.echo:
        return const Color(0xFFFF3366); // Danger red
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _glitchAnimation]),
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _MarkerPainter(
            quality: widget.quality,
            pulseValue: _pulseAnimation.value,
            glitchValue: _glitchAnimation.value,
            baseColor: _getBaseColor(),
          ),
        );
      },
    );
  }
}

class _MarkerPainter extends CustomPainter {
  final SignalQuality quality;
  final double pulseValue;
  final double glitchValue;
  final Color baseColor;

  _MarkerPainter({
    required this.quality,
    required this.pulseValue,
    required this.glitchValue,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Base circle
    final basePaint = Paint()
      ..color = baseColor.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    // Pulse ring
    final pulsePaint = Paint()
      ..color = baseColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw pulse ring
    canvas.drawCircle(center, radius * pulseValue, pulsePaint);

    // Draw base circle with glitch effect
    if (quality == SignalQuality.echo && glitchValue > 0) {
      // Glitch effect
      final glitchOffset = Offset(
        (math.Random().nextDouble() - 0.5) * 4 * glitchValue,
        (math.Random().nextDouble() - 0.5) * 4 * glitchValue,
      );
      canvas.drawCircle(
        center + glitchOffset,
        radius * 0.7,
        basePaint..color = baseColor.withOpacity(0.5),
      );
    }

    // Main circle
    canvas.drawCircle(center, radius * 0.7, basePaint..color = baseColor);

    // Inner glow
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.3, glowPaint);
  }

  @override
  bool shouldRepaint(_MarkerPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.glitchValue != glitchValue;
  }
}
