import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

/// Earth Now Intro screen for the onboarding sequence
/// Shows the transition from code wall to the main app
class EarthNowIntro extends StatefulWidget {

  const EarthNowIntro({super.key, this.onComplete});
  final VoidCallback? onComplete;

  @override
  State<EarthNowIntro> createState() => _EarthNowIntroState();
}

class _EarthNowIntroState extends State<EarthNowIntro>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 3000));
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: Stack(
        children: <Widget>[
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.0,
                colors: <Color>[
                  NVSColors.neonMint.withValues(alpha: 0.1),
                  NVSColors.pureBlack,
                ],
              ),
            ),
          ),

          // Main content
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge(<Listenable?>[_fadeAnimation, _scaleAnimation]),
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Location icon
                        Icon(
                          Icons.location_on,
                          size: 120,
                          color: NVSColors.neonMint,
                        ),

                        SizedBox(height: 40),

                        // Title
                        Text(
                          'LIVE MAP',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: NVSColors.neonMint,
                            letterSpacing: 4,
                          ),
                        ),

                        SizedBox(height: 20),

                        // Subtitle
                        Text(
                          'Initializing location services...',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 16,
                            color: NVSColors.secondaryText,
                            letterSpacing: 1,
                          ),
                        ),

                        SizedBox(height: 60),

                        // Loading indicator
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            color: NVSColors.neonMint,
                            strokeWidth: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
