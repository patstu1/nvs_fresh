import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/mock_user_grid_provider.dart';

class NVSProfileCard extends StatefulWidget {
  final MockUser user;
  final VoidCallback onProfileClick;
  final VoidCallback onFavoriteToggle;

  const NVSProfileCard({
    super.key,
    required this.user,
    required this.onProfileClick,
    required this.onFavoriteToggle,
  });

  @override
  State<NVSProfileCard> createState() => _NVSProfileCardState();
}

class _NVSProfileCardState extends State<NVSProfileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onProfileClick,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: NVSColors.pureBlack,
          borderRadius: BorderRadius.circular(8), // More rounded for pop
          border: Border.all(
            color: _isPressed
                ? NVSColors.neonMint // Lighter turquoise when pressed
                : NVSColors.ultraLightMint, // Vibrant mint default
            width: _isPressed ? 3.0 : 2.0,
          ),
          boxShadow: [
            // Main glow - turquoise when pressed, mint when normal
            BoxShadow(
              color: _isPressed
                  ? NVSColors.neonMint.withValues(alpha: 0.5)
                  : NVSColors.ultraLightMint.withValues(alpha: 0.25),
              blurRadius: _isPressed ? 28 : 16,
              spreadRadius: _isPressed ? 4 : 2,
            ),
            // Secondary glow
            BoxShadow(
              color: NVSColors.ultraLightMint.withValues(alpha: 0.12),
              blurRadius: 20,
              spreadRadius: 0,
            ),
            // Subtle lift shadow
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: [
              // Background - pure matte black
              Container(
                decoration: const BoxDecoration(
                  color: NVSColors.pureBlack, // Pure flat black, no gradient
                ),
              ),

              Column(
                children: [
                  // Top section with compatibility and heart
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Compatibility percentage (top-left)
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: NVSColors.pureBlack.withValues(alpha: 0.9),
                                border: Border.all(
                                  color: NVSColors.ultraLightMint
                                      .withValues(alpha: _glowAnimation.value * 0.8),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: NVSColors.ultraLightMint.withOpacity(
                                        _glowAnimation.value * 0.3),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                  // Minimal lime green accent
                                  BoxShadow(
                                    color: NVSColors.neonLime.withOpacity(
                                        _glowAnimation.value * 0.1),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Text(
                                '${widget.user.matchPercent}%',
                                style: TextStyle(
                                  color: NVSColors.ultraLightMint,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: NVSColors.ultraLightMint
                                          .withValues(alpha: 0.4),
                                      blurRadius: 4,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Heart icon (top-right)
                        GestureDetector(
                          onTap: widget.onFavoriteToggle,
                          child: AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: NVSColors.pureBlack.withValues(alpha: 0.9),
                                  border: Border.all(
                                    color: widget.user.isFavorite
                                        ? NVSColors.neonLime
                                            .withValues(alpha: _glowAnimation.value)
                                        : NVSColors.ultraLightMint.withOpacity(
                                            _glowAnimation.value * 0.6),
                                    width: 1,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: widget.user.isFavorite
                                      ? [
                                          BoxShadow(
                                            color: NVSColors.neonLime
                                                .withOpacity(
                                                    _glowAnimation.value * 0.4),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Icon(
                                  widget.user.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: widget.user.isFavorite
                                      ? NVSColors.neonLime
                                      : NVSColors
                                          .ultraLightMint, // Vibrant mint
                                  size: 20,
                                  shadows: widget.user.isFavorite
                                      ? [
                                          Shadow(
                                            color: NVSColors.neonLime
                                                .withValues(alpha: 0.7),
                                            blurRadius: 10,
                                            offset: const Offset(0, 0),
                                          ),
                                          Shadow(
                                            color: NVSColors.ultraLightMint
                                                .withValues(alpha: 0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 0),
                                          ),
                                        ]
                                      : [
                                          Shadow(
                                            color: NVSColors.ultraLightMint
                                                .withValues(alpha: 0.5),
                                            blurRadius: 6,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center content area (photo or placeholder)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: widget.user.photoUrl != null &&
                              widget.user.photoUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.user.photoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildPlaceholder(),
                              ),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),

                  // Bottom info section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: NVSColors.pureBlack, // Pure flat black background
                      border: Border(
                        top: BorderSide(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Name and age
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${widget.user.name}, ${widget.user.age}',
                                style: TextStyle(
                                  color: NVSColors.ultraLightMint,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      color: NVSColors.ultraLightMint
                                          .withValues(alpha: 0.4),
                                      blurRadius: 4,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Online status dot
                            if (widget.user.isOnline) ...[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: NVSColors.neonLime,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          NVSColors.neonLime.withValues(alpha: 0.6),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 4),

                        // User ID
                        Text(
                          'User${widget.user.id.hashCode % 100}',
                          style: TextStyle(
                            color: NVSColors.ultraLightMint.withValues(alpha: 0.7),
                            fontSize: 9,
                            shadows: [
                              Shadow(
                                color:
                                    NVSColors.ultraLightMint.withValues(alpha: 0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: NVSColors.pureBlack.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Question mark icon
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: NVSColors.ultraLightMint
                        .withValues(alpha: _glowAnimation.value * 0.6),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: NVSColors.ultraLightMint
                          .withValues(alpha: _glowAnimation.value * 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                    // Minimal aqua accent
                    BoxShadow(
                      color: NVSColors.aquaOutline
                          .withValues(alpha: _glowAnimation.value * 0.1),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.help_outline,
                  color: NVSColors.ultraLightMint,
                  size: 20,
                  shadows: [
                    Shadow(
                      color: NVSColors.ultraLightMint.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
