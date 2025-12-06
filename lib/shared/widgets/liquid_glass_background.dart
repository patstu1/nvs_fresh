import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/quantum_design_tokens.dart';
import 'package:nvs/theme/nvs_palette.dart';

/// LiquidGlassBackground applies the global quantum visual stack:
/// 1. Glassmorphic blur layer.
/// 2. Breathing ambient glow matched to design tokens.
/// 3. Glitch shimmer overlay for subtle cyber aesthetic.
class LiquidGlassBackground extends StatefulWidget {
  const LiquidGlassBackground({super.key, this.child, this.intensity = 0.35});

  /// Primary content rendered above the visual stack.
  final Widget? child;

  /// Adjusts blur/opacity; keep between 0 (off) and 1 (strong).
  final double intensity;

  @override
  State<LiquidGlassBackground> createState() => _LiquidGlassBackgroundState();
}

class _LiquidGlassBackgroundState extends State<LiquidGlassBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double clampedIntensity = widget.intensity.clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double phase = _controller.value;
        final double blurSigma = ui.lerpDouble(
          10.0,
          25.0,
          clampedIntensity * phase,
        )!;
        final double glowOpacity = ui.lerpDouble(
          0.12,
          0.28,
          phase * clampedIntensity,
        )!;

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // Base gradient wash
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[NVSPalette.liquidGlassDark, NVSPalette.pureBlack],
                ),
              ),
            ),
            // Liquid glass layer with blur and translucency
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Container(
                color: NVSPalette.pureBlack.withValues(
                  alpha: 0.35 + (clampedIntensity * 0.2),
                ),
              ),
            ),
            // Breathing glow pulses
            _AmbientGlow(phase: phase, opacity: glowOpacity),
            // Glitch shimmer overlay
            _GlitchOverlay(intensity: clampedIntensity, seed: phase),
            if (child != null) child,
          ],
        ).animate().fadeIn(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      },
      child: widget.child,
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({required this.phase, required this.opacity});

  final double phase;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final double sizeFactor = ui.lerpDouble(0.85, 1.2, phase)!;

    return Align(
      alignment: const Alignment(0, -0.2),
      child: FractionallySizedBox(
        widthFactor: sizeFactor,
        heightFactor: sizeFactor,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                NVSPalette.primary.withValues(alpha: opacity),
                NVSPalette.primary.withValues(alpha: opacity * 0.7),
                NVSPalette.transparent,
              ],
              stops: const <double>[0.0, 0.35, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlitchOverlay extends StatelessWidget {
  const _GlitchOverlay({required this.intensity, required this.seed});

  final double intensity;
  final double seed;

  @override
  Widget build(BuildContext context) {
    if (intensity <= 0) return const SizedBox.shrink();

    final double glitchOpacity = ui.lerpDouble(0.02, 0.08, intensity)!;

    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: glitchOpacity,
        child: CustomPaint(painter: _GlitchPainter(seed: seed)),
      ),
    );
  }
}

class _GlitchPainter extends CustomPainter {
  const _GlitchPainter({required this.seed});

  final double seed;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final math.Random random = math.Random((seed * 1000).floor());
    final int lineCount = (120 * size.height / 1080).ceil();

    for (int i = 0; i < lineCount; i++) {
      final double y = random.nextDouble() * size.height;
      final double length = (random.nextDouble() * 120) + 40;
      final double thickness = (random.nextDouble() * 1.5) + 0.5;

      paint
        ..color = Color.lerp(
          NVSPalette.primary,
          NVSPalette.primary,
          random.nextDouble(),
        )!.withValues(alpha: 0.35)
        ..strokeWidth = thickness;

      canvas.drawLine(
        Offset(-20, y),
        Offset(math.min(size.width + 20, length), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GlitchPainter oldDelegate) => oldDelegate.seed != seed;
}
