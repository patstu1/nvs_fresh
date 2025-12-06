import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:nvs/meatup_core.dart';

/// Video player widget for Curator clips that appear at key moments
/// Creates hyper-realistic, human touch in the conversation
class CuratorVideoPlayer extends StatefulWidget {
  const CuratorVideoPlayer({
    required this.controller,
    required this.onVideoComplete,
    super.key,
  });
  final VideoPlayerController controller;
  final VoidCallback onVideoComplete;

  @override
  State<CuratorVideoPlayer> createState() => _CuratorVideoPlayerState();
}

class _CuratorVideoPlayerState extends State<CuratorVideoPlayer> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupVideoListener();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  void _setupVideoListener() {
    widget.controller.addListener(() {
      if (widget.controller.value.position >= widget.controller.value.duration) {
        _handleVideoComplete();
      }
    });
  }

  void _handleVideoComplete() {
    _fadeController.reverse().then((_) {
      widget.onVideoComplete();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[_fadeAnimation, _scaleAnimation, _glowAnimation]),
      builder: (BuildContext context, Widget? child) {
        return Positioned.fill(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ColoredBox(
              color: NVSColors.pureBlack.withValues(alpha: 0.8),
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.neonMint.withValues(
                            alpha: 0.3 * _glowAnimation.value,
                          ),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: NVSColors.ultraLightMint.withValues(
                            alpha: 0.2 * _glowAnimation.value,
                          ),
                          blurRadius: 50,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: <Widget>[
                          // Video player
                          if (widget.controller.value.isInitialized)
                            Positioned.fill(
                              child: AspectRatio(
                                aspectRatio: widget.controller.value.aspectRatio,
                                child: VideoPlayer(widget.controller),
                              ),
                            ),

                          // Overlay gradient
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

                          // Border
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: NVSColors.neonMint.withValues(
                                    alpha: 0.6 * _glowAnimation.value,
                                  ),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          // Skip button
                          Positioned(
                            top: 16,
                            right: 16,
                            child: GestureDetector(
                              onTap: _handleVideoComplete,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: NVSColors.pureBlack.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: NVSColors.neonMint.withValues(alpha: 0.5),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: NVSColors.neonMint,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),

                          // Progress indicator
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(milliseconds: 100)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!widget.controller.value.isInitialized) {
          return const SizedBox.shrink();
        }

        final double progress = widget.controller.value.position.inMilliseconds /
            widget.controller.value.duration.inMilliseconds;

        return Container(
          height: 4,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: NVSColors.cardBackground.withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              NVSColors.neonMint.withValues(alpha: 0.8),
            ),
          ),
        );
      },
    );
  }
}

/// Ambient video background for certain conversation moments
class AmbientVideoBackground extends StatefulWidget {
  const AmbientVideoBackground({
    required this.videoPath,
    super.key,
    this.opacity = 0.3,
  });
  final String videoPath;
  final double opacity;

  @override
  State<AmbientVideoBackground> createState() => _AmbientVideoBackgroundState();
}

class _AmbientVideoBackgroundState extends State<AmbientVideoBackground> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller!.initialize();

      setState(() {
        _isInitialized = true;
      });

      _controller!.setLooping(true);
      _controller!.play();
    } catch (e) {
      debugPrint('Ambient video initialization failed: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Opacity(
        opacity: widget.opacity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
      ),
    );
  }
}
