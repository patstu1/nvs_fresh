import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'dart:math' as math;

enum SignalQuality { perfect, weak, echo }

class BreathingPresenceMarker extends StatefulWidget {
  const BreathingPresenceMarker({
    required this.quality,
    super.key,
    this.isUserLocation = false,
    this.onTap,
    this.size = 40,
    this.isHosting = false,
    this.isOnline = false,
  });
  final SignalQuality quality;
  final bool isUserLocation;
  final VoidCallback? onTap;
  final double size;
  final bool isHosting;
  final bool isOnline;

  @override
  State<BreathingPresenceMarker> createState() => _BreathingPresenceMarkerState();
}

class _BreathingPresenceMarkerState extends State<BreathingPresenceMarker>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _pulseController;
  late AnimationController _glitchController;
  late AnimationController _rotationController;

  late Animation<double> _breathingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glitchAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Breathing effect (like the cyberpunk city lights)
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );

    // Pulse effect for active users
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );

    // Glitch effect for weak signals
    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _glitchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_glitchController);

    // Rotation for hosting users
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_rotationController);

    // Start animations based on state
    if (widget.isOnline) {
      _pulseController.repeat();
    }

    if (widget.quality == SignalQuality.weak) {
      // Random glitch effect
      _startRandomGlitch();
    }

    if (widget.isHosting) {
      _rotationController.repeat();
    }
  }

  void _startRandomGlitch() {
    Future.delayed(Duration(milliseconds: 1000 + math.Random().nextInt(3000)), () {
      if (mounted && widget.quality == SignalQuality.weak) {
        _glitchController.forward().then((_) {
          _glitchController.reverse();
          _startRandomGlitch();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge(<Listenable?>[
            _breathingController,
            _pulseController,
            _glitchController,
            _rotationController,
          ]),
          builder: (BuildContext context, Widget? child) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Outer breathing glow
                _buildOuterGlow(),

                // Pulse rings
                if (widget.isOnline) _buildPulseRings(),

                // Main marker
                Transform.rotate(
                  angle: widget.isHosting ? _rotationAnimation.value : 0,
                  child: Transform.scale(
                    scale: _breathingAnimation.value *
                        (widget.quality == SignalQuality.weak
                            ? (1.0 - _glitchAnimation.value * 0.3)
                            : 1.0),
                    child: _buildMainMarker(),
                  ),
                ),

                // Glitch overlay for weak signals
                if (widget.quality == SignalQuality.weak) _buildGlitchOverlay(),

                // Echo effect for distant signals
                if (widget.quality == SignalQuality.echo) _buildEchoEffect(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOuterGlow() {
    final Color glowColor = _getSignalColor();
    final double intensity = _breathingAnimation.value;

    return Container(
      width: widget.size * 2,
      height: widget.size * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            glowColor.withOpacity(0.1 * intensity),
            glowColor.withOpacity(0.05 * intensity),
            Colors.transparent,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: glowColor.withOpacity(0.3 * intensity),
            blurRadius: 20 * intensity,
            spreadRadius: 5 * intensity,
          ),
        ],
      ),
    );
  }

  Widget _buildPulseRings() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(3, (int index) {
        final double delay = index * 0.3;
        final Animation<double> adjustedAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _pulseController,
            curve: Interval(delay, 1.0, curve: Curves.easeOut),
          ),
        );

        return Transform.scale(
          scale: 1.0 + (adjustedAnimation.value * 1.5),
          child: Container(
            width: widget.size * 0.8,
            height: widget.size * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _getSignalColor().withOpacity(
                  (1.0 - adjustedAnimation.value) * 0.6,
                ),
                width: 2,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMainMarker() {
    final Color color = _getSignalColor();

    return Container(
      width: widget.size * 0.6,
      height: widget.size * 0.6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color,
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: widget.isUserLocation
          ? Icon(
              Icons.my_location,
              color: NVSColors.pureBlack,
              size: widget.size * 0.3,
            )
          : widget.isHosting
              ? Icon(
                  Icons.wifi_tethering,
                  color: NVSColors.pureBlack,
                  size: widget.size * 0.25,
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.9),
                  ),
                ),
    );
  }

  Widget _buildGlitchOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.transparent,
              NVSColors.primaryNeonMint.withOpacity(_glitchAnimation.value * 0.3),
              Colors.transparent,
              NVSColors.primaryNeonMint.withOpacity(_glitchAnimation.value * 0.2),
            ],
            stops: const <double>[0.0, 0.3, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildEchoEffect() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // Shimmering heat distortion effect
        Container(
          width: widget.size * 0.3,
          height: widget.size * 0.3,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                NVSColors.primaryNeonMint.withOpacity(0.1),
                NVSColors.primaryNeonMint.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Flickering pixel
        if (_breathingAnimation.value > 0.9)
          Container(
            width: 2,
            height: 2,
            decoration: BoxDecoration(
              color: NVSColors.primaryNeonMint.withOpacity(0.7),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: NVSColors.primaryNeonMint.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _getSignalColor() {
    switch (widget.quality) {
      case SignalQuality.perfect:
        return NVSColors.primaryNeonMint;
      case SignalQuality.weak:
        return NVSColors.turquoiseNeon;
      case SignalQuality.echo:
        return NVSColors.ultraLightMint.withOpacity(0.6);
    }
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pulseController.dispose();
    _glitchController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}
