// lib/core/widgets/quantum_glow_engine.dart
// High-Performance Quantum Glow Engine for Bio-Responsive UI
// Hardware-accelerated visual effects with neural synchronization

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../theme/quantum_design_tokens.dart';

/// Quantum Glow Engine - High-performance visual effects system
/// Provides hardware-accelerated glow effects, particle systems, and bio-responsive visuals
class QuantumGlowEngine extends StatefulWidget {
  const QuantumGlowEngine({
    super.key,
    this.intensity = 1.0,
    this.heartbeatScale = 1.0,
    this.config = const QuantumEffectConfig(),
    this.bioState,
    this.child,
  });

  final double intensity;
  final double heartbeatScale;
  final QuantumEffectConfig config;
  final BiometricState? bioState;
  final Widget? child;

  @override
  State<QuantumGlowEngine> createState() => _QuantumGlowEngineState();
}

class _QuantumGlowEngineState extends State<QuantumGlowEngine> with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _rippleController;
  late AnimationController _holoController;

  final List<Particle> _particles = <Particle>[];
  final List<Ripple> _ripples = <Ripple>[];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _generateParticles();
  }

  void _initializeControllers() {
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _rippleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _holoController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  void _generateParticles() {
    if (!widget.config.enableParticles) return;

    final math.Random random = math.Random();
    _particles.clear();

    for (int i = 0; i < widget.config.particleCount; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: 1.0 + random.nextDouble() * 3.0,
          speed: 0.001 + random.nextDouble() * 0.003,
          opacity: 0.3 + random.nextDouble() * 0.7,
          color: _getParticleColor(random),
          phase: random.nextDouble() * 2 * math.pi,
        ),
      );
    }
  }

  Color _getParticleColor(math.Random random) {
    final List<Color> colors = <Color>[
      QuantumDesignTokens.ultraLightMint,
      QuantumDesignTokens.neonMint,
      QuantumDesignTokens.turquoiseNeon,
      QuantumDesignTokens.avocadoGreen,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _particleController.dispose();
    _rippleController.dispose();
    _holoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Particle system
        if (widget.config.enableParticles)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: ParticleSystemPainter(
                    particles: _particles,
                    time: _particleController.value,
                    intensity: widget.intensity,
                    heartbeatScale: widget.heartbeatScale,
                  ),
                );
              },
            ),
          ),

        // Ripple effects
        if (widget.config.enableRipples)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rippleController,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: RippleEffectPainter(
                    ripples: _ripples,
                    time: _rippleController.value,
                    intensity: widget.intensity * widget.config.rippleIntensity,
                  ),
                );
              },
            ),
          ),

        // Holographic overlay
        if (widget.config.enableHolographic)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _holoController,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: HolographicOverlayPainter(
                    time: _holoController.value,
                    opacity: widget.config.holographicOpacity,
                    bioState: widget.bioState,
                  ),
                );
              },
            ),
          ),

        // Child content
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

/// Particle system painter for quantum effects
class ParticleSystemPainter extends CustomPainter {
  const ParticleSystemPainter({
    required this.particles,
    required this.time,
    required this.intensity,
    required this.heartbeatScale,
  });

  final List<Particle> particles;
  final double time;
  final double intensity;
  final double heartbeatScale;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..blendMode = BlendMode.screen
      ..isAntiAlias = true;

    for (final Particle particle in particles) {
      final double x = (particle.x + particle.speed * time * 10) % 1.0;
      final double y = (particle.y + math.sin(time * 2 * math.pi + particle.phase) * 0.1) % 1.0;

      final Offset position = Offset(x * size.width, y * size.height);
      final double currentSize = particle.size * intensity * heartbeatScale;
      final double currentOpacity = particle.opacity * intensity;

      // Create gradient for particle glow
      final ui.Gradient gradient = ui.Gradient.radial(
        Offset.zero,
        currentSize * 2,
        <Color>[
          particle.color.withValues(alpha: currentOpacity),
          particle.color.withValues(alpha: 0.0),
        ],
        <double>[0.0, 1.0],
      );

      paint.shader = gradient;
      canvas.drawCircle(position, currentSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleSystemPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.intensity != intensity ||
        oldDelegate.heartbeatScale != heartbeatScale;
  }
}

/// Ripple effect painter for touch interactions
class RippleEffectPainter extends CustomPainter {
  const RippleEffectPainter({
    required this.ripples,
    required this.time,
    required this.intensity,
  });

