// lib/features/messages/domain/models/message_thread.dart
import 'package:meta/meta.dart';
import 'message.dart';

@immutable
class MessageThread {
  // Context-specific data (e.g., live room ID)

  const MessageThread({
    required this.id,
    required this.participantWalletAddresses,
    required this.createdAt,
    required this.displayName,
    required this.avatarUrl,
    required this.unreadCount,
    required this.isFavorite,
    this.lastMessage,
    this.metadata = const <String, dynamic>{},
  });

  // Factory to parse GraphQL JSON response
  factory MessageThread.fromJson(Map<String, dynamic> json) {
    return MessageThread(
      id: json['id'],
      participantWalletAddresses: List<String>.from(
        json['participants'].map((p) => p['walletAddress']),
      ),
      lastMessage: json['lastMessage'] != null ? Message.fromJson(json['lastMessage']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      displayName: json['displayName'] ?? _generateDisplayName(json['participants']),
      avatarUrl: json['avatarUrl'] ?? _generateAvatarUrl(json['participants']),
      unreadCount: json['unreadCount'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      metadata: json['metadata'] ?? <String, dynamic>{},
    );
  }
  final String id; // UUID
  final List<String> participantWalletAddresses;
  final Message? lastMessage;
  final DateTime createdAt;
  final String displayName; // Generated client-side based on participants
  final String avatarUrl; // Generated client-side or from BFF layer
  final int unreadCount;
  final bool isFavorite;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'participants': participantWalletAddresses
          .map((String addr) => <String, String>{'walletAddress': addr})
          .toList(),
      'lastMessage': lastMessage?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'unreadCount': unreadCount,
      'isFavorite': isFavorite,
      'metadata': metadata,
    };
  }

  // Client-side display name generation
  static String _generateDisplayName(List<dynamic> participants) {
    if (participants.length == 1) {
      return participants.first['username'] ?? 'Anonymous';
    } else if (participants.length == 2) {
      return participants.map((p) => p['username'] ?? 'Anonymous').join(' & ');
    } else {
      return 'Group Chat (${participants.length})';
    }
  }

  // Client-side avatar URL generation
  static String _generateAvatarUrl(List<dynamic> participants) {
    // For now, use first participant's avatar or default
    return participants.isNotEmpty
        ? participants.first['avatarUrl'] ?? '/assets/images/default-avatar.png'
        : '/assets/images/default-avatar.png';
  }

  // Backwards compatibility for existing UI
  String get user => displayName;
  String get message => lastMessage?.content ?? '';
  DateTime get timestamp => lastMessage?.createdAt ?? createdAt;

  // Helper methods
  MessageThread copyWith({
    String? id,
    List<String>? participantWalletAddresses,
    Message? lastMessage,
    DateTime? createdAt,
    String? displayName,
    String? avatarUrl,
    int? unreadCount,
    bool? isFavorite,
    Map<String, dynamic>? metadata,
  }) {
    return MessageThread(
      id: id ?? this.id,
      participantWalletAddresses: participantWalletAddresses ?? this.participantWalletAddresses,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      isFavorite: isFavorite ?? this.isFavorite,
      metadata: metadata ?? this.metadata,
    );
  }

  MessageThread markAsRead() {
    return copyWith(unreadCount: 0);
  }

  MessageThread updateLastMessage(Message message) {
    return copyWith(
      lastMessage: message,
      unreadCount: unreadCount + 1,
    );
  }
}
