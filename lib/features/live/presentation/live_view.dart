// lib/features/live/presentation/live_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/features/live/application/live_provider.dart';
import 'package:nvs/features/live/presentation/living_lens.dart';

class LiveView extends ConsumerWidget {
  const LiveView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ProximitySphereUpdate> sphereState = ref.watch(proximitySphereProvider);

    return Column(
      children: <Widget>[
        // --- Video Grid Area ---
        Container(
          height: 150,
          // This would be a horizontally scrolling list of video streams (Agora)
          // for users who have chosen to go "on camera" in the sphere.
          color: Colors.black.withOpacity(0.2),
          child: const Center(
            child: Text(
              'VIDEO PARTICIPANTS',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
          ),
        ),

        // --- The Living Lens ---
        const SizedBox(
          height: 200,
          child: LivingLens(),
        ),

        // --- Proximity Sphere Chat Log ---
        Expanded(
          child: sphereState.when(
            data: (ProximitySphereUpdate update) => ColoredBox(
              color: Colors.black.withOpacity(0.1),
              child: ListView.builder(
                itemCount: update.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  // Build a chat bubble for each message
                  final SphereMessage message = update.messages[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${message.senderWalletAddress.substring(0, 6)}...',
                          style: const TextStyle(
                            color: Colors.cyan,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.content,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            loading: () => const Center(
              child: Text(
                'ACQUIRING LOCAL SPHERE...',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            error: (Object e, StackTrace st) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
