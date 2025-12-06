import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../theme/quantum_design_tokens.dart';
import '../providers/quantum_providers.dart';
import 'quantum_glow_engine.dart';

/// Bio-responsive scaffold that adapts to user arousal and performance metrics
class QuantumScaffold extends ConsumerStatefulWidget {
  const QuantumScaffold({
    required this.body, super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.enableBioResponse = true,
    this.enableQuantumEffects = true,
    this.sectionId,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool enableBioResponse;
  final bool enableQuantumEffects;
  final String? sectionId;

  @override
  ConsumerState<QuantumScaffold> createState() => _QuantumScaffoldState();
}

class _QuantumScaffoldState extends ConsumerState<QuantumScaffold> with TickerProviderStateMixin {
  late AnimationController _ambientController;
  late AnimationController _bioResponseController;
  late Animation<double> _ambientAnimation;
  late Animation<double> _bioResponseAnimation;

  @override
  void initState() {
    super.initState();

    // Ambient background animation
    _ambientController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _ambientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _ambientController,
        curve: Curves.easeInOut,
      ),
    );

    // Bio-response animation
    _bioResponseController = AnimationController(
      duration: QuantumDesignTokens.durationMedium,
      vsync: this,
    );
    _bioResponseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _bioResponseController,
        curve: Curves.elasticOut,
      ),
    );

    if (widget.enableQuantumEffects) {
      _ambientController.repeat(reverse: true);
    }

    // Update section tracking
    if (widget.sectionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(currentAppSectionProvider.notifier).state = widget.sectionId;
      });
    }
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _bioResponseController.dispose();
    super.dispose();
  }

  void _triggerBioResponse() {
    if (widget.enableBioResponse && mounted) {
      _bioResponseController.forward().then((_) {
        if (mounted) {
          _bioResponseController.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldEnableGlows = ref.watch(shouldEnableGlowEffectsProvider);
    final performanceMetrics = ref.watch(performanceMetricsProvider);

    // Listen for bio-response triggers
    ref.listen(currentUserProfileProvider, (previous, next) {
      if (previous != next && next != null) {
        _triggerBioResponse();
      }
    });

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable?>[
        _ambientAnimation,
        _bioResponseAnimation,
      ]),
      builder: (BuildContext context, Widget? child) {
        final baseColor = widget.backgroundColor ?? QuantumDesignTokens.matteBlack;
        final double ambientIntensity =
            widget.enableQuantumEffects ? _ambientAnimation.value * 0.1 : 0.0;
        final double bioIntensity =
            widget.enableBioResponse ? _bioResponseAnimation.value * 0.2 : 0.0;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: baseColor,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: widget.appBar,
            body: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    baseColor,
                    Color.lerp(
                      baseColor,
                      QuantumDesignTokens.neonMint.withOpacity(0.05),
                      ambientIntensity + bioIntensity,
                    )!,
                    Color.lerp(
                      baseColor,
                      QuantumDesignTokens.turquoiseNeon.withOpacity(0.03),
                      ambientIntensity * 0.5,
                    )!,
                  ],
                  stops: const <double>[0.0, 0.7, 1.0],
                ),
              ),
              child: Stack(
                children: <Widget>[
                  // Quantum dots effect
                  if (shouldEnableGlows && widget.enableQuantumEffects)
                    Positioned.fill(
                      child: _QuantumDotsBackground(
                        intensity: ambientIntensity + bioIntensity,
                      ),
                    ),

                  // Bio-response pulse overlay
                  if (shouldEnableGlows && widget.enableBioResponse)
                    Positioned.fill(
                      child: AnimatedOpacity(
                        duration: QuantumDesignTokens.durationFast,
                        opacity: _bioResponseAnimation.value * 0.1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              radius: 1.5,
                              colors: <Color>[
                                QuantumDesignTokens.turquoiseNeon.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Main body
                  widget.body,
                ],
              ),
            ),
            bottomNavigationBar: widget.bottomNavigationBar,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            drawer: widget.drawer,
            endDrawer: widget.endDrawer,
            extendBody: widget.extendBody,
            extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          ),
        );
      },
    );
  }
}

/// Quantum dots background effect
class _QuantumDotsBackground extends StatefulWidget {
  const _QuantumDotsBackground({
    required this.intensity,
  });
  final double intensity;

  @override
  State<_QuantumDotsBackground> createState() => _QuantumDotsBackgroundState();
}

class _QuantumDotsBackgroundState extends State<_QuantumDotsBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: _QuantumDotsPainter(
            progress: _animation.value,
            intensity: widget.intensity,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Custom painter for quantum dots effect
class _QuantumDotsPainter extends CustomPainter {
  _QuantumDotsPainter({
    required this.progress,
    required this.intensity,
  });
  final double progress;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;

    final Paint paint = Paint()
      ..color = QuantumDesignTokens.neonMint.withOpacity(intensity * 0.3)
      ..style = PaintingStyle.fill;

    const int dotCount = 20;
    final double spacing = size.width / dotCount;

    for (int i = 0; i < dotCount; i++) {
      for (int j = 0; j < (size.height / spacing).floor(); j++) {
        final double x = (i * spacing) + (spacing * 0.5);
        final double y = (j * spacing) + (spacing * 0.5);

        // Create wave effect
        final double wave = (progress * 2 * 3.14159) + (i * 0.5) + (j * 0.3);
        final opacity = (wave.sin() * 0.5 + 0.5) * intensity;

        if (opacity > 0.1) {
          paint.color = QuantumDesignTokens.neonMint.withOpacity(opacity * 0.2);
          canvas.drawCircle(
            Offset(x, y),
            1.0 + (opacity * 2),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QuantumDotsPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.intensity != intensity;
  }
}

/// Pre-configured quantum scaffolds for different app sections
class QuantumScaffoldGrid extends ConsumerWidget {
  const QuantumScaffoldGrid({
    required this.body, super.key,
    this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuantumScaffold(
      body: body,
      appBar: appBar,
      sectionId: 'grid',
    );
  }
}

class QuantumScaffoldNow extends ConsumerWidget {
  const QuantumScaffoldNow({
    required this.body, super.key,
    this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuantumScaffold(
      body: body,
      appBar: appBar,
      sectionId: 'now',
      backgroundColor: QuantumDesignTokens.matteBlack.withBlue(10),
    );
  }
}

class QuantumScaffoldConnect extends ConsumerWidget {
  const QuantumScaffoldConnect({
    required this.body, super.key,
    this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuantumScaffold(
      body: body,
      appBar: appBar,
      sectionId: 'connect',
      backgroundColor: QuantumDesignTokens.matteBlack.withGreen(8),
    );
  }
}

class QuantumScaffoldLive extends ConsumerWidget {
  const QuantumScaffoldLive({
    required this.body, super.key,
    this.appBar,
  });
  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuantumScaffold(
      body: body,
      appBar: appBar,
      sectionId: 'live',
      backgroundColor: QuantumDesignTokens.matteBlack.withRed(8),
    );
  }
}
