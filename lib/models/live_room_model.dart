// features/live/data/models/live_room_model.dart

class LiveRoom {
  LiveRoom({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.isProximityRoom,
    required this.tags,
    required this.participants,
    required this.isActive,
    required this.lastActive,
  });
  final String id;
  final String title;
  final String description;
  final String location;
  final bool isProximityRoom;
  final List<String> tags;
  final List<LiveParticipant> participants;
  final bool isActive;
  final DateTime lastActive;
}

class LiveParticipant {
  LiveParticipant({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.isSpeaking,
    required this.isPinned,
    required this.isAnonymous,
    required this.mood,
    required this.role,
  });
  final String userId;
  final String displayName;
  final String avatarUrl;
  final bool isSpeaking;
  final bool isPinned;
  final bool isAnonymous;
  final String mood;
  final String role;
}
