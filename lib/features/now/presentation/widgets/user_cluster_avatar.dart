import 'package:flutter/material.dart';
import 'package:nvs/data/now_map_model.dart';
import 'package:nvs/meatup_core.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserClusterAvatar extends StatelessWidget {
  const UserClusterAvatar({
    required this.user,
    super.key,
    this.isPulsing = false,
  });
  final NowMapUser user;
  final bool isPulsing;

  @override
  Widget build(BuildContext context) {
    final CircleAvatar avatar = CircleAvatar(
      radius: 30,
      backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
          ? NetworkImage(user.profileImage!)
          : null,
      backgroundColor: NVSColors.dividerColor,
      child: user.profileImage == null || user.profileImage!.isEmpty
          ? Text(
              user.displayName[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: NVSColors.neonMint,
              ),
            )
          : null,
    );

    if (isPulsing) {
      return avatar.animate(onPlay: (AnimationController controller) => controller.repeat()).tint(
            color: NVSColors.neonMint.withValues(alpha: 0.5),
            duration: 1500.ms,
          );
    }

    return avatar;
  }
}
