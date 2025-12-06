import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
// Removed earth radar intro import
import 'package:video_player/video_player.dart';

class CodeWallScreen extends ConsumerStatefulWidget {
  const CodeWallScreen({required this.onComplete, super.key});
  final VoidCallback onComplete;

  @override
  ConsumerState<CodeWallScreen> createState() => _CodeWallScreenState();
}

class _CodeWallScreenState extends ConsumerState<CodeWallScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/videos/0724(1).mov');

      await _videoController.initialize();
      setState(() {
        _isVideoInitialized = true;
      });

      _videoController.play();
      _videoController.addListener(_onVideoProgress);
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _videoFailed = true;
      });
      // Fallback to next screen if video fails
      Future.delayed(const Duration(seconds: 3), _navigateToNext);
    }
  }

  void _onVideoProgress() {
    if (_videoController.value.position >= _videoController.value.duration) {
      _navigateToNext();
    }
  }

  void _navigateToNext() {
    // Complete the code wall sequence and proceed to main app
    widget.onComplete();
  }

  @override
  void dispose() {
    if (_isVideoInitialized) {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.background,
      body: Stack(
        children: <Widget>[
          // Video background - full screen
          if (_isVideoInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          else if (_videoFailed)
            // Fallback glitch effect if video fails
            _buildFallbackGlitchEffect()
          else
            // Loading fallback
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    color: NVSColors.neonGreen,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading Code Wall...',
                    style: TextStyle(
                      color: NVSColors.neonGreen,
                      fontSize: 16,
                      fontFamily: 'FFMagdaClean',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackGlitchEffect() {
    return ColoredBox(
      color: NVSColors.background,
      child: CustomPaint(
        size: Size.infinite,
        painter: FallbackGlitchPainter(),
      ),
    );
  }
}

class FallbackGlitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = NVSColors.neonGreen.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Draw glitch lines
    for (int i = 0; i < 50; i++) {
      final double x = (i * size.width / 50) + (DateTime.now().millisecondsSinceEpoch % 100);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal scanlines
    for (int i = 0; i < 30; i++) {
      final double y = (i * size.height / 30) + (DateTime.now().millisecondsSinceEpoch % 50);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
