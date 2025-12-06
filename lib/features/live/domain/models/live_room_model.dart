// lib/features/live/domain/models/live_room_model.dart
class LiveRoomModel {
  LiveRoomModel({required this.id, required this.title, required this.participantCount});
  final String id;
  final String title;
  final int participantCount;
}
