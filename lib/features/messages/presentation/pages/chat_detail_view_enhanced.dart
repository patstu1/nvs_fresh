// Enhanced Chat Detail View with Advanced Features for NVS
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';

// Enhanced message model with more features
class EnhancedChatMessage {
  const EnhancedChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.mediaUrl,
    this.isPrivate = false,
    this.isEmoji = false,
    this.replyToId,
    this.reactions = const <String>[],
  });
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String? mediaUrl;
  final bool isPrivate;
  final bool isEmoji;
  final String? replyToId;
  final List<String> reactions;
}

// Enhanced thread model
class EnhancedChatThread {
  const EnhancedChatThread({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.messages,
    required this.lastActivity,
    this.isOnline = true,
    this.status = 'Active now',
  });
  final String id;
  final String userName;
  final String avatarUrl;
  final List<EnhancedChatMessage> messages;
  final DateTime lastActivity;
  final bool isOnline;
  final String status;
}

class ChatDetailViewEnhanced extends ConsumerStatefulWidget {
  const ChatDetailViewEnhanced({required this.thread, super.key});
  final EnhancedChatThread thread;

  @override
  ConsumerState<ChatDetailViewEnhanced> createState() => _ChatDetailViewEnhancedState();
}

class _ChatDetailViewEnhancedState extends ConsumerState<ChatDetailViewEnhanced>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<EnhancedChatMessage> _messages;
  bool _isTyping = false;
  bool _showEmojiPanel = false;
  EnhancedChatMessage? _replyingTo;

  late AnimationController _sendAnimationController;
  late AnimationController _emojiPanelController;
  late AnimationController _heartAnimationController;
  late Animation<double> _sendAnimation;
  late Animation<double> _emojiPanelAnimation;
  late Animation<double> _heartAnimation;

  final List<String> _quickEmojis = <String>[
    '❤️',
    '😍',
    '🔥',
    '👏',
    '😂',
    '🥵',
    '🍑',
    '🍆',
  ];
  final List<String> _quickReactions = <String>['💚', '🫱', '😘', '💦', '🔥', '🥵'];

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.thread.messages);

    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _initializeAnimations() {
    _sendAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _emojiPanelController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _sendAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _sendAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _emojiPanelAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _emojiPanelController, curve: Curves.easeInOut),
    );

    _heartAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _sendAnimationController.dispose();
    _emojiPanelController.dispose();
    _heartAnimationController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(
    String text, {
    bool isPrivate = false,
    bool isEmoji = false,
  }) {
    if (text.trim().isEmpty) return;

    final EnhancedChatMessage newMsg = EnhancedChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      text: text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
      isPrivate: isPrivate,
      isEmoji: isEmoji,
      replyToId: _replyingTo?.id,
    );

    setState(() {
      _messages.add(newMsg);
      _controller.clear();
      _isTyping = false;
      _replyingTo = null;
    });

    // Animation feedback
    _sendAnimationController.forward().then((_) {
      _sendAnimationController.reverse();
    });

    if (isEmoji) {
      _heartAnimationController.forward().then((_) {
        _heartAnimationController.reverse();
      });
    }

    _scrollToBottom();
    _simulateResponse();
  }

  void _sendMedia({bool isPrivate = false}) {
    final EnhancedChatMessage mediaMsg = EnhancedChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      text: isPrivate ? '🔒 Private photo' : '📸 Photo',
      timestamp: DateTime.now(),
      isMe: true,
      mediaUrl: 'assets/images/placeholder.jpg',
      isPrivate: isPrivate,
    );

    setState(() {
      _messages.add(mediaMsg);
    });

    _scrollToBottom();
    _simulateResponse();
  }

  void _simulateResponse() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final List<String> responses = <String>[
          "That's so hot 🔥",
          'Come over tonight 😈',
          "I can't stop thinking about you",
          'Want to video chat?',
          "You're driving me crazy 🥵",
          'Send me more 😍',
        ];

        final EnhancedChatMessage response = EnhancedChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: widget.thread.id,
          text: responses[_messages.length % responses.length],
          timestamp: DateTime.now(),
          isMe: false,
        );

        setState(() {
          _messages.add(response);
        });

        _scrollToBottom();
      }
    });
  }

  void _toggleEmojiPanel() {
    setState(() {
      _showEmojiPanel = !_showEmojiPanel;
    });

    if (_showEmojiPanel) {
      _emojiPanelController.forward();
    } else {
      _emojiPanelController.reverse();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: _buildAppBar(),
      body: Column(
        children: <Widget>[
          // Reply indicator
          if (_replyingTo != null) _buildReplyIndicator(),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildEnhancedMessageBubble(_messages[index]),
            ),
          ),

          // Typing indicator
          if (_isTyping) _buildTypingIndicator(),

          // Quick reactions bar
          _buildQuickReactionsBar(),

          // Message input
          _buildEnhancedMessageInput(),

          // Emoji panel
          if (_showEmojiPanel) _buildEmojiPanel(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: NVSColors.pureBlack,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: NVSColors.neonMint),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: NVSColors.neonMint,
                child: Text(
                  widget.thread.userName[0],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MagdaCleanMono',
                  ),
                ),
              ),
              if (widget.thread.isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: NVSColors.neonLime,
                      shape: BoxShape.circle,
                      border: Border.all(width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.thread.userName,
                  style: const TextStyle(
                    color: NVSColors.neonMint,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MagdaCleanMono',
                  ),
                ),
                Text(
                  widget.thread.status,
                  style: const TextStyle(
                    color: NVSColors.secondaryText,
                    fontSize: 12,
                    fontFamily: 'MagdaCleanMono',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.videocam, color: NVSColors.neonLime),
          onPressed: _showVideoCallDialog,
        ),
        IconButton(
          icon: const Icon(Icons.call, color: NVSColors.neonMint),
          onPressed: _showVoiceCallDialog,
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: NVSColors.secondaryText),
          onPressed: _showOptionsMenu,
        ),
      ],
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: NVSColors.cardBackground,
        border: Border(
          bottom: BorderSide(color: NVSColors.dividerColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.reply, color: NVSColors.neonMint, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Replying to: ${_replyingTo!.text}',
              style: const TextStyle(
                color: NVSColors.secondaryText,
                fontSize: 12,
                fontFamily: 'MagdaCleanMono',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: NVSColors.secondaryText, size: 16),
            onPressed: () => setState(() => _replyingTo = null),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedMessageBubble(EnhancedChatMessage message) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: message.isPrivate
                ? NVSColors.electricPink.withValues(alpha: 0.15)
                : message.isMe
                    ? NVSColors.neonMint.withValues(alpha: 0.15)
                    : NVSColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: message.isPrivate
                  ? NVSColors.electricPink.withValues(alpha: 0.5)
                  : message.isMe
                      ? NVSColors.neonMint.withValues(alpha: 0.3)
                      : NVSColors.dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Reply context
              if (message.replyToId != null) _buildReplyContext(message.replyToId!),

              // Message content
              if (message.mediaUrl != null)
                _buildMediaContent(message)
              else
                _buildTextContent(message),

              // Message footer
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (message.isPrivate)
                    const Icon(Icons.lock, color: NVSColors.electricPink, size: 12),
                  if (message.isPrivate) const SizedBox(width: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: const TextStyle(
                      color: NVSColors.secondaryText,
                      fontSize: 10,
                      fontFamily: 'MagdaCleanMono',
                    ),
                  ),
                  if (message.isMe) ...<Widget>[
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, color: NVSColors.neonMint, size: 12),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(EnhancedChatMessage message) {
    return Text(
      message.text,
      style: TextStyle(
        color: Colors.white,
        fontSize: message.isEmoji ? 24 : 14,
        fontFamily: 'MagdaCleanMono',
      ),
    );
  }

  Widget _buildMediaContent(EnhancedChatMessage message) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            color: NVSColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: NVSColors.dividerColor),
          ),
          child: const Icon(
            Icons.photo,
            color: NVSColors.secondaryText,
            size: 48,
          ),
        ),
        if (message.isPrivate) ...<Widget>[
          Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const Icon(Icons.lock, color: NVSColors.electricPink, size: 32),
        ],
      ],
    );
  }

  Widget _buildReplyContext(String replyToId) {
    final EnhancedChatMessage originalMessage =
        _messages.firstWhere((EnhancedChatMessage m) => m.id == replyToId);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: NVSColors.dividerColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: NVSColors.neonMint, width: 3),
        ),
      ),
      child: Text(
        originalMessage.text,
        style: const TextStyle(
          color: NVSColors.secondaryText,
          fontSize: 12,
          fontFamily: 'MagdaCleanMono',
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildQuickReactionsBar() {
    return AnimatedBuilder(
      animation: _heartAnimation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _quickReactions.map((String emoji) {
              return Transform.scale(
                scale: _heartAnimation.value,
                child: GestureDetector(
                  onTap: () => _sendMessage(emoji, isEmoji: true),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: NVSColors.cardBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: NVSColors.neonMint.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: NVSColors.cardBackground,
        border: Border(
          top: BorderSide(color: NVSColors.dividerColor),
        ),
      ),
      child: Row(
        children: <Widget>[
          // Media buttons
          IconButton(
            icon: const Icon(Icons.photo, color: NVSColors.neonMint),
            onPressed: _sendMedia,
          ),
          IconButton(
            icon: const Icon(Icons.lock_person, color: NVSColors.electricPink),
            onPressed: () => _sendMedia(isPrivate: true),
          ),

          // Text input
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'MagdaCleanMono',
              ),
              cursorColor: NVSColors.neonMint,
              decoration: InputDecoration(
                hintText: 'Message...',
                hintStyle: const TextStyle(
                  color: NVSColors.secondaryText,
                  fontFamily: 'MagdaCleanMono',
                ),
                filled: true,
                fillColor: NVSColors.pureBlack,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: NVSColors.neonMint),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: NVSColors.neonMint, width: 2),
                ),
              ),
              onChanged: (String text) {
                setState(() {
                  _isTyping = text.isNotEmpty;
                });
              },
              onSubmitted: _sendMessage,
            ),
          ),

          const SizedBox(width: 8),

          // Emoji toggle
          IconButton(
            icon: Icon(
              _showEmojiPanel ? Icons.keyboard : Icons.emoji_emotions,
              color: NVSColors.neonLime,
            ),
            onPressed: _toggleEmojiPanel,
          ),

          // Send button
          AnimatedBuilder(
            animation: _sendAnimation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _sendAnimation.value,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: NVSColors.neonLime,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.neonLime.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => _sendMessage(_controller.text),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.black,
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

  Widget _buildEmojiPanel() {
    return AnimatedBuilder(
      animation: _emojiPanelAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: Offset(0, (1 - _emojiPanelAnimation.value) * 100),
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: NVSColors.cardBackground,
              border: Border(
                top: BorderSide(color: NVSColors.dividerColor),
              ),
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _quickEmojis.length,
              itemBuilder: (BuildContext context, int index) {
                final String emoji = _quickEmojis[index];
                return GestureDetector(
                  onTap: () => _sendMessage(emoji, isEmoji: true),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: NVSColors.pureBlack,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: NVSColors.neonMint.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 12,
            backgroundColor: NVSColors.neonMint,
            child: Text(
              widget.thread.userName[0],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: NVSColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'typing...',
              style: TextStyle(
                color: NVSColors.secondaryText,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(EnhancedChatMessage message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.reply, color: NVSColors.neonMint),
              title: const Text(
                'Reply',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
              onTap: () {
                setState(() => _replyingTo = message);
                Navigator.pop(context);
              },
            ),
            if (!message.isMe) ...<Widget>[
              ListTile(
                leading: const Icon(Icons.favorite, color: NVSColors.electricPink),
                title: const Text(
                  'Add Reaction',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'MagdaCleanMono',
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.copy, color: NVSColors.secondaryText),
              title: const Text(
                'Copy Text',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            if (message.isMe) ...<Widget>[
              ListTile(
                leading: const Icon(Icons.delete, color: NVSColors.electricPink),
                title: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'MagdaCleanMono',
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showVideoCallDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: NVSColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Video Call',
          style: TextStyle(
            color: NVSColors.neonMint,
            fontFamily: 'MagdaCleanMono',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Start a video call with ${widget.thread.userName}?',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'MagdaCleanMono',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: NVSColors.secondaryText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: NVSColors.neonLime),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video call starting...'),
                  backgroundColor: NVSColors.neonLime,
                ),
              );
            },
            child: const Text(
              'Call',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showVoiceCallDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: NVSColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Voice Call',
          style: TextStyle(
            color: NVSColors.neonMint,
            fontFamily: 'MagdaCleanMono',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Start a voice call with ${widget.thread.userName}?',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'MagdaCleanMono',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: NVSColors.secondaryText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: NVSColors.neonMint),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice call starting...'),
                  backgroundColor: NVSColors.neonMint,
                ),
              );
            },
            child: const Text(
              'Call',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: NVSColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.notifications_off, color: NVSColors.secondaryText),
              title: const Text(
                'Mute Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: NVSColors.electricPink),
              title: const Text(
                'Block User',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.report, color: NVSColors.electricPink),
              title: const Text(
                'Report',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: NVSColors.electricPink),
              title: const Text(
                'Delete Conversation',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'MagdaCleanMono',
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
