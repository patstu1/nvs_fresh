// lib/features/messages/presentation/pages/realtime_chat_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/message.dart';
import '../../domain/models/message_thread.dart';
import '../../data/realtime_message_service.dart';
import '../../../core/theme/nvs_colors.dart';

class RealtimeChatView extends ConsumerStatefulWidget {
  const RealtimeChatView({
    required this.thread,
    required this.contextType,
    super.key,
  });
  final MessageThread thread;
  final ChatContextType contextType;

  @override
  ConsumerState<RealtimeChatView> createState() => _RealtimeChatViewState();
}

class _RealtimeChatViewState extends ConsumerState<RealtimeChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = <Message>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _subscribeToNewMessages();
  }

  Future<void> _loadInitialMessages() async {
    try {
      final RealtimeMessageService service = ref.read(realtimeMessageServiceProvider);
      final List<Message> messages = await service.getMessages(widget.thread.id);

      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages.reversed); // Show oldest first
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Failed to load messages: $e');
      }
    }
  }

  void _subscribeToNewMessages() {
    final AsyncValue<Message> messageStream = ref.read(messageStreamProvider(widget.thread.id));

    messageStream.listen(
      (AsyncValue<Message> asyncMessage) {
        asyncMessage.when(
          data: (Message message) {
            if (mounted) {
              setState(() {
                _messages.add(message);
              });
              _scrollToBottom();
            }
          },
          error: (Object error, StackTrace stackTrace) {
            _showError('Real-time connection error: $error');
          },
          loading: () {
            // Connection is loading, show indicator if needed
          },
        );
      },
    );
  }

  Future<void> _sendMessage() async {
    final String content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();

    try {
      final RealtimeMessageService service = ref.read(realtimeMessageServiceProvider);

      // Send message based on context type
      late Message sentMessage;
      switch (widget.contextType) {
        case ChatContextType.grid:
          sentMessage = await service.sendGridMessage(widget.thread.id, content);
          break;
        case ChatContextType.now:
          sentMessage = await service.sendNowMessage(widget.thread.id, content);
          break;
        case ChatContextType.connect:
          sentMessage = await service.sendConnectMessage(widget.thread.id, content);
          break;
        case ChatContextType.live:
          sentMessage = await service.sendLiveMessage(widget.thread.id, content);
          break;
        case ChatContextType.direct:
          sentMessage = await service.sendDirectMessage(widget.thread.id, content);
          break;
      }

      // Message will be received via subscription, no need to add manually
    } catch (e) {
      _showError('Failed to send message: $e');
      // Restore the message text on error
      _messageController.text = content;
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: NVSColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.background,
      appBar: AppBar(
        title: Text(
          widget.thread.displayName,
          style: const TextStyle(
            color: NVSColors.neonMint,
            fontFamily: 'MagdaCleanMono',
          ),
        ),
        backgroundColor: NVSColors.surface,
        iconTheme: const IconThemeData(color: NVSColors.neonMint),
        elevation: 0,
        actions: <Widget>[
          // Context indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: _getContextColor(widget.contextType),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.contextType.toString().split('.').last.toUpperCase(),
              style: const TextStyle(
                color: NVSColors.background,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Real-time connection status indicator
          _buildConnectionStatus(),

          // Messages list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(NVSColors.neonMint),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final AsyncValue<Message> messageStream =
            ref.watch(messageStreamProvider(widget.thread.id));

        return messageStream.when(
          data: (_) => Container(
            height: 2,
            color: NVSColors.neonMint,
          ),
          error: (_, __) => Container(
            height: 2,
            color: NVSColors.error,
          ),
          loading: () => Container(
            height: 2,
            color: NVSColors.warning,
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(Message message) {
    final bool isMe = message.senderWalletAddress == 'current_user_wallet'; // TODO: Get from auth

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? NVSColors.neonMint : NVSColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: (isMe ? NVSColors.neonMint : NVSColors.surface).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!isMe)
              Text(
                message.displayName,
                style: TextStyle(
                  color: NVSColors.textSecondary,
                  fontSize: 12,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
            const SizedBox(height: 4),
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? NVSColors.background : NVSColors.textPrimary,
                fontSize: 16,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    color: isMe ? NVSColors.background.withOpacity(0.7) : NVSColors.textSecondary,
                    fontSize: 11,
                    fontFamily: 'MagdaCleanMono',
                  ),
                ),
                if (message.type != MessageType.text)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getMessageTypeColor(message.type),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.type.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(
                        color: NVSColors.background,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: NVSColors.surface,
        border: Border(
          top: BorderSide(color: NVSColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(
                color: NVSColors.textPrimary,
                fontFamily: 'MagdaCleanMono',
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  color: NVSColors.textSecondary,
                  fontFamily: 'MagdaCleanMono',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: NVSColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: NVSColors.neonMint),
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
          FloatingActionButton.small(
            onPressed: _sendMessage,
            backgroundColor: NVSColors.neonMint,
            foregroundColor: NVSColors.background,
            elevation: 0,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Color _getContextColor(ChatContextType context) {
    switch (context) {
      case ChatContextType.grid:
        return NVSColors.neonMint;
      case ChatContextType.now:
        return NVSColors.neonBlue;
      case ChatContextType.connect:
        return NVSColors.neonPurple;
      case ChatContextType.live:
        return NVSColors.neonRed;
      case ChatContextType.direct:
        return NVSColors.neonYellow;
    }
  }

  Color _getMessageTypeColor(MessageType type) {
    switch (type) {
      case MessageType.text:
        return NVSColors.textSecondary;
      case MessageType.image:
        return NVSColors.neonBlue;
      case MessageType.video:
        return NVSColors.neonPurple;
      case MessageType.audio:
        return NVSColors.neonYellow;
      case MessageType.haptic_whisper:
        return NVSColors.neonMint;
      case MessageType.system_event:
        return NVSColors.neonRed;
    }
  }

  String _formatTime(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
