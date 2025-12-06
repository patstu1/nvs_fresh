import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../theme/quantum_design_tokens.dart';
import '../providers/quantum_providers.dart';

/// Quantum-enhanced NVS logo with bio-responsive glow effects
class QuantumLogo extends ConsumerStatefulWidget {
  const QuantumLogo({
    super.key,
    this.width,
    this.height,
    this.enableBioResponse = true,
    this.enableQuantumPulse = true,
    this.overrideColor,
  });
  final double? width;
  final double? height;
  final bool enableBioResponse;
  final bool enableQuantumPulse;
  final Color? overrideColor;

  @override
  ConsumerState<QuantumLogo> createState() => _QuantumLogoState();
}

class _QuantumLogoState extends ConsumerState<QuantumLogo> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _bioController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bioAnimation;

  @override
  void initState() {
    super.initState();

    // Quantum pulse animation
    _pulseController = AnimationController(
      duration: QuantumDesignTokens.durationSlow,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Subtle rotation for quantum effect
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController);

    // Bio-responsive animation
    _bioController = AnimationController(
      duration: QuantumDesignTokens.durationMedium,
      vsync: this,
    );
    _bioAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _bioController,
        curve: Curves.elasticOut,
      ),
    );

    if (widget.enableQuantumPulse) {
      _pulseController.repeat(reverse: true);
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldEnableGlows = ref.watch(shouldEnableGlowEffectsProvider);
    final performanceMetrics = ref.watch(performanceMetricsProvider);

    // Trigger bio response animation when enabled
    if (widget.enableBioResponse && shouldEnableGlows) {
      _bioController.forward();
    }

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[
        _pulseAnimation,
        _rotationAnimation,
        _bioAnimation,
      ]),
      builder: (BuildContext context, Widget? child) {
        final color = widget.overrideColor ?? QuantumDesignTokens.neonMint;
        final double glowIntensity = shouldEnableGlows
            ? (0.5 + (_pulseAnimation.value * 0.5)) *
                (widget.enableBioResponse ? (0.7 + _bioAnimation.value * 0.3) : 1.0)
            : 0.0;

        return Transform.scale(
          scale: widget.enableQuantumPulse ? _pulseAnimation.value : 1.0,
          child: Transform.rotate(
            angle: widget.enableQuantumPulse ? _rotationAnimation.value * 0.1 : 0.0,
            child: Container(
              width: widget.width ?? 60,
              height: widget.height ?? 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: QuantumDesignTokens.matteBlack,
                border: Border.all(
                  color: color.withOpacity(0.8),
                  width: 2,
                ),
                boxShadow: shouldEnableGlows
                    ? <BoxShadow>[
                        // Inner glow
                        BoxShadow(
                          color: color.withOpacity(glowIntensity * 0.6),
                          blurRadius: 8,
                          spreadRadius: -2,
                        ),
                        // Outer glow
                        BoxShadow(
                          color: color.withOpacity(glowIntensity * 0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                        // Far glow for bio response
                        if (widget.enableBioResponse)
                          BoxShadow(
                            color: QuantumDesignTokens.turquoiseNeon.withOpacity(
                              glowIntensity * 0.3 * _bioAnimation.value,
                            ),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                      ]
                    : null,
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: QuantumDesignTokens.durationFast,
                  style: TextStyle(
                    fontFamily: QuantumDesignTokens.fontPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                    shadows: shouldEnableGlows
                        ? <Shadow>[
                            Shadow(
                              color: color.withOpacity(glowIntensity),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  child: const Text('N'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Quantum logo for app bars with reduced animations
class QuantumLogoAppBar extends ConsumerWidget {
  const QuantumLogoAppBar({
    super.key,
    this.size,
  });
  final double? size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuantumLogo(
      width: size ?? 32,
      height: size ?? 32,
      enableQuantumPulse: false,
      enableBioResponse: false,
    );
  }
}

/// Quantum logo for loading states with enhanced animation
class QuantumLogoLoading extends ConsumerWidget {
  const QuantumLogoLoading({
    super.key,
    this.loadingText,
  });
  final String? loadingText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const QuantumLogo(
          width: 80,
          height: 80,
        ),
        if (loadingText != null) ...<Widget>[
          const SizedBox(height: 16),
          Text(
            loadingText!,
            style: TextStyle(
              fontFamily: QuantumDesignTokens.fontSecondary,
              fontSize: 14,
              color: QuantumDesignTokens.neonMint.withOpacity(0.8),
            ),
          ),
        ],
      ],
    );
  }
}
