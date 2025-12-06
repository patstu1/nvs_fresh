import 'package:json_annotation/json_annotation.dart';
part 'room_model.g.dart';

@JsonSerializable()
class Room {
  const Room({
    required this.id,
    required this.name,
    required this.members,
    this.lastMessage,
    this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  final String id;
  final String name;
  final List<String> members;
  final RoomMessage? lastMessage;
  final DateTime? updatedAt;
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}

@JsonSerializable()
class RoomMessage {
  const RoomMessage({
    required this.senderId,
    required this.text,
    this.sentAt,
  });

  factory RoomMessage.fromJson(Map<String, dynamic> json) => _$RoomMessageFromJson(json);
  final String senderId;
  final String text;
  final DateTime? sentAt;
  Map<String, dynamic> toJson() => _$RoomMessageToJson(this);
}
