import 'package:flutter/material.dart';
import '../../data/now_map_model.dart';
import 'package:nvs/meatup_core.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserClusterAvatar extends StatelessWidget {
  final NowMapUser user;
  final bool isPulsing;

  const UserClusterAvatar({
    super.key,
    required this.user,
    this.isPulsing = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 30,
      backgroundImage:
          user.profileImage != null && user.profileImage!.isNotEmpty
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
      return avatar.animate(onPlay: (controller) => controller.repeat()).tint(
            color: NVSColors.neonMint.withValues(alpha: 0.5),
            duration: 1500.ms,
          );
    }

    return avatar;
  }
}
