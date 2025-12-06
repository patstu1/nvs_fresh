import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class UserProfileDrawer extends StatefulWidget {
  const UserProfileDrawer({
    required this.user,
    required this.onClose,
    required this.isVisible,
    super.key,
    this.onMessage,
    this.onPhotoShare,
  });
  final UserProfile user;
  final VoidCallback onClose;
  final bool isVisible;
  final VoidCallback? onMessage;
  final VoidCallback? onPhotoShare;

  @override
  State<UserProfileDrawer> createState() => _UserProfileDrawerState();
}

class _UserProfileDrawerState extends State<UserProfileDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(UserProfileDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: NVSColors.cardBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(
              color: NVSColors.neonMint.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.neonMint.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: NVSColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close, color: NVSColors.ultraLightMint),
                ),
              ),

              // Profile content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      // Profile picture
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: NVSColors.neonMint,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: widget.user.photoURL != null && widget.user.photoURL!.isNotEmpty
                              ? Image.network(
                                  widget.user.photoURL!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) =>
                                      _buildPlaceholder(),
                                )
                              : _buildPlaceholder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Name and age
                      Text(
                        '${widget.user.displayName}, ${widget.user.age}',
                        style: const TextStyle(
                          fontFamily: 'MagdaClean',
                          color: NVSColors.ultraLightMint,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Role and emoji
                      if (widget.user.roleEmoji != null && widget.user.sexualRole != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: NVSColors.neonMint.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: NVSColors.neonMint.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                widget.user.roleEmoji!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.user.sexualRole!,
                                style: const TextStyle(
                                  fontFamily: 'MagdaClean',
                                  color: NVSColors.ultraLightMint,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: widget.onMessage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: NVSColors.neonMint,
                                foregroundColor: NVSColors.pureBlack,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'MESSAGE',
                                style: TextStyle(
                                  fontFamily: 'MagdaClean',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: widget.onPhotoShare,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: NVSColors.ultraLightMint,
                                side: const BorderSide(
                                  color: NVSColors.neonMint,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'SHARE PHOTO',
                                style: TextStyle(
                                  fontFamily: 'MagdaClean',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
  }

  Widget _buildPlaceholder() {
    return const ColoredBox(
      color: NVSColors.cardBackground,
      child: Icon(Icons.person, size: 50, color: NVSColors.ultraLightMint),
    );
  }
}
