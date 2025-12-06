import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/models/ai_bot_personality.dart';
import '../../services/ai_bot_service.dart';

class AiBotAstrologyScreen extends StatefulWidget {
  const AiBotAstrologyScreen({super.key});

  @override
  State<AiBotAstrologyScreen> createState() => _AiBotAstrologyScreenState();
}

class _AiBotAstrologyScreenState extends State<AiBotAstrologyScreen> with TickerProviderStateMixin {
  late AnimationController _cosmicController;
  late AnimationController _planetController;
  late AnimationController _zodiacController;

  final AiBotService _aiBotService = AiBotService(personality: AiBotPersonality.createNvsBot());
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = <Map<String, dynamic>>[];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _cosmicController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _planetController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _zodiacController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final Map<String, Object> welcomeMessage = <String, Object>{
      'text':
          "I'm your cosmic guide. I can read birth charts, analyze planetary aspects, and reveal your relationship destiny through the stars. What do the cosmos want to tell you?",
      'isBot': true,
      'timestamp': DateTime.now(),
    };
    setState(() {
      _messages.add(welcomeMessage);
    });
    _zodiacController.forward();
  }

  @override
  void dispose() {
    _cosmicController.dispose();
    _planetController.dispose();
    _zodiacController.dispose();
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
              animation: _cosmicController,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        AppTheme.primaryColor.withValues(alpha: 0.9),
                        AppTheme.primaryColor.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.6),
                        blurRadius: 25 + (_cosmicController.value * 15),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
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
                  'Cosmic Oracle',
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
            icon: const Icon(Icons.psychology, color: AppTheme.primaryColor),
            onPressed: _showAstrologyDemo,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Cosmic Stats Card
          _buildCosmicStatsCard(),

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

  Widget _buildCosmicStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppTheme.primaryColor.withValues(alpha: 0.15),
            AppTheme.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.4),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildCosmicStatItem('Charts Read', '2,847', Icons.auto_awesome),
              _buildCosmicStatItem('Cosmic Accuracy', '96%', Icons.psychology),
              _buildCosmicStatItem('Planets Analyzed', '15,392', Icons.star),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _planetController,
            builder: (BuildContext context, Widget? child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      AppTheme.primaryColor.withValues(alpha: 0.9),
                      AppTheme.primaryColor.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppTheme.primaryColor
                          .withValues(alpha: 0.4 + (_planetController.value * 0.3)),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  'Cosmic Compatibility Expert',
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

  Widget _buildCosmicStatItem(String label, String value, IconData icon) {
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
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
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
                    color: AppTheme.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
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
                    ? AppTheme.primaryColor.withValues(alpha: 0.15)
                    : AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isBot ? const Radius.circular(4) : null,
                  bottomRight: !isBot ? const Radius.circular(4) : null,
                ),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.4),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                message['text'] as String,
                style: TextStyle(
                  color: isBot ? AppTheme.primaryTextColor : AppTheme.primaryColor,
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
                  color: AppTheme.primaryColor.withValues(alpha: 0.4),
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: AppTheme.primaryTextColor),
                decoration: const InputDecoration(
                  hintText: 'Ask me about the cosmos...',
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
                    color: AppTheme.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12,
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
      final String response = _aiBotService.generateResponse(text, 'astrology');
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

  void _showAstrologyDemo() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Cosmic Oracle Demo',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDemoOption('Birth Chart Reading', Icons.auto_awesome),
            _buildDemoOption('Planetary Compatibility', Icons.psychology),
            _buildDemoOption('Synastry Analysis', Icons.favorite),
            _buildDemoOption('Cosmic Timing', Icons.schedule),
            _buildDemoOption('Karmic Connections', Icons.psychology),
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
        _runAstrologyDemo(title);
      },
    );
  }

  void _runAstrologyDemo(String demoType) {
    String demoMessage = '';
    String demoResponse = '';

    switch (demoType) {
      case 'Birth Chart Reading':
        demoMessage =
            "Can you read my birth chart? I'm a Leo sun, Cancer moon, and Scorpio rising.";
        demoResponse =
            "Your Leo sun gives you dramatic creativity and generous warmth. Your Cancer moon makes you emotionally nurturing and deeply protective. Your Scorpio rising shows intense passion and mysterious depth. This is a powerful combination - you're magnetic and emotionally complex. Your chart reveals someone who leads with heart but has incredible depth.";
        break;
      case 'Planetary Compatibility':
        demoMessage =
            'What about planetary compatibility? My Venus is in Libra and their Venus is in Aries.';
        demoMessage =
            'What about planetary compatibility? My Venus is in Libra and their Venus is in Aries.';
        demoResponse =
            "Libra Venus + Aries Venus: Your Venus signs are opposite - you'll be fascinated by each other's different approach to love. Libra Venus seeks harmony and balance in relationships, while Aries Venus wants passion and excitement. This creates incredible chemistry and mutual attraction. You'll learn from each other's love styles.";
        break;
      case 'Synastry Analysis':
        demoMessage = 'Can you analyze our synastry? We have a Sun-Moon conjunction.';
        demoResponse =
            "Sun-Moon conjunction in synastry is fucking electric. This is the most powerful aspect for emotional connection. Your core identity perfectly aligns with their emotional nature. You'll feel completely understood and safe with each other. This is rare and precious - don't let it go. The cosmos has blessed you with this connection.";
        break;
      case 'Cosmic Timing':
        demoMessage = "What's the best time for us to make important relationship decisions?";
        demoResponse =
            "The cosmos is showing me that Venus is currently in a favorable position for love decisions. The new moon in two weeks will be perfect for starting fresh. Jupiter's transit through your relationship house suggests this is a time of expansion in love. Trust the timing - the universe is supporting your connection right now.";
        break;
      case 'Karmic Connections':
        demoMessage = 'Do you see any karmic connections in our charts?';
        demoResponse =
            "I'm seeing strong Saturn aspects between your charts - this indicates karmic lessons and soul contracts. You've likely known each other in past lives. The North Node connections suggest you're meant to help each other grow spiritually. This isn't just a casual connection - it's a soul-level relationship with deep karmic significance.";
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
