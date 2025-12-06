import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../theme/quantum_design_tokens.dart';
import '../providers/quantum_providers.dart';

/// Revolutionary holographic interface component with 3D depth effects
class QuantumHolographicInterface extends ConsumerStatefulWidget {
  const QuantumHolographicInterface({
    required this.child, super.key,
    this.depth = 20.0,
    this.enableParallax = true,
    this.enableHologram = true,
    this.enableNeuralResponse = true,
    this.hologramColor,
    this.intensity = 1.0,
  });
  final Widget child;
  final double depth;
  final bool enableParallax;
  final bool enableHologram;
  final bool enableNeuralResponse;
  final Color? hologramColor;
  final double intensity;

  @override
  ConsumerState<QuantumHolographicInterface> createState() => _QuantumHolographicInterfaceState();
}

class _QuantumHolographicInterfaceState extends ConsumerState<QuantumHolographicInterface>
    with TickerProviderStateMixin {
  late AnimationController _scanlineController;
  late AnimationController _interferenceController;
  late AnimationController _depthController;
  late AnimationController _neuralController;

  late Animation<double> _scanlineAnimation;
  late Animation<double> _interferenceAnimation;
  late Animation<double> _depthAnimation;
  late Animation<double> _neuralAnimation;

  Offset _pointerPosition = Offset.zero;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // Holographic scanline effect
    _scanlineController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scanlineAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _scanlineController,
        curve: Curves.linear,
      ),
    );

    // Interference pattern
    _interferenceController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _interferenceAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_interferenceController);

    // 3D depth animation
    _depthController = AnimationController(
      duration: QuantumDesignTokens.durationMedium,
      vsync: this,
    );
    _depthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _depthController,
        curve: Curves.elasticOut,
      ),
    );

    // Neural response animation
    _neuralController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _neuralAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _neuralController,
        curve: Curves.easeInOutQuart,
      ),
    );

    if (widget.enableHologram) {
      _scanlineController.repeat();
      _interferenceController.repeat();
    }
  }

  @override
  void dispose() {
    _scanlineController.dispose();
    _interferenceController.dispose();
    _depthController.dispose();
    _neuralController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerEvent details, Size size) {
    setState(() {
      _pointerPosition = Offset(
        (details.localPosition.dx / size.width - 0.5) * 2,
        (details.localPosition.dy / size.height - 0.5) * 2,
      );
    });
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovered = hovering;
    });

    if (hovering) {
      _depthController.forward();
      if (widget.enableNeuralResponse) {
        _neuralController.forward();
      }
    } else {
      _depthController.reverse();
      _neuralController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldEnableGlows = ref.watch(shouldEnableGlowEffectsProvider);
    final performanceMetrics = ref.watch(performanceMetricsProvider);

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[
        _scanlineAnimation,
        _interferenceAnimation,
        _depthAnimation,
        _neuralAnimation,
      ]),
      builder: (BuildContext context, Widget? child) {
        final hologramColor = widget.hologramColor ?? QuantumDesignTokens.turquoiseNeon;
        final effectIntensity = shouldEnableGlows ? widget.intensity : 0.0;

        return MouseRegion(
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: Listener(
            onPointerMove: (PointerMoveEvent event) =>
                _onPointerMove(event, context.size ?? Size.zero),
            child: Stack(
              children: <Widget>[
                // 3D transformed child with parallax
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..rotateX(widget.enableParallax ? _pointerPosition.dy * 0.1 : 0)
                    ..rotateY(widget.enableParallax ? -_pointerPosition.dx * 0.1 : 0)
                    ..translate(
                      0.0,
                      0.0,
                      widget.depth * _depthAnimation.value,
                    ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: shouldEnableGlows
                          ? <BoxShadow>[
                              // 3D depth shadow
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(
                                  widget.depth * _depthAnimation.value * 0.1,
                                  widget.depth * _depthAnimation.value * 0.1,
                                ),
                                blurRadius: widget.depth * _depthAnimation.value * 0.5,
                              ),
                              // Holographic glow
                              BoxShadow(
                                color: hologramColor.withOpacity(effectIntensity * 0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ]
                          : null,
                    ),
                    child: widget.child,
                  ),
                ),

                // Holographic scanline overlay
                if (widget.enableHologram && shouldEnableGlows)
                  Positioned.fill(
                    child: ClipRect(
                      child: CustomPaint(
                        painter: _HolographicScanlinePainter(
                          scanlineProgress: _scanlineAnimation.value,
                          interferenceProgress: _interferenceAnimation.value,
                          color: hologramColor,
                          intensity: effectIntensity,
                        ),
                      ),
                    ),
                  ),

                // Neural response overlay
                if (widget.enableNeuralResponse && shouldEnableGlows)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _NeuralResponsePainter(
                          progress: _neuralAnimation.value,
                          center: _pointerPosition,
                          color: QuantumDesignTokens.neonMint,
                          intensity: effectIntensity,
                        ),
                      ),
                    ),
                  ),

                // Interference pattern
                if (widget.enableHologram && shouldEnableGlows && _isHovered)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              hologramColor.withOpacity(0.1 * effectIntensity),
                              Colors.transparent,
                              hologramColor.withOpacity(0.05 * effectIntensity),
                            ],
                            stops: const <double>[0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Holographic scanline painter for that authentic hologram effect
class _HolographicScanlinePainter extends CustomPainter {
  _HolographicScanlinePainter({
    required this.scanlineProgress,
    required this.interferenceProgress,
    required this.color,
    required this.intensity,
  });
  final double scanlineProgress;
  final double interferenceProgress;
  final Color color;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;

    final Paint paint = Paint()
      ..color = color.withOpacity(intensity * 0.6)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;

    // Horizontal scanlines
    final double scanlineY = (scanlineProgress + 1) * size.height * 0.5;
    const double scanlineHeight = 2.0;

    for (int i = 0; i < 5; i++) {
      final double y = scanlineY + (i * scanlineHeight * 3);
      if (y >= 0 && y <= size.height) {
        canvas.drawRect(
          Rect.fromLTWH(0, y, size.width, scanlineHeight),
          paint..color = color.withOpacity(intensity * (0.8 - i * 0.15)),
        );
      }
    }

    // Interference grid pattern
    paint.color = color.withOpacity(intensity * 0.1);
    const double gridSize = 4.0;

    for (double x = 0; x < size.width; x += gridSize) {
      for (double y = 0; y < size.height; y += gridSize) {
        final double interference =
            math.sin(interferenceProgress + x * 0.01) * math.cos(interferenceProgress + y * 0.01);
        if (interference > 0.7) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, 1, 1),
            paint..color = color.withOpacity(intensity * 0.3),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HolographicScanlinePainter oldDelegate) {
    return oldDelegate.scanlineProgress != scanlineProgress ||
        oldDelegate.interferenceProgress != interferenceProgress ||
        oldDelegate.intensity != intensity;
  }
}

/// Neural response painter for biometric-driven visual effects
class _NeuralResponsePainter extends CustomPainter {
  _NeuralResponsePainter({
    required this.progress,
    required this.center,
    required this.color,
    required this.intensity,
  });
  final double progress;
  final Offset center;
  final Color color;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0 || progress <= 0) return;

    final Paint paint = Paint()
      ..color = color.withOpacity(intensity * 0.4 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Offset centerPoint = Offset(
      size.width * 0.5 + (center.dx * size.width * 0.1),
      size.height * 0.5 + (center.dy * size.height * 0.1),
    );

    // Neural network connections
    const int nodeCount = 8;
    final double radius = progress * 100;

    for (int i = 0; i < nodeCount; i++) {
      final double angle = (i / nodeCount) * 2 * math.pi;
      final double nodeX = centerPoint.dx + math.cos(angle) * radius;
      final double nodeY = centerPoint.dy + math.sin(angle) * radius;

      // Draw connection lines
      canvas.drawLine(
        centerPoint,
        Offset(nodeX, nodeY),
        paint..strokeWidth = 2.0 * progress,
      );

      // Draw nodes
      canvas.drawCircle(
        Offset(nodeX, nodeY),
        3.0 * progress,
        Paint()
          ..color = color.withOpacity(intensity * 0.8 * progress)
          ..style = PaintingStyle.fill,
      );

      // Draw pulse rings
      for (int ring = 1; ring <= 3; ring++) {
        canvas.drawCircle(
          Offset(nodeX, nodeY),
          (3.0 + ring * 5.0) * progress,
          Paint()
            ..color = color.withOpacity(intensity * 0.2 * progress / ring)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralResponsePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center ||
        oldDelegate.intensity != intensity;
  }
}

/// 3D Card with holographic interface
class QuantumHolographicCard extends ConsumerWidget {
  const QuantumHolographicCard({
    required this.child, super.key,
    this.padding,
    this.elevation = 8.0,
    this.enableQuantumEffects = true,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final bool enableQuantumEffects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuantumHolographicInterface(
      depth: elevation,
      enableHologram: enableQuantumEffects,
      enableNeuralResponse: enableQuantumEffects,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: QuantumDesignTokens.matteBlack.withOpacity(0.9),
          borderRadius: BorderRadius.circular(QuantumDesignTokens.radiusMedium),
          border: Border.all(
            color: QuantumDesignTokens.neonMint.withOpacity(0.3),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: QuantumDesignTokens.neonMint.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Floating action button with holographic effects
class QuantumHolographicFAB extends ConsumerWidget {
  const QuantumHolographicFAB({
    required this.child, super.key,
    this.onPressed,
    this.backgroundColor,
    this.size = 56.0,
  });
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuantumHolographicInterface(
      depth: 15.0,
      intensity: 1.5,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? QuantumDesignTokens.neonMint,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: QuantumDesignTokens.neonMint.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(size / 2),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
