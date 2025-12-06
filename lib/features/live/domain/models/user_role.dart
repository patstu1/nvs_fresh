// lib/features/live/domain/models/user_role.dart

enum UserRole {
  host,
  coHost,
  participant,
  moderator,
  viewer,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.host:
        return 'Host';
      case UserRole.coHost:
        return 'Co-Host';
      case UserRole.participant:
        return 'Participant';
      case UserRole.moderator:
        return 'Moderator';
      case UserRole.viewer:
        return 'Viewer';
    }
  }

  bool get canModerate {
    return this == UserRole.host ||
        this == UserRole.coHost ||
        this == UserRole.moderator;
  }

  bool get canSpeak {
    return this != UserRole.viewer;
  }
}
