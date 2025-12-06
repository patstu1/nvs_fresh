// lib/features/onboarding/presentation/views/initiation_view.dart
import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import 'package:nvs/meatup_core.dart';
import 'dart:math' as math;

// The states of our initiation ritual
enum InitiationPhase {
  permission, // Camera permission request
  scanning, // High-tech face scanner
  meanings, // Blurred NVS meanings
  reveal, // V->N->S sequence
  schism // Netflix-style V split
}

class InitiationView extends StatefulWidget {
  const InitiationView({super.key, this.onFinished});
  final VoidCallback? onFinished;

  @override
  State<InitiationView> createState() => _InitiationViewState();
}

class _InitiationViewState extends State<InitiationView> with TickerProviderStateMixin {
  InitiationPhase _currentPhase = InitiationPhase.permission;

  // Animation controllers
  late AnimationController _scanController;
  late AnimationController _glitchController;
  late AnimationController _meaningsController;
  late AnimationController _revealController;
  late AnimationController _schismController;

  // Scanner animations
  late Animation<double> _scanPosition;
  late Animation<double> _glitchIntensity;

  // Meanings animations
  late Animation<double> _blurAnimation;
  late Animation<double> _scrollAnimation;

  // Reveal animations
  late Animation<double> _vReveal;
  late Animation<double> _nReveal;
  late Animation<double> _sReveal;
  late Animation<double> _flashIntensity;

  // Schism animations
  late Animation<double> _splitAnimation;
  late Animation<double> _beamExpansion;

