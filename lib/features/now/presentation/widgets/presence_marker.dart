// packages/now/lib/presentation/widgets/presence_marker.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

// The law of our Signal Integrity Protocol
enum SignalQuality { perfect, weak, echo }

class PresenceMarker extends StatefulWidget {

  const PresenceMarker({
    super.key,
    this.quality = SignalQuality.perfect,
  });
  final SignalQuality quality;

  @override
  State<PresenceMarker> createState() => _PresenceMarkerState();
}

class _PresenceMarkerState extends State<PresenceMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // The animation speed and behavior depends on the signal quality
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.quality == SignalQuality.perfect ? 3 : 1),
    )..repeat(reverse: widget.quality == SignalQuality.perfect);
  }

  @override
  void didUpdateWidget(covariant PresenceMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.quality != oldWidget.quality) {
      _controller.duration = Duration(seconds: widget.quality == SignalQuality.perfect ? 3 : 1);
      if (_controller.isAnimating) {
        _controller.repeat(reverse: widget.quality == SignalQuality.perfect);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We use a larger tap target for accessibility
    return SizedBox(
      width: 60,
      height: 60,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: _MarkerPainter(
              quality: widget.quality,
              animationValue: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _MarkerPainter extends CustomPainter {

  _MarkerPainter({required this.quality, required this.animationValue});
  final SignalQuality quality;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint paint = Paint()..color = NVSColors.primaryNeonMint;

    switch (quality) {
      case SignalQuality.perfect:
        // A clean, breathing, holographic pulse
        final double glowRadius = 10 + (animationValue * 5);
        final double coreRadius = 6 + (animationValue * 2);
        
        paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 12 + (animationValue * 8));
        canvas.drawCircle(center, glowRadius, paint);
        
        paint.maskFilter = null;
        canvas.drawCircle(center, coreRadius, paint..color = NVSColors.primaryNeonMint);
        break;

      case SignalQuality.weak:
        // A staticky, glitching, unstable signal
        final Random random = Random();
        if (random.nextDouble() > 0.2) { // Make it flicker
            final double radius = 8 + (random.nextDouble() * 4);
            paint.color = NVSColors.primaryNeonMint.withOpacity(0.4 + random.nextDouble() * 0.5);
            paint.strokeWidth = 1.0 + random.nextDouble() * 1.5;
            paint.style = PaintingStyle.stroke;
            
            // Draw a slightly distorted circle
            final Path path = Path();
            path.addOval(Rect.fromCenter(center: center, width: radius * 2, height: radius * 2.2));
            canvas.drawPath(path, paint);
        }
        break;

      case SignalQuality.echo:
        // A faint, single-pixel, almost subliminal flicker of data
        if (Random().nextDouble() > 0.96) { // Rarely visible
          paint.color = NVSColors.primaryNeonMint.withOpacity(0.8);
          canvas.drawCircle(center, 1.5, paint);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _MarkerPainter oldDelegate) {
    return true; // Always repaint for animated/random effects
  }
}