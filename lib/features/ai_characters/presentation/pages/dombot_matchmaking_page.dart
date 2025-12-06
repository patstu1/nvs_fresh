import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/features/ai_characters/data/ai_character_repository.dart';
import '../../data/ai_character_model.dart';
import '../../data/ai_character_provider.dart';
import '../widgets/animated_ai_character.dart';

class DomBotMatchmakingPage extends ConsumerStatefulWidget {
  const DomBotMatchmakingPage({super.key});

  @override
  ConsumerState<DomBotMatchmakingPage> createState() => _DomBotMatchmakingPageState();
}

class _DomBotMatchmakingPageState extends ConsumerState<DomBotMatchmakingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<String, dynamic> _answers = <String, dynamic>{};
  final Map<String, dynamic> _astrologyData = <String, dynamic>{};
  final Map<String, dynamic> _stylePreferences = <String, dynamic>{};

  final List<Map<String, dynamic>> _relationshipQuestions = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'relationship_goals',
      'question': 'What are your primary relationship goals?',
      'options': <String>[
        'Long-term commitment',
        'Casual dating',
        'Friendship first',
        'Open to anything',
      ],
    },
    <String, dynamic>{
      'id': 'communication_style',
      'question': 'How do you prefer to communicate in relationships?',
      'options': <String>[
        'Direct and honest',
        'Gentle and supportive',
        'Playful and flirty',
        'Deep and meaningful',
      ],
    },
    <String, dynamic>{
      'id': 'love_language',
      'question': "What's your primary love language?",
      'options': <String>[
        'Physical touch',
        'Words of affirmation',
        'Quality time',
        'Acts of service',
        'Gifts',
      ],
    },
    <String, dynamic>{
      'id': 'deal_breakers',
      'question': 'What are your biggest deal breakers?',
      'options': <String>[
        'Dishonesty',
        'Lack of ambition',
        'Different values',
        'Poor communication',
        'Incompatible lifestyles',
      ],
    },
    <String, dynamic>{
      'id': 'ideal_date',
      'question': "What's your ideal first date?",
      'options': <String>[
        'Romantic dinner',
        'Adventure/outdoor activity',
        'Casual coffee/tea',
        'Cultural event',
        'Something unique',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeDomBot();
  }

  void _initializeDomBot() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiCharacterProvider.notifier).showCharacter(AICharacterType.domBot);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _relationshipQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _completeMatchmaking();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  void _selectAnswer(String questionId, String answer) {
    setState(() {
      _answers[questionId] = answer;
    });
  }

  Future<void> _completeMatchmaking() async {
    // Save answers to Firebase
    final AICharacterRepository repository = ref.read(aiCharacterRepositoryProvider);
    await repository.saveRelationshipAnswers(answers: _answers);

    // Generate matchmaking analysis
    final Map<String, dynamic> analysis = await _generateMatchmakingAnalysis();

    // Show results
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => DomBotResultsPage(
            analysis: analysis,
            answers: _answers,
          ),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _generateMatchmakingAnalysis() async {
    // This would integrate with a real AI service
    // For now, we'll generate mock analysis
    return <String, dynamic>{
      'personality_type': _determinePersonalityType(),
      'compatibility_factors': _analyzeCompatibility(),
      'recommended_matches': await _getRecommendedMatches(),
      'dating_advice': _generateDatingAdvice(),
      'confidence_score': _calculateConfidenceScore(),
    };
  }

  String _determinePersonalityType() {
    final communicationStyle = _answers['communication_style'];
    final loveLanguage = _answers['love_language'];

    if (communicationStyle == 'Direct and honest' && loveLanguage == 'Physical touch') {
      return 'The Confident Charmer';
    } else if (communicationStyle == 'Gentle and supportive' &&
        loveLanguage == 'Words of affirmation') {
      return 'The Nurturing Partner';
    } else if (communicationStyle == 'Playful and flirty' && loveLanguage == 'Quality time') {
      return 'The Fun-Loving Spirit';
    } else {
      return 'The Balanced Soul';
    }
  }

  Map<String, dynamic> _analyzeCompatibility() {
    return <String, dynamic>{
      'communication': _answers['communication_style'] ?? 'Not specified',
      'values': _answers['deal_breakers'] ?? 'Not specified',
      'lifestyle': _answers['ideal_date'] ?? 'Not specified',
      'relationship_goals': _answers['relationship_goals'] ?? 'Not specified',
    };
  }

  Future<List<Map<String, dynamic>>> _getRecommendedMatches() async {
    final AICharacterRepository repository = ref.read(aiCharacterRepositoryProvider);
    final Map<String, dynamic> preferences = <String, dynamic>{
      'communication_style': _answers['communication_style'],
      'love_language': _answers['love_language'],
      'relationship_goals': _answers['relationship_goals'],
    };

    return repository.getPotentialMatches(
      preferences: preferences,
      userLocation: null,
      limit: 5,
    );
  }

  String _generateDatingAdvice() {
    final String personalityType = _determinePersonalityType();

    switch (personalityType) {
      case 'The Confident Charmer':
        return "Your confidence is magnetic! Focus on being genuine and showing your softer side too. Don't be afraid to be vulnerable.";
      case 'The Nurturing Partner':
        return 'Your caring nature is beautiful! Make sure to also take care of yourself and set healthy boundaries.';
      case 'The Fun-Loving Spirit':
        return 'Your energy is infectious! Keep the fun alive while also showing your serious side when needed.';
      default:
        return 'You have a beautiful balance of qualities! Trust your instincts and be authentic in your connections.';
    }
  }

  double _calculateConfidenceScore() {
    final int answeredQuestions = _answers.length;
    return (answeredQuestions / _relationshipQuestions.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: <Widget>[
                // Header
                _buildHeader(),

                // Progress indicator
                _buildProgressIndicator(),

                // Questions page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _relationshipQuestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildQuestionPage(_relationshipQuestions[index]);
                    },
                  ),
                ),

                // Navigation buttons
                _buildNavigationButtons(),
              ],
            ),
          ),

          // DomBot character
          Positioned(
            bottom: 20,
            right: 20,
            child: AnimatedAICharacter(
              characterType: AICharacterType.domBot,
              floating: true,
              onTap: () {
                ref.read(aiCharacterProvider.notifier).triggerAnimation(
                      AICharacterType.domBot,
                      AICharacterState.excited,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'NVS Matchmaking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Question ${_currentPage + 1} of ${_relationshipQuestions.length}',
                style: const TextStyle(
                  color: Color(0xFF4BEFE0),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${((_currentPage + 1) / _relationshipQuestions.length * 100).round()}%',
                style: const TextStyle(
                  color: Color(0xFF4BEFE0),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_currentPage + 1) / _relationshipQuestions.length,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4BEFE0)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(Map<String, dynamic> question) {
    final String questionId = question['id'] as String;
    final String questionText = question['question'] as String;
    final List<String> options = question['options'] as List<String>;
    final selectedAnswer = _answers[questionId];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 40),

          // Question text
          Text(
            questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 40),

          // Answer options
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final String option = options[index];
                final bool isSelected = selectedAnswer == option;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _selectAnswer(questionId, option),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF4BEFE0).withValues(alpha: 0.2)
                              : Colors.grey[900],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF4BEFE0) : Colors.grey[700]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: isSelected ? const Color(0xFF4BEFE0) : Colors.white,
                                  fontSize: 18,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF4BEFE0),
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final bool canProceed = _answers[_relationshipQuestions[_currentPage]['id']] != null;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          // Previous button
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF4BEFE0)),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(
                    color: Color(0xFF4BEFE0),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          if (_currentPage > 0) const SizedBox(width: 16),

          // Next/Complete button
          Expanded(
            child: ElevatedButton(
              onPressed: canProceed ? _nextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4BEFE0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: Colors.grey[700],
              ),
              child: Text(
                _currentPage == _relationshipQuestions.length - 1 ? 'Complete' : 'Next',
                style: TextStyle(
                  color: canProceed ? Colors.black : Colors.grey[400],
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
}

class DomBotResultsPage extends StatelessWidget {
  const DomBotResultsPage({
    required this.analysis,
    required this.answers,
    super.key,
  });
  final Map<String, dynamic> analysis;
  final Map<String, dynamic> answers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'Your Matchmaking Results',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 30),

              // Personality type
              _buildResultCard(
                'Your Personality Type',
                analysis['personality_type'] ?? 'Not determined',
                Icons.psychology,
                const Color(0xFF4BEFE0),
              ),

              const SizedBox(height: 20),

              // Confidence score
              _buildResultCard(
                'Matchmaking Confidence',
                '${analysis['confidence_score']?.round() ?? 0}%',
                Icons.trending_up,
                Colors.green,
              ),

              const SizedBox(height: 20),

              // Dating advice
              _buildResultCard(
                "DomBot's Advice",
                analysis['dating_advice'] ?? 'Stay authentic and be yourself!',
                Icons.lightbulb,
                Colors.amber,
              ),

              const SizedBox(height: 20),

              // Compatibility factors
              _buildCompatibilitySection(
                analysis['compatibility_factors'] ?? <String, dynamic>{},
              ),

              const SizedBox(height: 30),

              // Action buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilitySection(Map<String, dynamic> compatibility) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4BEFE0).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.favorite, color: Color(0xFF4BEFE0), size: 24),
              SizedBox(width: 12),
              Text(
                'Compatibility Factors',
                style: TextStyle(
                  color: Color(0xFF4BEFE0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...compatibility.entries.map(
            (MapEntry<String, dynamic> entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    '${entry.key}:',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to matches
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4BEFE0),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'View Matches',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF4BEFE0)),
            ),
            child: const Text(
              'Start Over',
              style: TextStyle(
                color: Color(0xFF4BEFE0),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
