import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isFromCurrentUser,
    this.senderImageUrl,
  });
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isFromCurrentUser;
  final String? senderImageUrl;
}

class NowChatPanel extends StatefulWidget {
  const NowChatPanel({
    required this.onClose,
    super.key,
    this.selectedUserId,
    this.selectedUserName,
  });
  final VoidCallback onClose;
  final String? selectedUserId;
  final String? selectedUserName;

  @override
  State<NowChatPanel> createState() => _NowChatPanelState();
}

class _NowChatPanelState extends State<NowChatPanel> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    _loadMockMessages();
  }

  void _loadMockMessages() {
    // Mock chat messages like Sniffies
    _messages.addAll(<ChatMessage>[
      ChatMessage(
        id: '1',
        senderId: 'user1',
        senderName: 'Anonymous',
        message: 'Hey, saw you on the map nearby 👋',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isFromCurrentUser: false,
      ),
      ChatMessage(
        id: '2',
        senderId: 'current',
        senderName: 'You',
        message: "Hey! Yeah I'm at the coffee shop",
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        isFromCurrentUser: true,
      ),
      ChatMessage(
        id: '3',
        senderId: 'user1',
        senderName: 'Anonymous',
        message: 'Cool! Mind if I join?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isFromCurrentUser: false,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: <Color>[
            NVSColors.pureBlack,
            NVSColors.pureBlack.withOpacity(0.95),
            NVSColors.primaryNeonMint.withOpacity(0.05),
          ],
        ),
        border: Border(
          left: BorderSide(
            color: NVSColors.primaryNeonMint.withOpacity(0.3),
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.primaryNeonMint.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          // Header
          _buildHeader(),

          // Messages
          Expanded(
            child: _buildMessagesList(),
          ),

          // Input area
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: NVSColors.primaryNeonMint.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          // User avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: NVSColors.primaryNeonMint,
                width: 2,
              ),
              color: NVSColors.primaryNeonMint.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.person,
              color: NVSColors.primaryNeonMint,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.selectedUserName ?? 'Anonymous User',
                  style: const TextStyle(
                    fontFamily: 'BellGothic',
                    color: NVSColors.primaryNeonMint,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Active now • 0.2km away',
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    color: NVSColors.ultraLightMint,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: <Widget>[
              _buildActionButton(Icons.videocam, () {
                // Video call functionality
              }),
              const SizedBox(width: 8),
              _buildActionButton(Icons.phone, () {
                // Voice call functionality
              }),
              const SizedBox(width: 8),
              _buildActionButton(Icons.close, widget.onClose),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: NVSColors.primaryNeonMint.withOpacity(0.3),
          ),
        ),
        child: Icon(
          icon,
          color: NVSColors.primaryNeonMint,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (BuildContext context, int index) {
        final ChatMessage message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isFromCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (!message.isFromCurrentUser) ...<Widget>[
            // Sender avatar
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: NVSColors.primaryNeonMint.withOpacity(0.5),
                ),
                color: NVSColors.primaryNeonMint.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.person,
                color: NVSColors.primaryNeonMint,
                size: 12,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(message.isFromCurrentUser ? 12 : 4),
                  bottomRight: Radius.circular(message.isFromCurrentUser ? 4 : 12),
                ),
                color: message.isFromCurrentUser
                    ? NVSColors.primaryNeonMint
                    : NVSColors.ultraLightMint.withOpacity(0.1),
                border: Border.all(
                  color: message.isFromCurrentUser
                      ? NVSColors.primaryNeonMint
                      : NVSColors.ultraLightMint.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message.message,
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: message.isFromCurrentUser
                          ? NVSColors.pureBlack
                          : NVSColors.ultraLightMint,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: message.isFromCurrentUser
                          ? NVSColors.pureBlack.withOpacity(0.7)
                          : NVSColors.ultraLightMint.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (message.isFromCurrentUser) ...<Widget>[
            const SizedBox(width: 8),
            // Your avatar
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: NVSColors.primaryNeonMint,
              ),
              child: const Icon(
                Icons.person,
                color: NVSColors.pureBlack,
                size: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: NVSColors.primaryNeonMint.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Quick actions
          GestureDetector(
            onTap: () {
              // Image/media picker
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: NVSColors.primaryNeonMint.withOpacity(0.3),
                ),
              ),
              child: const Icon(
                Icons.add,
                color: NVSColors.primaryNeonMint,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Text input
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: NVSColors.primaryNeonMint.withOpacity(0.3),
                ),
                color: NVSColors.primaryNeonMint.withOpacity(0.05),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  color: NVSColors.ultraLightMint,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    color: NVSColors.ultraLightMint.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Send button
          GestureDetector(
            onTap: () => _sendMessage(_messageController.text),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: NVSColors.primaryNeonMint,
              ),
              child: const Icon(
                Icons.send,
                color: NVSColors.pureBlack,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'current',
          senderName: 'You',
          message: text.trim(),
          timestamp: DateTime.now(),
          isFromCurrentUser: true,
        ),
      );
    });

    _messageController.clear();

    // Auto-scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
