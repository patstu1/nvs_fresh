import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/models/ai_bot_personality.dart';
import '../../services/ai_bot_service.dart';

class AiBotCompatibilityScreen extends StatefulWidget {
  const AiBotCompatibilityScreen({super.key});

  @override
  State<AiBotCompatibilityScreen> createState() =>
      _AiBotCompatibilityScreenState();
}

class _AiBotCompatibilityScreenState extends State<AiBotCompatibilityScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _textController;

  final AiBotService _aiBotService =
      AiBotService(personality: AiBotPersonality.createNvsBot());
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = <Map<String, dynamic>>[];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final Map<String, Object> welcomeMessage = <String, Object>{
      'text':
          "Hey, I'm your compatibility genius. I can analyze relationships, read people, and help you find real connections. What do you want to know?",
      'isBot': true,
      'timestamp': DateTime.now(),
    };
    setState(() {
      _messages.add(welcomeMessage);
    });
    _textController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _textController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: <Widget>[
            AnimatedBuilder(
              animation: _pulseController,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        AppTheme.primaryColor.withValues(alpha: 0.8),
                        AppTheme.primaryColor.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.5),
                        blurRadius: 20 + (_pulseController.value * 10),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 20,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'NVS AI',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Compatibility Genius',
                  style: TextStyle(
                    color: AppTheme.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: AppTheme.primaryColor),
            onPressed: _showCompatibilityDemo,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Compatibility Stats Card
          _buildCompatibilityStatsCard(),

          // Messages
          Expanded(
            child: _buildMessagesList(),
          ),

          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildCompatibilityStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildStatItem('Matches Analyzed', '1,247', Icons.favorite),
              _buildStatItem('Success Rate', '89%', Icons.trending_up),
              _buildStatItem('Compatibility Score', '94/100', Icons.psychology),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _glowController,
            builder: (BuildContext context, Widget? child) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      AppTheme.primaryColor.withValues(alpha: 0.8),
                      AppTheme.primaryColor.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(
                          alpha: 0.3 + (_glowController.value * 0.2),),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Text(
                  'AI-Powered Matchmaking',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.secondaryTextColor,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _messages.length,
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isBot = message['isBot'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isBot) ...<Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withValues(alpha: 0.7),
                  ],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isBot
                    ? AppTheme.primaryColor.withValues(alpha: 0.1)
                    : AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isBot ? const Radius.circular(4) : null,
                  bottomRight: !isBot ? const Radius.circular(4) : null,
                ),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                message['text'] as String,
                style: TextStyle(
                  color:
                      isBot ? AppTheme.primaryTextColor : AppTheme.primaryColor,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (!isBot) ...<Widget>[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppTheme.secondaryColor,
                    AppTheme.secondaryColor.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
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
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: AppTheme.primaryTextColor),
                decoration: const InputDecoration(
                  hintText: 'Ask me about compatibility...',
                  hintStyle: TextStyle(color: AppTheme.secondaryTextColor),
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
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(25),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final String text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(<String, dynamic>{
        'text': text,
        'isBot': false,
        'timestamp': DateTime.now(),
      });
      _messageController.clear();
      _isTyping = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      final String response = _aiBotService.generateResponse(text, 'compatibility');
      setState(() {
        _messages.add(<String, dynamic>{
          'text': response,
          'isBot': true,
          'timestamp': DateTime.now(),
        });
        _isTyping = false;
      });
    });
  }

  void _showCompatibilityDemo() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Compatibility Demo',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDemoOption(
                'Analyze Zodiac Compatibility', Icons.auto_awesome,),
            _buildDemoOption('Personality Match Analysis', Icons.psychology),
            _buildDemoOption('Communication Style Check', Icons.chat),
            _buildDemoOption('Values & Goals Alignment', Icons.favorite),
            _buildDemoOption('Lifestyle Compatibility', Icons.home),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(
        title,
        style: const TextStyle(color: AppTheme.primaryTextColor),
      ),
      onTap: () {
        Navigator.pop(context);
        _runCompatibilityDemo(title);
      },
    );
  }

  void _runCompatibilityDemo(String demoType) {
    String demoMessage = '';
    String demoResponse = '';

    switch (demoType) {
      case 'Analyze Zodiac Compatibility':
        demoMessage =
            "Can you analyze my zodiac compatibility? I'm a Leo and I'm interested in a Scorpio.";
        demoResponse =
            "Leo + Scorpio: This is fucking electric. You two are cosmically aligned. Leo's fire and Scorpio's water create intense passion. You'll need to work on communication, but the chemistry is undeniable. Don't mess this up.";
        break;
      case 'Personality Match Analysis':
        demoMessage =
            "What about personality compatibility? I'm an INTJ and they're an ENFP.";
        demoResponse =
            "INTJ + ENFP: Your MBTI types are highly compatible. You'll understand each other on a deep level. INTJ's strategic thinking complements ENFP's creativity perfectly. This is a strong foundation for something special.";
        break;
      case 'Communication Style Check':
        demoMessage =
            "How do we communicate? I'm direct and they're more emotional.";
        demoResponse =
            "Different communication styles can work, but you'll need to learn each other's approach. Your directness might hurt their feelings sometimes, but their emotional depth will help you connect on a deeper level. It's about balance.";
        break;
      case 'Values & Goals Alignment':
        demoMessage = 'We have different political views. Does that matter?';
        demoResponse =
            "Values alignment is crucial for long-term success. Different political views can work if you respect each other's perspectives, but if it's a core value for both of you, it might cause issues. Be honest about what you can compromise on.";
        break;
      case 'Lifestyle Compatibility':
        demoMessage = "I'm a homebody and they love going out. Will this work?";
        demoResponse =
            "Lifestyle compatibility matters. You'll need to find a balance that works for both of you. Maybe you can compromise - some nights in, some nights out. The key is whether you're both willing to adapt and meet in the middle.";
        break;
    }

    setState(() {
      _messages.add(<String, dynamic>{
        'text': demoMessage,
        'isBot': false,
        'timestamp': DateTime.now(),
      });
      _messages.add(<String, dynamic>{
        'text': demoResponse,
        'isBot': true,
        'timestamp': DateTime.now(),
      });
    });
  }
}
