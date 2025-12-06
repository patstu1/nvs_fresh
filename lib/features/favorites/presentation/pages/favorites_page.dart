import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<UserProfile>> favoritesAsync = ref.watch(favoritesListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, StackTrace st) => Center(child: Text('Error: $e')),
        data: (List<UserProfile> users) {
          if (users.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final UserProfile user = users[index];
                return _FavoriteUserTile(user: user);
              },
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteUserTile extends StatelessWidget {
  const _FavoriteUserTile({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/profile/${user.id}'),
      child: Card(
        color: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 38,
                backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty
                    ? NetworkImage(user.photoURL!)
                    : null,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: user.photoURL == null || user.photoURL!.isEmpty
                    ? const Icon(Icons.person, size: 38, color: AppTheme.primaryColor)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                user.displayName,
                style: const TextStyle(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${user.age} years',
                style: const TextStyle(
                  color: AppTheme.secondaryTextColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
