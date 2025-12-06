// lib/features/meatup/presentation/meatup_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/features/meatup/application/meatup_provider.dart';
import 'package:nvs/features/meatup/presentation/synaptic_tile.dart';

class MeatupView extends ConsumerWidget {
  const MeatupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ProfileWithScore>> profilesState = ref.watch(meatupControllerProvider);

    // Add a scroll controller to detect when to paginate
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        ref.read(meatupControllerProvider.notifier).fetchMoreProfiles();
      }
    });

    return profilesState.when(
      data: (List<ProfileWithScore> profiles) => GridView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(4.0).copyWith(bottom: 90), // Padding to avoid nav bar
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: profiles.length,
        itemBuilder: (BuildContext context, int index) {
          final ProfileWithScore profileWithScore = profiles[index];
          return SynapticTile(
            profile: profileWithScore.profile,
            compatibilityScore: profileWithScore.score,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, StackTrace st) => Center(child: Text('Error: $e')),
    );
  }
}
