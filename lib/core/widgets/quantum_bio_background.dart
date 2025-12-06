// lib/core/widgets/quantum_bio_background.dart
// Bio-Responsive Background Widget with GLSL Quantum Shaders
// Creates living, breathing backgrounds that respond to biometric data

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/services/quantum_biometric_service.dart';

import '../providers/quantum_providers.dart' hide quantumShaderServiceProvider;
import '../theme/quantum_design_tokens.dart';

/// Bio-responsive background that pulses with heart rate and responds to biometrics
class QuantumBioBackground extends ConsumerStatefulWidget {
  const QuantumBioBackground({
    required this.child,
    super.key,
    this.intensity = 1.0,
    this.enableShaderEffects = true,
    this.baseColor,
    this.pulseColor,
  });
  final Widget child;
  final double intensity;
  final bool enableShaderEffects;
  final Color? baseColor;
  final Color? pulseColor;

  @override
  ConsumerState<QuantumBioBackground> createState() => _QuantumBioBackgroundState();
}

class _QuantumBioBackgroundState extends ConsumerState<QuantumBioBackground>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _breathingController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Heart rate pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000), // Default 60 BPM
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Breathing rhythm animation (slower, more organic)
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 4000), // 4 second breathing cycle
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  void _updateHeartRateAnimation(double heartRate) {
    final double bpm = heartRate.clamp(30.0, 200.0);
    final Duration duration = Duration(milliseconds: (60000 / bpm).round());

    if (_pulseController.duration != duration) {
      _pulseController.duration = duration;
      if (_pulseController.isAnimating) {
        _pulseController.repeat();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<BiometricReading?> biometricReading =
        ref.watch(currentBiometricReadingProvider);
    final shaderService = ref.watch(quantumShaderServiceProvider);
    final AsyncValue<dynamic> performanceMetrics = ref.watch(performanceMetricsProvider);
    final bool shouldEnableEffects = ref.watch(shouldEnableGlowEffectsProvider);

    // Update shader service with current biometric data
    biometricReading.whenData((BiometricReading? reading) {
      if (reading != null) {
        _updateHeartRateAnimation(reading.heartRate.toDouble());

        shaderService.updateBiometricData(
          heartRate: reading.heartRate.toDouble(),
          arousalLevel: reading.arousalLevel,
          stressLevel: reading.stressLevel,
          baseColor: widget.baseColor ?? QuantumDesignTokens.neonMint,
          pulseColor: widget.pulseColor ?? QuantumDesignTokens.neonPulse,
        );
      }
    });

    return performanceMetrics.when(
      data: (Object? metrics) {
        final bool enableShaders =
            widget.enableShaderEffects && shouldEnableEffects && metrics.isMeetingTarget;

        return AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[_pulseAnimation, _breathingAnimation]),
          builder: (BuildContext context, Widget? child) {
            if (enableShaders) {
              // Use GLSL shader for high-performance bio-effects
              return _buildShaderBackground(context, child);
            } else {
              // Fallback to Flutter animations for lower-end devices
              return _buildAnimatedBackground(context, child);
            }
          },
          child: widget.child,
        );
      },
      loading: () => _buildAnimatedBackground(context, widget.child),
      error: (_, __) => _buildAnimatedBackground(context, widget.child),
    );
  }

  Widget _buildShaderBackground(BuildContext context, Widget? child) {
    final shaderService = ref.read(quantumShaderServiceProvider);
    final Size size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        // Base gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 1.5,
              colors: <Color>[
                QuantumDesignTokens.pureBlack,
                QuantumDesignTokens.charcoalBlack,
                QuantumDesignTokens.pureBlack,
              ],
              stops: <double>[0.0, 0.7, 1.0],
            ),
          ),
        ),

        // GLSL shader overlay
        shaderService.createBioShaderWidget(
          shaderName: 'quantum_bio_pulse',
          size: size,
          intensity: widget.intensity * _breathingAnimation.value,
          child: child ?? const SizedBox.expand(),
        ),
      ],
    );
  }

  Widget _buildAnimatedBackground(BuildContext context, Widget? child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1.5 * _breathingAnimation.value,
          colors: <Color>[
            QuantumDesignTokens.neonMint.withValues(
              alpha: 0.1 * _pulseAnimation.value * widget.intensity,
            ),
            QuantumDesignTokens.pureBlack,
            QuantumDesignTokens.charcoalBlack,
          ],
          stops: const <double>[0.0, 0.6, 1.0],
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: QuantumDesignTokens.neonMint.withValues(
                alpha: 0.05 * _pulseAnimation.value * widget.intensity,
              ),
              blurRadius: 20 + (10 * _pulseAnimation.value),
              spreadRadius: 5 + (5 * _pulseAnimation.value),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Smaller bio-responsive widget for UI elements
class QuantumBioPulse extends ConsumerWidget {
  const QuantumBioPulse({
    required this.child,
    super.key,
    this.intensity = 0.5,
    this.enableHeartSync = true,
  });
  final Widget child;
  final double intensity;
  final bool enableHeartSync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BiometricReading?> biometricReading =
        ref.watch(currentBiometricReadingProvider);

    return biometricReading.when(
      data: (BiometricReading? reading) {
        if (reading == null || !enableHeartSync) {
          return child;
        }

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: (60000 / reading.heartRate).round()),
          tween: Tween<double>(begin: 1.0, end: 1.2),
          builder: (BuildContext context, double scale, Widget? child) {
            return Transform.scale(
              scale: 1.0 + ((scale - 1.0) * intensity),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: QuantumDesignTokens.neonMint.withValues(
                        alpha: 0.3 * (scale - 1.0) * intensity,
                      ),
                      blurRadius: 10 * (scale - 1.0),
                      spreadRadius: 2 * (scale - 1.0),
                    ),
                  ],
                ),
                child: this.child,
              ),
            );
          },
          child: child,
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}
