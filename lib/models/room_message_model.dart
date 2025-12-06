/// Message model for live room chat
class RoomMessage {
  const RoomMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderDisplayName,
    required this.content,
    required this.type,
    required this.timestamp,
    this.senderPhotoURL,
    this.metadata = const <String, dynamic>{},
    this.reactions = const <String>[],
    this.isHighlighted = false,
    this.isPinned = false,
    this.replyToMessageId,
    this.status = MessageStatus.sent,
  });

  factory RoomMessage.fromJson(Map<String, dynamic> json) {
    return RoomMessage(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      senderId: json['senderId'] as String,
      senderDisplayName: json['senderDisplayName'] as String,
      senderPhotoURL: json['senderPhotoURL'] as String?,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (MessageType e) => e.name == json['type'] as String,
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      metadata: json['metadata'] as Map<String, dynamic>? ?? <String, dynamic>{},
      reactions: List<String>.from(json['reactions'] as List? ?? <dynamic>[]),
      isHighlighted: json['isHighlighted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      replyToMessageId: json['replyToMessageId'] as String?,
      status: MessageStatus.values.firstWhere(
        (MessageStatus e) => e.name == json['status'] as String,
        orElse: () => MessageStatus.sent,
      ),
    );
  }
  final String id;
  final String roomId;
  final String senderId;
  final String senderDisplayName;
  final String? senderPhotoURL;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final List<String> reactions;
  final bool isHighlighted;
  final bool isPinned;
  final String? replyToMessageId;
  final MessageStatus status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'senderDisplayName': senderDisplayName,
      'senderPhotoURL': senderPhotoURL,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'metadata': metadata,
      'reactions': reactions,
      'isHighlighted': isHighlighted,
      'isPinned': isPinned,
      'replyToMessageId': replyToMessageId,
      'status': status.name,
    };
  }

  RoomMessage copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? senderDisplayName,
    String? senderPhotoURL,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    List<String>? reactions,
    bool? isHighlighted,
    bool? isPinned,
    String? replyToMessageId,
    MessageStatus? status,
  }) {
    return RoomMessage(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      senderDisplayName: senderDisplayName ?? this.senderDisplayName,
      senderPhotoURL: senderPhotoURL ?? this.senderPhotoURL,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      reactions: reactions ?? this.reactions,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      isPinned: isPinned ?? this.isPinned,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      status: status ?? this.status,
    );
  }

  /// Get time display string
  String get timeDisplay {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  /// Check if message is from system
  bool get isSystemMessage => type == MessageType.system;

  /// Check if message has reactions
  bool get hasReactions => reactions.isNotEmpty;

  /// Get reaction count
  int get reactionCount => reactions.length;

  /// Check if message is a reply
  bool get isReply => replyToMessageId != null;

  /// Get type emoji
  String get typeEmoji {
    switch (type) {
      case MessageType.text:
        return '💬';
      case MessageType.image:
        return '🖼️';
      case MessageType.video:
        return '📹';
      case MessageType.audio:
        return '🎤';
      case MessageType.file:
        return '📎';
      case MessageType.system:
        return '⚙️';
      case MessageType.yo:
        return '👋';
      case MessageType.gift:
        return '🎁';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomMessage && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  system,
  yo,
  gift,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}
