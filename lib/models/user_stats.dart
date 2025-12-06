// packages/core/lib/models/user_stats.dart

class UserStats {
  const UserStats({
    this.totalConnections = 0,
  });

  final int totalConnections;

  Map<String, dynamic> toJson() => {
    'totalConnections': totalConnections,
  };

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalConnections: map['totalConnections'] as int? ?? 0,
    );
  }
}
