// lib/features/now/presentation/pages/now_view.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

enum NowViewState {
  GlobeIntro,
  Zooming,
  MapActive,
}

class NowView extends StatefulWidget {
  const NowView({super.key});

  @override
  State<NowView> createState() => _NowViewState();
}

class _NowViewState extends State<NowView> with TickerProviderStateMixin {
  late AnimationController _introController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  NowViewState _currentState = NowViewState.GlobeIntro;

  @override
  void initState() {
    super.initState();

    _introController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();
    _pulseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    // Sequence:
    // 1. Show globe for 2 seconds.
    // 2. Animate camera zoom for 2 seconds.
    // 3. Switch to map view.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _currentState = NowViewState.Zooming);
        _introController.forward().whenComplete(() {
          setState(() => _currentState = NowViewState.MapActive);
        });
      }
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      // We will build a new, minimal, holographic AppBar later.
      appBar: AppBar(
        backgroundColor: NVSColors.pureBlack,
        title: Text(
          'N O W',
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 20,
            color: NVSColors.secondaryText,
            letterSpacing: 4,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child: _buildCurrentStateView(),
      ),
    );
  }

  Widget _buildCurrentStateView() {
    switch (_currentState) {
      case NowViewState.GlobeIntro:
      case NowViewState.Zooming:
        return _buildGlobeView();
      case NowViewState.MapActive:
        return _buildDataScapeMap(); // This is where our Mapbox implementation will live
    }
  }

  Widget _buildGlobeView() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            NVSColors.cardBackground.withValues(alpha: 0.3),
            NVSColors.pureBlack,
            NVSColors.pureBlack,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(
              [_introController, _rotationController, _pulseController]),
          builder: (context, child) {
            // Animate scale to create a "zoom" effect
            final scale = 0.3 + (_introController.value * 0.7);
            final pulseScale = 1.0 + (_pulseController.value * 0.1);

            return Transform.scale(
              scale: scale * pulseScale,
              child: Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: _buildAnimatedGlobe(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedGlobe() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.8,
          colors: [
            NVSColors.ultraLightMint.withValues(alpha: 0.8),
            NVSColors.turquoiseNeon.withValues(alpha: 0.6),
            NVSColors.cardBackground.withValues(alpha: 0.4),
            NVSColors.pureBlack.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: NVSColors.turquoiseNeon.withValues(alpha: 0.3),
            blurRadius: 50,
            spreadRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid lines for wireframe effect
          ..._buildGridLines(),

          // Pulsing dots for data points
          ..._buildDataPoints(),

          // Center glow
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    NVSColors.avocadoGreen.withValues(alpha: 0.8),
                    NVSColors.avocadoGreen.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGridLines() {
    return [
      // Horizontal lines
      for (int i = 0; i < 5; i++)
        Positioned(
          top: 20 + (i * 40.0),
          left: 20,
          right: 20,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  NVSColors.ultraLightMint.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

      // Vertical curved lines
      for (int i = 0; i < 4; i++)
        Positioned(
          left: 30 + (i * 35.0),
          top: 20,
          bottom: 20,
          child: Container(
            width: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  NVSColors.ultraLightMint.withValues(alpha: 0.3),
                  NVSColors.ultraLightMint.withValues(alpha: 0.5),
                  NVSColors.ultraLightMint.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
    ];
  }

  List<Widget> _buildDataPoints() {
    final points = [
      const Offset(0.3, 0.2),
      const Offset(0.7, 0.3),
      const Offset(0.2, 0.6),
      const Offset(0.8, 0.7),
      const Offset(0.5, 0.8),
      const Offset(0.6, 0.4),
    ];

    return points.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;

      return AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final delay = index * 0.2;
          final adjustedValue = (_pulseController.value + delay) % 1.0;
          final opacity = 0.4 + (math.sin(adjustedValue * 2 * math.pi) * 0.6);

          return Positioned(
            left: point.dx * 160 + 20,
            top: point.dy * 160 + 20,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: NVSColors.avocadoGreen.withValues(alpha: opacity),
                boxShadow: [
                  BoxShadow(
                    color:
                        NVSColors.avocadoGreen.withValues(alpha: opacity * 0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildDataScapeMap() {
    // Our primary task is still here.
    // TODO: Implement Mapbox GL widget here.
    // TODO: Add PresenceMarker widgets to the map layer.
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            NVSColors.pureBlack,
            NVSColors.cardBackground.withValues(alpha: 0.3),
            NVSColors.pureBlack,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: NVSColors.avocadoGreen,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'DATA-SCAPE ACTIVE',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: NVSColors.avocadoGreen,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: NVSColors.turquoiseNeon.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: NVSColors.turquoiseNeon.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: NVSColors.turquoiseNeon,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Placeholder for map implementation
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: NVSColors.cardBackground.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: NVSColors.mintGlow,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        color: NVSColors.ultraLightMint.withValues(alpha: 0.6),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '[DATA-SCAPE RENDERED]',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: NVSColors.ultraLightMint,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Real-time proximity mapping',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 12,
                          color: NVSColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Switch back to globe view
                        setState(() => _currentState = NowViewState.GlobeIntro);
                        _introController.reset();
                      },
                      icon: Icon(Icons.public, size: 18),
                      label: const Text('GLOBE VIEW'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NVSColors.avocadoGreen,
                        foregroundColor: NVSColors.pureBlack,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Location scan initiated...'),
                            backgroundColor: NVSColors.turquoiseNeon,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: Icon(Icons.location_on, size: 18),
                      label: const Text('SCAN'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: NVSColors.turquoiseNeon,
                        side: BorderSide(color: NVSColors.turquoiseNeon),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
