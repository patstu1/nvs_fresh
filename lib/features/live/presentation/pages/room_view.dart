// lib/features/live/presentation/pages/room_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/models/app_types.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';
import '../../../../core/providers/quantum_providers.dart';
// LivingEye removed

/// LIVE room view for video calls and multi-user interactions
/// Enterprise-grade video rooms with cyberpunk styling
class RoomView extends ConsumerStatefulWidget {
  const RoomView({
    required this.roomId,
    super.key,
  });

  final String roomId;

  @override
  ConsumerState<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends ConsumerState<RoomView> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _eyeController;
  late AnimationController _watchingController;
  late Animation<double> _glowAnimation;
  late Animation<double> _eyeAnimation;
  late Animation<double> _watchingAnimation;

  // Room state for the living eye
  double _roomEnergy = 0.5;
  Offset _pointerPosition = const Offset(0.5, 0.5);
  final Color _irisColor = QuantumDesignTokens.neonMint;
  final double _chatVolume = 0.3;
  final int _participantCount = 1;

  @override
  void initState() {
    super.initState();
    _initializeWatchingEyeAnimations();
    _initializeRoom();
  }

  /// Initialize the watching eye animations for the living interface
  void _initializeWatchingEyeAnimations() {
    // Glow controller for quantum effects
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Eye blinking animation
    _eyeController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _eyeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _eyeController, curve: Curves.easeInOutSine),
    );

    // Watching/tracking animation
    _watchingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _watchingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _watchingController, curve: Curves.easeInOut),
    );

    // Start the living eye activities
    _glowController.repeat(reverse: true);
    _eyeController.repeat(reverse: true);
    _watchingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _eyeController.dispose();
    _watchingController.dispose();
    super.dispose();
  }

  Future<void> _initializeRoom() async {
    // Initialize room connection
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue performanceMetrics = ref.watch(performanceMetricsProvider);
    final bool shouldEnableGlow = ref.watch(shouldEnableGlowEffectsProvider);
    final BioResponsiveThemeData? bioThemeData = ref.watch(bioResponsiveThemeProvider);

    return Scaffold(
      backgroundColor: QuantumDesignTokens.pureBlack,
      body: Stack(
        children: <Widget>[
          // Background placeholder
          const SizedBox.shrink(),

          // Main room interface overlay with eye tracking
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                _pointerPosition = Offset(
                  details.localPosition.dx / MediaQuery.of(context).size.width,
                  details.localPosition.dy / MediaQuery.of(context).size.height,
                );
                // Increase room energy based on interaction
                _roomEnergy = (_roomEnergy + 0.1).clamp(0.0, 1.0);
              });
            },
            onTap: () {
              setState(() {
                _roomEnergy = (_roomEnergy + 0.2).clamp(0.0, 1.0);
              });
            },
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  Expanded(
                    child: _buildVideoGrid(),
                  ),
                  _buildControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: QuantumDesignTokens.primaryNeonMint.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: QuantumDesignTokens.darkBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: QuantumDesignTokens.primaryNeonMint.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.close,
                color: QuantumDesignTokens.primaryNeonMint,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'LIVE ROOM ${widget.roomId.toUpperCase()}',
              style: const TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: QuantumDesignTokens.ultraLightMint,
                letterSpacing: 1.5,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: QuantumDesignTokens.primaryNeonMint,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: QuantumDesignTokens.primaryNeonMint.withValues(
                        alpha: _glowAnimation.value * 0.8,
                      ),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          const Text(
            'LIVE',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: QuantumDesignTokens.primaryNeonMint,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGrid() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: QuantumDesignTokens.darkBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: QuantumDesignTokens.primaryNeonMint.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.videocam_rounded,
              size: 80,
              color: QuantumDesignTokens.secondaryText,
            ),
            SizedBox(height: 20),
            Text(
              'VIDEO FEED INITIALIZING',
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: QuantumDesignTokens.secondaryText,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Neural-Sync Video Streaming Active',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 12,
                color: QuantumDesignTokens.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: QuantumDesignTokens.primaryNeonMint.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildControlButton(
            Icons.mic_rounded,
            'MIC',
            true,
            () {
              // Toggle microphone
            },
          ),
          _buildControlButton(
            Icons.videocam_rounded,
            'CAM',
            true,
            () {
              // Toggle camera
            },
          ),
          _buildControlButton(
            Icons.screen_share_rounded,
            'SHARE',
            false,
            () {
              // Toggle screen share
            },
          ),
          _buildControlButton(
            Icons.call_end_rounded,
            'END',
            false,
            () {
              Navigator.of(context).pop();
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final Color buttonColor = isDestructive
        ? const Color(0xFFFF4444)
        : isActive
            ? QuantumDesignTokens.primaryNeonMint
            : QuantumDesignTokens.secondaryText;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive || isDestructive
                  ? buttonColor.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: buttonColor,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 24,
              color: buttonColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: buttonColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
