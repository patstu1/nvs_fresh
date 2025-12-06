import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';

/// Universal Messenger for NVS
/// Uses BellGothic and MagdaCleanMono fonts [[memory:4642926]]
class UniversalMessengerView extends ConsumerStatefulWidget {
  const UniversalMessengerView({super.key});

  @override
  ConsumerState<UniversalMessengerView> createState() =>
      _UniversalMessengerViewState();
}

class _UniversalMessengerViewState extends ConsumerState<UniversalMessengerView>
    with TickerProviderStateMixin {
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
        child: Column(
          children: <Widget>[
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Text(
                      'MESSAGES',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: NVSColors.neonMint,
                        letterSpacing: 4,
                        shadows: <Shadow>[
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

            // Content
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: NVSColors.cardBackground.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: NVSColors.neonMint.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.neonMint.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.chat,
                        color: NVSColors.neonMint,
                        size: 80,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Universal Messenger',
                        style: TextStyle(
                          fontFamily: 'BellGothic',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: NVSColors.ultraLightMint,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Connect through meaningful\nconversations',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 16,
                          color: NVSColors.secondaryText,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Your connections from Connect will appear here',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 14,
                          color: NVSColors.neonMint,
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}