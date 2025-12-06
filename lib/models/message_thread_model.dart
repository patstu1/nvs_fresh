/// Thread model for universal messaging system
class MessageThread {
  const MessageThread({
    required this.id,
    required this.displayName,
    required this.participantIds,
    required this.context,
    required this.createdAt,
    required this.lastMessageAt,
    this.avatarURL,
    this.lastMessageContent,
    this.lastMessageSenderId,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    this.isArchived = false,
    this.metadata = const <String, dynamic>{},
    this.type = ThreadType.direct,
    this.status = ThreadStatus.active,
  });

  factory MessageThread.fromJson(Map<String, dynamic> json) {
    return MessageThread(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatarURL: json['avatarURL'] as String?,
      participantIds: List<String>.from(json['participantIds'] as List),
      context: ThreadContext.values.firstWhere(
        (ThreadContext e) => e.name == json['context'] as String,
        orElse: () => ThreadContext.grid,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      lastMessageAt: DateTime.fromMillisecondsSinceEpoch(json['lastMessageAt'] as int),
      lastMessageContent: json['lastMessageContent'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? <String, dynamic>{},
      type: ThreadType.values.firstWhere(
        (ThreadType e) => e.name == json['type'] as String,
        orElse: () => ThreadType.direct,
      ),
      status: ThreadStatus.values.firstWhere(
        (ThreadStatus e) => e.name == json['status'] as String,
        orElse: () => ThreadStatus.active,
      ),
    );
  }
  final String id;
  final String displayName;
  final String? avatarURL;
  final List<String> participantIds;
  final ThreadContext context;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final String? lastMessageContent;
  final String? lastMessageSenderId;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;
  final bool isArchived;
  final Map<String, dynamic> metadata;
  final ThreadType type;
  final ThreadStatus status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'avatarURL': avatarURL,
      'participantIds': participantIds,
      'context': context.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastMessageAt': lastMessageAt.millisecondsSinceEpoch,
      'lastMessageContent': lastMessageContent,
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'isMuted': isMuted,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'metadata': metadata,
      'type': type.name,
      'status': status.name,
    };
  }

  MessageThread copyWith({
    String? id,
    String? displayName,
    String? avatarURL,
    List<String>? participantIds,
    ThreadContext? context,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    String? lastMessageContent,
    String? lastMessageSenderId,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    bool? isArchived,
    Map<String, dynamic>? metadata,
    ThreadType? type,
    ThreadStatus? status,
  }) {
    return MessageThread(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      avatarURL: avatarURL ?? this.avatarURL,
      participantIds: participantIds ?? this.participantIds,
      context: context ?? this.context,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  /// Get time display string
  String get timeDisplay {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(lastMessageAt);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 7).floor()}w';
    }
  }

  /// Check if thread has unread messages
  bool get hasUnreadMessages => unreadCount > 0;

  /// Get context emoji
  String get contextEmoji {
    switch (context) {
      case ThreadContext.grid:
        return '🏋️';
      case ThreadContext.now:
        return '📡';
      case ThreadContext.connect:
        return '🔗';
      case ThreadContext.live:
        return '📺';
    }
  }

  /// Get context color
  String get contextColor {
    switch (context) {
      case ThreadContext.grid:
        return '#A7FFE0'; // ultraLightMint
      case ThreadContext.now:
        return '#B0FF5A'; // avocadoGreen
      case ThreadContext.connect:
        return '#FF53A1'; // electricPink
      case ThreadContext.live:
        return '#00F7FF'; // turquoiseNeon
    }
  }

  /// Get type display
  String get typeDisplay {
    switch (type) {
      case ThreadType.direct:
        return 'Direct';
      case ThreadType.group:
        return 'Group';
      case ThreadType.room:
        return 'Room';
    }
  }

  /// Check if thread is group
  bool get isGroup => type == ThreadType.group;

  /// Check if thread is room chat
  bool get isRoomChat => type == ThreadType.room;

  /// Get participant count
  int get participantCount => participantIds.length;

  /// Get participant name (for backwards compatibility)
  String? get participantName => displayName;

  /// Get thread type as string (for UI filtering)
  String? get typeString {
    switch (context) {
      case ThreadContext.grid:
        return 'Grid';
      case ThreadContext.now:
        return 'Now';
      case ThreadContext.connect:
        return 'Connect';
      case ThreadContext.live:
        return 'Live';
    }
  }

  /// Get last message time for compatibility
  DateTime? get lastMessageTime => lastMessageAt;

  /// Get last message for compatibility
  String? get lastMessage => lastMessageContent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageThread && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum ThreadContext {
  grid,
  now,
  connect,
  live,
}

enum ThreadType {
  direct,
  group,
  room,
}

enum ThreadStatus {
  active,
  archived,
  blocked,
  deleted,
}
