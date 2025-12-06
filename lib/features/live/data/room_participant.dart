import 'user_role.dart';

/// Represents a participant in a live video room
class RoomParticipant {
  RoomParticipant({
    required this.userId,
    required this.displayName,
    this.profileImageUrl,
    this.role = UserRole.participant,
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isHandRaised = false,
    DateTime? joinedAt,
    this.isHost = false,
    this.isMuted = false,
    this.metadata = const <String, dynamic>{},
  }) : joinedAt = joinedAt ?? DateTime.now();

  // Factory constructor that properly initializes joinedAt
  factory RoomParticipant.create({
    required String userId,
    required String displayName,
    String? profileImageUrl,
    UserRole role = UserRole.participant,
    bool isVideoEnabled = true,
    bool isAudioEnabled = true,
    bool isHandRaised = false,
    DateTime? joinedAt,
    bool isHost = false,
    bool isMuted = false,
    Map<String, dynamic> metadata = const <String, dynamic>{},
  }) {
    return RoomParticipant(
      userId: userId,
      displayName: displayName,
      profileImageUrl: profileImageUrl,
      role: role,
      isVideoEnabled: isVideoEnabled,
      isAudioEnabled: isAudioEnabled,
      isHandRaised: isHandRaised,
      joinedAt: joinedAt ?? DateTime.now(),
      isHost: isHost,
      isMuted: isMuted,
      metadata: metadata,
    );
  }
  final String userId;
  final String displayName;
  final String? profileImageUrl;
  final UserRole role;
  final bool isVideoEnabled;
  final bool isAudioEnabled;
  final bool isHandRaised;
  final DateTime joinedAt;
  final bool isHost;
  final bool isMuted;
  final Map<String, dynamic> metadata;

  // Copy with method
  RoomParticipant copyWith({
    String? userId,
    String? displayName,
    String? profileImageUrl,
    UserRole? role,
    bool? isVideoEnabled,
    bool? isAudioEnabled,
    bool? isHandRaised,
    DateTime? joinedAt,
    bool? isHost,
    bool? isMuted,
    Map<String, dynamic>? metadata,
  }) {
    return RoomParticipant.create(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      isHandRaised: isHandRaised ?? this.isHandRaised,
      joinedAt: joinedAt ?? this.joinedAt,
      isHost: isHost ?? this.isHost,
      isMuted: isMuted ?? this.isMuted,
      metadata: metadata ?? this.metadata,
    );
  }

  // Convenience getters
  bool get canModerate => role.canModerate;
  bool get canInvite => role.canInvite;

  @override
  String toString() => 'RoomParticipant(userId: $userId, displayName: $displayName, role: $role)';
}
