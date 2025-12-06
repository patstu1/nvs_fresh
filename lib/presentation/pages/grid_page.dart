import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Removed go_router import - not needed for simple navigation
import 'package:nvs/meatup_core.dart';
import '../../data/user_grid_provider.dart';

class GridPage extends ConsumerWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userGridAsync = ref.watch(userGridListProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'DISCOVER',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent.shade100,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: Colors.greenAccent.shade100,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filters coming soon!')),
              );
            },
          ),
        ],
      ),
      body: userGridAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.greenAccent),
        ),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No users found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: users.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3-column layout as specified
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75, // Adjusted for 3-column layout
              ),
              itemBuilder: (context, index) {
                final user = users[index];
                return NeonUserTile(user: user);
              },
            ),
          );
        },
      ),
    );
  }
}

class NeonUserTile extends StatelessWidget {
  final UserProfile user;

  const NeonUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to profile - simplified for now
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile: ${user.displayName}')));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.greenAccent.shade100, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.shade100.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage:
                    user.photoURL != null && user.photoURL!.isNotEmpty
                    ? NetworkImage(user.photoURL!)
                    : null,
                backgroundColor: Colors.greenAccent.withValues(alpha: 0.1),
                child: user.photoURL == null || user.photoURL!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 36,
                        color: Colors.greenAccent,
                      )
                    : null,
              ),
              Text(
                '${user.displayName}, ${user.age}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent.shade100,
                  fontSize: 16,
                ),
              ),
              Text(
                '${user.roleEmoji ?? '🔞'} ${user.sexualRole ?? 'ROLE'}',
                style: TextStyle(
                  color: Colors.greenAccent.shade100.withValues(alpha: 0.85),
                  fontSize: 13,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${user.compatibility ?? '??%'} MATCH',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.greenAccent.shade100,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
