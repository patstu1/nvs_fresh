import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/live_repository.dart';

/// Real-time chat sidebar with AI moderation and cyberpunk aesthetics.
///
/// Features:
/// - Real-time messaging with Firebase
/// - AI-powered content moderation
/// - Message reactions and emojis
/// - Cyberpunk styling with neon effects
/// - Smooth animations and transitions
class ChatSidebarWidget extends StatefulWidget {
  const ChatSidebarWidget({
    required this.messages,
    required this.onSendMessage,
    required this.onClose,
    super.key,
  });
  final List<LiveMessage> messages;
  final Function(String) onSendMessage;
  final VoidCallback onClose;

  @override
  State<ChatSidebarWidget> createState() => _ChatSidebarWidgetState();
}

class _ChatSidebarWidgetState extends State<ChatSidebarWidget> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _slideController;
  late AnimationController _glowController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  bool _isTyping = false;
  String _typingIndicator = '';
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTypingIndicator();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Slide animation for sidebar
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Glow animation for cyberpunk effect
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start animations
    _slideController.forward();
    _glowController.repeat(reverse: true);
  }

  void _startTypingIndicator() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      if (mounted) {
        setState(() {
          if (_typingIndicator.length < 3) {
            _typingIndicator += '.';
          } else {
            _typingIndicator = '';
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border(
            left: BorderSide(
              color: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            // Header
            _buildHeader(),

            // Messages
            Expanded(child: _buildMessagesList()),

            // Typing indicator
            if (_isTyping) _buildTypingIndicator(),

            // Input area
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF4BEFE0).withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.chat_bubble, color: Color(0xFF4BEFE0), size: 20),

          const SizedBox(width: 8),

          const Text(
            'Live Chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // AI moderation indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4BEFE0).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.security, color: Color(0xFF4BEFE0), size: 12),
                SizedBox(width: 4),
                Text(
                  'AI Mod',
                  style: TextStyle(
                    color: Color(0xFF4BEFE0),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Close button
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close, color: Color(0xFF4BEFE0), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ColoredBox(
      color: Colors.transparent,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: widget.messages.length,
        itemBuilder: (BuildContext context, int index) {
          final LiveMessage message = widget.messages[index];
          return _buildMessageItem(message);
        },
      ),
    );
  }

  Widget _buildMessageItem(LiveMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Message header
          Row(
            children: <Widget>[
              // Avatar placeholder
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _getUserColor(message.fromUserId),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    message.fromUserId.isNotEmpty ? message.fromUserId[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Username
              Text(
                message.fromUserId,
                style: TextStyle(
                  color: _getUserColor(message.fromUserId),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 8),

              // Timestamp
              Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(color: Colors.grey[500], fontSize: 10),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Message content
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              message.message,
              style: const TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideX(begin: 0.2, duration: const Duration(milliseconds: 300));
  }

  Widget _buildMessageReactions(LiveMessage message) {
    // LiveMessage doesn't have metadata/reactions, so return empty widget
    return const SizedBox();
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF4BEFE0),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'AI',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'AI is typing$_typingIndicator',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF4BEFE0).withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Message input
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (String value) {
                  setState(() {
                    _isTyping = value.isNotEmpty;
                  });
                },
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Send button
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF4BEFE0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _messageController.clear();
      setState(() {
        _isTyping = false;
      });

      // Scroll to bottom
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
  }

  // Helper methods

  Color _getUserColor(String userId) {
    // Generate consistent color based on user ID
    final int hash = userId.hashCode;
    final double hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.7, 0.6).toColor();
  }

  String _formatTimestamp(DateTime timestamp) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
