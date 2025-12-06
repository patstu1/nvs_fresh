import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSession {
  ChatSession({
    required this.id,
    required this.participants,
    required this.updatedAt,
    this.lastMessage,
    this.isRoom = false,
  });

  factory ChatSession.fromFirestore(DocumentSnapshot doc) {
    final Map data = doc.data() as Map<String, dynamic>;
    return ChatSession(
      id: doc.id,
      participants: List<String>.from(data['participants'] as Iterable? ?? <dynamic>[]),
      lastMessage: data['lastMessage'] != null
          ? Message.fromMap(data['lastMessage'] as Map<String, dynamic>)
          : null,
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isRoom: data['isRoom'] as bool? ?? false,
    );
  }
  final String id;
  final List<String> participants;
  final Message? lastMessage;
  final DateTime updatedAt;
  final bool isRoom;
}

class Message {
  Message({
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      content: map['content'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
  final String senderId;
  final String content;
  final DateTime timestamp;
}
