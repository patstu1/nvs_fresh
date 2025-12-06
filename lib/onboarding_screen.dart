import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({super.key, this.onComplete});
  final VoidCallback? onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // Onboarding phases
  int _currentPhase = 0; // 0: Scanner, 1: Blurry Names, 2: Netflix-style NVS

  // Scanner animations
  late AnimationController _scannerController;
  double scannerY = 0.0;
  bool glitch = false;

  // Names wall animations
  late AnimationController _namesController;
  late Animation<double> _blurAnimation;

  // Netflix-style logo animations
  late AnimationController _logoController;
  late AnimationController _beamsController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  final List<String> names = <String>[
    'Alex',
    'Jordan',
    'Casey',
    'Riley',
    'Morgan',
    'Avery',
    'Quinn',
    'Sage',
    'River',
    'Phoenix',
    'Rowan',
    'Blake',
    'Cameron',
    'Dylan',
    'Jamie',
    'Parker',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startOnboardingSequence();
  }

  void _initializeAnimations() {
    // Scanner phase animations
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerController.addListener(() {
      setState(() {
        scannerY = _scannerController.value;
        if ((scannerY - 0.5).abs() < 0.03) {
          glitch = true;
        } else {
          glitch = false;
        }
      });
    });

    // Names wall phase animations
    _namesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _namesController, curve: Curves.easeInOut),
    );

    // Netflix-style logo animations
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _beamsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
  }

  Future<void> _startOnboardingSequence() async {
    // Phase 1: Scanner (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() => _currentPhase = 1);

      // Phase 2: Blurry names wall (3 seconds)
      _namesController.forward();
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() => _currentPhase = 2);

        // Phase 3: Netflix-style NVS logo
        _logoController.forward();
        _beamsController.forward();

        await Future.delayed(const Duration(seconds: 4));

        // Complete onboarding
        if (mounted && widget.onComplete != null) {
          widget.onComplete!();
        }
      }
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _namesController.dispose();
    _logoController.dispose();
    _beamsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildCurrentPhase(),
    );
  }

  Widget _buildCurrentPhase() {
    switch (_currentPhase) {
      case 0:
        return _buildScannerPhase();
      case 1:
        return _buildNamesWallPhase();
      case 2:
        return _buildNetflixLogoPhase();
      default:
        return _buildScannerPhase();
    }
  }

  Widget _buildScannerPhase() {
    const Color neonMint = Color(0xFF00FFD0);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        // Scanner bar
        Positioned(
          top: scannerY * (screenHeight - 100),
          left: 0,
          right: 0,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: neonMint.withValues(alpha: 0.7),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: neonMint,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),
        // NVS text
        Center(
          child: Animate(
            effects: glitch
                ? <Effect>[ShakeEffect(duration: 120.ms), BlurEffect(duration: 120.ms)]
                : <Effect>[],
            child: Text(
              'Meatup',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 64,
                color: neonMint,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                shadows: <Shadow>[
                  Shadow(
                    color: neonMint,
                    blurRadius: glitch ? 40 : 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNamesWallPhase() {
    return AnimatedBuilder(
      animation: _blurAnimation,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[
              Colors.black.withValues(alpha: 0.3),
              Colors.black,
            ],
            stops: <double>const <double>[0.3, 1.0],
          ),
        ),
        child: GridView.builder(
          itemCount: names.length * 6, // Repeat names to fill screen
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            final String name = names[index % names.length];
            return Center(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 16,
                  color: const Color(0xFF00FFD0).withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: (index * 50) % 1000),
                    duration: 500.ms,
                  ),
            );
          },
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return ImageFiltered(
          imageFilter: ui.ImageFilter.blur(
            sigmaX: _blurAnimation.value,
            sigmaY: _blurAnimation.value,
          ),
          child: child,
        );
      },
    );
  }

  Widget _buildNetflixLogoPhase() {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[_logoController, _beamsController]),
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: <Widget>[
            // Light beams radiating from center
            ...List.generate(12, (int index) {
              final double angle = (index * 30.0) * (math.pi / 180);
              return Positioned.fill(
                child: Transform.rotate(
                  angle: angle,
                  child: Align(
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        -200 * _beamsController.value,
                      ),
                      child: Container(
                        width: 4,
                        height: 400 * _beamsController.value,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              const Color(0xFF00FFD0).withValues(alpha: 0.8),
                              const Color(0xFF00FFD0).withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            // Central NVS logo
            Center(
              child: Transform.scale(
                scale: _logoScale.value,
                child: Opacity(
                  opacity: _logoOpacity.value,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFF00FFD0).withValues(alpha: 0.5),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Meatup',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontSize: 80,
                        color: Color(0xFF00FFD0),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 12,
                        shadows: <Shadow>[
                          Shadow(
                            color: Color(0xFF00FFD0),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
