class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    this.targetId,
    this.createdAt,
    this.read = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      body: json['body'],
      targetId: json['targetId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      read: json['read'] ?? false,
    );
  }
  final String id;
  final String type;
  final String title;
  final String? body;
  final String? targetId;
  final DateTime? createdAt;
  final bool read;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      'targetId': targetId,
      'createdAt': createdAt?.toIso8601String(),
      'read': read,
    };
  }
}
