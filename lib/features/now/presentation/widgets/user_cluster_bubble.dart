import 'package:flutter/material.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';

class UserClusterBubble extends StatefulWidget {
  const UserClusterBubble({
    required this.userId,
    super.key,
    this.profileImageUrl,
    this.isOnline = false,
    this.isViewed = false,
    this.isViewing = false,
    this.distance = 0.0,
    this.onTap,
    this.size = 60,
  });
  final String userId;
  final String? profileImageUrl;
  final bool isOnline;
  final bool isViewed;
  final bool isViewing;
  final double distance;
  final VoidCallback? onTap;
  final double size;

  @override
  State<UserClusterBubble> createState() => _UserClusterBubbleState();
}

class _UserClusterBubbleState extends State<UserClusterBubble> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _viewFlashController;
  late AnimationController _pulseController;
  late AnimationController _glowController;

  late Animation<double> _breathingAnimation;
  late Animation<double> _viewFlashAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  bool _wasViewed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(UserClusterBubble oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger flash when someone views this profile
    if (!_wasViewed && widget.isViewed) {
      _triggerViewFlash();
    }
    _wasViewed = widget.isViewed;
  }

  void _setupAnimations() {
    // Continuous breathing effect
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );

    // Flash effect when viewed
    _viewFlashController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _viewFlashAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(
      CurvedAnimation(
        parent: _viewFlashController,
        curve: Curves.elasticOut,
      ),
    );

    // Pulse for online users
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeOut,
      ),
    );

    // Glow intensity
    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isOnline) {
      _pulseController.repeat();
    }
  }

  void _triggerViewFlash() {
    _viewFlashController.forward().then((_) {
      _viewFlashController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        // Trigger own flash effect when tapping
        _triggerViewFlash();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable?>[
          _breathingController,
          _viewFlashController,
          _pulseController,
          _glowController,
        ]),
        builder: (BuildContext context, Widget? child) {
          final double combinedScale = _breathingAnimation.value * _viewFlashAnimation.value;

          return SizedBox(
            width: widget.size * 2, // Extra space for glow effects
            height: widget.size * 2,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Outer glow ring
                _buildOuterGlow(combinedScale),

                // Pulse rings for online users
                if (widget.isOnline) _buildPulseRings(),

                // View flash overlay
                if (widget.isViewed || _viewFlashController.isAnimating)
                  _buildViewFlashOverlay(combinedScale),

                // Main profile bubble
                Transform.scale(
                  scale: combinedScale,
                  child: _buildMainBubble(),
                ),

                // Online indicator
                if (widget.isOnline) _buildOnlineIndicator(combinedScale),

                // Distance indicator
                _buildDistanceIndicator(combinedScale),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOuterGlow(double scale) {
    final double glowIntensity = _glowAnimation.value;
    final Color glowColor = widget.isViewed ? QuantumDesignTokens.neonMint : QuantumDesignTokens.turquoiseNeon;

    return Container(
      width: widget.size * 1.8 * scale,
      height: widget.size * 1.8 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            glowColor.withOpacity(0.1 * glowIntensity),
            glowColor.withOpacity(0.05 * glowIntensity),
            Colors.transparent,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: glowColor.withOpacity(0.3 * glowIntensity),
            blurRadius: 20 * scale,
            spreadRadius: 5 * scale,
          ),
        ],
      ),
    );
  }

  Widget _buildPulseRings() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(2, (int index) {
        final double delay = index * 0.5;
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
          scale: 1.0 + (adjustedAnimation.value * 0.8),
          child: Container(
            width: widget.size * 1.2,
            height: widget.size * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: QuantumDesignTokens.neonMint.withOpacity(
                  (1.0 - adjustedAnimation.value) * 0.8,
                ),
                width: 2,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildViewFlashOverlay(double scale) {
    final double flashIntensity =
        widget.isViewed ? 0.8 : _viewFlashAnimation.value - 1.0; // Only show during animation

    if (flashIntensity <= 0) return const SizedBox.shrink();

    return Container(
      width: widget.size * scale,
      height: widget.size * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            QuantumDesignTokens.neonMint.withOpacity(flashIntensity * 0.4),
            QuantumDesignTokens.neonMint.withOpacity(flashIntensity * 0.2),
            Colors.transparent,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: QuantumDesignTokens.neonMint.withOpacity(flashIntensity * 0.6),
            blurRadius: 30 * scale,
            spreadRadius: 10 * scale,
          ),
        ],
      ),
    );
  }

  Widget _buildMainBubble() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            QuantumDesignTokens.ultraLightMint.withOpacity(0.9),
            QuantumDesignTokens.turquoiseNeon.withOpacity(0.7),
            QuantumDesignTokens.neonMint.withOpacity(0.5),
          ],
        ),
        border: Border.all(
          color: widget.isViewed ? QuantumDesignTokens.neonMint : QuantumDesignTokens.turquoiseNeon,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (widget.isViewed ? QuantumDesignTokens.neonMint : QuantumDesignTokens.turquoiseNeon)
                .withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: widget.profileImageUrl != null
            ? Image.network(
                widget.profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) =>
                    _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            QuantumDesignTokens.ultraLightMint.withOpacity(0.3),
            QuantumDesignTokens.turquoiseNeon.withOpacity(0.2),
            QuantumDesignTokens.neonMint.withOpacity(0.1),
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        color: QuantumDesignTokens.neonMint,
        size: widget.size * 0.4,
      ),
    );
  }

  Widget _buildOnlineIndicator(double scale) {
    return Positioned(
      right: widget.size * 0.1,
      top: widget.size * 0.1,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: widget.size * 0.25,
          height: widget.size * 0.25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: QuantumDesignTokens.neonMint,
            border: Border.all(
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: QuantumDesignTokens.neonMint.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceIndicator(double scale) {
    final String distanceText = widget.distance < 1
        ? '${(widget.distance * 1000).round()}m'
        : '${widget.distance.toStringAsFixed(1)}km';

    return Positioned(
      bottom: -widget.size * 0.2,
      child: Transform.scale(
        scale: scale * 0.8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: QuantumDesignTokens.pureBlack.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: QuantumDesignTokens.neonMint.withOpacity(0.3),
            ),
          ),
          child: Text(
            distanceText,
            style: const TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: QuantumDesignTokens.neonMint,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _viewFlashController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }
}
