import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../onboarding/glitched_scanner_screen.dart';
import 'splash_screen.dart';
import 'package:nvs/presentation/widgets/globe_intro.dart';

/// Main onboarding sequence: scanner+glitch, then video+glitch, then globe, then callback.
class OnboardingSequence extends StatefulWidget {
  const OnboardingSequence({required this.onFinished, super.key});
  final VoidCallback onFinished;

  @override
  State<OnboardingSequence> createState() => _OnboardingSequenceState();
}

class _OnboardingSequenceState extends State<OnboardingSequence> {
  int _step = 0;
  late VideoPlayerController _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    // Use a different video file that exists
    _videoController = VideoPlayerController.asset('assets/videos/blurrr_mint.mov')
      ..initialize().then((_) {
        setState(() => _videoReady = true);
        _videoController.play();
        _videoController.setLooping(false);
      }).catchError((error) {
        // If video fails to load, just mark as ready with a placeholder
        debugPrint('Video loading error: $error');
        setState(() => _videoReady = true);
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 0) {
      // Splash screen (loading)
      return GenesisSplashScreen(onFinished: _nextStep);
    } else if (_step == 1) {
      // Scanner with glitch
      return GlitchedScannerScreen(onDoubleTap: _nextStep);
    } else if (_step == 2) {
      // Video with strong glitch overlay
      return Stack(
        children: <Widget>[
          // Background - video or fallback
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: _videoReady && _videoController.value.isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.play_circle_outline,
                          size: 100,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'NVS INTRO',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          // Extra strong glitch overlay
          const Positioned.fill(
            child: IgnorePointer(
              child: AnimatedGlitchOverlay(),
            ),
          ),
          // Tap to continue
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _nextStep,
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      );
    } else if (_step == 3) {
      // Mint globe intro
      return GlobeIntro(onIntroComplete: _nextStep);
    } else {
      // Proceed to main app or map view
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onFinished();
      });
      return const SizedBox.shrink();
    }
  }
}

/// Simple animated glitch overlay for video (extra strong, but screen visible)
class AnimatedGlitchOverlay extends StatefulWidget {
  // 0.0 to 1.0
  const AnimatedGlitchOverlay({super.key, this.strength = 1.0});
  final double strength;

  @override
  State<AnimatedGlitchOverlay> createState() => _AnimatedGlitchOverlayState();
}

class _AnimatedGlitchOverlayState extends State<AnimatedGlitchOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
        // Glitch: color split, offset, noise, opacity flicker
        final double t = _controller.value;
        return Stack(
          children: <Widget>[
            // RGB split
            Opacity(
              opacity: 0.5 + 0.5 * widget.strength,
              child: Transform.translate(
                offset: Offset(8 * (t - 0.5) * widget.strength, 0),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.redAccent,
                    BlendMode.modulate,
                  ),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Opacity(
              opacity: 0.5 * widget.strength,
              child: Transform.translate(
                offset: Offset(-8 * (t - 0.5) * widget.strength, 0),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.cyanAccent,
                    BlendMode.modulate,
                  ),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            // Noise flicker
            Opacity(
              opacity: 0.15 + 0.25 * widget.strength * (0.5 + 0.5 * math.sin(t * 20)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05 * widget.strength),
                  backgroundBlendMode: BlendMode.screen,
                ),
              ),
            ),
            // Scan lines
            CustomPaint(
              painter: GlitchScanlinePainter(strength: widget.strength, t: t),
              size: Size.infinite,
            ),
          ],
        );
      },
    );
  }
}

class GlitchScanlinePainter extends CustomPainter {
  GlitchScanlinePainter({required this.strength, required this.t});
  final double strength;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08 * strength)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 3) {
      if ((y ~/ 3) % 2 == 0) {
        canvas.drawLine(
          Offset(0, y + 0.5 * math.sin(t * 40 + y)),
          Offset(size.width, y + 0.5 * math.sin(t * 40 + y)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant GlitchScanlinePainter oldDelegate) => true;
}
