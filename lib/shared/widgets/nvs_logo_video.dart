import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:nvs/meatup_core.dart';

/// NVS Logo Video Widget
/// Displays the looping NVS logo video at the top of main sections
class NvsLogoVideo extends StatefulWidget {
  const NvsLogoVideo({
    super.key,
    this.height = 60,
    this.width,
    this.showOverlay = false,
  });
  final double? height;
  final double? width;
  final bool showOverlay;

  @override
  State<NvsLogoVideo> createState() => _NvsLogoVideoState();
}

class _NvsLogoVideoState extends State<NvsLogoVideo>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  final bool _isVisible = true;
  bool _isPaused = false;

  // Glitch effect controllers
  late AnimationController _glitchController;
  late AnimationController _scanLineController;
  late Animation<double> _glitchAnimation;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo();
    _initializeGlitchAnimations();
  }

  void _initializeGlitchAnimations() {
    // Random glitch flickers every 3-8 seconds
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 150),
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

    // Subtle scan line effect
    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(
      begin: -0.1,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _scanLineController,
        curve: Curves.linear,
      ),
    );

    // Start the scan line animation (continuous)
    _scanLineController.repeat();

    // Trigger random glitches
    _scheduleRandomGlitch();
  }

  void _scheduleRandomGlitch() {
    final int random = DateTime.now().millisecondsSinceEpoch % 1000;
    final int delay = 3000 + (random * 5); // 3-8 seconds

    Future.delayed(Duration(milliseconds: delay.toInt()), () {
      if (mounted) {
        _glitchController.forward().then((_) {
          _glitchController.reverse();
          _scheduleRandomGlitch();
        });
      }
    });
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(
        'assets/videos/NVS_LOGO-TOP-OF_ALL_PAGES.mp4',
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      );

      // Add error listener
      _controller.addListener(_onVideoError);

      await _controller.initialize();

      // Configure for performance
      _controller.setLooping(true);
      _controller.setVolume(0.0); // Mute for performance

      // Auto-play only if widget is still mounted
      if (mounted) {
        _controller.play();
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing NVS logo video: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  void _onVideoError() {
    if (_controller.value.hasError) {
      debugPrint('Video playback error: ${_controller.value.errorDescription}');
      // Try to reinitialize on error
      if (mounted) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _initializeVideo();
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _glitchController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!_isInitialized) return;

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _pauseVideo();
        break;
      case AppLifecycleState.resumed:
        _resumeVideo();
        break;
      case AppLifecycleState.detached:
        _pauseVideo();
        break;
      case AppLifecycleState.hidden:
        _pauseVideo();
        break;
    }
  }

  void _pauseVideo() {
    if (_isInitialized && !_isPaused) {
      _controller.pause();
      _glitchController.stop();
      _scanLineController.stop();
      _isPaused = true;
    }
  }

  void _resumeVideo() {
    if (_isInitialized && _isPaused && _isVisible) {
      _controller.play();
      _scanLineController.repeat();
      _scheduleRandomGlitch();
      _isPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        height: widget.height,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          color: NVSColors.pureBlack,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                NVSColors.ultraLightMint,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[_glitchAnimation, _scanLineAnimation]),
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: <Widget>[
                // Video Player with potential glitch transform
                Transform(
                  transform: Matrix4.identity()
                    ..translate(
                      _glitchAnimation.value * (DateTime.now().millisecondsSinceEpoch % 10 - 5),
                    ),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),

                // Glitch color overlay
                if (_glitchAnimation.value > 0.1)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Colors.red.withValues(
                              alpha: _glitchAnimation.value * 0.2,
                            ),
                            Colors.cyan.withValues(
                              alpha: _glitchAnimation.value * 0.15,
                            ),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // Scan line effect
                Positioned(
                  top: widget.height! * _scanLineAnimation.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.transparent,
                          NVSColors.ultraLightMint.withValues(alpha: 0.6),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.4),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                // Optional overlay for branding
                if (widget.showOverlay)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.transparent,
                            NVSColors.pureBlack.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
