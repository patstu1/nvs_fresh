import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class UserClusterAvatar extends StatefulWidget {
  const UserClusterAvatar({
    required this.user,
    super.key,
    this.size = 60,
    this.onTap,
    this.showPulse = true,
  });
  final UserProfile user;
  final double size;
  final VoidCallback? onTap;
  final bool showPulse;

  @override
  State<UserClusterAvatar> createState() => _UserClusterAvatarState();
}

class _UserClusterAvatarState extends State<UserClusterAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: widget.showPulse ? _pulseAnimation.value : 1.0,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: NVSColors.neonMint,
                  width: 3,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.neonMint.withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: widget.user.photoURL != null && widget.user.photoURL!.isNotEmpty
                    ? Image.network(
                        widget.user.photoURL!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (BuildContext context, Object error, StackTrace? stackTrace) =>
                                _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return ColoredBox(
      color: NVSColors.cardBackground,
      child: Icon(
        Icons.person,
        size: widget.size * 0.5,
        color: NVSColors.ultraLightMint,
      ),
    );
  }
}
