import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'live_room_model.dart';
import 'live_repository.dart' as repo;
import 'package:cloud_firestore/cloud_firestore.dart';

// Firestore instance provider (for testability)
final Provider<FirebaseFirestore> firestoreProvider =
    Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

// Live rooms list - using comprehensive LiveRoom model
final FutureProvider<List<LiveRoom>> liveRoomsProvider =
    FutureProvider<List<LiveRoom>>((FutureProviderRef<List<LiveRoom>> ref) async {
  final FirebaseFirestore db = ref.watch(firestoreProvider);
  final QuerySnapshot<Map<String, dynamic>> snap =
      await db.collection('live_rooms').orderBy('createdAt', descending: true).limit(50).get();
  return snap.docs.map(LiveRoom.fromFirestore).toList();
});

// Current room chat (based on room ID) - using simple repository for chat data
final ProviderFamily<List<RoomMessage>, String> fullChatProvider =
    Provider.family<List<RoomMessage>, String>((_, String roomId) {
  // Real-time chat integration can be added later
  return const <RoomMessage>[];
});

// Private chat between two users - using simple repository for chat data
final ProviderFamily<List<RoomMessage>, List<String>> privateChatProvider =
    Provider.family<List<RoomMessage>, List<String>>((_, List<String> ids) {
  return const <RoomMessage>[];
});

// List of all live users across all rooms
final FutureProvider<List<UserProfile>> liveUserListProvider =
    FutureProvider<List<UserProfile>>((FutureProviderRef<List<UserProfile>> ref) async {
  // Use repository-provided live rooms to derive a robust list of users for simulator/dev
  final List<repo.LiveRoom> rooms = await repo.LiveRepository().getLiveRooms();
  final Map<String, UserProfile> unique = <String, UserProfile>{};
  for (final repo.LiveRoom r in rooms) {
    for (final UserProfile u in r.users) {
      unique[u.id] = u;
    }
  }
  return unique.values.toList();
});
// Removed mock comprehensive rooms
