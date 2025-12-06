// lib/core/widgets/quantum_enhanced_scaffold.dart
// Enterprise-Grade Quantum Scaffold with Bio-Responsive Glow Engine
// Replaces basic Scaffold with performance-optimized, visually stunning container

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/quantum_design_tokens.dart';
import '../providers/quantum_providers.dart';
import 'quantum_glow_engine.dart';
import 'quantum_neural_visualization.dart';

/// Enterprise-grade scaffold with quantum glow effects and bio-responsiveness
/// Use this instead of regular Scaffold for all major app screens
class QuantumEnhancedScaffold extends ConsumerStatefulWidget {
  const QuantumEnhancedScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.enableGlowEngine = true,
    this.enableNeuralBackground = true,
    this.glowIntensity = 1.0,
    this.bioResponsive = true,
    this.performanceMode = PerformanceMode.balanced,
    this.quantumEffects = const QuantumEffectConfig(),
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool enableGlowEngine;
  final bool enableNeuralBackground;
  final double glowIntensity;
  final bool bioResponsive;
  final PerformanceMode performanceMode;
  final QuantumEffectConfig quantumEffects;

  @override
  ConsumerState<QuantumEnhancedScaffold> createState() =>
      _QuantumEnhancedScaffoldState();
}

class _QuantumEnhancedScaffoldState
    extends ConsumerState<QuantumEnhancedScaffold>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _breathController;
  late AnimationController _heartbeatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _breathAnimation;
  late Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Bio-synchronized animations
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _breathController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _breathAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _heartbeatAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _heartbeatController, curve: Curves.elasticOut),
    );

    // Start bio-responsive animations
    if (widget.bioResponsive) {
      _startBioSyncedAnimations();
    }
  }

  void _startBioSyncedAnimations() {
    _pulseController.repeat(reverse: true);
    _breathController.repeat(reverse: true);

    // Simulate heartbeat pattern
    _simulateHeartbeat();
  }

  void _simulateHeartbeat() {
    Timer.periodic(const Duration(milliseconds: 1200), (Timer timer) {
      if (mounted && widget.bioResponsive) {
        _heartbeatController.forward().then((_) {
          _heartbeatController.reset();
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathController.dispose();
    _heartbeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final biometricState = ref.watch(biometricStateProvider);
    final performanceConfig = ref.watch(performanceConfigProvider);

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? QuantumDesignTokens.pureBlack,
      appBar: widget.appBar != null ? _buildQuantumAppBar() : null,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      floatingActionButton: widget.floatingActionButton != null
          ? _buildQuantumFAB()
          : null,
      bottomNavigationBar: widget.bottomNavigationBar,
      body: Stack(
        children: <Widget>[
          // Neural background visualization
          if (widget.enableNeuralBackground)
            Positioned.fill(
              child: QuantumNeuralVisualization(
                intensity: widget.glowIntensity,
                bioState: biometricState,
                performanceMode: widget.performanceMode,
              ),
            ),

          // Quantum glow engine overlay
          if (widget.enableGlowEngine)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge(<Listenable?>[
                  _pulseAnimation,
                  _breathAnimation,
                  _heartbeatAnimation,
                ]),
                builder: (BuildContext context, Widget? child) {
                  return QuantumGlowEngine(
                    intensity: widget.glowIntensity *
                        _pulseAnimation.value *
                        _breathAnimation.value,
                    heartbeatScale: _heartbeatAnimation.value,
                    config: widget.quantumEffects,
                    bioState: biometricState,
                  );
                },
              ),
            ),

          // Main content with bio-responsive scaling
          if (widget.body != null)
            AnimatedBuilder(
              animation: _breathAnimation,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: widget.bioResponsive ? _breathAnimation.value : 1.0,
                  child: widget.body,
                );
              },
            ),

          // Performance monitoring overlay (debug only)
          if (performanceConfig.showDebugOverlay && kDebugMode)
            Positioned(
              top: 50,
              right: 16,
              child: _buildPerformanceOverlay(),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildQuantumAppBar() {
    return PreferredSize(
      preferredSize: widget.appBar!.preferredSize,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (BuildContext context, Widget? child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: QuantumDesignTokens.neonMint
                      .withValues(alpha: 0.3 * _pulseAnimation.value),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: widget.appBar,
          );
        },
      ),
    );
  }

  Widget _buildQuantumFAB() {
    return AnimatedBuilder(
      animation: _heartbeatAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: _heartbeatAnimation.value,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: QuantumDesignTokens.turquoiseNeon
                      .withValues(alpha: 0.6 * _heartbeatAnimation.value),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: widget.floatingActionButton,
          ),
        );
      },
    );
  }

  Widget _buildPerformanceOverlay() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: QuantumDesignTokens.pureBlack.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: QuantumDesignTokens.neonMint.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'QUANTUM ENGINE',
            style: TextStyle(
              color: QuantumDesignTokens.neonMint,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: QuantumDesignTokens.fontMono,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Glow: ${(widget.glowIntensity * 100).toInt()}%',
            style: TextStyle(
              color: QuantumDesignTokens.textSecondary,
              fontSize: 8,
              fontFamily: QuantumDesignTokens.fontMono,
            ),
          ),
          Text(
            'Bio: ${widget.bioResponsive ? "SYNC" : "OFF"}',
            style: TextStyle(
              color: widget.bioResponsive
                  ? QuantumDesignTokens.success
                  : QuantumDesignTokens.textDisabled,
              fontSize: 8,
              fontFamily: QuantumDesignTokens.fontMono,
            ),
          ),
          Text(
            'Mode: ${widget.performanceMode.name.toUpperCase()}',
            style: TextStyle(
              color: QuantumDesignTokens.textSecondary,
              fontSize: 8,
              fontFamily: QuantumDesignTokens.fontMono,
            ),
          ),
        ],
      ),
    );
  }
}

/// Performance modes for quantum effects
enum PerformanceMode {
  maximum, // Full effects, no compromises
  balanced, // Optimal balance of performance and visuals
  battery, // Reduced effects for battery savings
  minimal, // Essential effects only
}

/// Configuration for quantum visual effects
class QuantumEffectConfig {
  const QuantumEffectConfig({
    this.enableParticles = true,
    this.enableRipples = true,
    this.enableHolographic = true,
    this.enableBioSync = true,
    this.particleCount = 50,
    this.rippleIntensity = 1.0,
    this.holographicOpacity = 0.3,
    this.bioSyncSensitivity = 1.0,
  });

  final bool enableParticles;
  final bool enableRipples;
  final bool enableHolographic;
  final bool enableBioSync;
  final int particleCount;
  final double rippleIntensity;
  final double holographicOpacity;
  final double bioSyncSensitivity;
}

/// Quantum-enhanced app bar for consistency
class QuantumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuantumAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = true,
    this.enableGlow = true,
  });

  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final bool enableGlow;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? DefaultTextStyle(
              style: TextStyle(
                color: QuantumDesignTokens.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: QuantumDesignTokens.fontPrimary,
                shadows: enableGlow
                    ? QuantumDesignTokens.textGlowMedium
                    : null,
              ),
              child: title!,
            )
          : null,
      actions: actions,
      leading: leading,
      backgroundColor:
          backgroundColor ?? QuantumDesignTokens.pureBlack.withValues(alpha: 0.95),
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}

// Import statements for missing dependencies
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
