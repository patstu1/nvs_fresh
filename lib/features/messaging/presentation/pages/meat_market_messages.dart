// NVS Meat Market Messages - Standard DM inbox
// Shows user's public profile pic, full name visible
// Chat history persists, send: text, photos, location, albums
// Unlock private pics per conversation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeatMarketMessages extends StatefulWidget {
  const MeatMarketMessages({super.key});

  @override
  State<MeatMarketMessages> createState() => _MeatMarketMessagesState();
}

class _MeatMarketMessagesState extends State<MeatMarketMessages>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Mock conversation data
  final List<_Conversation> _conversations = [
    _Conversation(
      id: '1',
      name: 'Marcus',
      age: 28,
      photoUrl: 'https://example.com/1.jpg',
      lastMessage: 'Hey! How\'s your day going?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isOnline: true,
      unreadCount: 2,
      isVerified: true,
      distance: '0.3 mi',
      privateUnlocked: false,
    ),
    _Conversation(
      id: '2',
      name: 'Jordan',
      age: 32,
      photoUrl: 'https://example.com/2.jpg',
      lastMessage: 'That sounds great, let\'s do it',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isOnline: true,
      unreadCount: 0,
      isVerified: true,
      distance: '1.2 mi',
      privateUnlocked: true,
    ),
    _Conversation(
      id: '3',
      name: 'Alex',
      age: 25,
      photoUrl: 'https://example.com/3.jpg',
      lastMessage: 'Photo',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isOnline: false,
      unreadCount: 1,
      isVerified: false,
      distance: '2.5 mi',
      privateUnlocked: false,
    ),
    _Conversation(
      id: '4',
      name: 'Ryan',
      age: 30,
      photoUrl: 'https://example.com/4.jpg',
      lastMessage: 'See you there!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isOnline: false,
      unreadCount: 0,
      isVerified: true,
      distance: '0.8 mi',
      privateUnlocked: true,
    ),
    _Conversation(
      id: '5',
      name: 'Tyler',
      age: 27,
      photoUrl: 'https://example.com/5.jpg',
      lastMessage: 'Thanks for the unlock 😏',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isOnline: false,
      unreadCount: 0,
      isVerified: false,
      distance: '5.0 mi',
      privateUnlocked: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _openConversation(_Conversation conversation) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _MeatMarketChatScreen(conversation: conversation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _conversations.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _conversations.length,
            itemBuilder: (context, index) => _buildConversationTile(_conversations[index]),
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: _mint.withOpacity(0.3),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start browsing Meat Market to connect',
            style: TextStyle(
              color: _mint.withOpacity(0.4),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(_Conversation conversation) {
    return GestureDetector(
      onTap: () => _openConversation(conversation),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          final hasUnread = conversation.unreadCount > 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasUnread ? _mint.withOpacity(0.5) : _mint.withOpacity(0.15),
                width: hasUnread ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: hasUnread
                  ? [
                      BoxShadow(
                        color: _mint.withOpacity(0.15 * _glowAnimation.value),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                _buildAvatar(conversation),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  conversation.name,
                                  style: TextStyle(
                                    color: _mint,
                                    fontSize: 15,
                                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${conversation.age}',
                                  style: TextStyle(
                                    color: _mint.withOpacity(0.5),
                                    fontSize: 13,
                                  ),
                                ),
                                if (conversation.isVerified) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.verified,
                                    color: _mint.withOpacity(0.7),
                                    size: 14,
                                  ),
                                ],
                                if (conversation.privateUnlocked) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.lock_open,
                                    color: _mint.withOpacity(0.5),
                                    size: 12,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(
                            _formatTimestamp(conversation.timestamp),
                            style: TextStyle(
                              color: _mint.withOpacity(0.4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _mint.withOpacity(hasUnread ? 0.8 : 0.5),
                                fontSize: 13,
                                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            conversation.distance,
                            style: TextStyle(
                              color: _mint.withOpacity(0.4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (conversation.unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _mint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${conversation.unreadCount}',
                      style: const TextStyle(
                        color: _black,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(_Conversation conversation) {
    return Stack(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: conversation.isOnline ? _mint : _mint.withOpacity(0.3),
              width: conversation.isOnline ? 2 : 1,
            ),
            boxShadow: conversation.isOnline
                ? [BoxShadow(color: _mint.withOpacity(0.3), blurRadius: 8)]
                : null,
          ),
          child: ClipOval(
            child: Container(
              color: _mint.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: _mint.withOpacity(0.4),
                size: 28,
              ),
            ),
          ),
        ),
        if (conversation.isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _mint,
                shape: BoxShape.circle,
                border: Border.all(color: _black, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}

class _Conversation {
  final String id;
  final String name;
  final int age;
  final String photoUrl;
  final String lastMessage;
  final DateTime timestamp;
  final bool isOnline;
  final int unreadCount;
  final bool isVerified;
  final String distance;
  final bool privateUnlocked;

  _Conversation({
    required this.id,
    required this.name,
    required this.age,
    required this.photoUrl,
    required this.lastMessage,
    required this.timestamp,
    required this.isOnline,
    required this.unreadCount,
    required this.isVerified,
    required this.distance,
    required this.privateUnlocked,
  });
}

// ============ CHAT SCREEN ============
class _MeatMarketChatScreen extends StatefulWidget {
  final _Conversation conversation;

  const _MeatMarketChatScreen({required this.conversation});

  @override
  State<_MeatMarketChatScreen> createState() => _MeatMarketChatScreenState();
}

class _MeatMarketChatScreenState extends State<_MeatMarketChatScreen>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      id: '1',
      text: 'Hey! I saw your profile, you seem interesting',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: MessageType.text,
    ),
    _ChatMessage(
      id: '2',
      text: 'Thanks! Yeah I just moved to the area',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      type: MessageType.text,
    ),
    _ChatMessage(
      id: '3',
      text: 'Oh nice! Where from?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      type: MessageType.text,
    ),
    _ChatMessage(
      id: '4',
      text: 'Originally from Chicago, but I\'ve been moving around a lot',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: MessageType.text,
    ),
    _ChatMessage(
      id: '5',
      text: 'Hey! How\'s your day going?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: MessageType.text,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(_ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
        type: MessageType.text,
      ));
    });
    _messageController.clear();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showAttachmentOptions() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAttachmentSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildChatHeader(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _buildMessage(_messages[index]),
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _mint.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back, color: _mint, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _mint.withOpacity(0.5)),
                ),
                child: ClipOval(
                  child: Container(
                    color: _mint.withOpacity(0.1),
                    child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 24),
                  ),
                ),
              ),
              if (widget.conversation.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _mint,
                      shape: BoxShape.circle,
                      border: Border.all(color: _black, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${widget.conversation.name}, ${widget.conversation.age}',
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.conversation.isVerified) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.verified, color: _mint.withOpacity(0.7), size: 14),
                    ],
                  ],
                ),
                Text(
                  widget.conversation.isOnline
                      ? 'Online • ${widget.conversation.distance}'
                      : '${widget.conversation.distance}',
                  style: TextStyle(
                    color: _mint.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildHeaderAction(Icons.photo_library_outlined, 'Album'),
          const SizedBox(width: 8),
          _buildHeaderAction(
            widget.conversation.privateUnlocked ? Icons.lock_open : Icons.lock_outline,
            'Private',
          ),
          const SizedBox(width: 8),
          _buildHeaderAction(Icons.more_vert, 'More'),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, String tooltip) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // Handle action
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: _mint.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: _mint.withOpacity(0.7), size: 18),
      ),
    );
  }

  Widget _buildMessage(_ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: message.isMe ? _mint.withOpacity(0.1) : Colors.transparent,
                  border: Border.all(
                    color: message.isMe ? _mint.withOpacity(0.4) : _mint.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                    bottomRight: Radius.circular(message.isMe ? 4 : 16),
                  ),
                  boxShadow: message.isMe
                      ? [
                          BoxShadow(
                            color: _mint.withOpacity(0.1 * _glowAnimation.value),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                        color: _mint.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatMessageTime(message.timestamp),
                      style: TextStyle(
                        color: _mint.withOpacity(0.4),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: _mint.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showAttachmentOptions,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(Icons.add, color: _mint, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: _mint, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(color: _mint.withOpacity(0.4)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: _mint),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: _mint.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(Icons.send, color: _mint, size: 20),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _black,
        border: Border.all(color: _mint.withOpacity(0.3)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _mint.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption(Icons.photo, 'Photo'),
              _buildAttachmentOption(Icons.photo_library, 'Album'),
              _buildAttachmentOption(Icons.location_on, 'Location'),
              _buildAttachmentOption(Icons.lock_open, 'Unlock'),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: _mint, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: _mint.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final amPm = timestamp.hour >= 12 ? 'PM' : 'AM';
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }
}

class _ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageType type;

  _ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.type,
  });
}

enum MessageType { text, photo, album, location }

