import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nvs/meatup_core.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({
    required this.chatId,
    super.key,
  });
  final String chatId;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _sendAnimationController;
  late AnimationController _typingAnimationController;
  late Animation<double> _sendAnimation;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _sendAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sendAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _sendAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _errorMessage = 'You must be logged in to send messages';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _sendAnimationController.forward().then((_) {
        _sendAnimationController.reverse();
      });

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add(<String, dynamic>{
        'senderId': user.uid,
        'senderName': user.displayName ?? 'Anonymous',
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      });

      // Update chat metadata
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update(<Object, Object?>{
        'lastMessage': _messageController.text.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSender': user.uid,
      });

      _messageController.clear();
      setState(() {
        _isTyping = false;
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send message: $e';
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sendAnimationController.dispose();
    _typingAnimationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.video_call, color: AppTheme.primaryColor),
            onPressed: () {
              Navigator.of(context).pushNamed('/live');
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.primaryColor),
            onPressed: _showChatOptions,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Error message
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red.withValues(alpha: 0.1),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.error, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                  ),
                ],
              ),
            ),

          // Messages
          Expanded(
            child: _buildMessages(),
          ),

          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Error loading messages',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Please check your connection and try again',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(color: AppTheme.primaryColor),
                SizedBox(height: 16),
                Text(
                  'Loading messages...',
                  style: TextStyle(color: AppTheme.secondaryTextColor),
                ),
              ],
            ),
          );
        }

        final List<QueryDocumentSnapshot<Object?>> messages =
            snapshot.data?.docs ?? <QueryDocumentSnapshot<Object?>>[];

        if (messages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.chat_bubble_outline,
                  color: AppTheme.primaryColor.withValues(alpha: 0.5),
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No messages yet',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start the conversation!',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> message = messages[index].data() as Map<String, dynamic>;
            return _buildMessageItem(message, messages[index].id);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message, String messageId) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final bool isMyMessage = message['senderId'] == currentUser?.uid;
    final String senderId = message['senderId'] as String;
    final String senderName = message['senderName'] as String? ?? 'Anonymous';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isMyMessage) ...<Widget>[
            // User avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              child: Text(
                senderName.isNotEmpty ? senderName[0].toUpperCase() : 'A',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                if (!isMyMessage)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      senderName,
                      style: const TextStyle(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                // Message bubble
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMyMessage ? AppTheme.primaryColor : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isMyMessage
                          ? AppTheme.primaryColor
                          : AppTheme.neonBorderColor.withValues(alpha: 0.3),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: isMyMessage
                            ? AppTheme.primaryColor.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    (message['message'] as String?) ?? '',
                    style: TextStyle(
                      color: isMyMessage ? Colors.black : AppTheme.primaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Timestamp
                Text(
                  _formatTimestamp(message['timestamp']),
                  style: const TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isMyMessage) ...<Widget>[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              child: Text(
                currentUser?.displayName?.isNotEmpty ?? false
                    ? currentUser!.displayName![0].toUpperCase()
                    : 'M',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.neonBorderColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Attachment button
          IconButton(
            onPressed: _showAttachmentOptions,
            icon: const Icon(
              Icons.attach_file,
              color: AppTheme.primaryColor,
            ),
          ),

          // Message input
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppTheme.neonBorderColor.withValues(alpha: 0.5),
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: AppTheme.primaryTextColor),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: AppTheme.secondaryTextColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    _isTyping = value.isNotEmpty;
                  });
                },
                onSubmitted: (_) {
                  if (_isTyping && !_isLoading) {
                    _sendMessage();
                  }
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Send button
          AnimatedBuilder(
            animation: _sendAnimation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _sendAnimation.value,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isTyping && !_isLoading
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor.withValues(alpha: 0.3),
                    boxShadow: _isTyping && !_isLoading
                        ? <BoxShadow>[
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: IconButton(
                    onPressed: _isTyping && !_isLoading ? _sendMessage : null,
                    icon: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _isTyping ? Colors.black : AppTheme.primaryColor,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.send,
                            color: _isTyping ? Colors.black : AppTheme.primaryColor,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.secondaryTextColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.block, color: AppTheme.primaryColor),
              title: const Text(
                'Block User',
                style: TextStyle(color: AppTheme.primaryTextColor),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement block user
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: AppTheme.primaryColor),
              title: const Text(
                'Report Chat',
                style: TextStyle(color: AppTheme.primaryTextColor),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement report chat
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete Chat',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.secondaryTextColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo, color: AppTheme.primaryColor),
              title: const Text(
                'Photo',
                style: TextStyle(color: AppTheme.primaryTextColor),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement photo attachment
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
              title: const Text(
                'Camera',
                style: TextStyle(color: AppTheme.primaryTextColor),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: AppTheme.primaryColor),
              title: const Text(
                'Location',
                style: TextStyle(color: AppTheme.primaryTextColor),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement location sharing
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Delete Chat',
          style: TextStyle(color: AppTheme.primaryTextColor),
        ),
        content: const Text(
          'Are you sure you want to delete this chat? This action cannot be undone.',
          style: TextStyle(color: AppTheme.secondaryTextColor),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete chat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat deleted'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      final DateTime now = DateTime.now();
      final Duration diff = now.difference(timestamp.toDate());

      if (diff.inDays > 0) {
        return '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    }
    return 'Unknown';
  }
}
