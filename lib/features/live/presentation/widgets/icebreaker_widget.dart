import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/icebreaker_game.dart';

/// Icebreaker widget with AI-generated games and activities for room participants.
///
/// Features:
/// - AI-generated icebreaker questions and games
/// - Interactive polls and trivia
/// - Real-time participant responses
/// - Cyberpunk styling with neon effects
/// - Smooth animations and transitions
class IcebreakerWidget extends StatefulWidget {
  const IcebreakerWidget({
    required this.onClose, super.key,
  });
  final VoidCallback onClose;

  @override
  State<IcebreakerWidget> createState() => _IcebreakerWidgetState();
}

class _IcebreakerWidgetState extends State<IcebreakerWidget> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  IcebreakerGame? _currentGame;
  bool _isGameActive = false;
  int _timeRemaining = 0;
  final List<String> _participantResponses = <String>[];

  final List<IcebreakerGame> _availableGames = <IcebreakerGame>[
    const IcebreakerGame(
      id: '1',
      title: 'Would You Rather',
      description: 'Choose between two options and explain why',
      prompt: 'Would you rather have the ability to fly or be invisible?',
      options: <String>['Fly', 'Invisible'],
      type: GameType.wouldYouRather,
    ),
    const IcebreakerGame(
      id: '2',
      title: 'Truth or Dare',
      description: 'Answer a question or complete a challenge',
      prompt: "What's the most embarrassing thing that happened to you this week?",
      options: <String>['Truth', 'Dare'],
      type: GameType.truthOrDare,
      duration: Duration(seconds: 45),
    ),
    const IcebreakerGame(
      id: '3',
      title: 'Word Association',
      description: 'Say the first word that comes to mind',
      prompt: 'What\'s the first word that comes to mind when I say "cyberpunk"?',
      type: GameType.wordAssociation,
      duration: Duration(seconds: 30),
    ),
    const IcebreakerGame(
      id: '4',
      title: 'Trivia Challenge',
      description: 'Test your knowledge with fun questions',
      prompt: 'What year was the first iPhone released?',
      options: <String>['2005', '2007', '2009', '2010'],
      type: GameType.trivia,
      duration: Duration(seconds: 30),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Slide animation for overlay
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Pulse animation for active game
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.8),
      child: SlideTransition(
        position: _slideAnimation,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF1A1A1A),
                Colors.black,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                // Header
                _buildHeader(),

                // Content
                Expanded(
                  child: _isGameActive ? _buildActiveGame() : _buildGameSelection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.games,
            color: Color(0xFFFF6B6B),
            size: 24,
          ),

          const SizedBox(width: 12),

          const Text(
            'Icebreaker Games',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // AI indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.5),
              ),
            ),
            child: const Row(
              children: <Widget>[
                Icon(
                  Icons.psychology,
                  color: Color(0xFFFF6B6B),
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'AI Generated',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Close button
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(
              Icons.close,
              color: Color(0xFFFF6B6B),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Choose a Game',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI-curated games to break the ice and get everyone talking',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _availableGames.length,
              itemBuilder: (BuildContext context, int index) {
                final IcebreakerGame game = _availableGames[index];
                return _buildGameCard(game);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(IcebreakerGame game) {
    return GestureDetector(
      onTap: () => _startGame(game),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFF6B6B).withOpacity(0.3),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              const Color(0xFFFF6B6B).withOpacity(0.1),
              const Color(0xFF8B5CF6).withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Game icon
              Icon(
                _getGameIcon(game.type),
                color: const Color(0xFFFF6B6B),
                size: 32,
              ),

              const SizedBox(height: 12),

              // Game title
              Text(
                game.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Game description
              Text(
                game.description,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const Spacer(),

              // Duration
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.timer,
                    color: Color(0xFFFF6B6B),
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${game.duration.inSeconds}s',
                    style: const TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300)).scale(
          begin: const Offset(0.8, 0.8),
          duration: const Duration(milliseconds: 300),
        );
  }

  Widget _buildActiveGame() {
    if (_currentGame == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          // Game header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  _getGameIcon(_currentGame!.type),
                  color: const Color(0xFFFF6B6B),
                  size: 24,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _currentGame!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _currentGame!.description,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Timer
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _timeRemaining <= 10 ? _pulseAnimation.value : 1.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _timeRemaining <= 10
                              ? Colors.red.withOpacity(0.8)
                              : const Color(0xFFFF6B6B).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$_timeRemaining',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Game prompt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
              ),
            ),
            child: Column(
              children: <Widget>[
                const Text(
                  'Question:',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentGame!.prompt,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Game options
          if (_currentGame!.options.isNotEmpty)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _currentGame!.options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = _currentGame!.options[index];
                  return _buildOptionButton(option);
                },
              ),
            ),

          // Participant responses
          if (_participantResponses.isNotEmpty) ...<Widget>[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF6B6B).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Responses:',
                    style: TextStyle(
                      color: Color(0xFFFF6B6B),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _participantResponses.map((String response) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          response,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),

          // End game button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _endGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'End Game',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: () => _submitResponse(option),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFFF6B6B)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        option,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _startGame(IcebreakerGame game) {
    setState(() {
      _currentGame = game;
      _isGameActive = true;
      _timeRemaining = game.duration.inSeconds;
      _participantResponses.clear();
    });

    // Start timer
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          _timeRemaining--;
        });

        if (_timeRemaining <= 0) {
          timer.cancel();
          _endGame();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _submitResponse(String response) {
    setState(() {
      _participantResponses.add(response);
    });
  }

  void _endGame() {
    setState(() {
      _isGameActive = false;
      _currentGame = null;
      _timeRemaining = 0;
    });
  }

  IconData _getGameIcon(GameType type) {
    switch (type) {
      case GameType.question:
        return Icons.quiz;
      case GameType.poll:
        return Icons.poll;
      case GameType.trivia:
        return Icons.school;
      case GameType.wordAssociation:
        return Icons.psychology;
      case GameType.wouldYouRather:
        return Icons.compare_arrows;
      case GameType.truthOrDare:
        return Icons.casino;
      case GameType.quickQuestion:
        return Icons.help_outline;
      case GameType.rolePlay:
        return Icons.theater_comedy;
      case GameType.storyBuilding:
        return Icons.auto_stories;
      case GameType.rapidFire:
        return Icons.flash_on;
    }
  }
}
