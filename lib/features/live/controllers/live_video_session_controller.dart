// lib/features/live/video/live_video_session_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
// Agora removed

final StateProvider<int?> remoteUidProvider =
    StateProvider<int?>((StateProviderRef<int?> ref) => null);
final StateProvider<bool> isInCallProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) => false);
final StateProvider<bool> isMutedProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) => false);
final StateProvider<bool> isVideoOnProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) => true);

Future<void> startVideoCall(WidgetRef ref) async {
  // Simulator-safe: no-op
  ref.read(isInCallProvider.notifier).state = true;
}

Future<void> endVideoCall(WidgetRef ref) async {
  ref.read(isInCallProvider.notifier).state = false;
  ref.read(remoteUidProvider.notifier).state = null;
  ref.read(isMutedProvider.notifier).state = false;
  ref.read(isVideoOnProvider.notifier).state = true;
}
