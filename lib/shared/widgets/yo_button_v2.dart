import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/services/chimera_core.dart';
import 'package:nvs/services/haptic_service.dart';

class YoButtonV2 extends StatefulWidget {
  const YoButtonV2({
    super.key,
    this.onTap,
    this.size = 60.0,
  });
  final VoidCallback? onTap;
  final double size;

  @override
  State<YoButtonV2> createState() => _YoButtonV2State();
}

class _YoButtonV2State extends State<YoButtonV2> with TickerProviderStateMixin {
  late AnimationController _shockwaveController;
  late AnimationController _scaleController;
  late Animation<double> _shockwaveAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Shockwave animation controller
    _shockwaveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Shockwave animation - expands outward and fades
    _shockwaveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _shockwaveController,
        curve: Curves.easeOut,
      ),
    );

    // Scale animation - button press effect
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _shockwaveController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    // Trigger visual animations
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    _shockwaveController.forward().then((_) {
      _shockwaveController.reset();
    });

    // Trigger multi-sensory feedback
    ChimeraCore().haptics.trigger(NvsHaptic.yo);
    ChimeraCore().audio.playYoSound();

    // Call the provided callback
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable?>[_shockwaveAnimation, _scaleAnimation]),
        builder: (BuildContext context, Widget? child) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Shockwave effect
              if (_shockwaveAnimation.value > 0)
                Container(
                  width: widget.size * 3 * _shockwaveAnimation.value,
                  height: widget.size * 3 * _shockwaveAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: NVSColors.primaryNeonMint.withValues(
                        alpha: (1.0 - _shockwaveAnimation.value) * 0.8,
                      ),
                      width: 2.0,
                    ),
                  ),
                ),

              // Main button
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        NVSColors.primaryNeonMint,
                        NVSColors.primaryNeonMint.withValues(alpha: 0.8),
                      ],
                      stops: const <double>[0.0, 1.0],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.primaryNeonMint.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'YO',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: NVSColors.pureBlack,
                            fontSize: 20,
                            letterSpacing: 2,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