  final List<Ripple> ripples;
  final double time;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.screen
      ..isAntiAlias = true;

    for (final Ripple ripple in ripples) {
      final double progress = (time - ripple.startTime) % 1.0;
      final double radius = progress * ripple.maxRadius;
      final double opacity = (1.0 - progress) * ripple.opacity * intensity;

      paint.color = ripple.color.withValues(alpha: opacity);
      paint.strokeWidth = ripple.strokeWidth * (1.0 - progress * 0.5);

      canvas.drawCircle(
        Offset(ripple.x * size.width, ripple.y * size.height),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RippleEffectPainter oldDelegate) {
    return oldDelegate.time != time || oldDelegate.intensity != intensity;
  }
}

/// Holographic overlay painter for cyberpunk effects
class HolographicOverlayPainter extends CustomPainter {
  const HolographicOverlayPainter({
    required this.time,
    required this.opacity,
    this.bioState,
  });

  final double time;
  final double opacity;
  final BiometricState? bioState;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..blendMode = BlendMode.overlay
      ..isAntiAlias = true;

    // Horizontal scan lines
    for (double y = 0; y < size.height; y += 4) {
      final double scanOpacity = opacity * (0.1 + 0.1 * math.sin(time * 2 * math.pi + y / 10));
      paint.color = QuantumDesignTokens.turquoiseNeon.withValues(alpha: scanOpacity);
      paint.strokeWidth = 0.5;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Vertical interference pattern
    for (double x = 0; x < size.width; x += 8) {
      final double interferenceOpacity =
          opacity * (0.05 + 0.05 * math.cos(time * 3 * math.pi + x / 20));
      paint.color = QuantumDesignTokens.neonMint.withValues(alpha: interferenceOpacity);
      paint.strokeWidth = 1.0;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Bio-responsive glow based on biometric state
    if (bioState != null) {
      _paintBioGlow(canvas, size, paint);
    }
  }

  void _paintBioGlow(Canvas canvas, Size size, Paint paint) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double bioIntensity = _getBioIntensity();

    final ui.Gradient gradient = ui.Gradient.radial(
      center,
      size.width * 0.7,
      <Color>[
        _getBioColor().withValues(alpha: bioIntensity * opacity * 0.1),
        _getBioColor().withValues(alpha: 0.0),
      ],
      <double>[0.0, 1.0],
    );

    paint.shader = gradient;
    canvas.drawCircle(center, size.width * 0.7, paint);
  }

  double _getBioIntensity() {
    if (bioState == null) return 0.5;

    // Map biometric data to intensity
    switch (bioState!.arousalLevel) {
      case ArousalLevel.low:
        return 0.3;
      case ArousalLevel.medium:
        return 0.6;
      case ArousalLevel.high:
        return 0.9;
      case ArousalLevel.extreme:
        return 1.0;
    }
  }

  Color _getBioColor() {
    if (bioState == null) return QuantumDesignTokens.bioNeutral;

    switch (bioState!.arousalLevel) {
      case ArousalLevel.low:
        return QuantumDesignTokens.bioCalm;
      case ArousalLevel.medium:
        return QuantumDesignTokens.bioNeutral;
      case ArousalLevel.high:
        return QuantumDesignTokens.bioExcited;
      case ArousalLevel.extreme:
        return QuantumDesignTokens.bioStressed;
    }
  }

  @override
  bool shouldRepaint(covariant HolographicOverlayPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.opacity != opacity ||
        oldDelegate.bioState != bioState;
  }
}

/// Particle data structure
class Particle {
  const Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
    required this.phase,
  });

  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final Color color;
  final double phase;
}

/// Ripple data structure
class Ripple {
  const Ripple({
    required this.x,
    required this.y,
    required this.startTime,
    required this.maxRadius,
    required this.opacity,
    required this.color,
    required this.strokeWidth,
  });

  final double x;
  final double y;
  final double startTime;
  final double maxRadius;
  final double opacity;
  final Color color;
  final double strokeWidth;
}

/// Biometric state for bio-responsive effects
class BiometricState {
  const BiometricState({
    required this.heartRate,
    required this.arousalLevel,
    required this.stressLevel,
    required this.timestamp,
  });

  final int heartRate;
  final ArousalLevel arousalLevel;
  final double stressLevel;
  final DateTime timestamp;
}

/// Arousal levels for biometric responsiveness
enum ArousalLevel {
  low,
  medium,
  high,
  extreme,
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
