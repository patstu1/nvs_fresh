import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/navigation/main_navigation_page.dart';

class GenesisSequence extends StatefulWidget {
  const GenesisSequence({super.key});

  @override
  State<GenesisSequence> createState() => _GenesisSequenceState();
}

class _GenesisSequenceState extends State<GenesisSequence> with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _glitchController;
  late AnimationController _textController;
  late AnimationController _fadeController;

  late Animation<double> _scanAnimation;
  late Animation<double> _glitchAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _fadeAnimation;

  bool _showLogo = false;
  bool _showText = false;
  bool _showConnectionProtocol = false;
  final int _currentStep = 0;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startGenesisSequence();
  }

  void _setupAnimations() {
    // Scan line animation
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: -0.1, end: 1.1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    // Glitch effect animation
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _glitchAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glitchController, curve: Curves.easeInOut),
    );

    // Text typing animation
    _textController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Fade transitions
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _startGenesisSequence() {
    // Step 1: The Threshold - Scan line and logo reveal
    _scanController.forward();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _showLogo = true);
        HapticFeedback.mediumImpact();
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showText = true);
        _textController.forward();
        _glitchController.repeat(reverse: true);
      }
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _showConnectionProtocol = true);
        HapticFeedback.heavyImpact();
      }
    });

    // Transition to next step
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        _fadeController.forward().then((_) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) =>
                  const ValuePropositionTriptych(),
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _glitchController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.matteBlack,
      body: GestureDetector(
        onTap: () {
          // User must tap to proceed - intentional discovery action
          if (_showConnectionProtocol) {
            _fadeController.forward().then((_) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) =>
                      const ValuePropositionTriptych(),
                  transitionsBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 800),
                ),
              );
            });
          }
        },
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[
            _scanController,
            _glitchController,
            _textController,
            _fadeController,
          ]),
          builder: (BuildContext context, Widget? child) {
            final double scanY = _scanAnimation.value;
            final bool isPassing = scanY > 0.45 && scanY < 0.55;

            return ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    NVSColors.turquoiseNeon.withValues(alpha: 0.2),
                    NVSColors.ultraLightNeonMint.withValues(alpha: 0.8),
                    NVSColors.turquoiseNeon.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: <double>[
                    scanY - 0.02,
                    scanY,
                    scanY + 0.01,
                    scanY + 0.02,
                    scanY + 0.04,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // NVS Logo with glitch effect
                  if (_showLogo)
                    Opacity(
                      opacity: isPassing ? 1.0 : 0.0,
                      child: Transform.translate(
                        offset: Offset(
                          (_random.nextDouble() - 0.5) * 20 * _glitchAnimation.value,
                          (_random.nextDouble() - 0.5) * 5 * _glitchAnimation.value,
                        ),
                        child: _buildNVSLogo(),
                      ),
                    ),

                  // Connection Protocol Text
                  if (_showConnectionProtocol)
                    Positioned(
                      bottom: 100,
                      child: AnimatedOpacity(
                        opacity: _textAnimation.value,
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          '//: CONNECTION PROTOCOL INITIATED...',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14,
                            color: NVSColors.oliveGreenNeon.withValues(alpha: 0.8),
                            letterSpacing: 2,
                            shadows: <Shadow>[
                              Shadow(
                                color: NVSColors.oliveGreenNeon.withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Tap to proceed hint
                  if (_showConnectionProtocol)
                    Positioned(
                      bottom: 40,
                      child: AnimatedOpacity(
                        opacity: _textAnimation.value,
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          'TAP TO PROCEED',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: NVSColors.turquoiseNeon.withValues(alpha: 0.6),
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNVSLogo() {
    return Text(
      'NVS',
      style: TextStyle(
        fontFamily: 'MagdaClean',
        fontWeight: FontWeight.w100,
        fontSize: 120,
        color: NVSColors.ultraLightNeonMint,
        letterSpacing: 15,
        shadows: <Shadow>[
          const Shadow(
            blurRadius: 3.0,
            color: NVSColors.turquoiseNeon,
          ),
          Shadow(
            blurRadius: 12.0,
            color: NVSColors.turquoiseNeon.withValues(alpha: 0.8),
          ),
          Shadow(
            blurRadius: 30.0,
            color: NVSColors.turquoiseNeon.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

class ValuePropositionTriptych extends StatefulWidget {
  const ValuePropositionTriptych({super.key});

  @override
  State<ValuePropositionTriptych> createState() => _ValuePropositionTriptychState();
}

class _ValuePropositionTriptychState extends State<ValuePropositionTriptych>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  int _currentSlide = 0;

  final List<Map<String, dynamic>> _slides = <Map<String, dynamic>>[
    <String, dynamic>{
      'title': 'WHERE YOU ARE THE VIEW',
      'subtitle': 'Envy Us',
      'visual': 'assets/images/artistic_figure.jpg',
      'color': NVSColors.ultraLightNeonMint,
    },
    <String, dynamic>{
      'title': 'YOUR DESIRES, DECODED',
      'subtitle': 'Neuro-Visual Sync',
      'visual': 'assets/images/neural_network.jpg',
      'color': NVSColors.turquoiseNeon,
    },
    <String, dynamic>{
      'title': 'FREEDOM IS THE ULTIMATE TURN-ON',
      'subtitle': 'No Vanilla Shit',
      'visual': 'assets/images/stylized_icon.jpg',
      'color': NVSColors.oliveGreenNeon,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (mounted && _currentSlide < _slides.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
        _proceedToNextStep();
      }
    });
  }

  void _proceedToNextStep() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                const IdentityForgery(),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.matteBlack,
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() => _currentSlide = index);
        },
        itemCount: _slides.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> slide = _slides[index];
          return _buildSlide(slide, index);
        },
      ),
    );
  }

  Widget _buildSlide(Map<String, dynamic> slide, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            NVSColors.matteBlack,
            slide['color'].withValues(alpha: 0.1),
            NVSColors.matteBlack,
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          // Background visual (placeholder for now)
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    slide['color'].withValues(alpha: 0.3),
                    slide['color'].withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  slide['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'MagdaClean',
                    color: slide['color'],
                    letterSpacing: 4,
                    shadows: <Shadow>[
                      Shadow(
                        color: slide['color'].withValues(alpha: 0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  slide['subtitle'],
                  style: TextStyle(
                    fontSize: 16,
                    color: slide['color'].withValues(alpha: 0.7),
                    letterSpacing: 2,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          // Progress indicator
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (int i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == index ? slide['color'] : slide['color'].withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class IdentityForgery extends StatefulWidget {
  const IdentityForgery({super.key});

  @override
  State<IdentityForgery> createState() => _IdentityForgeryState();
}

class _IdentityForgeryState extends State<IdentityForgery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.matteBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'IDENTITY FORGERY',
              style: TextStyle(
                fontSize: 24,
                color: NVSColors.ultraLightNeonMint,
                fontFamily: 'MagdaClean',
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Your Signal',
              style: TextStyle(
                fontSize: 16,
                color: NVSColors.turquoiseNeon,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) =>
                        const TheImmersion(),
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 800),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NVSColors.turquoiseNeon,
                foregroundColor: NVSColors.matteBlack,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}

class TheImmersion extends StatefulWidget {
  const TheImmersion({super.key});

  @override
  State<TheImmersion> createState() => _TheImmersionState();
}

class _TheImmersionState extends State<TheImmersion> {
  @override
  void initState() {
    super.initState();
    _proceedToMainApp();
  }

  void _proceedToMainApp() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                const MainNavigationPage(),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.matteBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'WELCOME TO THE NETWORK',
              style: TextStyle(
                fontSize: 28,
                color: NVSColors.ultraLightNeonMint,
                fontFamily: 'MagdaClean',
                letterSpacing: 4,
                shadows: <Shadow>[
                  Shadow(
                    color: NVSColors.turquoiseNeon.withValues(alpha: 0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "You're not just signed up. You're plugged in.",
              style: TextStyle(
                fontSize: 16,
                color: NVSColors.turquoiseNeon.withValues(alpha: 0.8),
                fontFamily: 'monospace',
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
