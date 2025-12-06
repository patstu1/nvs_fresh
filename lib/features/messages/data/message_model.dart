import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class ChatSession {
  ChatSession({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => _$ChatSessionFromJson(json);
  final String id;
  final List<String> participants;
  final ChatMessage? lastMessage;
  final DateTime? updatedAt;
  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);
}

@JsonSerializable()
class ChatMessage {
  ChatMessage({
    required this.senderId,
    required this.content,
    this.sentAt,
    this.readAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  final String senderId;
  final String content;
  final DateTime? sentAt;
  final DateTime? readAt;
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
