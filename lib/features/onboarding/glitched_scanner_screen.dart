import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nvs/meatup_core.dart';

class GlitchedScannerScreen extends StatefulWidget {
  const GlitchedScannerScreen({required this.onDoubleTap, super.key});
  final VoidCallback onDoubleTap;

  @override
  State<GlitchedScannerScreen> createState() => _GlitchedScannerScreenState();
}

class _GlitchedScannerScreenState extends State<GlitchedScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _glitchController;
  late Animation<double> _scanAnimation;
  late Animation<double> _glitchAnimation;
  bool _glitching = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _glitchAnimation = Tween<double>(begin: 0, end: 1).animate(_glitchController);
    _scanController.addListener(_onScanUpdate);
  }

  void _onScanUpdate() {
    // When scan line passes center, trigger glitch
    if ((_scanAnimation.value - 0.5).abs() < 0.01 && !_glitching) {
      _glitching = true;
      _glitchController.forward(from: 0).then((_) {
        _glitching = false;
      });
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onDoubleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable?>[_scanController, _glitchController]),
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: _ScannerPainter(
              scanY: _scanAnimation.value,
              glitchValue: _glitchAnimation.value,
              random: _random,
            ),
            child: Container(),
          );
        },
      ),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  _ScannerPainter({required this.scanY, required this.glitchValue, required this.random});
  final double scanY;
  final double glitchValue;
  final Random random;

  @override
  void paint(Canvas canvas, Size size) {
    // Matte black background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = NVSColors.pureBlack,
    );

    // CRT scanlines
    final Paint scanlinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanlinePaint);
    }

    // Mint scan line (horizontal)
    final double scanLineY = size.height * scanY;
    final Paint scanPaint = Paint()
      ..color = NVSColors.ultraLightMint.withValues(alpha: 0.7)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(0, scanLineY),
      Offset(size.width, scanLineY),
      scanPaint,
    );

    // N V S glitching at center (fixed position)
    final double nvsY = size.height / 2;
    final Offset center = Offset(size.width / 2, nvsY - 10); // Always center, never moves
    if ((scanLineY - nvsY).abs() < 32) {
      // 32px threshold for glitch effect
      final TextStyle textStyle = TextStyle(
        fontFamily: 'MagdaClean',
        fontWeight: FontWeight.w900,
        fontSize: 64 + random.nextDouble() * 24 * glitchValue, // more size jitter
        color: NVSColors.ultraLightMint.withValues(alpha: 0.8),
        letterSpacing: 18 + random.nextDouble() * 18 * glitchValue, // more spacing jitter
        shadows: <Shadow>[
          Shadow(
            blurRadius: 16 + 24 * glitchValue, // stronger glow
            color: NVSColors.turquoiseNeon.withValues(alpha: 0.9),
          ),
          Shadow(
            blurRadius: 36,
            color: NVSColors.turquoiseNeon.withValues(alpha: 0.5),
          ),
        ],
      );
      // Strong glitch: more layers, more color split, but NO movement
      for (int i = 0; i < 12; i++) {
        final Color color = i % 3 == 0
            ? Colors.redAccent.withValues(alpha: 0.5 - 0.03 * i)
            : i % 3 == 1
                ? Colors.blueAccent.withValues(alpha: 0.5 - 0.03 * i)
                : NVSColors.ultraLightMint.withValues(alpha: 0.7 - 0.05 * i);
        final TextStyle style = textStyle.copyWith(color: color);
        final TextSpan textSpan = TextSpan(text: 'N V S', style: style);
        final TextPainter painter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        )..layout();
        painter.paint(canvas, center.translate(-painter.width / 2, 0));
      }
      // Strong flicker: unreadable characters, horizontal tearing
      if (glitchValue > 0.3) {
        for (int i = 0; i < 8; i++) {
          final double dx = (random.nextDouble() - 0.5) * 120;
          final double dy = (random.nextDouble() - 0.5) * 40;
          final TextStyle style = textStyle.copyWith(
            color: Colors.white.withValues(alpha: 0.2 + 0.5 * random.nextDouble()),
            fontSize: 32 + random.nextDouble() * 48,
            letterSpacing: 10 + random.nextDouble() * 20,
          );
          final TextSpan textSpan = TextSpan(
            text: String.fromCharCode(33 + random.nextInt(94)),
            style: style,
          );
          final TextPainter painter = TextPainter(
            text: textSpan,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          )..layout();
          painter.paint(canvas, center.translate(dx, dy));
        }
        // Horizontal tearing: draw random lines over text
        final Paint tearPaint = Paint()
          ..color = Colors.cyanAccent.withValues(alpha: 0.3 + 0.3 * glitchValue)
          ..strokeWidth = 2 + 4 * glitchValue;
        for (int i = 0; i < 6; i++) {
          final double y = nvsY - 30 + random.nextDouble() * 60;
          final double x1 = center.dx - 120 + random.nextDouble() * 80;
          final double x2 = center.dx + 40 + random.nextDouble() * 80;
          canvas.drawLine(Offset(x1, y), Offset(x2, y), tearPaint);
        }
      }
    }

    // Glitch static overlay
    if (glitchValue > 0.2) {
      final Paint staticPaint = Paint()..color = Colors.white.withValues(alpha: 0.08 * glitchValue);
      for (int i = 0; i < 120 * glitchValue; i++) {
        final double x = random.nextDouble() * size.width;
        final double y = random.nextDouble() * size.height;
        canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5, staticPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
