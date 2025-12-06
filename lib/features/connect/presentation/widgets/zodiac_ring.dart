import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ZodiacRing extends StatefulWidget {
  const ZodiacRing({super.key});

  @override
  State<ZodiacRing> createState() => _ZodiacRingState();
}

class _ZodiacRingState extends State<ZodiacRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40), // A slow, majestic rotation
    )..repeat();
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
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: CustomPaint(
            size: const Size(250, 250), // Matches the SizedBox in the Intro Card
            painter: _ZodiacPainter(),
          ),
        );
      },
    );
  }
}

class _ZodiacPainter extends CustomPainter {
  // Unicode characters for the zodiac glyphs
  final List<String> zodiacSymbols = <String>[
    '♈',
    '♉',
    '♊',
    '♋',
    '♌',
    '♍',
    '♎',
    '♏',
    '♐',
    '♑',
    '♒',
    '♓',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 15; // Give it some padding

    final Paint paint = Paint()
      ..color = NVSColors.primaryNeonMint.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw the main ring
    canvas.drawCircle(center, radius, paint);

    // Draw the glyphs
    for (int i = 0; i < zodiacSymbols.length; i++) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: zodiacSymbols[i],
          style: const TextStyle(
            color: NVSColors.primaryNeonMint,
            fontSize: 20,
            shadows: <Shadow>[
              Shadow(color: NVSColors.primaryNeonMint, blurRadius: 6),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final double angle = (i / zodiacSymbols.length) * 2 * pi;
      final Offset offset = Offset(
        center.dx + radius * cos(angle) - (textPainter.width / 2),
        center.dy + radius * sin(angle) - (textPainter.height / 2),
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
