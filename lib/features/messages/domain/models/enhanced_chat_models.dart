// Enhanced chat models for the messaging system

class EnhancedChatThread {
  EnhancedChatThread({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.isOnline,
    required this.status,
    required this.lastActivity,
    required this.messages,
  });
  final String id;
  final String userName;
  final String avatarUrl;
  final bool isOnline;
  final String status;
  final DateTime lastActivity;
  final List<EnhancedChatMessage> messages;
}

class EnhancedChatMessage {
  EnhancedChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.type = MessageType.text,
    this.mediaUrl,
    this.replyToId,
  });
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final MessageType type;
  final String? mediaUrl;
  final String? replyToId;
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}
