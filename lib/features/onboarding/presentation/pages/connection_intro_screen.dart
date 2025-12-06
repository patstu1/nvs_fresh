import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/features/onboarding/presentation/pages/code_wall_screen.dart';

class ConnectionIntroScreen extends ConsumerStatefulWidget {
  const ConnectionIntroScreen({required this.onComplete, super.key});
  final VoidCallback onComplete;

  @override
  ConsumerState<ConnectionIntroScreen> createState() => _ConnectionIntroScreenState();
}

class _ConnectionIntroScreenState extends ConsumerState<ConnectionIntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanlineController;
  late Animation<double> _scanlineAnimation;

  @override
  void initState() {
    super.initState();

    _scanlineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanlineAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _scanlineController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    _scanlineController.forward();
    await Future.delayed(const Duration(seconds: 2));
    _navigateToNext();
  }

  void _navigateToNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
            CodeWallScreen(onComplete: widget.onComplete),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _scanlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.background,
      body: Stack(
        children: <Widget>[
          // Glowing horizontal scanline effect
          Center(
            child: AnimatedBuilder(
              animation: _scanlineAnimation,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  width: 300,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.transparent,
                        NVSColors.ultraLightNeonMint.withValues(alpha: 0.8),
                        NVSColors.ultraLightNeonMint,
                        NVSColors.ultraLightNeonMint.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.ultraLightNeonMint.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Main content
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // NVS text
                Text(
                  'NVS',
                  style: TextStyle(
                    color: NVSColors.ultraLightNeonMint,
                    fontSize: 48,
                    fontFamily: 'FFMagdaClean',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Connection protocol text
                Text(
                  '//: CONNECTION PROTOCOL INITIATED...',
                  style: TextStyle(
                    color: NVSColors.ultraLightNeonMint,
                    fontSize: 16,
                    fontFamily: 'FFMagdaClean',
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
