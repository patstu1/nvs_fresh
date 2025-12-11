// NVS Lookout Room Chat (Prompt 38)
// Public chat for room participants
// Visible to all users in the room with user tags and timestamps

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutRoomChat extends StatefulWidget {
  final String roomId;
  final String roomName;

  const LookoutRoomChat({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<LookoutRoomChat> createState() => _LookoutRoomChatState();
}

class _LookoutRoomChatState extends State<LookoutRoomChat> {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_RoomMessage> _messages = [];
  bool _showMentions = false;
  String _mentionFilter = '';

  // Mock users in room for mentions
  final List<String> _roomUsers = [
    'Alex', 'Jordan', 'Casey', 'Sam', 'Riley', 'Morgan', 'Taylor', 'Drew'
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialMessages() {
    _messages.addAll([
      _RoomMessage('Alex', 'Hey everyone! 👋', DateTime.now().subtract(const Duration(minutes: 5)), isSystem: false),
      _RoomMessage('Jordan', 'What\'s up!', DateTime.now().subtract(const Duration(minutes: 4)), isSystem: false),
      _RoomMessage('System', 'Casey joined the room', DateTime.now().subtract(const Duration(minutes: 3)), isSystem: true),
      _RoomMessage('Casey', 'Nice vibes in here', DateTime.now().subtract(const Duration(minutes: 2)), isSystem: false),
      _RoomMessage('Sam', 'Anyone from NYC?', DateTime.now().subtract(const Duration(minutes: 1)), isSystem: false),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _black,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: _mint.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMessagesList()),
          if (_showMentions) _buildMentionsSuggestions(),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: _mint.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          // Handle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: _olive.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.chat_bubble, color: _aqua, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'ROOM CHAT',
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${_roomUsers.length} users online',
                  style: TextStyle(color: _olive, fontSize: 12),
                ),
              ],
            ),
          ),
          // Close button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, color: _olive),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) => _buildMessage(_messages[index]),
    );
  }

  Widget _buildMessage(_RoomMessage message) {
    if (message.isSystem) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _olive.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: _olive, fontSize: 12),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _showUserOptions(message.sender),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _aqua.withOpacity(0.5)),
              ),
              child: ClipOval(
                child: Container(
                  color: _mint.withOpacity(0.1),
                  child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _insertMention(message.sender),
                      child: Text(
                        message.sender,
                        style: const TextStyle(
                          color: _aqua,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(message.timestamp),
                      style: TextStyle(color: _olive, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message.text,
                  style: TextStyle(
                    color: _mint.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentionsSuggestions() {
    final filteredUsers = _roomUsers
        .where((u) => u.toLowerCase().contains(_mentionFilter.toLowerCase()))
        .toList();

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return GestureDetector(
            onTap: () => _completeMention(user),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _aqua.withOpacity(0.5)),
                color: _aqua.withOpacity(0.1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: _aqua, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    user,
                    style: const TextStyle(color: _aqua, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: _black,
        border: Border(top: BorderSide(color: _mint.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          // Emoji button
          GestureDetector(
            onTap: _showEmojiPicker,
            child: Icon(Icons.emoji_emotions_outlined, color: _olive, size: 24),
          ),
          const SizedBox(width: 12),
          // Input field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _mint.withOpacity(0.2)),
              ),
              child: TextField(
                controller: _messageController,
                onChanged: _onTextChanged,
                style: const TextStyle(color: _mint),
                decoration: InputDecoration(
                  hintText: 'Message everyone...',
                  hintStyle: TextStyle(color: _olive),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _aqua,
              ),
              child: const Icon(Icons.send, color: _black, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _onTextChanged(String text) {
    // Check for @ mention
    final lastAtIndex = text.lastIndexOf('@');
    if (lastAtIndex != -1 && lastAtIndex < text.length - 1) {
      final afterAt = text.substring(lastAtIndex + 1);
      if (!afterAt.contains(' ')) {
        setState(() {
          _showMentions = true;
          _mentionFilter = afterAt;
        });
        return;
      }
    }
    setState(() => _showMentions = false);
  }

  void _insertMention(String username) {
    final currentText = _messageController.text;
    _messageController.text = '$currentText @$username ';
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  void _completeMention(String username) {
    final text = _messageController.text;
    final lastAtIndex = text.lastIndexOf('@');
    if (lastAtIndex != -1) {
      _messageController.text = '${text.substring(0, lastAtIndex)}@$username ';
      _messageController.selection = TextSelection.fromPosition(
        TextPosition(offset: _messageController.text.length),
      );
    }
    setState(() => _showMentions = false);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(_RoomMessage(
        'You',
        _messageController.text,
        DateTime.now(),
        isSystem: false,
      ));
      _messageController.clear();
      _showMentions = false;
    });
    
    HapticFeedback.selectionClick();
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _showUserOptions(String username) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _UserChatOptions(username: username),
    );
  }

  void _showEmojiPicker() {
    // Show emoji picker
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _RoomMessage {
  final String sender;
  final String text;
  final DateTime timestamp;
  final bool isSystem;

  _RoomMessage(this.sender, this.text, this.timestamp, {this.isSystem = false});
}

class _UserChatOptions extends StatelessWidget {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final String username;

  const _UserChatOptions({required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _olive.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _aqua),
                ),
                child: Icon(Icons.person, color: _mint.withOpacity(0.4)),
              ),
              const SizedBox(width: 14),
              Text(
                username,
                style: const TextStyle(
                  color: _mint,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildOption(context, Icons.chat_bubble, 'Send private message'),
          _buildOption(context, Icons.videocam, 'Start 1-on-1 cam'),
          _buildOption(context, Icons.person, 'View profile'),
          _buildOption(context, Icons.alternate_email, 'Mention in chat'),
          _buildOption(context, Icons.block, 'Block user', isDestructive: true),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.redAccent.shade200 : _mint;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(label, style: TextStyle(color: color, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}


