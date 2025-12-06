import 'package:flutter/material.dart';
import '../../data/models/ai_bot_personality.dart';
import '../../services/ai_bot_service.dart';

class AiBotChatScreen extends StatefulWidget {
  const AiBotChatScreen({super.key});

  @override
  State<AiBotChatScreen> createState() => _AiBotChatScreenState();
}

class _AiBotChatScreenState extends State<AiBotChatScreen> with TickerProviderStateMixin {
  late AiBotService _aiBotService;
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  late AnimationController _typingController;
  late AnimationController _avatarController;

  late Animation<double> _typingAnimation;
  late Animation<double> _avatarAnimation;

  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isTyping = false;
  bool _isAvatarSpeaking = false;

  @override
  void initState() {
    super.initState();

    _aiBotService = AiBotService(personality: AiBotPersonality.dynamiteFaust);
    _messageController = TextEditingController();
    _scrollController = ScrollController();

    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
    );

    _avatarAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.easeInOut),
    );

    // Add initial greeting
    _addBotMessage(_aiBotService.generateConversationStarter());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Header with AI Bot Avatar
            _buildHeader(),

            // Chat Messages
            Expanded(
              child: _buildChatMessages(),
            ),

            // Typing Indicator
            if (_isTyping) _buildTypingIndicator(),

            // Message Input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFB0FFF7),
              size: 28,
            ),
          ),

          // AI Bot Avatar
          AnimatedBuilder(
            animation: _avatarAnimation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _isAvatarSpeaking ? _avatarAnimation.value : 1.0,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFFFF53A1), // Pink
                        Color(0xFF00F0FF), // Cyan
                      ],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                        blurRadius: _isAvatarSpeaking ? 20 : 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AiBotPersonality.dynamiteFaust.name,
                  style: const TextStyle(
                    color: Color(0xFFB0FFF7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'AI Companion',
                  style: TextStyle(
                    color: const Color(0xFFB0FFF7).withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          // Status indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00FF00),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFF00FF00).withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: _messages.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isUser = message.isUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isUser) ...<Widget>[
            // AI Avatar for bot messages
            Container(
              width: 35,
              height: 35,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFFFF53A1),
                    Color(0xFF00F0FF),
                  ],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFFB0FFF7).withValues(alpha: 0.2)
                    : const Color(0xFFB0FFF7).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? const Color(0xFFB0FFF7) : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...<Widget>[
            const SizedBox(width: 10),
            // User avatar placeholder
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                border: Border.all(
                  color: const Color(0xFFB0FFF7),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Color(0xFFB0FFF7),
                  size: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFFFF53A1),
                  Color(0xFF00F0FF),
                ],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
              ),
            ),
            child: AnimatedBuilder(
              animation: _typingAnimation,
              builder: (BuildContext context, Widget? child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'typing',
                      style: TextStyle(
                        color: const Color(0xFFB0FFF7).withValues(alpha: 0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFB0FFF7).withValues(alpha: _typingAnimation.value),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xFFB0FFF7).withValues(alpha: _typingAnimation.value * 0.7),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            const Color(0xFFB0FFF7).withValues(alpha: _typingAnimation.value * 0.4),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.send,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final String message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    _addUserMessage(message);
    _messageController.clear();

    // Show typing indicator
    setState(() {
      _isTyping = true;
    });

    // Simulate AI response delay
    Future.delayed(const Duration(seconds: 2), () {
      _generateBotResponse(message);
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = false;
    });
    _scrollToBottom();
  }

  void _generateBotResponse(String userMessage) {
    final String response = _aiBotService.generateResponse(userMessage, 'chat');

    // Animate avatar speaking
    setState(() {
      _isAvatarSpeaking = true;
    });
    _avatarController.repeat(reverse: true);

    // Add bot response
    _addBotMessage(response);

    // Stop avatar animation
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isAvatarSpeaking = false;
      });
      _avatarController.stop();
    });
  }

  void _scrollToBottom() {
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
}

class ChatMessage {
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
  final String text;
  final bool isUser;
  final DateTime timestamp;
}
