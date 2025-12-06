import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../theme/quantum_design_tokens.dart';
import '../providers/quantum_providers.dart';

/// Revolutionary neural network visualization that responds to biometric data
class QuantumNeuralVisualization extends ConsumerStatefulWidget {
  const QuantumNeuralVisualization({
    required this.width, required this.height, super.key,
    this.nodeCount = 50,
    this.enableBiometricResponse = true,
    this.enableQuantumTunneling = true,
    this.primaryColor,
    this.secondaryColor,
    this.intensity = 1.0,
  });
  final double width;
  final double height;
  final int nodeCount;
  final bool enableBiometricResponse;
  final bool enableQuantumTunneling;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double intensity;

  @override
  ConsumerState<QuantumNeuralVisualization> createState() => _QuantumNeuralVisualizationState();
}

class _QuantumNeuralVisualizationState extends ConsumerState<QuantumNeuralVisualization>
    with TickerProviderStateMixin {
  late AnimationController _networkController;
  late AnimationController _pulseController;
  late AnimationController _quantumController;
  late AnimationController _biometricController;

  late Animation<double> _networkAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _quantumAnimation;
  late Animation<double> _biometricAnimation;

  final List<_NeuralNode> _nodes = <_NeuralNode>[];
  final List<_NeuralConnection> _connections = <_NeuralConnection>[];

  @override
  void initState() {
    super.initState();

    // Network flow animation
    _networkController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _networkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_networkController);

    // Neural pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutQuart,
      ),
    );

    // Quantum tunneling effect
    _quantumController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _quantumAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_quantumController);

    // Biometric response animation
    _biometricController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _biometricAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _biometricController,
        curve: Curves.elasticOut,
      ),
    );

    _generateNeuralNetwork();
    _startAnimations();
  }

  void _generateNeuralNetwork() {
    _nodes.clear();
    _connections.clear();

    // Generate nodes in 3D space
    for (int i = 0; i < widget.nodeCount; i++) {
      _nodes.add(
        _NeuralNode(
          position: Offset(
            math.Random().nextDouble() * widget.width,
            math.Random().nextDouble() * widget.height,
          ),
          z: math.Random().nextDouble() * 100 - 50,
          radius: 2.0 + math.Random().nextDouble() * 4.0,
          energy: math.Random().nextDouble(),
          pulsePhase: math.Random().nextDouble() * 2 * math.pi,
        ),
      );
    }

    // Generate connections between nearby nodes
    for (int i = 0; i < _nodes.length; i++) {
      for (int j = i + 1; j < _nodes.length; j++) {
        final double distance = (_nodes[i].position - _nodes[j].position).distance;
        if (distance < 150 && math.Random().nextDouble() > 0.7) {
          _connections.add(
            _NeuralConnection(
              startIndex: i,
              endIndex: j,
              strength: math.Random().nextDouble(),
              flowSpeed: 0.5 + math.Random().nextDouble() * 1.5,
              quantumEntangled: widget.enableQuantumTunneling && math.Random().nextDouble() > 0.8,
            ),
          );
        }
      }
    }
  }

  void _startAnimations() {
    _networkController.repeat();
    _quantumController.repeat();

    // Trigger pulses randomly
    void triggerPulse() {
      if (mounted) {
        _pulseController.forward().then((_) {
          if (mounted) {
            _pulseController.reset();
            Future.delayed(Duration(milliseconds: 500 + math.Random().nextInt(2000)), triggerPulse);
          }
        });
      }
    }

    triggerPulse();
  }

  void _triggerBiometricResponse() {
    if (widget.enableBiometricResponse && mounted) {
      _biometricController.forward().then((_) {
        if (mounted) {
          _biometricController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _networkController.dispose();
    _pulseController.dispose();
    _quantumController.dispose();
    _biometricController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldEnableGlows = ref.watch(shouldEnableGlowEffectsProvider);

    // Listen for biometric triggers
    ref.listen(currentUserProfileProvider, (previous, next) {
      if (previous != next && next != null) {
        _triggerBiometricResponse();
      }
    });

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[
        _networkAnimation,
        _pulseAnimation,
        _quantumAnimation,
        _biometricAnimation,
      ]),
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: shouldEnableGlows
              ? CustomPaint(
                  painter: _QuantumNeuralPainter(
                    nodes: _nodes,
                    connections: _connections,
                    networkProgress: _networkAnimation.value,
                    pulseProgress: _pulseAnimation.value,
                    quantumProgress: _quantumAnimation.value,
                    biometricProgress: _biometricAnimation.value,
                    primaryColor: widget.primaryColor ?? QuantumDesignTokens.neonMint,
                    secondaryColor: widget.secondaryColor ?? QuantumDesignTokens.turquoiseNeon,
                    intensity: widget.intensity,
                    enableQuantumTunneling: widget.enableQuantumTunneling,
                  ),
                )
              : Container(),
        );
      },
    );
  }
}

