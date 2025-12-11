// NVS TradeBlock Messages - Anonymous messaging system
// Anonymous by default (if user has anon mode ON)
// Shows private pic OR silhouette based on settings
// Display name hidden if anon (shows "Anonymous" or random handle)
// Location-aware ("0.2 mi away")
// Disappearing messages option
// Quick presets: "Looking?" "Host?" "Travel?"

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TradeBlockMessages extends StatefulWidget {
  const TradeBlockMessages({super.key});

  @override
  State<TradeBlockMessages> createState() => _TradeBlockMessagesState();
}

class _TradeBlockMessagesState extends State<TradeBlockMessages>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Mock TradeBlock conversations
  final List<_TBConversation> _conversations = [
    _TBConversation(
      id: '1',
      handle: 'Anonymous',
      isAnonymous: true,
      hasPrivatePic: false,
      lastMessage: 'Looking?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      distance: '0.1 mi',
      unreadCount: 1,
      isDisappearing: true,
    ),
    _TBConversation(
      id: '2',
      handle: 'NightOwl42',
      isAnonymous: true,
      hasPrivatePic: true,
      lastMessage: 'Can host. You?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      distance: '0.3 mi',
      unreadCount: 2,
      isDisappearing: true,
    ),
    _TBConversation(
      id: '3',
      handle: 'Anonymous',
      isAnonymous: true,
      hasPrivatePic: false,
      lastMessage: 'Travel?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      distance: '0.5 mi',
      unreadCount: 0,
      isDisappearing: false,
    ),
    _TBConversation(
      id: '4',
      handle: 'Downtown_M',
      isAnonymous: false,
      hasPrivatePic: true,
      lastMessage: 'On my way',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      distance: '0.8 mi',
      unreadCount: 0,
      isDisappearing: true,
    ),
    _TBConversation(
      id: '5',
      handle: 'Anonymous',
      isAnonymous: true,
      hasPrivatePic: false,
      lastMessage: 'Stats?',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      distance: '1.2 mi',
      unreadCount: 0,
      isDisappearing: false,
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

  void _openConversation(_TBConversation conversation) {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _TradeBlockChatScreen(conversation: conversation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQuickPresets(),
        Expanded(
          child: _conversations.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) =>
                      _buildConversationTile(_conversations[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildQuickPresets() {
    final presets = ['Looking?', 'Host?', 'Travel?', 'Stats?', 'Pics?'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              'QUICK:',
              style: TextStyle(
                color: _mint.withOpacity(0.4),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(width: 8),
            ...presets.map((preset) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildPresetChip(preset),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String preset) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // Copy to clipboard or start new convo
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: _mint.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          preset,
          style: TextStyle(
            color: _mint.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.swap_horiz_rounded,
            color: _mint.withOpacity(0.3),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No trades yet',
            style: TextStyle(
              color: _mint.withOpacity(0.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap profiles on TradeBlock map to start',
            style: TextStyle(
              color: _mint.withOpacity(0.4),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(_TBConversation conversation) {
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
                                  conversation.handle,
                                  style: TextStyle(
                                    color: _mint,
                                    fontSize: 15,
                                    fontWeight: hasUnread
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontStyle: conversation.isAnonymous
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                                if (conversation.isDisappearing) ...[
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.timer_outlined,
                                    color: _mint.withOpacity(0.4),
                                    size: 14,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: _mint.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              conversation.distance,
                              style: TextStyle(
                                color: _mint.withOpacity(0.7),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
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
                                fontWeight:
                                    hasUnread ? FontWeight.w500 : FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimestamp(conversation.timestamp),
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

  Widget _buildAvatar(_TBConversation conversation) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _mint.withOpacity(conversation.hasPrivatePic ? 0.5 : 0.2),
        ),
      ),
      child: ClipOval(
        child: conversation.hasPrivatePic
            ? Container(
                color: _mint.withOpacity(0.15),
                child: Icon(
                  Icons.person,
                  color: _mint.withOpacity(0.6),
                  size: 28,
                ),
              )
            : Container(
                color: _mint.withOpacity(0.05),
                child: Icon(
                  Icons.person_outline,
                  color: _mint.withOpacity(0.3),
                  size: 28,
                ),
              ),
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

class _TBConversation {
  final String id;
  final String handle;
  final bool isAnonymous;
  final bool hasPrivatePic;
  final String lastMessage;
  final DateTime timestamp;
  final String distance;
  final int unreadCount;
  final bool isDisappearing;

  _TBConversation({
    required this.id,
    required this.handle,
    required this.isAnonymous,
    required this.hasPrivatePic,
    required this.lastMessage,
    required this.timestamp,
    required this.distance,
    required this.unreadCount,
    required this.isDisappearing,
  });
}

// ============ TRADEBLOCK CHAT SCREEN ============
class _TradeBlockChatScreen extends StatefulWidget {
  final _TBConversation conversation;

  const _TradeBlockChatScreen({required this.conversation});

  @override
  State<_TradeBlockChatScreen> createState() => _TradeBlockChatScreenState();
}

class _TradeBlockChatScreenState extends State<_TradeBlockChatScreen>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  bool _disappearingMode = true;

  final List<_TBMessage> _messages = [
    _TBMessage(
      id: '1',
      text: 'Looking?',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    _TBMessage(
      id: '2',
      text: 'Yeah. You?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    _TBMessage(
      id: '3',
      text: 'Can host',
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    _TBMessage(
      id: '4',
      text: 'Nice. Stats?',
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];

  final List<String> _quickReplies = [
    'Looking?',
    'Host?',
    'Travel?',
    'Stats?',
    'Pics?',
    'Now?',
    'Address?',
    'ETA?',
  ];

  @override
  void initState() {
    super.initState();
    _disappearingMode = widget.conversation.isDisappearing;
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

  void _sendMessage([String? preset]) {
    final text = preset ?? _messageController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(_TBMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isMe: true,
        timestamp: DateTime.now(),
      ));
    });
    if (preset == null) _messageController.clear();

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
            if (_disappearingMode) _buildDisappearingBanner(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _buildMessage(_messages[index]),
              ),
            ),
            _buildQuickReplies(),
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _mint.withOpacity(0.3)),
            ),
            child: ClipOval(
              child: Container(
                color: _mint.withOpacity(0.05),
                child: Icon(
                  widget.conversation.isAnonymous
                      ? Icons.person_outline
                      : Icons.person,
                  color: _mint.withOpacity(0.4),
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.handle,
                  style: TextStyle(
                    color: _mint,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: widget.conversation.isAnonymous
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: _mint.withOpacity(0.5),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.conversation.distance} away',
                      style: TextStyle(
                        color: _mint.withOpacity(0.5),
                        fontSize: 12,
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
              setState(() => _disappearingMode = !_disappearingMode);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _disappearingMode ? _mint.withOpacity(0.1) : Colors.transparent,
                border: Border.all(
                  color: _disappearingMode ? _mint : _mint.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.timer_outlined,
                color: _disappearingMode ? _mint : _mint.withOpacity(0.4),
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              // Block or report options
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.more_vert, color: _mint.withOpacity(0.6), size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisappearingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _mint.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, color: _mint.withOpacity(0.5), size: 14),
          const SizedBox(width: 8),
          Text(
            'Messages disappear after 24 hours',
            style: TextStyle(
              color: _mint.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(_TBMessage message) {
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
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_disappearingMode)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.timer_outlined,
                              color: _mint.withOpacity(0.3),
                              size: 10,
                            ),
                          ),
                        Text(
                          _formatMessageTime(message.timestamp),
                          style: TextStyle(
                            color: _mint.withOpacity(0.4),
                            fontSize: 10,
                          ),
                        ),
                      ],
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

  Widget _buildQuickReplies() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _quickReplies
              .map((reply) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _sendMessage(reply),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: _mint.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          reply,
                          style: TextStyle(
                            color: _mint.withOpacity(0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
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

class _TBMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;

  _TBMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}


