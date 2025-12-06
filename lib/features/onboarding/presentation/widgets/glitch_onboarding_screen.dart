import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlitchOnboardingScreen extends StatefulWidget {
  const GlitchOnboardingScreen({required this.onFinished, super.key});
  final VoidCallback onFinished;

  @override
  State<GlitchOnboardingScreen> createState() => _GlitchOnboardingScreenState();
}

class _GlitchOnboardingScreenState extends State<GlitchOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _scannerController;
  AnimationController? _glitchController;
  late VideoPlayerController _videoController;

  bool _showCodeWall = false;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(vsync: this, duration: 3.seconds)
      ..repeat(reverse: true);
    _glitchController = AnimationController(vsync: this, duration: 200.ms);
    _videoController = VideoPlayerController.asset('assets/videos/0724(1).mov')
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _glitchController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _handleInteraction() {
    if (_showCodeWall) {
      widget.onFinished();
    } else {
      setState(() {
        _showCodeWall = true;
        _videoController.play();
        _videoController.setLooping(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: GestureDetector(
        onTap: _handleInteraction, // Simplified to a single tap
        behavior: HitTestBehavior.opaque, // Ensures the entire screen is tappable
        child: AnimatedSwitcher(
          duration: 300.ms,
          child: _showCodeWall ? _buildCodeWall() : _buildScanner(),
        ),
      ),
    );
  }

  Widget _buildScanner() {
    return SizedBox.expand(
      // Ensures the Stack fills the screen for proper centering
      key: const ValueKey('scanner'),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // The animated scanner line
          AnimatedBuilder(
            animation: _scannerController,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * _scannerController.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    color: NVSColors.neonMint,
                    boxShadow: NVSColors.mintGlow,
                  ),
                ),
              );
            },
          ),
          // The centered, glitched NVS logo, drawn on top
          AnimatedBuilder(
            animation: _scannerController,
            builder: (BuildContext context, Widget? child) {
              final bool isNearCenter =
                  _scannerController.value > 0.45 && _scannerController.value < 0.55;
              if (isNearCenter && _glitchController?.isAnimating == false) {
                _glitchController?.forward(from: 0);
              }
              // Always build the widget, but control its visibility
              return Visibility(
                visible: isNearCenter,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: _buildGlitchedNVS(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGlitchedNVS() {
    if (_glitchController == null) {
      return const SizedBox.shrink();
    }
    return Animate(
      controller: _glitchController,
      effects: <Effect>[
        ShakeEffect(hz: 20, duration: 200.ms, rotation: 0.1),
        BlurEffect(
          begin: const Offset(0, 0),
          end: const Offset(5, 5),
          duration: 200.ms,
        ),
      ],
      child: Text(
        'NVS',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontFamily: 'Cyberpunk',
              color: NVSColors.neonMint,
              shadows: NVSColors.mintTextShadow,
            ),
      ),
    );
  }

  Widget _buildCodeWall() {
    return SizedBox.expand(
      key: const ValueKey('codeWall'),
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoController.value.size.width,
          height: _videoController.value.size.height,
          child: VideoPlayer(_videoController),
        ),
      ),
    ).animate().fadeIn();
  }
}
