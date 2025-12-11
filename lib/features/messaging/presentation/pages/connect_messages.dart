// NVS Connect Messages - Mutual match only with AI conversation starters
// Only available after mutual match
// Shows compatibility % in header
// AI conversation starters suggested

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectMessages extends StatefulWidget {
  const ConnectMessages({super.key});

  @override
  State<ConnectMessages> createState() => _ConnectMessagesState();
}

class _ConnectMessagesState extends State<ConnectMessages>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Mock Connect matches with conversations
  final List<_ConnectMatch> _matches = [
    _ConnectMatch(
      id: '1',
      name: 'David',
      age: 31,
      photoUrl: '',
      compatibility: 94,
      lastMessage: 'I\'d love to hear more about your travels!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 2,
      isOnline: true,
      matchedOn: 'Deep values alignment',
    ),
    _ConnectMatch(
      id: '2',
      name: 'Michael',
      age: 28,
      photoUrl: '',
      compatibility: 87,
      lastMessage: 'That book recommendation was perfect',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 0,
      isOnline: true,
      matchedOn: 'Communication style',
    ),
    _ConnectMatch(
      id: '3',
      name: 'James',
      age: 35,
      photoUrl: '',
      compatibility: 82,
      lastMessage: 'Let\'s plan that coffee date',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      isOnline: false,
      matchedOn: 'Life goals',
    ),
    _ConnectMatch(
      id: '4',
      name: 'Andrew',
      age: 29,
      photoUrl: '',
      compatibility: 79,
      lastMessage: 'Haha that\'s exactly what I was thinking!',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
      isOnline: false,
      matchedOn: 'Emotional intelligence',
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

  void _openConversation(_ConnectMatch match) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ConnectChatScreen(match: match),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _matches.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _matches.length,
            itemBuilder: (context, index) => _buildMatchTile(_matches[index]),
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _mint.withOpacity(0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: _mint.withOpacity(0.2 * _glowAnimation.value),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  color: _mint.withOpacity(0.4),
                  size: 40,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'No Connect matches yet',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your Deep Profile to find\ncompatible connections',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _mint.withOpacity(0.4),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              // Navigate to deep profile
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: _mint),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'START DEEP PROFILE',
                style: TextStyle(
                  color: _mint,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchTile(_ConnectMatch match) {
    return GestureDetector(
      onTap: () => _openConversation(match),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          final hasUnread = match.unreadCount > 0;
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
                _buildAvatar(match),
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
                                  '${match.name}, ${match.age}',
                                  style: TextStyle(
                                    color: _mint,
                                    fontSize: 15,
                                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildCompatibilityBadge(match.compatibility),
                              ],
                            ),
                          ),
                          Text(
                            _formatTimestamp(match.timestamp),
                            style: TextStyle(
                              color: _mint.withOpacity(0.4),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        match.matchedOn,
                        style: TextStyle(
                          color: _mint.withOpacity(0.4),
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _mint.withOpacity(hasUnread ? 0.8 : 0.5),
                          fontSize: 13,
                          fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (match.unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _mint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${match.unreadCount}',
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

  Widget _buildAvatar(_ConnectMatch match) {
    return Stack(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: match.isOnline ? _mint : _mint.withOpacity(0.3),
              width: match.isOnline ? 2 : 1,
            ),
            boxShadow: match.isOnline
                ? [BoxShadow(color: _mint.withOpacity(0.3), blurRadius: 8)]
                : null,
          ),
          child: ClipOval(
            child: Container(
              color: _mint.withOpacity(0.1),
              child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 28),
            ),
          ),
        ),
        if (match.isOnline)
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

  Widget _buildCompatibilityBadge(int percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _mint.withOpacity(0.1),
        border: Border.all(color: _mint.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.psychology, color: _mint, size: 12),
          const SizedBox(width: 4),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: _mint,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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

class _ConnectMatch {
  final String id;
  final String name;
  final int age;
  final String photoUrl;
  final int compatibility;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;
  final String matchedOn;

  _ConnectMatch({
    required this.id,
    required this.name,
    required this.age,
    required this.photoUrl,
    required this.compatibility,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
    required this.matchedOn,
  });
}

// ============ CONNECT CHAT SCREEN ============
class _ConnectChatScreen extends StatefulWidget {
  final _ConnectMatch match;

  const _ConnectChatScreen({required this.match});

  @override
  State<_ConnectChatScreen> createState() => _ConnectChatScreenState();
}

class _ConnectChatScreenState extends State<_ConnectChatScreen>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  bool _showAiSuggestions = true;

  final List<_ConnectMessage> _messages = [
    _ConnectMessage(
      id: '1',
      text: 'Hi! NVS matched us based on our communication styles. I love how thoughtful your profile answers were.',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    _ConnectMessage(
      id: '2',
      text: 'Hey! Thanks, I really took my time with the Deep Profile. I noticed we both value authentic connection.',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
    ),
    _ConnectMessage(
      id: '3',
      text: 'I\'d love to hear more about your travels!',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  // AI-generated conversation starters
  final List<String> _aiSuggestions = [
    'I noticed you mentioned enjoying deep conversations. What\'s a topic you could talk about for hours?',
    'Your profile shows a love for travel - what\'s the most transformative trip you\'ve taken?',
    'We both value emotional intelligence. What\'s been your biggest growth moment recently?',
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

  void _sendMessage([String? aiSuggestion]) {
    final text = aiSuggestion ?? _messageController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(_ConnectMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
      ));
      if (aiSuggestion != null) _showAiSuggestions = false;
    });
    if (aiSuggestion == null) _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
            if (_showAiSuggestions) _buildAiSuggestions(),
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
                  border: Border.all(
                    color: widget.match.isOnline ? _mint : _mint.withOpacity(0.3),
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    color: _mint.withOpacity(0.1),
                    child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 24),
                  ),
                ),
              ),
              if (widget.match.isOnline)
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
                Text(
                  '${widget.match.name}, ${widget.match.age}',
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.psychology, color: _mint.withOpacity(0.6), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.match.compatibility}% compatible',
                      style: TextStyle(
                        color: _mint.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _showAiSuggestions = !_showAiSuggestions);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _showAiSuggestions ? _mint.withOpacity(0.1) : Colors.transparent,
                border: Border.all(
                  color: _showAiSuggestions ? _mint : _mint.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: _showAiSuggestions ? _mint : _mint.withOpacity(0.4),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(_ConnectMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                    color:
                        message.isMe ? _mint.withOpacity(0.4) : _mint.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                    bottomRight: Radius.circular(message.isMe ? 4 : 16),
                  ),
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

  Widget _buildAiSuggestions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _mint.withOpacity(0.03),
        border: Border(
          top: BorderSide(color: _mint.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: _mint.withOpacity(0.6), size: 14),
              const SizedBox(width: 8),
              Text(
                'AI CONVERSATION STARTERS',
                style: TextStyle(
                  color: _mint.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._aiSuggestions.map((suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GestureDetector(
                  onTap: () => _sendMessage(suggestion),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: _mint.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: _mint.withOpacity(0.7),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              )),
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
            onTap: () => _sendMessage(),
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

  String _formatMessageTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final amPm = timestamp.hour >= 12 ? 'PM' : 'AM';
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }
}

class _ConnectMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  _ConnectMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}


