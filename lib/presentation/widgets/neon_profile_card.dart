// packages/grid/lib/presentation/widgets/neon_profile_card.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

/// Enhanced profile card with neon styling for the production grid
class NeonProfileCard extends StatefulWidget {
  final UserProfile user;
  final VoidCallback onTap;
  final VoidCallback onMessage;

  const NeonProfileCard({
    super.key,
    required this.user,
    required this.onTap,
    required this.onMessage,
  });

  @override
  State<NeonProfileCard> createState() => _NeonProfileCardState();
}

class _NeonProfileCardState extends State<NeonProfileCard> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this)
      ..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _isHovered ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) => setState(() => _isHovered = false),
            onTapCancel: () => setState(() => _isHovered = false),
            child: Container(
              decoration: BoxDecoration(
                color: NVSColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: NVSColors.ultraLightMint.withValues(alpha: _glowAnimation.value * 0.8),
                  width: 2 + (_isHovered ? 1 : 0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: NVSColors.ultraLightMint.withValues(alpha: _glowAnimation.value * 0.4),
                    blurRadius: 16 + (_isHovered ? 8 : 0),
                    spreadRadius: 2 + (_isHovered ? 1 : 0),
                  ),
                  BoxShadow(
                    color: NVSColors.turquoiseNeon.withValues(alpha: _glowAnimation.value * 0.2),
                    blurRadius: 24 + (_isHovered ? 12 : 0),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Image
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        image: widget.user.avatarUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(widget.user.avatarUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                        gradient: widget.user.avatarUrl.isEmpty
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  NVSColors.ultraLightMint.withValues(alpha: 0.3),
                                  NVSColors.turquoiseNeon.withValues(alpha: 0.2),
                                ],
                              )
                            : null,
                      ),
                      child: widget.user.avatarUrl.isEmpty
                          ? Center(
                              child: Text(
                                widget.user.displayName.isNotEmpty
                                    ? widget.user.displayName[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontFamily: 'BellGothic',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: NVSColors.ultraLightMint,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),

                  // Profile Info
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name and Status
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.user.displayName.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'BellGothic',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: NVSColors.ultraLightMint,
                                  shadows: [
                                    Shadow(
                                      color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.user.status.isOnline ? 'ONLINE' : 'OFFLINE',
                                style: TextStyle(
                                  fontFamily: 'MagdaCleanMono',
                                  fontSize: 10,
                                  color: widget.user.status.isOnline
                                      ? NVSColors.avocadoGreen
                                      : NVSColors.secondaryText,
                                ),
                              ),
                            ],
                          ),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: widget.onMessage,
                                  child: Container(
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'MSG',
                                        style: TextStyle(
                                          fontFamily: 'MagdaCleanMono',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: NVSColors.ultraLightMint,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: NVSColors.avocadoGreen.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: NVSColors.avocadoGreen.withValues(alpha: 0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: NVSColors.avocadoGreen,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
