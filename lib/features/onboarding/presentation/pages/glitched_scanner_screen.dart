import 'package:flutter/material.dart';

class GlitchedScannerScreen extends StatefulWidget {
  const GlitchedScannerScreen({
    required this.onComplete,
    super.key,
  });
  final VoidCallback onComplete;

  @override
  State<GlitchedScannerScreen> createState() => _GlitchedScannerScreenState();
}

class _GlitchedScannerScreenState extends State<GlitchedScannerScreen>
    with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late AnimationController _scanController;
  late Animation<double> _glitchAnimation;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _glitchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _glitchController,
        curve: Curves.easeInOut,
      ),
    );

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _scanController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _glitchController.repeat(reverse: true);
    _scanController.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _glitchController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[_glitchAnimation, _scanAnimation]),
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              painter: GlitchedScannerPainter(
                glitchValue: _glitchAnimation.value,
                scanValue: _scanAnimation.value,
              ),
              size: const Size(300, 300),
            );
          },
        ),
      ),
    );
  }
}

class GlitchedScannerPainter extends CustomPainter {
  GlitchedScannerPainter({
    required this.glitchValue,
    required this.scanValue,
  });
  final double glitchValue;
  final double scanValue;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    const Color mint = Color(0xFF4BEFE0);

    // Draw scanner frame
    final Paint framePaint = Paint()
      ..color = mint.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Rect frameRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.8,
      height: size.height * 0.8,
    );
    canvas.drawRect(frameRect, framePaint);

    // Draw glitch effect
    final Paint glitchPaint = Paint()
      ..color = mint.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    const double glitchHeight = 10.0;
    final double glitchY = center.dy - size.height * 0.4 + (glitchValue * size.height * 0.8);

    canvas.drawRect(
      Rect.fromLTWH(
        frameRect.left,
        glitchY,
        frameRect.width,
        glitchHeight,
      ),
      glitchPaint,
    );

    // Draw scan line
    final Paint scanPaint = Paint()
      ..color = mint.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double scanY = frameRect.top + (scanValue * frameRect.height);
    canvas.drawLine(
      Offset(frameRect.left, scanY),
      Offset(frameRect.right, scanY),
      scanPaint,
    );

    // Draw corner indicators
    final Paint cornerPaint = Paint()
      ..color = mint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double cornerSize = 20.0;

    // Top-left corner
    canvas.drawLine(
      Offset(frameRect.left, frameRect.top + cornerSize),
      Offset(frameRect.left, frameRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.left, frameRect.top),
      Offset(frameRect.left + cornerSize, frameRect.top),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(frameRect.right - cornerSize, frameRect.top),
      Offset(frameRect.right, frameRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.right, frameRect.top),
      Offset(frameRect.right, frameRect.top + cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(frameRect.left, frameRect.bottom - cornerSize),
      Offset(frameRect.left, frameRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.left, frameRect.bottom),
      Offset(frameRect.left + cornerSize, frameRect.bottom),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(frameRect.right - cornerSize, frameRect.bottom),
      Offset(frameRect.right, frameRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.right, frameRect.bottom - cornerSize),
      Offset(frameRect.right, frameRect.bottom),
      cornerPaint,
    );

    // Draw scanning text
    final TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: 'SCANNING...',
        style: TextStyle(
          color: mint,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        frameRect.bottom + 20,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
