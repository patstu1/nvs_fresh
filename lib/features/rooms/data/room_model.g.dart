// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['id'] as String,
      name: json['name'] as String,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : RoomMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'members': instance.members,
      'lastMessage': instance.lastMessage,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

RoomMessage _$RoomMessageFromJson(Map<String, dynamic> json) => RoomMessage(
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
    );

Map<String, dynamic> _$RoomMessageToJson(RoomMessage instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'text': instance.text,
      'sentAt': instance.sentAt?.toIso8601String(),
    };
