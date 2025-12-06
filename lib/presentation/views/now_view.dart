import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/spinning_earth_widget.dart';
import '../widgets/now_hud.dart';

/// Main Now view that shows the spinning earth with real-time activity
class NowView extends StatefulWidget {
  const NowView({super.key});

  @override
  State<NowView> createState() => _NowViewState();
}

class _NowViewState extends State<NowView> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Stack(
          children: [
            // Background stars effect
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  colors: [
                    Color(0xFF001a1a),
                    Colors.black,
                  ],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
            
            // Main content
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Text(
                          'NOW',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: NVSColors.neonMint,
                            shadows: [
                              Shadow(
                                color: NVSColors.neonMint.withValues(alpha: 0.8),
                                blurRadius: 20,
                              ),
                              Shadow(
                                color: NVSColors.neonMint.withValues(alpha: 0.4),
                                blurRadius: 40,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Spinning Earth
                Expanded(
                  child: Center(
                    child: SpinningEarthWidget(),
                  ),
                ),

                // HUD overlay
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: NowHud(
                    onRecenter: () {},
                    isBroadcasting: false,
                    onToggleBroadcast: (value) {},
                    onOpenNexus: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Alternative widget name for compatibility
class NowViewWidget extends StatelessWidget {
  const NowViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NowView();
  }
}
