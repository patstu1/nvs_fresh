import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'room_model.dart';
import 'room_repository.dart';

final Provider<RoomRepository> roomRepositoryProvider =
    Provider<RoomRepository>((ProviderRef<RoomRepository> ref) {
  return RoomRepository();
});

final StreamProvider<List<Room>> roomListProvider =
    StreamProvider<List<Room>>((StreamProviderRef<List<Room>> ref) {
  final RoomRepository repo = ref.watch(roomRepositoryProvider);
  return repo.getRooms();
});