  // NVS meanings for the blur phase
  final List<String> nvsMeanings = <String>[
    'ENVIOUS',
    'ENVY US',
    'NEVER VISUALLY SATISFIED',
    'NEXT-LEVEL VISUAL SYSTEM',
    'NEON VISUAL SOCIETY',
    'NO VISIBLE SEAMS',
    'NEURAL VISION SYSTEM',
    'NEVER-ENDING VISUAL SEDUCTION',
    'NEXT-GENERATION VISUAL SPACE',
    'NEON VIBE SCENE',
    'NETWORKED VIRTUAL SPACES',
    'NEON VIRTUAL SOCIETY',
    'NEVER VULNERABLE, STRONG',
    'NEW VISUAL STANDARD',
    'NOCTURNAL VOYEUR SOCIETY',
    'NEXT-LEVEL VIBE SOURCE',
    'NEON VOYEUR SANCTUARY',
    'NEVER-ENDING VIBE STREAM',
    'NEON VISUAL SANCTUARY',
    'NETWORKED VIBE SYSTEM',
    'NOBLE VISION SEEKERS',
    'NEON VIRTUAL SANCTUARY',
    'NEVER VANILLA SOCIETY',
    'NEXT VISUAL SENSATION',
    'NEW VIBE STANDARD',
    'NEON VIEW SPHERE',
    'NEVER VANILLA, SEXY',
    'NO VACANCY, SEXY',
    'NEON VANGUARD SOCIETY',
    'NEURAL VIBE SYNCHRONY',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Scanner controller - continuous scanning motion
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Glitch controller - random glitch effects
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Meanings controller - scrolling blur effect
    _meaningsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Reveal controller - V->N->S sequence
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Schism controller - Netflix split effect
    _schismController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Setup animations
    _scanPosition = Tween<double>(begin: -0.2, end: 1.2).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    _glitchIntensity = Tween<double>(begin: 0.0, end: 1.0).animate(_glitchController);

    _blurAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _meaningsController,
        curve: const Interval(0.6, 1.0),
      ),
    );

    _scrollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_meaningsController);

    // Reveal sequence animations
    _vReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.0, 0.3),
      ),
    );

    _nReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.3, 0.6),
      ),
    );

    _sReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.6, 0.9),
      ),
    );

    _flashIntensity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.elasticOut),
    );

    // Schism animations
    _splitAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _schismController,
        curve: const Interval(0.0, 0.4),
      ),
    );

    _beamExpansion = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _schismController,
        curve: const Interval(0.2, 1.0),
      ),
    );

    // Start with permission request
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    // Simulate permission request
    await Future.delayed(const Duration(milliseconds: 500));
    _startScanning();
  }

  void _startScanning() {
    setState(() => _currentPhase = InitiationPhase.scanning);
    _scanController.repeat();
    _startGlitching();

    // Complete scan after 4 seconds
    Future.delayed(const Duration(seconds: 4), _startMeanings);
  }

  void _startGlitching() {
    _glitchController.repeat(reverse: true);
  }

  void _startMeanings() {
    setState(() => _currentPhase = InitiationPhase.meanings);
    _scanController.stop();
    _glitchController.stop();
    _meaningsController.forward().whenComplete(_startReveal);
  }

  void _startReveal() {
    setState(() => _currentPhase = InitiationPhase.reveal);
    _revealController.forward().whenComplete(_startSchism);
  }

  void _startSchism() {
    setState(() => _currentPhase = InitiationPhase.schism);
    _schismController.forward().whenComplete(() {
      if (widget.onFinished != null) {
        widget.onFinished!();
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _glitchController.dispose();
    _meaningsController.dispose();
    _revealController.dispose();
    _schismController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child: _buildCurrentPhase(),
      ),
    );
  }

  Widget _buildCurrentPhase() {
    switch (_currentPhase) {
      case InitiationPhase.permission:
        return _buildPermissionPhase();
      case InitiationPhase.scanning:
        return _buildScanningPhase();
      case InitiationPhase.meanings:
        return _buildMeaningsPhase();
      case InitiationPhase.reveal:
        return _buildRevealPhase();
      case InitiationPhase.schism:
        return _buildSchismPhase();
    }
  }

  Widget _buildPermissionPhase() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: NVSColors.cardBackground.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: NVSColors.ultraLightMint.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NVSColors.ultraLightMint.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.camera_alt,
              color: NVSColors.scannerGlow,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'BIOMETRIC SCAN',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: NVSColors.ultraLightMint,
                letterSpacing: 3,
                shadows: <Shadow>[
                  Shadow(
                    color: NVSColors.ultraLightMint,
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Allow camera access for\nfacial recognition authentication',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 16,
                color: NVSColors.secondaryText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startScanning,
              style: ElevatedButton.styleFrom(
                backgroundColor: NVSColors.scannerGlow,
                foregroundColor: NVSColors.pureBlack,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'AUTHORIZE SCAN',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningPhase() {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[_scanController, _glitchController]),
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: <Widget>[
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              color: NVSColors.pureBlack,
            ),

            // Scanning overlay
            CustomPaint(
              painter: ScannerPainter(
                scanPosition: _scanPosition.value,
                glitchIntensity: _glitchIntensity.value,
              ),
              size: Size.infinite,
            ),

            // Glitchy NVS text
            Center(
              child: Transform.scale(
                scale: 1.0 + (_glitchIntensity.value * 0.1),
                child: Opacity(
                  opacity: 0.8 + (_glitchIntensity.value * 0.2),
                  child: Text(
                    'NVS',
                    style: TextStyle(
                      fontFamily: 'BellGothic',
                      fontSize: 120,
                      fontWeight: FontWeight.w900,
                      color: _getGlitchColor(),
                      letterSpacing: 8,
                      shadows: <Shadow>[
                        Shadow(
                          color: NVSColors.scannerGlow.withOpacity(0.8),
                          blurRadius: 30,
                        ),
                        Shadow(
                          color: NVSColors.neonPink.withOpacity(_glitchIntensity.value),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Scan status
            const Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'BIOMETRIC SCAN IN PROGRESS...',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 16,
                    color: NVSColors.scannerGlow,
                    letterSpacing: 2,
                    shadows: <Shadow>[
                      Shadow(
                        color: NVSColors.scannerGlow,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getGlitchColor() {
    final List<Color> colors = <Color>[
      NVSColors.ultraLightMint,
      NVSColors.scannerGlow,
      NVSColors.neonPink,
      NVSColors.hologramBlue,
    ];
    return colors[(_glitchIntensity.value * colors.length).floor() % colors.length];
  }

  Widget _buildMeaningsPhase() {
    return AnimatedBuilder(
      animation: _meaningsController,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                NVSColors.pureBlack,
                NVSColors.glitchPink.withOpacity(0.1),
                NVSColors.pureBlack,
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Streaming meanings with glitch effect like your reference
              ...List.generate(nvsMeanings.length, (int index) {
                final double baseOffset = (_scrollAnimation.value * 3) - (index * 0.08);
                final double staggeredOffset =
                    baseOffset + (math.sin(_scrollAnimation.value * math.pi * 2 + index) * 0.1);
                final double yPosition =
                    (MediaQuery.of(context).size.height * staggeredOffset) + (index * 45);

                // Color variation for depth like the reference image
                Color textColor;
                double opacity;
                if (index % 4 == 0) {
                  textColor = NVSColors.hologramBlue;
                  opacity = 0.8;
                } else if (index % 4 == 1) {
                  textColor = NVSColors.glitchPink;
                  opacity = 0.9;
                } else if (index % 4 == 2) {
                  textColor = NVSColors.scannerGlow;
                  opacity = 0.7;
                } else {
                  textColor = NVSColors.ultraLightMint;
                  opacity = 0.85;
                }

                return Positioned(
                  top: yPosition,
                  left: -50 + (math.sin(_scrollAnimation.value * 2 + index) * 30),
                  right: -50,
                  child: Transform.scale(
                    scale: 0.8 + (math.sin(_scrollAnimation.value * 3 + index) * 0.2),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: _blurAnimation.value * (1.5 + (index % 3) * 0.5),
                        sigmaY: _blurAnimation.value * 0.3,
                      ),
                      child: Text(
                        nvsMeanings[index],
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 16 + (index % 3) * 4,
                          fontWeight: FontWeight.w600,
                          color: textColor.withOpacity(opacity),
                          letterSpacing: 1.5,
                          shadows: <Shadow>[
                            Shadow(
                              color: textColor.withOpacity(0.5),
                              blurRadius: 15,
                            ),
                            Shadow(
                              color: textColor.withOpacity(0.3),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                );
              }),

              // Additional streaming effect layers like your reference
              ...List.generate(10, (int i) {
                final double streamOffset = (_scrollAnimation.value * 4) - (i * 0.15);
                return Positioned(
                  top: MediaQuery.of(context).size.height * streamOffset,
                  left: i * 35.0,
                  child: Container(
                    width: 2,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          NVSColors.scannerGlow.withOpacity(0.6),
                          NVSColors.hologramBlue.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Glitch overlay
              if (_meaningsController.value > 0.8)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: NVSColors.glitchPink.withOpacity(0.1),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRevealPhase() {
    return AnimatedBuilder(
      animation: _revealController,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: NVSColors.pureBlack,
          child: Stack(
            children: <Widget>[
              // Flash effect
              if (_flashIntensity.value > 0.5)
                Container(
                  color: NVSColors.ultraLightMint.withOpacity((_flashIntensity.value - 0.5) * 0.3),
                ),

              // Letters
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // V
                    AnimatedOpacity(
                      opacity: _vReveal.value,
                      duration: const Duration(milliseconds: 100),
                      child: _buildRevealLetter('V'),
                    ),
                    const SizedBox(width: 20),
                    // N (disappears after reveal)
                    AnimatedOpacity(
                      opacity: _revealController.value > 0.9 ? 0.0 : _nReveal.value,
                      duration: const Duration(milliseconds: 200),
                      child: _buildRevealLetter('N'),
                    ),
                    const SizedBox(width: 20),
                    // S (disappears after reveal)
                    AnimatedOpacity(
                      opacity: _revealController.value > 0.9 ? 0.0 : _sReveal.value,
                      duration: const Duration(milliseconds: 200),
                      child: _buildRevealLetter('S'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRevealLetter(String letter) {
    return Text(
      letter,
      style: const TextStyle(
        fontFamily: 'BellGothic',
        fontSize: 140,
        fontWeight: FontWeight.w900,
        color: NVSColors.ultraLightMint,
        shadows: <Shadow>[
          Shadow(
            color: NVSColors.ultraLightMint,
            blurRadius: 30,
          ),
          Shadow(
            color: NVSColors.scannerGlow,
            blurRadius: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildSchismPhase() {
    return AnimatedBuilder(
      animation: _schismController,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: NVSColors.pureBlack,
          child: CustomPaint(
            painter: SchismPainter(
              splitProgress: _splitAnimation.value,
              beamExpansion: _beamExpansion.value,
            ),
            child: Center(
              child: Transform.scale(
                scale: 1.0 + (_splitAnimation.value * 0.2),
                child: const Text(
                  'V',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontSize: 140,
                    fontWeight: FontWeight.w900,
                    color: NVSColors.ultraLightMint,
                    shadows: <Shadow>[
                      Shadow(
                        color: NVSColors.ultraLightMint,
                        blurRadius: 40,
                      ),
                      Shadow(
                        color: NVSColors.hologramBlue,
                        blurRadius: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for high-tech scanner effect
class ScannerPainter extends CustomPainter {
  ScannerPainter({
    required this.scanPosition,
    required this.glitchIntensity,
  });
  final double scanPosition;
  final double glitchIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Scanner beam
    final double beamY = size.height * scanPosition;
    const double beamHeight = 8.0;

    // Main scanner beam
    paint.color = NVSColors.scannerGlow.withOpacity(0.8);
    canvas.drawRect(
      Rect.fromLTWH(0, beamY - beamHeight / 2, size.width, beamHeight),
      paint,
    );

    // Glowing edges
    paint.color = NVSColors.ultraLightMint.withOpacity(0.6);
    canvas.drawRect(
      Rect.fromLTWH(0, beamY - beamHeight / 2 - 2, size.width, 2),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, beamY + beamHeight / 2, size.width, 2),
      paint,
    );

    // Grid overlay
    _drawScanGrid(canvas, size, beamY);
  }

  void _drawScanGrid(Canvas canvas, Size size, double beamY) {
    final Paint gridPaint = Paint()
      ..color = NVSColors.scannerGlow.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Vertical lines
    for (int i = 0; i < 10; i++) {
      final double x = (size.width / 9) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Horizontal lines near scanner
    for (int i = -5; i <= 5; i++) {
      final double y = beamY + (i * 20);
      if (y >= 0 && y <= size.height) {
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          gridPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Enhanced schism painter with Netflix-style beam effects
class SchismPainter extends CustomPainter {
  SchismPainter({
    required this.splitProgress,
    required this.beamExpansion,
  });
  final double splitProgress;
  final double beamExpansion;

  @override
  void paint(Canvas canvas, Size size) {
    if (beamExpansion <= 0) return;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Create dramatic vertical light beams
    const int beamCount = 20;
    final double maxBeamHeight = size.height * beamExpansion;

    for (int i = 0; i < beamCount; i++) {
      final double angle = (i / beamCount) * math.pi * 2;
      final double beamX = centerX + (math.cos(angle) * 100 * splitProgress);
      final double beamWidth = (8.0 + (i % 3) * 4) * beamExpansion;
      final double alpha = (1.0 - (i.abs() / beamCount)) * beamExpansion;

      // Color variation for depth
      Color beamColor;
      if (i % 4 == 0) {
        beamColor = NVSColors.ultraLightMint;
      } else if (i % 4 == 1) {
        beamColor = NVSColors.scannerGlow;
      } else if (i % 4 == 2) {
        beamColor = NVSColors.hologramBlue;
      } else {
        beamColor = NVSColors.plasmaGreen;
      }

      final Paint paint = Paint()
        ..color = beamColor.withOpacity(alpha * 0.8)
        ..style = PaintingStyle.fill;

      // Draw vertical beam
      canvas.drawRect(
        Rect.fromLTWH(
          beamX - beamWidth / 2,
          centerY - maxBeamHeight / 2,
          beamWidth,
          maxBeamHeight,
        ),
        paint,
      );

      // Add glow effect
      paint.color = beamColor.withOpacity(alpha * 0.3);
      canvas.drawRect(
        Rect.fromLTWH(
          beamX - beamWidth,
          centerY - maxBeamHeight / 2,
          beamWidth * 2,
          maxBeamHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