class _NeuralNode {
  _NeuralNode({
    required this.position,
    required this.z,
    required this.radius,
    required this.energy,
    required this.pulsePhase,
  });
  final Offset position;
  final double z;
  final double radius;
  final double energy;
  final double pulsePhase;
}

class _NeuralConnection {
  _NeuralConnection({
    required this.startIndex,
    required this.endIndex,
    required this.strength,
    required this.flowSpeed,
    required this.quantumEntangled,
  });
  final int startIndex;
  final int endIndex;
  final double strength;
  final double flowSpeed;
  final bool quantumEntangled;
}

class _QuantumNeuralPainter extends CustomPainter {
  _QuantumNeuralPainter({
    required this.nodes,
    required this.connections,
    required this.networkProgress,
    required this.pulseProgress,
    required this.quantumProgress,
    required this.biometricProgress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.intensity,
    required this.enableQuantumTunneling,
  });
  final List<_NeuralNode> nodes;
  final List<_NeuralConnection> connections;
  final double networkProgress;
  final double pulseProgress;
  final double quantumProgress;
  final double biometricProgress;
  final Color primaryColor;
  final Color secondaryColor;
  final double intensity;
  final bool enableQuantumTunneling;

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;

    // Draw neural connections
    for (final _NeuralConnection connection in connections) {
      if (connection.startIndex >= nodes.length || connection.endIndex >= nodes.length) continue;

      final _NeuralNode startNode = nodes[connection.startIndex];
      final _NeuralNode endNode = nodes[connection.endIndex];

      // Calculate 3D positions
      final Offset startPos = _project3D(startNode.position, startNode.z, size);
      final Offset endPos = _project3D(endNode.position, endNode.z, size);

      // Connection line
      final Paint connectionPaint = Paint()
        ..color = primaryColor
            .withOpacity((connection.strength * intensity * 0.4) + (biometricProgress * 0.3))
        ..strokeWidth = 1.0 + (connection.strength * 2.0)
        ..style = PaintingStyle.stroke;

      canvas.drawLine(startPos, endPos, connectionPaint);

      // Data flow particles
      final double flowProgress = (networkProgress * connection.flowSpeed) % 1.0;
      final Offset particlePos = Offset.lerp(startPos, endPos, flowProgress)!;

      canvas.drawCircle(
        particlePos,
        1.5,
        Paint()
          ..color = secondaryColor.withOpacity(intensity * 0.8)
          ..style = PaintingStyle.fill,
      );

      // Quantum entanglement effect
      if (connection.quantumEntangled && enableQuantumTunneling) {
        final double quantumOffset = math.sin(quantumProgress + connection.strength * 10) * 5;
        final Offset quantumPos = Offset(
          particlePos.dx + quantumOffset,
          particlePos.dy + quantumOffset,
        );

        canvas.drawCircle(
          quantumPos,
          2.0,
          Paint()
            ..color = Color.lerp(primaryColor, secondaryColor, 0.5)!.withOpacity(intensity * 0.6)
            ..style = PaintingStyle.fill,
        );
      }
    }

    // Draw neural nodes
    for (int i = 0; i < nodes.length; i++) {
      final _NeuralNode node = nodes[i];
      final Offset nodePos = _project3D(node.position, node.z, size);

      // Node core
      final double coreRadius = node.radius * (1.0 + (biometricProgress * 0.5));
      final double nodeEnergy = node.energy + (biometricProgress * 0.3);

      canvas.drawCircle(
        nodePos,
        coreRadius,
        Paint()
          ..color = primaryColor.withOpacity(nodeEnergy * intensity)
          ..style = PaintingStyle.fill,
      );

      // Neural pulse rings
      final double pulseIntensity = math.sin(quantumProgress + node.pulsePhase) * 0.5 + 0.5;
      for (int ring = 1; ring <= 3; ring++) {
        final double ringRadius = coreRadius + (ring * 8 * pulseIntensity);
        canvas.drawCircle(
          nodePos,
          ringRadius,
          Paint()
            ..color = secondaryColor.withOpacity((intensity * 0.3 * pulseIntensity) / ring)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0,
        );
      }

      // Biometric response burst
      if (biometricProgress > 0) {
        final double burstRadius = coreRadius + (biometricProgress * 20);
        canvas.drawCircle(
          nodePos,
          burstRadius,
          Paint()
            ..color = Color.lerp(primaryColor, secondaryColor, biometricProgress)!
                .withOpacity(intensity * 0.4 * (1 - biometricProgress))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.0,
        );
      }

      // Holographic shimmer
      if (intensity > 0.7) {
        final double shimmer = math.sin(networkProgress * 4 + i * 0.5) * 0.5 + 0.5;
        canvas.drawCircle(
          nodePos,
          coreRadius * 0.7,
          Paint()
            ..color = Colors.white.withOpacity(shimmer * intensity * 0.3)
            ..style = PaintingStyle.fill
            ..blendMode = BlendMode.screen,
        );
      }
    }

