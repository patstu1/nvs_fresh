import 'dart:math'; // Added
import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nvs/shared/widgets/nvs_logo_app_bar.dart';

class AiConnectScreen extends StatefulWidget {
  const AiConnectScreen({super.key});

  @override
  State<AiConnectScreen> createState() => _AiConnectScreenState();
}

class _AiConnectScreenState extends State<AiConnectScreen> with TickerProviderStateMixin {
  late Future<String> _personalitySummary;
  late AnimationController _matchRingController;

  @override
  void initState() {
    super.initState();
    _matchRingController = AnimationController(vsync: this, duration: 2.seconds)..forward();
    _personalitySummary = AiService().generatePersonalitySummary(
      instagramProfile: 'instagram.com/user', // Placeholder
      tiktokProfile: 'tiktok.com/@user', // Placeholder
      twitterProfile: 'twitter.com/user', // Placeholder
    );
  }

  @override
  void dispose() {
    _matchRingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: const NvsLogoAppBar(),
      body: Stack(
        children: <Widget>[
          _buildGlitchedBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildSplitFaceVisual(),
                  const SizedBox(height: 30),
                  _buildAiGeneratedCopy(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlitchedBackground() {
    return Container(color: Colors.transparent)
        .animate(onPlay: (AnimationController c) => c.repeat())
        .shake(hz: 1, duration: 10.seconds, rotation: 0.01);
  }

  Widget _buildSplitFaceVisual() {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildAuraRing(
            NVSColors.electricPink.withValues(alpha: 0.4),
            1.2,
            3000.ms,
          ),
          _buildAuraRing(
            NVSColors.neonMint.withValues(alpha: 0.5),
            1.4,
            4000.ms,
          ),
          _buildMatchPercentageRing(73), // Example match percentage
          _buildSplitFaceImage(),
        ],
      ),
    );
  }

  Widget _buildAuraRing(Color color, double scale, Duration duration) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[BoxShadow(color: color, blurRadius: 40, spreadRadius: 15)],
      ),
    ).animate(onPlay: (AnimationController c) => c.repeat(reverse: true)).scaleXY(
          begin: 1,
          end: scale,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }

  Widget _buildMatchPercentageRing(int percentage) {
    return SizedBox(
      width: 260,
      height: 260,
      child: AnimatedBuilder(
        animation: _matchRingController,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: RingPainter(
              progress: _matchRingController.value,
              percentage: percentage,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSplitFaceImage() {
    return SizedBox(
      width: 200,
      height: 200,
      child: ClipOval(
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              width: 100,
              child: Image.asset(
                'assets/images/https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              right: 0,
              width: 100,
              child: Image.asset(
                'assets/images/placeholder_avatar_2.png',
                fit: BoxFit.cover,
              ), // Second avatar
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiGeneratedCopy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: FutureBuilder<String>(
        future: _personalitySummary,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: NVSColors.neonMint);
          }
          if (snapshot.hasError) {
            return const Text(
              'AI is unavailable',
              style: TextStyle(color: NVSColors.electricPink),
            );
          }
          return Text(
            '"${snapshot.data ?? 'Unable to synthesize connection...'}"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: NVSColors.secondaryText,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
          ).animate().fadeIn(duration: 1.seconds).slideY(begin: 0.2);
        },
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  RingPainter({required this.progress, required this.percentage});
  final double progress;
  final int percentage;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Rect rect = Rect.fromCircle(center: center, radius: size.width / 2);

    final Paint backgroundPaint = Paint()
      ..color = NVSColors.dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final Paint foregroundPaint = Paint()
      ..shader = const SweepGradient(
        colors: <Color>[NVSColors.neonMint, NVSColors.avocadoGreen],
        stops: <double>[0.0, 0.7],
        transform: GradientRotation(pi / 2),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    canvas.drawArc(rect, -pi / 2, 2 * pi, false, backgroundPaint);
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * (percentage / 100) * progress,
      false,
      foregroundPaint,
    );

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage%',
        style: const TextStyle(
          color: NVSColors.ultraLightMint,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: NVSColors.mintTextShadow,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center -
          Offset(
            textPainter.width / 2,
            textPainter.height / 2 + size.width / 2 + 15,
          ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
