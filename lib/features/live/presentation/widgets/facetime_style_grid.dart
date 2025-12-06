import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/features/live/data/live_user_list_provider.dart';

class FaceTimeStyleGrid extends ConsumerWidget {
  const FaceTimeStyleGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<UserProfile>> asyncUsers = ref.watch(liveUserListProvider);

    return asyncUsers.when(
      data: (List<UserProfile> users) => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final UserProfile user = users[index];
          return DecoratedBox(
            decoration: BoxDecoration(
              color: NVSColors.pureBlack.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NVSColors.dividerColor),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                const SizedBox(height: 12),
                Text(
                  user.displayName,
                  style: NVSTextStyles.cardTitle,
                ),
              ],
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stack) => const Center(child: Text('Error loading users')),
    );
  }
}
