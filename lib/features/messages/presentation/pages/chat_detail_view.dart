import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../domain/models/message_thread.dart';

/// Chat detail view for individual conversations
class ChatDetailView extends StatefulWidget {
  const ChatDetailView({
    required this.thread, super.key,
  });
  final MessageThread thread;

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = <Map<String, dynamic>>[];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(<String, dynamic>{
        'text': _messageController.text.trim(),
        'isMe': true,
        'timestamp': DateTime.now(),
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        backgroundColor: NVSColors.pureBlack,
        title: Text(
          widget.thread.displayName,
          style: const TextStyle(
            color: NVSColors.ultraLightMint,
            fontFamily: 'MagdaCleanMono',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: NVSColors.ultraLightMint,
        ),
      ),
      body: Column(
        children: <Widget>[
          // Messages area
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: NVSColors.secondaryText,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Start the conversation',
                          style: TextStyle(
                            color: NVSColors.secondaryText,
                            fontSize: 16,
                            fontFamily: 'MagdaCleanMono',
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> message = _messages[_messages.length - 1 - index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: NVSColors.cardBackground,
              border: Border(
                top: BorderSide(
                  color: NVSColors.dividerColor,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(
                      color: NVSColors.ultraLightMint,
                      fontFamily: 'MagdaCleanMono',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(
                        color: NVSColors.secondaryText,
                        fontFamily: 'MagdaCleanMono',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: NVSColors.dividerColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: NVSColors.dividerColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: NVSColors.ultraLightMint,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: NVSColors.ultraLightMint,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isMe = message['isMe'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (!isMe) ...<Widget>[
            CircleAvatar(
              radius: 16,
              backgroundColor: NVSColors.ultraLightMint,
              child: Text(
                widget.thread.displayName[0],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isMe ? NVSColors.ultraLightMint : NVSColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: !isMe ? Border.all(color: NVSColors.dividerColor) : null,
              ),
              child: Text(
                message['text'] ?? '',
                style: TextStyle(
                  color: isMe ? Colors.black : NVSColors.ultraLightMint,
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isMe) ...<Widget>[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: NVSColors.avocadoGreen,
              child: Text(
                'Me',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
