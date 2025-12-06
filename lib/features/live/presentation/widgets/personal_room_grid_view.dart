import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/mock_personal_room_users.dart';

class PersonalRoomGridView extends StatelessWidget {
  const PersonalRoomGridView({
    required this.users,
    required this.onUserTap,
    super.key,
  });
  final List<MockPersonalRoomUser> users;
  final Function(MockPersonalRoomUser) onUserTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        final user = users[index];
        return _buildUserCell(user, index)
            .animate(delay: Duration(milliseconds: index * 50))
            .fadeIn(duration: const Duration(milliseconds: 400))
            .slideY(begin: 0.3, duration: const Duration(milliseconds: 400));
      },
    );
  }

  Widget _buildUserCell(MockPersonalRoomUser user, int index) {
    return GestureDetector(
      onTap: () => onUserTap(user),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: NVSColors.nvsBlack.withValues(alpha: 0.8),
          border: Border.all(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Avatar with glow effect
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Glow effect
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
                    border: Border.all(
                      color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      user.username.substring(0, 2),
                      style: TextStyle(
                        fontFamily: 'MagdaClean',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        foreground: Paint()..color = NVSColors.ultraLightMint,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                // Online indicator
                if (user.isOnline)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: NVSColors.aquaOutline,
                        border: Border.all(
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // Username
            Text(
              user.username,
              style: TextStyle(
                fontFamily: 'MagdaClean',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                foreground: Paint()..color = NVSColors.ultraLightMint,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Match percentage
            Text(
              '${user.matchPercentage.toInt()}%',
              style: TextStyle(
                fontFamily: 'MagdaClean',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                foreground: Paint()..color = NVSColors.aquaOutline,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 2),

            // Proximity
            Text(
              user.proximity,
              style: TextStyle(
                fontFamily: 'MagdaClean',
                fontSize: 8,
                fontWeight: FontWeight.w300,
                foreground: Paint()..color = NVSColors.ultraLightMint.withValues(alpha: 0.6),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