    // Global neural field effect
    if (biometricProgress > 0.3) {
      final Paint fieldPaint = Paint()
        ..color = primaryColor.withOpacity(biometricProgress * intensity * 0.1)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        fieldPaint,
      );
    }
  }

  Offset _project3D(Offset position, double z, Size size) {
    // Simple 3D to 2D projection
    final double perspective = 200.0 / (200.0 + z);
    return Offset(
      (position.dx - size.width * 0.5) * perspective + size.width * 0.5,
      (position.dy - size.height * 0.5) * perspective + size.height * 0.5,
    );
  }

  @override
  bool shouldRepaint(covariant _QuantumNeuralPainter oldDelegate) {
    return oldDelegate.networkProgress != networkProgress ||
        oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.quantumProgress != quantumProgress ||
        oldDelegate.biometricProgress != biometricProgress;
  }
}

/// Bio-neural compatibility meter with quantum visualization
class QuantumCompatibilityMeter extends ConsumerStatefulWidget {
  const QuantumCompatibilityMeter({
    required this.compatibility, super.key,
    this.width = 200,
    this.height = 40,
    this.showPercentage = true,
  });
  final double compatibility;
  final double width;
  final double height;
  final bool showPercentage;

  @override
  ConsumerState<QuantumCompatibilityMeter> createState() => _QuantumCompatibilityMeterState();
}

class _QuantumCompatibilityMeterState extends ConsumerState<QuantumCompatibilityMeter>
    with TickerProviderStateMixin {
  late AnimationController _fillController;
  late AnimationController _waveController;
  late Animation<double> _fillAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    _fillController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: widget.compatibility,
    ).animate(
      CurvedAnimation(
        parent: _fillController,
        curve: Curves.elasticOut,
      ),
    );

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_waveController);

    _fillController.forward();
    _waveController.repeat();
  }

  @override
  void dispose() {
    _fillController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[_fillAnimation, _waveAnimation]),
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: <Widget>[
              // Background container
              Container(
                decoration: BoxDecoration(
                  color: QuantumDesignTokens.matteBlack,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  border: Border.all(
                    color: QuantumDesignTokens.neonMint.withOpacity(0.3),
                  ),
                ),
              ),

              // Quantum wave fill
              ClipRRect(
                borderRadius: BorderRadius.circular(widget.height / 2),
                child: CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: _CompatibilityWavePainter(
                    fillProgress: _fillAnimation.value,
                    waveProgress: _waveAnimation.value,
                    compatibility: widget.compatibility,
                  ),
                ),
              ),

              // Percentage text
              if (widget.showPercentage)
                Center(
                  child: Text(
                    '${(widget.compatibility * 100).round()}%',
                    style: const TextStyle(
                      fontFamily: QuantumDesignTokens.fontSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: QuantumDesignTokens.white,
                      shadows: <Shadow>[
                        Shadow(
                          color: QuantumDesignTokens.neonMint,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CompatibilityWavePainter extends CustomPainter {
  _CompatibilityWavePainter({
    required this.fillProgress,
    required this.waveProgress,
    required this.compatibility,
  });
  final double fillProgress;
  final double waveProgress;
  final double compatibility;

  @override
  void paint(Canvas canvas, Size size) {
    final double fillHeight = size.height * fillProgress;
    final double waveHeight = fillHeight * 0.1;

    // Gradient colors based on compatibility
    final List<Color> colors = _getCompatibilityColors(compatibility);

    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height - fillHeight);

    // Create wave effect
    for (double x = 0; x <= size.width; x += 1) {
      final double wave = math.sin((x / size.width * 4 * math.pi) + waveProgress) * waveHeight;
      path.lineTo(x, size.height - fillHeight + wave);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  List<Color> _getCompatibilityColors(double compatibility) {
    if (compatibility >= 0.8) {
      return <Color>[
        QuantumDesignTokens.neonMint,
        QuantumDesignTokens.turquoiseNeon,
      ];
    } else if (compatibility >= 0.6) {
      return <Color>[
        QuantumDesignTokens.turquoiseNeon,
        QuantumDesignTokens.avocadoGreen,
      ];
    } else if (compatibility >= 0.4) {
      return <Color>[
        QuantumDesignTokens.avocadoGreen,
        Colors.orange,
      ];
    } else {
      return <Color>[
        Colors.orange,
        Colors.red,
      ];
    }
  }

  @override
  bool shouldRepaint(covariant _CompatibilityWavePainter oldDelegate) {
    return oldDelegate.fillProgress != fillProgress || oldDelegate.waveProgress != waveProgress;
  }
}
