// packages/core/lib/models/user_status.dart

enum UserStatusType { online, offline, away, busy }

class UserStatus {
  final UserStatusType status;
  final DateTime lastSeen;
  final String? customMessage;

  const UserStatus({
    required this.status,
    required this.lastSeen,
    this.customMessage,
  });

  factory UserStatus.online() {
    return UserStatus(status: UserStatusType.online, lastSeen: DateTime.now());
  }

  factory UserStatus.offline() {
    return UserStatus(status: UserStatusType.offline, lastSeen: DateTime.now());
  }

  bool get isOnline => status == UserStatusType.online;

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString().split('.').last,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'customMessage': customMessage,
    };
  }

  factory UserStatus.fromFirestore(Map<String, dynamic> data) {
    return UserStatus(
      status: UserStatusType.values.firstWhere(
        (e) => e.toString() == 'UserStatusType.${data['status']}',
        orElse: () => UserStatusType.offline,
      ),
      lastSeen: data['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['lastSeen'])
          : DateTime.now(),
      customMessage: data['customMessage'],
    );
  }
}
