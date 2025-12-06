import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/now_map_model.dart';

class UserAvatarWidget extends StatefulWidget {
  final NowMapUser user;
  final double size;
  final bool showGlow;
  final bool showPulse;
  final AnimationController? flashController;

  const UserAvatarWidget({
    super.key,
    required this.user,
    this.size = 90,
    this.showGlow = false,
    this.showPulse = false,
    this.flashController,
  });

  @override
  _UserAvatarWidgetState createState() => _UserAvatarWidgetState();
}

class _UserAvatarWidgetState extends State<UserAvatarWidget>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.flashController != null) {
      _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.flashController!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, widget.flashController]),
      builder: (context, child) {
        final scale = widget.showPulse ? _pulseAnimation.value : 1.0;
        final flashValue =
            widget.flashController != null ? _flashAnimation.value : 0.0;
        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (widget.showGlow)
                  BoxShadow(
                    color:
                        Colors.pinkAccent.withValues(alpha: 0.5 * (1 - flashValue)),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                if (flashValue > 0)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.8 * flashValue),
                    blurRadius: 32,
                    spreadRadius: 12,
                  ),
              ],
            ),
            child: CircleAvatar(
              radius: widget.size / 2,
              backgroundImage: NetworkImage(widget.user.profileImage!),
            ),
          ),
        );
      },
    );
  }
}

class ClusterAvatarWidget extends StatelessWidget {
  final UserCluster cluster;
  final double size;
  final VoidCallback? onTap;

  const ClusterAvatarWidget({
    super.key,
    required this.cluster,
    this.size = 80,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              cluster.clusterColor.withValues(alpha: 0.8),
              cluster.clusterColor.withValues(alpha: 0.4),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: cluster.clusterColor.withValues(alpha: 0.6),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Cluster count
            Center(
              child: Text(
                '${cluster.userCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Small avatars around the edge
            ...List.generate(
              cluster.users.take(4).length,
              (index) => _buildSmallAvatar(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallAvatar(int index) {
    final user = cluster.users[index];
    final angle = (index * 90) * (3.14159 / 180); // Convert to radians
    final radius = size * 0.35;
    final x = radius * cos(angle);
    final y = radius * sin(angle);

    return Positioned(
      left: (size / 2) + x - 15,
      top: (size / 2) + y - 15,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: user.profileImage != null
              ? CachedNetworkImage(
                  imageUrl: user.profileImage!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: cluster.clusterColor,
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 16),
                  ),
                )
              : Container(
                  color: cluster.clusterColor,
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 16),
                ),
        ),
      ),
    );
  }
}
