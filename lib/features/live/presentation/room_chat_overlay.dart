// lib/features/live/presentation/room_chat_overlay.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomChatOverlay extends ConsumerStatefulWidget {
  const RoomChatOverlay({super.key});

  @override
  ConsumerState<RoomChatOverlay> createState() => _RoomChatOverlayState();
}

class _RoomChatOverlayState extends ConsumerState<RoomChatOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample messages data
  final List<ChatMessage> _roomMessages = <ChatMessage>[
    ChatMessage(
      id: '1',
      senderName: 'CryptoKnight',
      senderWallet: '0x1234...5678',
      content: 'Welcome to Berlin Underground! 🎵',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: ChatMessageType.room,
    ),
    ChatMessage(
      id: '2',
      senderName: 'NeonDreamer',
      senderWallet: '0x2345...6789',
      content: 'This track is 🔥',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      type: ChatMessageType.room,
    ),
    ChatMessage(
      id: '3',
      senderName: 'QuantumSoul',
      senderWallet: '0x3456...7890',
      content: 'Anyone know the artist?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      type: ChatMessageType.room,
    ),
  ];

  final List<WhisperMessage> _whispers = <WhisperMessage>[
    WhisperMessage(
      id: 'w1',
      fromName: 'CryptoKnight',
      fromWallet: '0x1234...5678',
      content: 'Hey, want to start a breakout room?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isRead: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          // Header with tabs
          _buildChatHeader(),

          // Chat content area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildRoomChat(),
                _buildWhispersChat(),
              ],
            ),
          ),

          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.cyan.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text(
                'ROOM CHAT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.grey, size: 20),
                onPressed: () {
                  // Chat settings
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.cyan,
            labelColor: Colors.cyan,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              const Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.public, size: 16),
                    SizedBox(width: 4),
                    Text('ROOM'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.message, size: 16),
                    const SizedBox(width: 4),
                    const Text('WHISPERS'),
                    if (_whispers
                        .any((WhisperMessage w) => !w.isRead)) ...<Widget>[
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomChat() {
    return Column(
      children: <Widget>[
        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _roomMessages.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildMessageBubble(_roomMessages[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWhispersChat() {
    if (_whispers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.message_outlined, color: Colors.grey, size: 48),
            SizedBox(height: 16),
            Text(
              'No whispers yet',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap on a user to send a private message',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _whispers.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildWhisperItem(_whispers[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                message.senderName.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header with name and time
                Row(
                  children: <Widget>[
                    Text(
                      message.senderName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(message.timestamp),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Message text
                Text(
                  message.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhisperItem(WhisperMessage whisper) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whisper.isRead
            ? Colors.grey[900]?.withOpacity(0.5)
            : Colors.cyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              whisper.isRead ? Colors.grey[700]! : Colors.cyan.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                whisper.fromName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                _formatTimestamp(whisper.timestamp),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            whisper.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: () => _replyToWhisper(whisper),
                child:
                    const Text('REPLY', style: TextStyle(color: Colors.cyan)),
              ),
              TextButton(
                onPressed: () => _startBreakout(whisper),
                child: const Text(
                  'BREAKOUT',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.cyan.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: _tabController.index == 0
                    ? 'Message the room...'
                    : 'Reply to whisper...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.cyan),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _sendMessage(_messageController.text),
            icon: const Icon(Icons.send, color: Colors.cyan),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // TODO: Send message via GraphQL
    print('Sending message: $text');

    _messageController.clear();
  }

  void _replyToWhisper(WhisperMessage whisper) {
    // Switch to whisper tab and focus on this conversation
    _tabController.animateTo(1);
    setState(() {
      whisper.isRead = true;
    });
  }

  void _startBreakout(WhisperMessage whisper) {
    // TODO: Start breakout room with this user
    print('Starting breakout with ${whisper.fromName}');
  }

  String _formatTimestamp(DateTime timestamp) {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h';
    } else {
      return '${diff.inDays}d';
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

enum ChatMessageType { room, whisper, system }

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.senderWallet,
    required this.content,
    required this.timestamp,
    required this.type,
  });
  final String id;
  final String senderName;
  final String senderWallet;
  final String content;
  final DateTime timestamp;
  final ChatMessageType type;
}

class WhisperMessage {
  WhisperMessage({
    required this.id,
    required this.fromName,
    required this.fromWallet,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });
  final String id;
  final String fromName;
  final String fromWallet;
  final String content;
  final DateTime timestamp;
  bool isRead;
}
