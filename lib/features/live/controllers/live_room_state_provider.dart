// lib/features/live/state/live_room_state_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<PinnedUsersNotifier, List<String>> pinnedUsersProvider =
    StateNotifierProvider<PinnedUsersNotifier, List<String>>(
  (StateNotifierProviderRef<PinnedUsersNotifier, List<String>> ref) => PinnedUsersNotifier(),
);

final StateNotifierProvider<RoomMessagesNotifier, List<String>> roomMessagesProvider =
    StateNotifierProvider<RoomMessagesNotifier, List<String>>(
  (StateNotifierProviderRef<RoomMessagesNotifier, List<String>> ref) => RoomMessagesNotifier(),
);

final StateProvider<String?> activeDMUserProvider =
    StateProvider<String?>((StateProviderRef<String?> ref) => null);

class PinnedUsersNotifier extends StateNotifier<List<String>> {
  PinnedUsersNotifier() : super(<String>[]);

  void togglePin(String avatar) {
    if (state.contains(avatar)) {
      state = state.where((String u) => u != avatar).toList();
    } else if (state.length < 4) {
      state = <String>[...state, avatar];
    }
  }

  void clear() => state = <String>[];
}

class RoomMessagesNotifier extends StateNotifier<List<String>> {
  RoomMessagesNotifier() : super(<String>[]);

  void send(String msg) {
    state = <String>[...state, msg];
  }

  void clear() => state = <String>[];
}
