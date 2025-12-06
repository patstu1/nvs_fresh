// lib/features/live/domain/models/live_room_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'room_theme.dart';

enum RoomState { waiting, active, paused, ended }

// SentimentType moved to room_theme.dart to avoid conflicts

class LiveRoom {
  LiveRoom({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.activeUsers,
    required this.tags,
    required this.hostId,
    this.participants = const <String>[],
    this.maxParticipants = 100,
    this.isPrivate = false,
    this.isPremium = false,
    this.theme = RoomTheme.cyberpunkRave,
    this.state = RoomState.active,
    this.coHosts = const <String>[],
    this.currentSentiment = SentimentType.energetic,
    this.themeData = const <String, dynamic>{},
    this.settings = const <String, dynamic>{},
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Factory constructor for Firestore
  factory LiveRoom.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LiveRoom(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      emoji: data['emoji'] ?? '🎉',
      activeUsers: data['activeUsers'] ?? 0,
      tags: List<String>.from(data['tags'] ?? <dynamic>[]),
      participants: List<String>.from(data['participants'] ?? <dynamic>[]),
      maxParticipants: data['maxParticipants'] ?? 100,
      isPrivate: data['isPrivate'] ?? false,
      isPremium: data['isPremium'] ?? false,
      theme: RoomTheme.values.firstWhere(
        (RoomTheme t) => t.name == data['theme'],
        orElse: () => RoomTheme.cyberpunkRave,
      ),
      state: RoomState.values.firstWhere(
        (RoomState s) => s.name == data['state'],
        orElse: () => RoomState.active,
      ),
      hostId: data['hostId'] ?? '',
      coHosts: List<String>.from(data['coHosts'] ?? <dynamic>[]),
      currentSentiment: SentimentType.values.firstWhere(
        (SentimentType s) => s.name == data['currentSentiment'],
        orElse: () => SentimentType.energetic,
      ),
      themeData: Map<String, dynamic>.from(data['themeData'] ?? <dynamic, dynamic>{}),
      settings: Map<String, dynamic>.from(data['settings'] ?? <dynamic, dynamic>{}),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int activeUsers;
  final List<String> tags;
  final List<String> participants;
  final int maxParticipants;
  final bool isPrivate;
  final bool isPremium;
  final RoomTheme theme;
  final RoomState state;
  final String hostId;
  final List<String> coHosts;
  final SentimentType currentSentiment;
  final Map<String, dynamic> themeData;
  final Map<String, dynamic> settings;
  final DateTime createdAt;

  // Convenience getters
  int get participantCount => participants.length;
  bool get isFull => participants.length >= maxParticipants;
  bool get canJoin => !isFull && state == RoomState.active;

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'emoji': emoji,
      'activeUsers': activeUsers,
      'tags': tags,
      'participants': participants,
      'maxParticipants': maxParticipants,
      'isPrivate': isPrivate,
      'isPremium': isPremium,
      'theme': theme.name,
      'state': state.name,
      'hostId': hostId,
      'coHosts': coHosts,
      'currentSentiment': currentSentiment.name,
      'themeData': themeData,
      'settings': settings,
      'createdAt': createdAt,
    };
  }
}

class RoomMessage {
  RoomMessage({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.metadata = const <String, dynamic>{},
  });
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final Map<String, dynamic> metadata;

  // Getters for backwards compatibility
  String get displayName => userName;
  String get message => content;
  String? get reaction => metadata['reaction'] as String?;

  // Additional metadata getter for chat sidebar
  Map<String, dynamic> get metadataGetter => <String, dynamic>{
        'sender': userId,
        'timestamp': timestamp,
        'type': type,
        'userName': userName,
        'content': content,
        // Add anything else your sidebar expects
      };
}

enum MessageType {
  text,
  emoji,
  system,
  themeChange,
  icebreaker,
  reaction,
}
