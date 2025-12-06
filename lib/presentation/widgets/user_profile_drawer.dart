import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserProfileDrawer extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onClose;

  const UserProfileDrawer({
    super.key,
    required this.user,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose, // Tap outside to close
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping inside the drawer
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: NVSColors.pureBlack.withValues(alpha: 0.9),
                border: const Border(
                    top: BorderSide(color: NVSColors.dividerColor)),
                boxShadow: NVSColors.mintGlow,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(user.displayName, style: NvsTextStyles.display),
                  const SizedBox(height: 8),
                  Text('${user.age} // ${user.sexualRole}',
                      style: NvsTextStyles.body),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to full profile
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NVSColors.neonMint,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                    ),
                    child: Text(
                      'VIEW PROFILE',
                      style: NvsTextStyles.label
                          .copyWith(color: NVSColors.pureBlack, fontSize: 14),
                    ),
                  )
                ],
              ),
            ).animate().slideY(
                  begin: 1,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOutCubic,
                ),
          ),
        ),
      ),
    );
  }
}
