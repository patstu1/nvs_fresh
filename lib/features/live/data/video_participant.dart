import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'room_participant.dart';
import 'user_role.dart';

/// Video-specific participant data for WebRTC streams
class VideoParticipant extends RoomParticipant {
  const VideoParticipant({
    required super.userId,
    required super.displayName,
    super.profileImageUrl,
    super.role = UserRole.participant,
    super.isVideoEnabled = true,
    super.isAudioEnabled = true,
    super.isHandRaised = false,
    super.joinedAt,
    super.isHost = false,
    super.isMuted = false,
    super.metadata = const <String, dynamic>{},
    this.videoRenderer,
    this.uid,
    this.hasVideoStream = false,
    this.hasAudioStream = false,
    this.isLocalUser = false,
    this.channelId,
    this.streamMetadata = const <String, dynamic>{},
  });

  // Factory constructor that properly initializes joinedAt
  factory VideoParticipant.create({
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
    RTCVideoRenderer? videoRenderer,
    int? uid,
    bool hasVideoStream = false,
    bool hasAudioStream = false,
    bool isLocalUser = false,
    String? channelId,
    Map<String, dynamic> streamMetadata = const <String, dynamic>{},
  }) {
    return VideoParticipant(
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
      videoRenderer: videoRenderer,
      uid: uid,
      hasVideoStream: hasVideoStream,
      hasAudioStream: hasAudioStream,
      isLocalUser: isLocalUser,
      channelId: channelId,
      streamMetadata: streamMetadata,
    );
  }

  // Convert from RoomParticipant
  factory VideoParticipant.fromRoomParticipant(
    RoomParticipant participant, {
    RTCVideoRenderer? videoRenderer,
    int? uid,
    bool hasVideoStream = false,
    bool hasAudioStream = false,
    bool isLocalUser = false,
    String? channelId,
    Map<String, dynamic> streamMetadata = const <String, dynamic>{},
  }) {
    return VideoParticipant.create(
      userId: participant.userId,
      displayName: participant.displayName,
      profileImageUrl: participant.profileImageUrl,
      role: participant.role,
      isVideoEnabled: participant.isVideoEnabled,
      isAudioEnabled: participant.isAudioEnabled,
      isHandRaised: participant.isHandRaised,
      joinedAt: participant.joinedAt,
      isHost: participant.isHost,
      isMuted: participant.isMuted,
      metadata: participant.metadata,
      videoRenderer: videoRenderer,
      uid: uid,
      hasVideoStream: hasVideoStream,
      hasAudioStream: hasAudioStream,
      isLocalUser: isLocalUser,
      channelId: channelId,
      streamMetadata: streamMetadata,
    );
  }
  final RTCVideoRenderer? videoRenderer;
  final int? uid; // Agora UID
  final bool hasVideoStream;
  final bool hasAudioStream;
  final bool isLocalUser;
  final String? channelId;
  final Map<String, dynamic> streamMetadata;

  // Copy with method
  @override
  VideoParticipant copyWith({
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
    RTCVideoRenderer? videoRenderer,
    int? uid,
    bool? hasVideoStream,
    bool? hasAudioStream,
    bool? isLocalUser,
    String? channelId,
    Map<String, dynamic>? streamMetadata,
  }) {
    return VideoParticipant.create(
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
      videoRenderer: videoRenderer ?? this.videoRenderer,
      uid: uid ?? this.uid,
      hasVideoStream: hasVideoStream ?? this.hasVideoStream,
      hasAudioStream: hasAudioStream ?? this.hasAudioStream,
      isLocalUser: isLocalUser ?? this.isLocalUser,
      channelId: channelId ?? this.channelId,
      streamMetadata: streamMetadata ?? this.streamMetadata,
    );
  }

  @override
  String toString() =>
      'VideoParticipant(userId: $userId, displayName: $displayName, uid: $uid, hasVideo: $hasVideoStream)';
}
