import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/connect_provider.dart';

class ConnectPage extends ConsumerWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectUsersAsync = ref.watch(connectUserListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Connect',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: connectUsersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No compatible users found.'));
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
                final user = users[index];
                return _ConnectUserTile(user: user);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ConnectUserTile extends StatelessWidget {
  const _ConnectUserTile({required this.user});
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    const int compatibility = 0;
    final List? interests = user.toJson()['interests'] as List<dynamic>?;
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.favorite, color: AppTheme.primaryColor, size: 16),
                  SizedBox(width: 4),
                  Text(
                    '$compatibility%',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (interests != null && interests.isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  interests.take(3).join(', '),
                  style: const TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
