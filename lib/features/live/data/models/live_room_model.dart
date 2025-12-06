// lib/features/live/data/models/live_room_model.dart
import 'package:nvs/features/live/data/room_theme.dart';

class LiveRoom {
  LiveRoom({
    required this.id,
    required this.title,
    required this.theme,
    required this.participantCount,
    required this.tags,
    required this.currentSentiment,
    this.isPrivate = false,
    this.maxParticipants = 200,
  });
  final String id;
  final String title;
  final RoomTheme theme;
  final bool isPrivate;
  final int participantCount;
  final int maxParticipants;
  final List<String> tags;
  final SentimentType currentSentiment;
}
