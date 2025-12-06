import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/user_grid_provider.dart';

class GridUserCard extends StatelessWidget {
  final UserProfile user;
  final VoidCallback? onTap;

  const GridUserCard({super.key, required this.user, this.onTap});

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Top Dom Breeder':
        return const Color(0xFFCCFF33); // Lime
      case 'Power Bottom':
        return const Color(0xFFFF6699); // Pink
      case 'Vers':
        return const Color(0xFFB2FFD6); // Mint
      case 'Vers Top':
        return const Color(0xFFCCFF33); // Lime
      default:
        return const Color(0xFFB2FFD6); // Mint
    }
  }

  @override
  Widget build(BuildContext context) {
    final String role = user.sexualRole ?? '';
    final String? roleEmoji = user.roleEmoji;
    final double? match = user.compatibility;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: NVSColors.primaryLightMint,
            width: user.status.isOnline ? 3.5 : 2.5,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NVSColors.primaryLightMint.withOpacity(0.28),
              blurRadius: 22,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: NVSColors.turquoiseNeon.withOpacity(0.18),
              blurRadius: 28,
              spreadRadius: 1.2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: user.avatarUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            user.avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                user.displayName.isNotEmpty ? user.displayName[0] : '?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getRoleColor('Versatile'),
                                  fontFamily: 'MagdaCleanMono',
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          user.displayName.isNotEmpty ? user.displayName[0] : '?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getRoleColor('Versatile'),
                            fontFamily: 'MagdaCleanMono',
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),

              // Name
              Text(
                user.displayName,
                style: const TextStyle(
                  fontFamily: 'BellGothic',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.primaryLightMint,
                  shadows: [Shadow(color: NVSColors.primaryNeonMint, blurRadius: 4)],
                ),
                textAlign: TextAlign.center,
              ),

              // Distance
              Text(
                'Nearby', // Placeholder since UserProfile doesn't have distance
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 8,
                  color: Colors.grey.shade400,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Top-left match % badge if available
              if (match != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: NVSColors.avocadoGreen.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: NVSColors.avocadoGreen.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      '${match.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

              // Role tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: _getRoleColor(
                    role.isNotEmpty ? role : 'Versatile',
                  ).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _getRoleColor(role.isNotEmpty ? role : 'Versatile'),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  '${roleEmoji ?? ''} ${(role.isNotEmpty ? role : 'Versatile').toUpperCase()}',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: _getRoleColor(role.isNotEmpty ? role : 'Versatile'),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteHeart extends ConsumerWidget {
  const _FavoriteHeart({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Set<String>> favs = ref.watch(favoriteIdsProvider);
    final FavoritesService svc = ref.watch(favoritesServiceProvider);
    final bool isFav = favs.valueOrNull?.contains(userId) ?? false;
    return GestureDetector(
      onTap: () => svc.toggleFavorite(userId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (isFav ? NVSColors.avocadoGreen : NVSColors.primaryLightMint).withOpacity(
                0.35,
              ),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isFav ? NVSColors.avocadoGreen : NVSColors.primaryLightMint,
        ),
      ),
    );
  }
}
