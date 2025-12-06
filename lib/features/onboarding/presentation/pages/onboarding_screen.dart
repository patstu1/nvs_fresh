import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:nvs/meatup_core.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    required this.onComplete,
    super.key,
  });
  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  late AnimationController _scannerController;
  late AnimationController _glitchController;
  late AnimationController _nvsController;

  late Animation<double> _scannerPosition;
  late Animation<double> _glitchAnimation;
  late Animation<double> _nvsOpacity;

  VideoPlayerController? _videoController;
  bool _showVideo = false;

  bool _isGlitching = false;
  bool _hasTappedOnce = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startScanner();
  }

  Future<void> _initializeVideo() async {
    // Try preferred asset names from spec, fallback to existing files
    final List<String> candidates = <String>[
      'assets/videos/globe_intro.mov',
      'assets/videos/0724(1).mov',
      'assets/videos/spinning_globe_now_loading.mp4',
      'assets/videos/vecteezy_minimalist-earth-spinning-on-black-background-video-for-your-business-or-educational-project_3727472.mp4',
    ];

    VideoPlayerController? controller;
    for (final String path in candidates) {
      try {
        final VideoPlayerController attempt = VideoPlayerController.asset(path)
          ..setLooping(true)
          ..setVolume(0.0);
        await attempt.initialize();
        controller = attempt;
        break;
      } catch (_) {
        // try next candidate
      }
    }

    // Final fallback to existing asset
    controller ??= VideoPlayerController.asset('assets/videos/0724(1).mov')
      ..setLooping(true)
      ..setVolume(0.0);
    try {
      if (!controller.value.isInitialized) {
        await controller.initialize();
      }
    } catch (_) {}

    setState(() {
      _videoController = controller;
    });
    // Autoplay
    try {
      await _videoController?.play();
    } catch (_) {}
  }

  void _initializeAnimations() {
    // Scanner animation - moves up and down continuously
    _scannerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scannerPosition = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _scannerController,
        curve: Curves.easeInOut,
      ),
    );

    // Glitch animation for NVS logo
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 200),
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

    // NVS logo fade in animation
    _nvsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _nvsOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _nvsController,
        curve: Curves.easeInOut,
      ),
    );

    // Start NVS logo fade in
    _nvsController.forward();
  }

  void _startScanner() {
    _scannerController.repeat(reverse: true);

    // Listen to scanner position to trigger glitch effect
    _scannerController.addListener(_checkScannerOverNVS);
  }

  void _checkScannerOverNVS() {
    // NVS logo is positioned around 0.4-0.6 of screen height
    final double scannerY = _scannerPosition.value;
    final bool isOverNVS =
        scannerY >= 0.45 && scannerY <= 0.55; // Tighter range for more precise timing

    if (isOverNVS && !_isGlitching) {
      _triggerGlitch();
    } else if (!isOverNVS && _isGlitching) {
      _stopGlitch();
    }
  }

  void _triggerGlitch() {
    setState(() {
      _isGlitching = true;
    });
    _glitchController.repeat(reverse: true);
  }

  void _stopGlitch() {
    setState(() {
      _isGlitching = false;
    });
    _glitchController.stop();
    _glitchController.reset();
  }

  void _handleTap() {
    if (!_hasTappedOnce) {
      // First tap: transition from scanner to code wall
      setState(() {
        _showVideo = true;
        _hasTappedOnce = true;
        _scannerController.stop();
        _glitchController.stop();
      });
      _initializeVideo();
    } else {
      // Second tap: transition from code wall to the main app
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _glitchController.dispose();
    _nvsController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: _showVideo ? _buildVideoPlayer() : _buildScannerView(),
          ),
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    return Stack(
      key: const ValueKey('scanner'),
      children: <Widget>[
        // Background grid pattern
        _buildBackgroundGrid(),

        // NVS Logo with glitch effect
        _buildNVSLogo(),

        // Scanner line
        _buildScanner(),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      key: const ValueKey('video'),
      fit: StackFit.expand,
      children: <Widget>[
        if (_videoController != null && _videoController!.value.isInitialized)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          )
        else
          Container(
            color: NVSColors.pureBlack,
          ), // Placeholder while video loads
        // You can add overlays on top of the video here if needed
      ],
    );
  }

  Widget _buildBackgroundGrid() {
    return CustomPaint(
      painter: GridPainter(),
      size: Size.infinite,
    );
  }

  Widget _buildNVSLogo() {
    return AnimatedBuilder(
      animation: _nvsOpacity,
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: Opacity(
            opacity: _isGlitching ? _nvsOpacity.value : 0.0, // Only show when scanner passes over
            child: AnimatedBuilder(
              animation: _glitchAnimation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: _isGlitching
                      ? Offset(
                          (Random().nextDouble() - 0.5) * 20 * _glitchAnimation.value,
                          (Random().nextDouble() - 0.5) * 15 * _glitchAnimation.value,
                        )
                      : Offset.zero,
                  child: Stack(
                    children: <Widget>[
                      // Glitch effect layers
                      if (_isGlitching) ...<Widget>[
                        // Red glitch layer
                        Transform.translate(
                          offset: Offset(-2 * _glitchAnimation.value, 0),
                          child: Text(
                            'NVS',
                            style: TextStyle(
                              fontFamily: 'MagdaClean',
                              fontSize: 96,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8,
                              color: Colors.red.withValues(alpha: 0.8),
                              shadows: <Shadow>[
                                Shadow(
                                  color: Colors.red.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Blue glitch layer
                        Transform.translate(
                          offset: Offset(2 * _glitchAnimation.value, 0),
                          child: Text(
                            'NVS',
                            style: TextStyle(
                              fontFamily: 'MagdaClean',
                              fontSize: 96,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8,
                              color: Colors.blue.withValues(alpha: 0.8),
                              shadows: <Shadow>[
                                Shadow(
                                  color: Colors.blue.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      // Main NVS text - ultra pale mint neon
                      Text(
                        'NVS',
                        style: TextStyle(
                          fontFamily: 'MagdaClean',
                          fontSize: 96,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 8,
                          foreground: Paint()
                            ..color = const Color(0xFFE8FFF5), // Ultra pale mint neon
                          shadows: <Shadow>[
                            Shadow(
                              color: const Color(0xFFE8FFF5).withValues(alpha: 0.8),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      // Thin aqua outline
                      Text(
                        'NVS',
                        style: TextStyle(
                          fontFamily: 'MagdaClean',
                          fontSize: 96, // Much larger
                          fontWeight: FontWeight.w900,
                          letterSpacing: 8,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.5
                            ..color = NVSColors.aquaOutline,
                          shadows: <Shadow>[
                            Shadow(
                              color: NVSColors.aquaOutline.withValues(alpha: 0.6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildScanner() {
    return AnimatedBuilder(
      animation: _scannerPosition,
      builder: (BuildContext context, Widget? child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * _scannerPosition.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.transparent,
                  NVSColors.ultraLightMint.withValues(alpha: 0.8),
                  NVSColors.ultraLightMint,
                  NVSColors.ultraLightMint.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                stops: const <double>[0.0, 0.2, 0.5, 0.8, 1.0],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: NVSColors.aquaOutline.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionText() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.2,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          '//: CONNECTION PROTOCOL INITIATED...',
          style: TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 16,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            color: NVSColors.ultraLightMint.withValues(alpha: 0.8),
            shadows: <Shadow>[
              Shadow(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.4),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = NVSColors.ultraLightMint.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const double gridSpacing = 40.0; // Match React grid spacing

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
