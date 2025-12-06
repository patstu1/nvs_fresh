/// User roles in live video rooms
enum UserRole {
  participant,
  host,
  coHost,
  moderator,
  viewer,
}

/// User role utilities
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.participant:
        return 'Participant';
      case UserRole.host:
        return 'Host';
      case UserRole.coHost:
        return 'Co-Host';
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

  bool get canInvite {
    return this == UserRole.host || this == UserRole.coHost;
  }
}