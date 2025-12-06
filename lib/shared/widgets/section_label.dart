import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

/// Section Label Widget
/// Displays section names with cyberpunk glow effects
class SectionLabel extends StatefulWidget {
  const SectionLabel({
    required this.sectionName,
    super.key,
    this.glowColor,
    this.fontSize = 12,
    this.padding = const EdgeInsets.all(8),
    this.alignment = Alignment.bottomRight,
  });
  final String sectionName;
  final Color? glowColor;
  final double? fontSize;
  final EdgeInsets? padding;
  final AlignmentGeometry? alignment;

  @override
  State<SectionLabel> createState() => _SectionLabelState();
}

class _SectionLabelState extends State<SectionLabel>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final bool _isVisible = true;
  bool _animationsPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() {
    if (mounted && !_animationsPaused) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _pauseAnimations() {
    if (!_animationsPaused) {
      _pulseController.stop();
      _animationsPaused = true;
    }
  }

  void _resumeAnimations() {
    if (_animationsPaused && _isVisible) {
      _pulseController.repeat(reverse: true);
      _animationsPaused = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _pauseAnimations();
        break;
      case AppLifecycleState.resumed:
        _resumeAnimations();
        break;
      case AppLifecycleState.detached:
        _pauseAnimations();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveGlowColor = widget.glowColor ?? NVSColors.ultraLightMint;

    return Align(
      alignment: widget.alignment!,
      child: Padding(
        padding: widget.padding!,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (BuildContext context, Widget? child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: NVSColors.pureBlack.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: effectiveGlowColor.withValues(alpha: 0.3),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: effectiveGlowColor.withValues(
                      alpha: _pulseAnimation.value * 0.5,
                    ),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: effectiveGlowColor.withValues(
                      alpha: _pulseAnimation.value * 0.2,
                    ),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                widget.sectionName.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: effectiveGlowColor,
                  letterSpacing: 1.5,
                  shadows: <Shadow>[
                    Shadow(
                      color: effectiveGlowColor.withValues(
                        alpha: _pulseAnimation.value * 0.8,
                      ),
                      blurRadius: 4,
                    ),
                    Shadow(
                      color: effectiveGlowColor.withValues(
                        alpha: _pulseAnimation.value * 0.4,
                      ),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
