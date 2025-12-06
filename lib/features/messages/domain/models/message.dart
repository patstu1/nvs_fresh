// lib/features/messages/domain/models/message.dart
import 'package:meta/meta.dart';

@immutable
class Message {
  const Message({
    required this.id,
    required this.threadId,
    required this.senderWalletAddress,
    required this.content,
    required this.type,
    required this.context,
    required this.createdAt,
    this.replyToId,
  });

  // Factory to parse GraphQL JSON response
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      threadId: json['threadId'],
      senderWalletAddress: json['senderWalletAddress'],
      content: json['content'],
      type: MessageType.fromString(json['messageType']),
      context: ChatContextType.fromString(json['context']),
      createdAt: DateTime.parse(json['createdAt']),
      replyToId: json['replyToId'],
    );
  }
  final String id; // UUID
  final String threadId;
  final String senderWalletAddress;
  final String content; // Can be text or an IPFS URI
  final MessageType type;
  final ChatContextType context;
  final DateTime createdAt;
  final String? replyToId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'threadId': threadId,
      'senderWalletAddress': senderWalletAddress,
      'content': content,
      'messageType': type.toString().split('.').last,
      'context': context.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'replyToId': replyToId,
    };
  }

  // Backwards compatibility getters for existing UI
  String get displayName =>
      senderWalletAddress; // Will be enhanced with user lookup
  String get message => content;
  String? get reaction => null; // For future reaction system

  Map<String, dynamic> get metadata => <String, dynamic>{
        'sender': senderWalletAddress,
        'timestamp': createdAt,
        'type': type,
        'context': context,
      };
}

enum MessageType {
  text,
  image,
  video,
  audio,
  haptic_whisper,
  system_event;

  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (MessageType e) => e.toString().split('.').last == value,
      orElse: () => MessageType.text,
    );
  }
}

enum ChatContextType {
  grid,
  now,
  connect,
  live,
  direct;

  static ChatContextType fromString(String value) {
    return ChatContextType.values.firstWhere(
      (ChatContextType e) => e.toString().split('.').last == value,
      orElse: () => ChatContextType.direct,
    );
  }
}
