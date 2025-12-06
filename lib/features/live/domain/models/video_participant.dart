// lib/features/live/domain/models/video_participant.dart

import 'user_role.dart';

class VideoParticipant {
  VideoParticipant({
    required this.userId,
    required this.displayName,
    required this.role,
    this.profileImage,
    this.isVideoEnabled = true,
    this.isAudioEnabled = true,
    this.isScreenSharing = false,
  });

  factory VideoParticipant.fromJson(Map<String, dynamic> json) {
    return VideoParticipant(
      userId: json['userId'],
      displayName: json['displayName'],
      profileImage: json['profileImage'],
      role: UserRole.values.firstWhere(
        (UserRole r) => r.name == json['role'],
        orElse: () => UserRole.participant,
      ),
      isVideoEnabled: json['isVideoEnabled'] ?? true,
      isAudioEnabled: json['isAudioEnabled'] ?? true,
      isScreenSharing: json['isScreenSharing'] ?? false,
    );
  }
  final String userId;
  final String displayName;
  final String? profileImage;
  final UserRole role;
  final bool isVideoEnabled;
  final bool isAudioEnabled;
  final bool isScreenSharing;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'displayName': displayName,
      'profileImage': profileImage,
      'role': role.name,
      'isVideoEnabled': isVideoEnabled,
      'isAudioEnabled': isAudioEnabled,
      'isScreenSharing': isScreenSharing,
    };
  }
}
