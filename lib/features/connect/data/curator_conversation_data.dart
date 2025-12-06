import '../domain/models/connect_models.dart';

/// Static data for Curator conversation flow
/// In production, this would be replaced with LLM API calls
class CuratorConversationData {
  static CuratorQuestion getFirstQuestion() {
    return const CuratorQuestion(
      questionId: 'energy_preference',
      questionText:
          'When you walk into a room, what type of energy do you naturally gravitate toward?',
      responseType: QuestionType.multipleChoice,
      choices: <String>[
        'Quiet confidence and deep conversations',
        'Playful energy and spontaneous laughter',
        'Intellectual intensity and passionate debates',
        'Calm presence and peaceful vibes',
        'Creative chaos and artistic expression',
      ],
    );
  }

  static CuratorQuestion? getNextQuestion(int responseCount) {
    switch (responseCount) {
      case 1:
        return const CuratorQuestion(
          questionId: 'connection_style',
          questionText: 'How do you prefer to connect with someone new?',
          responseType: QuestionType.imageSelect,
          imageUrls: <String>[
            'assets/images/connection_style_1.jpg', // Deep conversation
            'assets/images/connection_style_2.jpg', // Activity together
            'assets/images/connection_style_3.jpg', // Quiet presence
            'assets/images/connection_style_4.jpg', // Creative collaboration
          ],
        );

      case 2:
        return const CuratorQuestion(
          questionId: 'emotional_depth',
          questionText: 'Rate your comfort level with emotional vulnerability (1-10)',
          responseType: QuestionType.slider,
        );

      case 3:
        return const CuratorQuestion(
          questionId: 'ideal_evening',
          questionText: 'Your ideal evening with someone special involves...',
          responseType: QuestionType.multipleChoice,
          choices: <String>[
            'Cooking together and sharing stories',
            'Exploring the city and discovering new places',
            'Creating something together - art, music, writing',
            'Quiet intimacy and deep physical connection',
            'Intellectual discussions under the stars',
            'Dancing and losing ourselves in music',
          ],
        );

      case 4:
        return const CuratorQuestion(
          questionId: 'growth_mindset',
          questionText:
              'Do you believe people can fundamentally change and grow throughout their lives?',
          responseType: QuestionType.yesNo,
        );

      default:
        return null;
    }
  }

  static List<String> getCuratorInsights() {
    return <String>[
      'A shared love for quiet mornings and deep conversations creates lasting bonds.',
      'Your creative energies complement each other in unexpected ways.',
      "There's a magnetic pull between your intellectual curiosities.",
      'Your emotional rhythms sync in a way that feels effortless.',
      'Both of you value growth and transformation in relationships.',
      'Your different approaches to life create a beautiful balance.',
      "There's an artistic harmony in how you both see the world.",
      'Your vulnerabilities match in a way that creates deep safety.',
    ];
  }

  static String getRandomInsight() {
    final List<String> insights = getCuratorInsights();
    insights.shuffle();
    return insights.first;
  }

  /// Generate mock responses for demonstration
  static Map<String, dynamic> getMockUserResponses() {
    return <String, dynamic>{
      'energy_preference': 'Quiet confidence and deep conversations',
      'connection_style': 'assets/images/connection_style_1.jpg',
      'emotional_depth': 8.0,
      'ideal_evening': 'Cooking together and sharing stories',
      'growth_mindset': true,
    };
  }

  /// Get conversation flow for specific user types
  static List<CuratorQuestion> getPersonalizedFlow(String userType) {
    // This would be much more sophisticated in production
    switch (userType) {
      case 'intellectual':
        return <CuratorQuestion>[
          const CuratorQuestion(
            questionId: 'philosophical_lean',
            questionText: 'Which philosophical approach resonates most with your worldview?',
            responseType: QuestionType.multipleChoice,
            choices: <String>[
              'Existentialism - life is what we make it',
              'Stoicism - focus on what we can control',
              'Humanism - people are fundamentally good',
              "Absurdism - embrace life's beautiful chaos",
            ],
          ),
        ];

      case 'creative':
        return <CuratorQuestion>[
          const CuratorQuestion(
            questionId: 'creative_expression',
            questionText: 'How does creativity flow through you?',
            responseType: QuestionType.imageSelect,
            imageUrls: <String>[
              'assets/images/creativity_1.jpg',
              'assets/images/creativity_2.jpg',
              'assets/images/creativity_3.jpg',
              'assets/images/creativity_4.jpg',
            ],
          ),
        ];

      default:
        return <CuratorQuestion>[];
    }
  }
}
