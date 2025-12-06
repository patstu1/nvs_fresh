import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nvs/meatup_core.dart';
import 'dart:async';
import 'dart:math';

class EphemeralChat extends StatefulWidget {
  final String? roomId;
  final Duration messageDuration;

  const EphemeralChat({super.key, this.roomId, this.messageDuration = const Duration(minutes: 5)});

  @override
  State<EphemeralChat> createState() => _EphemeralChatState();
}

class _EphemeralChatState extends State<EphemeralChat> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<EphemeralMessage> _messages = [];
  final Map<String, Timer> _messageTimers = {};

  late AnimationController _glowController;
  late AnimationController _fadeController;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadExistingMessages();
    _startTypingIndicator();
  }

  void _setupAnimations() {
    _glowController = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);

    _fadeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  void _loadExistingMessages() {
    // Simulate loading existing messages
    _addDemoMessages();
  }

  void _addDemoMessages() {
    final demoMessages = [
      "Just arrived at the location 👀",
      "Anyone else here?",
      "This place is wild 🔥",
      "Looking for someone adventurous",
      "The vibe is perfect tonight",
    ];

    for (int i = 0; i < demoMessages.length; i++) {
      Timer(Duration(milliseconds: i * 500), () {
        if (mounted) {
          _addMessage(demoMessages[i], isOwn: false);
        }
      });
    }
  }

  void _startTypingIndicator() {
    Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted && Random().nextBool()) {
        setState(() {
          _isTyping = true;
        });
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
          }
        });
      }
    });
  }

  void _addMessage(String text, {bool isOwn = true}) {
    final message = EphemeralMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      timestamp: DateTime.now(),
      isOwn: isOwn,
      expiresAt: DateTime.now().add(widget.messageDuration),
    );

    setState(() {
      _messages.add(message);
    });

    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Set timer to remove message
    _messageTimers[message.id] = Timer(widget.messageDuration, () {
      _removeMessage(message.id);
    });

    HapticFeedback.lightImpact();
  }

  void _removeMessage(String messageId) {
    if (mounted) {
      setState(() {
        _messages.removeWhere((msg) => msg.id == messageId);
      });
      _messageTimers[messageId]?.cancel();
      _messageTimers.remove(messageId);
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _addMessage(text);
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _fadeController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    for (var timer in _messageTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildChatInfo(),
          Expanded(child: _buildMessagesList()),
          if (_isTyping) _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withOpacity(0.5 + (_glowController.value * 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ephemeral Chat',
                style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: AppTheme.primaryColor),
    );
  }

  Widget _buildChatInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: AppTheme.primaryColor.withValues(alpha: 0.7), size: 16),
          const SizedBox(width: 8),
          Text(
            'Messages disappear in ${widget.messageDuration.inMinutes}m',
            style: TextStyle(color: AppTheme.primaryColor.withValues(alpha: 0.7), fontSize: 12),
          ),
          const Spacer(),
          Text(
            '${_messages.length} messages',
            style: TextStyle(color: AppTheme.primaryColor.withValues(alpha: 0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(EphemeralMessage message) {
    final timeLeft = message.expiresAt.difference(DateTime.now());
    final opacity = (timeLeft.inSeconds / widget.messageDuration.inSeconds).clamp(0.3, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: message.isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isOwn) _buildAvatar(false),
          if (!message.isOwn) const SizedBox(width: 8),
          Flexible(
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: message.isOwn
                      ? const LinearGradient(
                          colors: <Color>[NVSColors.primaryLightMint, NVSColors.turquoiseNeon],
                        )
                      : LinearGradient(
                          colors: [
                            AppTheme.surfaceColor.withValues(alpha: 0.8),
                            AppTheme.surfaceColor.withValues(alpha: 0.6),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(message.text, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTimestamp(message.timestamp),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: opacity > 0.7
                                ? const Color(0xFF00FF88)
                                : opacity > 0.4
                                ? Colors.orange
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (message.isOwn) const SizedBox(width: 8),
          if (message.isOwn) _buildAvatar(true),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isOwn) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isOwn
            ? const LinearGradient(
                colors: <Color>[NVSColors.primaryLightMint, NVSColors.turquoiseNeon],
              )
            : LinearGradient(
                colors: [AppTheme.surfaceColor, AppTheme.surfaceColor.withValues(alpha: 0.8)],
              ),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Icon(
        isOwn ? Icons.person : Icons.person_outline,
        color: AppTheme.primaryColor,
        size: 16,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildAvatar(false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(200),
                const SizedBox(width: 4),
                _buildTypingDot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int delay) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final value = (_glowController.value + delay / 1000) % 1.0;
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryColor.withValues(alpha: 0.3 + (value * 0.7)),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 1),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Send an ephemeral message...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[NVSColors.primaryLightMint, NVSColors.turquoiseNeon],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else {
      return '${difference.inHours}h';
    }
  }
}

class EphemeralMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final DateTime expiresAt;
  final bool isOwn;

  EphemeralMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.expiresAt,
    required this.isOwn,
  });
}
