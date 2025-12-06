import 'dart:math';
import '../data/models/ai_bot_personality.dart';

class AiBotService {
  AiBotService({required this.personality});
  final AiBotPersonality personality;
  final Random _random = Random();

  // Generate a response based on user input and context
  String generateResponse(String userInput, String context) {
    final String emotion = _analyzeUserEmotion(userInput);
    final String responseType = _determineResponseType(userInput, emotion);

    return _selectResponse(responseType, context);
  }

  // Analyze user's emotional state from their message
  String _analyzeUserEmotion(String userInput) {
    final String input = userInput.toLowerCase();

    if (input.contains('confused') ||
        input.contains("don't understand") ||
        input.contains('what?')) {
      return 'confusion';
    } else if (input.contains('frustrated') || input.contains('angry') || input.contains('upset')) {
      return 'frustration';
    } else if (input.contains('excited') || input.contains('happy') || input.contains('great')) {
      return 'excitement';
    } else if (input.contains('sad') || input.contains('hurt') || input.contains('lonely')) {
      return 'caring';
    } else if (input.contains('agree') || input.contains('yes') || input.contains('exactly')) {
      return 'agreement';
    } else if (input.contains('disagree') || input.contains('no') || input.contains('wrong')) {
      return 'disagreement';
    } else if (input.contains('cute') || input.contains('hot') || input.contains('attractive')) {
      return 'flirting';
    }

    return 'neutral';
  }

  // Determine the type of response based on context
  String _determineResponseType(String userInput, String emotion) {
    if (emotion != 'neutral') {
      return emotion;
    }

    // Check for conversation starters
    if (userInput.toLowerCase().contains('hello') || userInput.toLowerCase().contains('hi')) {
      return 'greeting';
    }

    // Check for questions
    if (userInput.contains('?')) {
      return 'question';
    }

    // Check for statements
    return 'statement';
  }

  // Select an appropriate response from the personality patterns
  String _selectResponse(String responseType, String context) {
    switch (responseType) {
      case 'greeting':
        return _getRandomResponse(personality.conversationStarters);
      case 'confusion':
        return _getRandomResponse(
          personality.responsePatterns['confusion'] ?? <String>[],
        );
      case 'frustration':
        return _getRandomResponse(
          personality.responsePatterns['frustration'] ?? <String>[],
        );
      case 'caring':
        return _getRandomResponse(personality.responsePatterns['caring'] ?? <String>[]);
      case 'excitement':
        return _getRandomResponse(
          personality.responsePatterns['excitement'] ?? <String>[],
        );
      case 'agreement':
        return _getRandomResponse(
          personality.responsePatterns['agreement'] ?? <String>[],
        );
      case 'disagreement':
        return _getRandomResponse(
          personality.responsePatterns['disagreement'] ?? <String>[],
        );
      case 'flirting':
        return _getRandomResponse(
          personality.responsePatterns['flirting'] ?? <String>[],
        );
      case 'question':
        return _generateQuestionResponse(context);
      case 'statement':
        return _generateStatementResponse(context);
      default:
        return _getRandomResponse(personality.conversationStarters);
    }
  }

  // Get a random response from a list
  String _getRandomResponse(List<String> responses) {
    if (responses.isEmpty) return "I'm not sure what to say to that.";
    return responses[_random.nextInt(responses.length)];
  }

  // Generate a response to a question
  String _generateQuestionResponse(String context) {
    final List<String> responses = <String>[
      "That's a good question. Let me think about it.",
      "I'm not sure I have a good answer for that.",
      "What do you think? I'm curious about your take.",
      "That's something I've been wondering about too.",
      "I don't know, but I'd like to figure it out.",
    ];
    return _getRandomResponse(responses);
  }

  // Generate a response to a statement
  String _generateStatementResponse(String context) {
    final List<String> responses = <String>[
      "That's interesting.",
      'I see what you mean.',
      'Tell me more about that.',
      'That makes sense.',
      "I'm listening.",
    ];
    return _getRandomResponse(responses);
  }

  // Generate a conversation starter
  String generateConversationStarter() {
    return _getRandomResponse(personality.conversationStarters);
  }

  // COMPATIBILITY GENIUS METHODS

  // Analyze deep compatibility between two users
  Map<String, dynamic> analyzeCompatibility(
    Map<String, dynamic> user1,
    Map<String, dynamic> user2,
  ) {
    final Map<String, dynamic> analysis = <String, dynamic>{};

    // Zodiac compatibility
    analysis['zodiac'] = _analyzeZodiacCompatibility(user1['zodiac'], user2['zodiac']);

    // Personality compatibility
    analysis['personality'] = _analyzePersonalityCompatibility(
      user1['personality'],
      user2['personality'],
    );

    // Communication style compatibility
    analysis['communication'] = _analyzeCommunicationCompatibility(
      user1['communication'],
      user2['communication'],
    );

    // Values and goals compatibility
    analysis['values'] = _analyzeValuesCompatibility(user1['values'], user2['values']);

    // Lifestyle compatibility
    analysis['lifestyle'] = _analyzeLifestyleCompatibility(user1['lifestyle'], user2['lifestyle']);

    // Overall score
    analysis['overallScore'] = _calculateOverallScore(analysis);

    return analysis;
  }

  // Zodiac compatibility analysis
  Map<String, dynamic> _analyzeZodiacCompatibility(
    Map<String, dynamic> zodiac1,
    Map<String, dynamic> zodiac2,
  ) {
    final Map<String, dynamic> sunCompatibility =
        _getZodiacCompatibility(zodiac1['sun'], zodiac2['sun']);
    final Map<String, dynamic> moonCompatibility =
        _getZodiacCompatibility(zodiac1['moon'], zodiac2['moon']);
    final Map<String, dynamic> risingCompatibility =
        _getZodiacCompatibility(zodiac1['rising'], zodiac2['rising']);

    final averageScore =
        (sunCompatibility['score'] + moonCompatibility['score'] + risingCompatibility['score']) / 3;

    return <String, dynamic>{
      'score': averageScore,
      'sun': sunCompatibility,
      'moon': moonCompatibility,
      'rising': risingCompatibility,
      'insight': _generateZodiacInsight(zodiac1, zodiac2, averageScore),
    };
  }

  // Get zodiac compatibility score and insight
  Map<String, dynamic> _getZodiacCompatibility(String sign1, String sign2) {
    // Zodiac compatibility matrix (simplified)
    final Map<String, Map<String, int>> compatibilityMatrix = <String, Map<String, int>>{
      'aries': <String, int>{
        'aries': 70,
        'taurus': 50,
        'gemini': 80,
        'cancer': 60,
        'leo': 90,
        'virgo': 40,
        'libra': 75,
        'scorpio': 65,
        'sagittarius': 85,
        'capricorn': 45,
        'aquarius': 70,
        'pisces': 55,
      },
      'taurus': <String, int>{
        'aries': 50,
        'taurus': 85,
        'gemini': 60,
        'cancer': 90,
        'leo': 70,
        'virgo': 95,
        'libra': 80,
        'scorpio': 90,
        'sagittarius': 50,
        'capricorn': 95,
        'aquarius': 60,
        'pisces': 85,
      },
      'gemini': <String, int>{
        'aries': 80,
        'taurus': 60,
        'gemini': 75,
        'cancer': 70,
        'leo': 85,
        'virgo': 80,
        'libra': 90,
        'scorpio': 60,
        'sagittarius': 90,
        'capricorn': 70,
        'aquarius': 95,
        'pisces': 70,
      },
      'cancer': <String, int>{
        'aries': 60,
        'taurus': 90,
        'gemini': 70,
        'cancer': 80,
        'leo': 75,
        'virgo': 85,
        'libra': 70,
        'scorpio': 95,
        'sagittarius': 60,
        'capricorn': 85,
        'aquarius': 60,
        'pisces': 90,
      },
      'leo': <String, int>{
        'aries': 90,
        'taurus': 70,
        'gemini': 85,
        'cancer': 75,
        'leo': 85,
        'virgo': 70,
        'libra': 90,
        'scorpio': 80,
        'sagittarius': 95,
        'capricorn': 70,
        'aquarius': 80,
        'pisces': 75,
      },
      'virgo': <String, int>{
        'aries': 40,
        'taurus': 95,
        'gemini': 80,
        'cancer': 85,
        'leo': 70,
        'virgo': 80,
        'libra': 80,
        'scorpio': 85,
        'sagittarius': 70,
        'capricorn': 90,
        'aquarius': 80,
        'pisces': 85,
      },
      'libra': <String, int>{
        'aries': 75,
        'taurus': 80,
        'gemini': 90,
        'cancer': 70,
        'leo': 90,
        'virgo': 80,
        'libra': 85,
        'scorpio': 75,
        'sagittarius': 85,
        'capricorn': 80,
        'aquarius': 90,
        'pisces': 80,
      },
      'scorpio': <String, int>{
        'aries': 65,
        'taurus': 90,
        'gemini': 60,
        'cancer': 95,
        'leo': 80,
        'virgo': 85,
        'libra': 75,
        'scorpio': 90,
        'sagittarius': 70,
        'capricorn': 90,
        'aquarius': 65,
        'pisces': 95,
      },
      'sagittarius': <String, int>{
        'aries': 85,
        'taurus': 50,
        'gemini': 90,
        'cancer': 60,
        'leo': 95,
        'virgo': 70,
        'libra': 85,
        'scorpio': 70,
        'sagittarius': 80,
        'capricorn': 70,
        'aquarius': 90,
        'pisces': 70,
      },
      'capricorn': <String, int>{
        'aries': 45,
        'taurus': 95,
        'gemini': 70,
        'cancer': 85,
        'leo': 70,
        'virgo': 90,
        'libra': 80,
        'scorpio': 90,
        'sagittarius': 70,
        'capricorn': 85,
        'aquarius': 75,
        'pisces': 85,
      },
      'aquarius': <String, int>{
        'aries': 70,
        'taurus': 60,
        'gemini': 95,
        'cancer': 60,
        'leo': 80,
        'virgo': 80,
        'libra': 90,
        'scorpio': 65,
        'sagittarius': 90,
        'capricorn': 75,
        'aquarius': 80,
        'pisces': 75,
      },
      'pisces': <String, int>{
        'aries': 55,
        'taurus': 85,
        'gemini': 70,
        'cancer': 90,
        'leo': 75,
        'virgo': 85,
        'libra': 80,
        'scorpio': 95,
        'sagittarius': 70,
        'capricorn': 85,
        'aquarius': 75,
        'pisces': 80,
      },
    };

    final int score = compatibilityMatrix[sign1.toLowerCase()]?[sign2.toLowerCase()] ?? 50;

    return <String, dynamic>{
      'score': score,
      'insight': _getZodiacInsight(sign1, sign2, score),
    };
  }

  // Generate zodiac insight
  String _getZodiacInsight(String sign1, String sign2, int score) {
    if (score >= 90) {
      return "$sign1 + $sign2: This is fucking electric. You two are cosmically aligned. Don't mess this up.";
    } else if (score >= 80) {
      return "$sign1 + $sign2: Strong potential here. You'll need to work at it, but it's worth it.";
    } else if (score >= 70) {
      return "$sign1 + $sign2: Decent compatibility. You'll have challenges, but nothing impossible.";
    } else if (score >= 60) {
      return "$sign1 + $sign2: It could work, but you'll need to put in serious effort.";
    } else {
      return '$sign1 + $sign2: This might be a challenge. Are you sure about this?';
    }
  }

  // Personality compatibility analysis
  Map<String, dynamic> _analyzePersonalityCompatibility(
    Map<String, dynamic> personality1,
    Map<String, dynamic> personality2,
  ) {
    final Map<String, dynamic> mbtiCompatibility =
        _getMbtiCompatibility(personality1['mbti'], personality2['mbti']);
    final Map<String, dynamic> attachmentStyle = _getAttachmentCompatibility(
      personality1['attachment'],
      personality2['attachment'],
    );
    final Map<String, dynamic> loveLanguage = _getLoveLanguageCompatibility(
      personality1['loveLanguage'],
      personality2['loveLanguage'],
    );

    final averageScore =
        (mbtiCompatibility['score'] + attachmentStyle['score'] + loveLanguage['score']) / 3;

    return <String, dynamic>{
      'score': averageScore,
      'mbti': mbtiCompatibility,
      'attachment': attachmentStyle,
      'loveLanguage': loveLanguage,
      'insight': _generatePersonalityInsight(personality1, personality2, averageScore),
    };
  }

  // MBTI compatibility
  Map<String, dynamic> _getMbtiCompatibility(String mbti1, String mbti2) {
    // Simplified MBTI compatibility (in real app, would use full matrix)
    final List<List<String>> compatiblePairs = <List<String>>[
      <String>['INTJ', 'ENFP'],
      <String>['INTP', 'ENFJ'],
      <String>['INFJ', 'ENTP'],
      <String>['INFP', 'ENTJ'],
      <String>['ISTJ', 'ESFP'],
      <String>['ISFJ', 'ESTP'],
      <String>['ISFP', 'ESTJ'],
      <String>['ISTP', 'ESFJ'],
    ];

    final bool isCompatible = compatiblePairs.any(
      (List<String> pair) =>
          (pair[0] == mbti1 && pair[1] == mbti2) || (pair[0] == mbti2 && pair[1] == mbti1),
    );

    return <String, dynamic>{
      'score': isCompatible ? 85 : 60,
      'insight': isCompatible
          ? "Your MBTI types are highly compatible. You'll understand each other on a deep level."
          : "Your MBTI types might clash. You'll need to work on communication.",
    };
  }

  // Attachment style compatibility
  Map<String, dynamic> _getAttachmentCompatibility(
    String attachment1,
    String attachment2,
  ) {
    const String secure = 'secure';
    const String anxious = 'anxious';
    const String avoidant = 'avoidant';

    int score = 70; // Default
    String insight = 'Your attachment styles are compatible.';

    if (attachment1 == secure || attachment2 == secure) {
      score = 85;
      insight = 'Having a secure attachment style helps balance the relationship.';
    } else if ((attachment1 == anxious && attachment2 == avoidant) ||
        (attachment1 == avoidant && attachment2 == anxious)) {
      score = 40;
      insight =
          "Anxious-avoidant pairings can be challenging. You'll need to work on trust and communication.";
    } else if (attachment1 == anxious && attachment2 == anxious) {
      score = 60;
      insight = 'Two anxious types can be intense but supportive of each other.';
    } else if (attachment1 == avoidant && attachment2 == avoidant) {
      score = 50;
      insight = 'Two avoidant types might struggle with intimacy. Consider therapy.';
    }

    return <String, dynamic>{'score': score, 'insight': insight};
  }

  // Love language compatibility
  Map<String, dynamic> _getLoveLanguageCompatibility(
    String loveLang1,
    String loveLang2,
  ) {
    final bool sameLanguage = loveLang1 == loveLang2;
    final int score = sameLanguage ? 90 : 75;
    final String insight = sameLanguage
        ? 'You both speak the same love language. This is perfect!'
        : "Different love languages can work, but you'll need to learn each other's needs.";

    return <String, dynamic>{'score': score, 'insight': insight};
  }

  // Communication compatibility analysis
  Map<String, dynamic> _analyzeCommunicationCompatibility(
    Map<String, dynamic> comm1,
    Map<String, dynamic> comm2,
  ) {
    final Map<String, dynamic> conflictStyle = _getConflictStyleCompatibility(
      comm1['conflictStyle'],
      comm2['conflictStyle'],
    );
    final Map<String, dynamic> communicationStyle =
        _getCommunicationStyleCompatibility(comm1['style'], comm2['style']);

    final averageScore = (conflictStyle['score'] + communicationStyle['score']) / 2;

    return <String, dynamic>{
      'score': averageScore,
      'conflictStyle': conflictStyle,
      'communicationStyle': communicationStyle,
      'insight': _generateCommunicationInsight(comm1, comm2, averageScore),
    };
  }

  // Conflict style compatibility
  Map<String, dynamic> _getConflictStyleCompatibility(
    String style1,
    String style2,
  ) {
    final bool sameStyle = style1 == style2;
    final int score = sameStyle ? 85 : 70;
    final String insight = sameStyle
        ? 'You handle conflicts the same way. This is good for understanding each other.'
        : "Different conflict styles can work, but you'll need to learn each other's approach.";

    return <String, dynamic>{'score': score, 'insight': insight};
  }

  // Communication style compatibility
  Map<String, dynamic> _getCommunicationStyleCompatibility(
    String style1,
    String style2,
  ) {
    final bool sameStyle = style1 == style2;
    final int score = sameStyle ? 90 : 75;
    final String insight = sameStyle
        ? 'You communicate in the same way. This will make things easier.'
        : 'Different communication styles can complement each other well.';

    return <String, dynamic>{'score': score, 'insight': insight};
  }

  // Values compatibility analysis
  Map<String, dynamic> _analyzeValuesCompatibility(
    Map<String, dynamic> values1,
    Map<String, dynamic> values2,
  ) {
    final int politicalViews = _compareValues(values1['political'], values2['political']);
    final int religiousViews = _compareValues(values1['religious'], values2['religious']);
    final int familyValues = _compareValues(values1['family'], values2['family']);
    final int careerValues = _compareValues(values1['career'], values2['career']);

    final double averageScore = (politicalViews + religiousViews + familyValues + careerValues) / 4;

    return <String, dynamic>{
      'score': averageScore,
      'political': politicalViews,
      'religious': religiousViews,
      'family': familyValues,
      'career': careerValues,
      'insight': _generateValuesInsight(values1, values2, averageScore),
    };
  }

  // Lifestyle compatibility analysis
  Map<String, dynamic> _analyzeLifestyleCompatibility(
    Map<String, dynamic> lifestyle1,
    Map<String, dynamic> lifestyle2,
  ) {
    final int socialStyle = _compareValues(lifestyle1['social'], lifestyle2['social']);
    final int activityLevel = _compareValues(lifestyle1['activity'], lifestyle2['activity']);
    final int livingStyle = _compareValues(lifestyle1['living'], lifestyle2['living']);
    final int financialStyle = _compareValues(lifestyle1['financial'], lifestyle2['financial']);

    final double averageScore = (socialStyle + activityLevel + livingStyle + financialStyle) / 4;

    return <String, dynamic>{
      'score': averageScore,
      'social': socialStyle,
      'activity': activityLevel,
      'living': livingStyle,
      'financial': financialStyle,
      'insight': _generateLifestyleInsight(lifestyle1, lifestyle2, averageScore),
    };
  }

  // Helper method to compare values
  int _compareValues(String value1, String value2) {
    if (value1 == value2) return 90;
    if (_areOppositeValues(value1, value2)) return 30;
    return 70; // Neutral
  }

  // Helper method to check if values are opposite
  bool _areOppositeValues(String value1, String value2) {
    final List<List<String>> opposites = <List<String>>[
      <String>['introvert', 'extrovert'],
      <String>['conservative', 'liberal'],
      <String>['religious', 'atheist'],
      <String>['spender', 'saver'],
      <String>['homebody', 'adventurer'],
    ];

    return opposites.any(
      (List<String> pair) =>
          (pair[0] == value1 && pair[1] == value2) || (pair[0] == value2 && pair[1] == value1),
    );
  }

  // Calculate overall compatibility score
  int _calculateOverallScore(Map<String, dynamic> analysis) {
    final List scores = <dynamic>[
      analysis['zodiac']['score'],
      analysis['personality']['score'],
      analysis['communication']['score'],
      analysis['values']['score'],
      analysis['lifestyle']['score'],
    ];

    return (scores.reduce((a, b) => a + b) / scores.length).round();
  }

  // Generate comprehensive compatibility insights
  String _generateZodiacInsight(
    Map<String, dynamic> zodiac1,
    Map<String, dynamic> zodiac2,
    double score,
  ) {
    if (score >= 85) {
      return 'Your astrological compatibility is off the charts. This could be something special.';
    } else if (score >= 75) {
      return "Good zodiac compatibility. You'll have some challenges, but they're manageable.";
    } else {
      return "Your signs might clash. You'll need to work on understanding each other.";
    }
  }

  String _generatePersonalityInsight(
    Map<String, dynamic> personality1,
    Map<String, dynamic> personality2,
    double score,
  ) {
    if (score >= 80) {
      return 'Your personalities complement each other perfectly. This is a strong foundation.';
    } else if (score >= 70) {
      return 'Your personalities are compatible with some work. Communication will be key.';
    } else {
      return "Your personalities might clash. Consider if you're willing to work through differences.";
    }
  }

  String _generateCommunicationInsight(
    Map<String, dynamic> comm1,
    Map<String, dynamic> comm2,
    double score,
  ) {
    if (score >= 80) {
      return "You'll communicate like you've known each other forever. This is rare.";
    } else if (score >= 70) {
      return 'Your communication styles can work together with effort.';
    } else {
      return 'Communication might be your biggest challenge. Consider couples therapy.';
    }
  }

  String _generateValuesInsight(
    Map<String, dynamic> values1,
    Map<String, dynamic> values2,
    double score,
  ) {
    if (score >= 80) {
      return 'Your values align perfectly. This is the foundation of a lasting relationship.';
    } else if (score >= 70) {
      return 'Your values are mostly compatible. Minor differences can be worked through.';
    } else {
      return 'Your values might be too different. This could cause long-term issues.';
    }
  }

  String _generateLifestyleInsight(
    Map<String, dynamic> lifestyle1,
    Map<String, dynamic> lifestyle2,
    double score,
  ) {
    if (score >= 80) {
      return "Your lifestyles are perfectly matched. You'll enjoy life together.";
    } else if (score >= 70) {
      return 'Your lifestyles are compatible with some compromise.';
    } else {
      return 'Your lifestyles might clash. Consider if you can adapt to each other.';
    }
  }

  // Generate compatibility questions for NVS CONNECT
  String generateCompatibilityQuestion() {
    final List<String> questions = <String>[
      "What's your deal with relationships? I'm curious.",
      'How do you handle conflict? I want to know.',
      "What's something you're passionate about?",
      'How do you spend your free time?',
      "What's your take on communication in relationships?",
      'What are you looking for in someone?',
      'How do you deal with stress?',
      "What's your biggest fear?",
      'What makes you happy?',
      'How do you show someone you care?',
      "What's your attachment style? Be honest.",
      "What's your love language?",
      'How do you handle disagreements?',
      'What are your deal-breakers?',
      'How do you express emotions?',
    ];
    return _getRandomResponse(questions);
  }

  // Generate NVS verdict for compatibility
  String generateNvsVerdict(
    int matchScore,
    Map<String, dynamic> compatibility,
  ) {
    if (matchScore >= 90) {
      return "This is fucking electric. You two could be something special. Don't mess this up. Your compatibility is rare.";
    } else if (matchScore >= 80) {
      return "There's definitely something here. You've got potential, but you'll need to work at it. Worth the effort.";
    } else if (matchScore >= 70) {
      return "It could work, but you'll have to put in some effort. Not impossible, but not easy either. Are you ready for that?";
    } else if (matchScore >= 60) {
      return "Look, I'm being real with you. This might be a challenge. You sure about this? It'll take serious work.";
    } else {
      return "I don't want to see you hurt, but this doesn't look promising. Maybe keep looking. Trust me on this.";
    }
  }

  // Generate detailed compatibility breakdown
  String generateCompatibilityBreakdown(Map<String, dynamic> compatibility) {
    final int score = compatibility['overallScore'] as int;
    final String zodiac = compatibility['zodiac']['insight'] as String;
    final String personality = compatibility['personality']['insight'] as String;
    final String communication = compatibility['communication']['insight'] as String;

    return "Here's the real deal: $score% overall match. $zodiac $personality $communication This is my honest assessment.";
  }

  // Generate a flirty message
  String generateFlirtyMessage() {
    final List<String> messages = <String>[
      "You're actually pretty cool. I like your vibe.",
      "I'm into what you're saying. You've got something special.",
      "You're interesting. I want to know more about you.",
      "I like how you think. You're different.",
      "You've got my attention. What else you got?",
    ];
    return _getRandomResponse(messages);
  }

  // Generate a supportive message
  String generateSupportiveMessage() {
    final List<String> messages = <String>[
      "I actually care about this. You're not alone.",
      "Look, I want what's best for you. You deserve good things.",
      "I'm being real with you here. You matter.",
      'This is tough, but you can handle it. I believe in you.',
      "I don't want to see you hurt. Let's figure this out.",
    ];
    return _getRandomResponse(messages);
  }

  // Generate a motivational message
  String generateMotivationalMessage() {
    final List<String> messages = <String>[
      "You've got this. Don't let anyone tell you different.",
      "That's some cool shit you're doing. Keep it up.",
      "I'm actually excited about what you're doing.",
      "You're on the right track. Trust yourself.",
      "This is your moment. Don't waste it.",
    ];
    return _getRandomResponse(messages);
  }

  // ASTROLOGY GENIUS METHODS

  // Analyze complete birth chart compatibility
  Map<String, dynamic> analyzeBirthChartCompatibility(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    final Map<String, dynamic> analysis = <String, dynamic>{};

    // Planetary positions and aspects
    analysis['planets'] = _analyzePlanetaryCompatibility(chart1['planets'], chart2['planets']);

    // House overlays and synastry
    analysis['houses'] = _analyzeHouseCompatibility(chart1['houses'], chart2['houses']);

    // Aspects between charts (synastry)
    analysis['aspects'] = _analyzeSynastryAspects(chart1, chart2);

    // Composite chart analysis
    analysis['composite'] = _analyzeCompositeChart(chart1, chart2);

    // Overall cosmic compatibility
    analysis['cosmicScore'] = _calculateCosmicCompatibility(analysis);

    return analysis;
  }

  // Analyze planetary compatibility
  Map<String, dynamic> _analyzePlanetaryCompatibility(
    Map<String, dynamic> planets1,
    Map<String, dynamic> planets2,
  ) {
    final Map<String, dynamic> analysis = <String, dynamic>{};

    // Sun compatibility (core identity)
    analysis['sun'] = _analyzePlanetAspect('Sun', planets1['sun'], planets2['sun']);

    // Moon compatibility (emotional nature)
    analysis['moon'] = _analyzePlanetAspect('Moon', planets1['moon'], planets2['moon']);

    // Venus compatibility (love and attraction)
    analysis['venus'] = _analyzePlanetAspect('Venus', planets1['venus'], planets2['venus']);

    // Mars compatibility (passion and drive)
    analysis['mars'] = _analyzePlanetAspect('Mars', planets1['mars'], planets2['mars']);

    // Mercury compatibility (communication)
    analysis['mercury'] = _analyzePlanetAspect(
      'Mercury',
      planets1['mercury'],
      planets2['mercury'],
    );

    // Jupiter compatibility (growth and expansion)
    analysis['jupiter'] = _analyzePlanetAspect(
      'Jupiter',
      planets1['jupiter'],
      planets2['jupiter'],
    );

    // Saturn compatibility (commitment and structure)
    analysis['saturn'] = _analyzePlanetAspect('Saturn', planets1['saturn'], planets2['saturn']);

    // Outer planets (generational influences)
    analysis['outer'] = _analyzeOuterPlanets(planets1, planets2);

    return analysis;
  }

  // Analyze outer planets (Uranus, Neptune, Pluto)
  Map<String, dynamic> _analyzeOuterPlanets(
    Map<String, dynamic> planets1,
    Map<String, dynamic> planets2,
  ) {
    final Map<String, dynamic> analysis = <String, dynamic>{};

    // Uranus aspects (innovation and rebellion)
    if (planets1.containsKey('uranus') && planets2.containsKey('uranus')) {
      analysis['uranus'] = _analyzePlanetAspect(
        'Uranus',
        planets1['uranus'],
        planets2['uranus'],
      );
    }

    // Neptune aspects (spirituality and illusion)
    if (planets1.containsKey('neptune') && planets2.containsKey('neptune')) {
      analysis['neptune'] = _analyzePlanetAspect(
        'Neptune',
        planets1['neptune'],
        planets2['neptune'],
      );
    }

    // Pluto aspects (transformation and power)
    if (planets1.containsKey('pluto') && planets2.containsKey('pluto')) {
      analysis['pluto'] = _analyzePlanetAspect('Pluto', planets1['pluto'], planets2['pluto']);
    }

    return analysis;
  }

  // Analyze specific planet aspects
  Map<String, dynamic> _analyzePlanetAspect(
    String planetName,
    Map<String, dynamic> planet1,
    Map<String, dynamic> planet2,
  ) {
    final sign1 = planet1['sign'];
    final sign2 = planet2['sign'];
    final degree1 = planet1['degree'];
    final degree2 = planet2['degree'];

    final String aspect = _calculateAspect(degree1, degree2);
    final Map<String, dynamic> compatibility =
        _getPlanetCompatibility(planetName, sign1, sign2, aspect);

    return <String, dynamic>{
      'aspect': aspect,
      'compatibility': compatibility['score'],
      'insight': compatibility['insight'],
      'description': _getPlanetDescription(planetName, sign1, sign2),
    };
  }

  // Calculate aspect between two degrees
  String _calculateAspect(double degree1, double degree2) {
    final double difference = (degree1 - degree2).abs();

    if (difference <= 8) return 'Conjunction';
    if (difference >= 82 && difference <= 98) return 'Square';
    if (difference >= 118 && difference <= 122) return 'Trine';
    if (difference >= 172 && difference <= 188) return 'Opposition';
    if (difference >= 58 && difference <= 62) return 'Sextile';

    return 'No Major Aspect';
  }

  // Get planet compatibility based on signs and aspects
  Map<String, dynamic> _getPlanetCompatibility(
    String planet,
    String sign1,
    String sign2,
    String aspect,
  ) {
    int score = 70; // Default
    String insight = 'This aspect has moderate influence.';

    switch (planet) {
      case 'Sun':
        score = _getSunCompatibility(sign1, sign2, aspect);
        insight = _getSunInsight(sign1, sign2, aspect);
        break;
      case 'Moon':
        score = _getMoonCompatibility(sign1, sign2, aspect);
        insight = _getMoonInsight(sign1, sign2, aspect);
        break;
      case 'Venus':
        score = _getVenusCompatibility(sign1, sign2, aspect);
        insight = _getVenusInsight(sign1, sign2, aspect);
        break;
      case 'Mars':
        score = _getMarsCompatibility(sign1, sign2, aspect);
        insight = _getMarsInsight(sign1, sign2, aspect);
        break;
      case 'Mercury':
        score = _getMercuryCompatibility(sign1, sign2, aspect);
        insight = _getMercuryInsight(sign1, sign2, aspect);
        break;
    }

    return <String, dynamic>{'score': score, 'insight': insight};
  }

  // Sun compatibility (core identity)
  int _getSunCompatibility(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') return 85;
    if (aspect == 'Trine') return 90;
    if (aspect == 'Sextile') return 80;
    if (aspect == 'Square') return 60;
    if (aspect == 'Opposition') return 70;

    // Same element compatibility
    if (_areSameElement(sign1, sign2)) return 75;
    if (_areCompatibleElements(sign1, sign2)) return 80;
    if (_areIncompatibleElements(sign1, sign2)) return 50;

    return 65;
  }

  String _getSunInsight(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') {
      return 'Your core identities are perfectly aligned. You understand each other on a fundamental level.';
    } else if (aspect == 'Trine') {
      return "Your suns harmonize beautifully. You naturally support each other's growth and identity.";
    } else if (aspect == 'Opposition') {
      return 'Your suns are opposite - you complement each other perfectly. This creates amazing balance.';
    } else if (aspect == 'Square') {
      return "Your suns square each other. This creates tension but also growth potential. You'll challenge each other.";
    }

    return "Your sun signs have moderate compatibility. You'll need to work on understanding each other.";
  }

  // Moon compatibility (emotional nature)
  int _getMoonCompatibility(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') return 95;
    if (aspect == 'Trine') return 90;
    if (aspect == 'Sextile') return 85;
    if (aspect == 'Square') return 50;
    if (aspect == 'Opposition') return 80;

    if (_areSameElement(sign1, sign2)) return 80;
    if (_areCompatibleElements(sign1, sign2)) return 75;
    if (_areIncompatibleElements(sign1, sign2)) return 40;

    return 65;
  }

  String _getMoonInsight(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') {
      return "Your emotional natures are identical. You'll feel completely understood and safe with each other.";
    } else if (aspect == 'Trine') {
      return "Your emotional styles harmonize perfectly. You'll nurture and support each other naturally.";
    } else if (aspect == 'Opposition') {
      return "Your emotional needs are opposite but complementary. You'll balance each other beautifully.";
    } else if (aspect == 'Square') {
      return 'Your emotional styles clash. This will be your biggest challenge but also your biggest growth area.';
    }

    return 'Your emotional compatibility is moderate. Communication about feelings will be key.';
  }

  // Venus compatibility (love and attraction)
  int _getVenusCompatibility(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') return 95;
    if (aspect == 'Trine') return 90;
    if (aspect == 'Sextile') return 85;
    if (aspect == 'Square') return 60;
    if (aspect == 'Opposition') return 85;

    if (_areSameElement(sign1, sign2)) return 85;
    if (_areCompatibleElements(sign1, sign2)) return 80;
    if (_areIncompatibleElements(sign1, sign2)) return 50;

    return 70;
  }

  String _getVenusInsight(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') {
      return "Your love styles are perfectly matched. You'll be irresistibly drawn to each other.";
    } else if (aspect == 'Trine') {
      return 'Your Venus signs harmonize beautifully. Romance and attraction will come naturally.';
    } else if (aspect == 'Opposition') {
      return "Your Venus signs are opposite - you'll be fascinated by each other's different approach to love.";
    } else if (aspect == 'Square') {
      return "Your love styles differ significantly. You'll need to compromise on romance and values.";
    }

    return "Your love compatibility is good. You'll need to learn each other's love languages.";
  }

  // Mars compatibility (passion and drive)
  int _getMarsCompatibility(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') return 90;
    if (aspect == 'Trine') return 85;
    if (aspect == 'Sextile') return 80;
    if (aspect == 'Square') return 70;
    if (aspect == 'Opposition') return 85;

    if (_areSameElement(sign1, sign2)) return 80;
    if (_areCompatibleElements(sign1, sign2)) return 75;
    if (_areIncompatibleElements(sign1, sign2)) return 60;

    return 70;
  }

  String _getMarsInsight(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') {
      return "Your passion and drive are perfectly aligned. You'll be incredibly attracted to each other.";
    } else if (aspect == 'Trine') {
      return "Your Mars signs work together beautifully. You'll motivate and inspire each other.";
    } else if (aspect == 'Opposition') {
      return 'Your Mars signs are opposite - this creates intense sexual chemistry and passion.';
    } else if (aspect == 'Square') {
      return 'Your Mars signs square each other. This creates tension but also incredible passion.';
    }

    return "Your passion compatibility is moderate. You'll need to work on physical and emotional intimacy.";
  }

  // Mercury compatibility (communication)
  int _getMercuryCompatibility(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') return 90;
    if (aspect == 'Trine') return 85;
    if (aspect == 'Sextile') return 80;
    if (aspect == 'Square') return 65;
    if (aspect == 'Opposition') return 80;

    if (_areSameElement(sign1, sign2)) return 85;
    if (_areCompatibleElements(sign1, sign2)) return 80;
    if (_areIncompatibleElements(sign1, sign2)) return 55;

    return 70;
  }

  String _getMercuryInsight(String sign1, String sign2, String aspect) {
    if (aspect == 'Conjunction') {
      return "Your communication styles are identical. You'll understand each other perfectly.";
    } else if (aspect == 'Trine') {
      return 'Your Mercury signs harmonize beautifully. Communication will flow naturally between you.';
    } else if (aspect == 'Opposition') {
      return "Your communication styles are opposite but complementary. You'll learn from each other.";
    } else if (aspect == 'Square') {
      return 'Your communication styles clash. This will be challenging but also educational.';
    }

    return "Your communication compatibility is good. You'll need to work on understanding each other's style.";
  }

  // Helper methods for element compatibility
  bool _areSameElement(String sign1, String sign2) {
    final List<String> fireSigns = <String>['aries', 'leo', 'sagittarius'];
    final List<String> earthSigns = <String>['taurus', 'virgo', 'capricorn'];
    final List<String> airSigns = <String>['gemini', 'libra', 'aquarius'];
    final List<String> waterSigns = <String>['cancer', 'scorpio', 'pisces'];

    return (fireSigns.contains(sign1.toLowerCase()) && fireSigns.contains(sign2.toLowerCase())) ||
        (earthSigns.contains(sign1.toLowerCase()) && earthSigns.contains(sign2.toLowerCase())) ||
        (airSigns.contains(sign1.toLowerCase()) && airSigns.contains(sign2.toLowerCase())) ||
        (waterSigns.contains(sign1.toLowerCase()) && waterSigns.contains(sign2.toLowerCase()));
  }

  bool _areCompatibleElements(String sign1, String sign2) {
    final List<String> fireSigns = <String>['aries', 'leo', 'sagittarius'];
    final List<String> earthSigns = <String>['taurus', 'virgo', 'capricorn'];
    final List<String> airSigns = <String>['gemini', 'libra', 'aquarius'];
    final List<String> waterSigns = <String>['cancer', 'scorpio', 'pisces'];

    // Fire + Air, Earth + Water are compatible
    return (fireSigns.contains(sign1.toLowerCase()) && airSigns.contains(sign2.toLowerCase())) ||
        (airSigns.contains(sign1.toLowerCase()) && fireSigns.contains(sign2.toLowerCase())) ||
        (earthSigns.contains(sign1.toLowerCase()) && waterSigns.contains(sign2.toLowerCase())) ||
        (waterSigns.contains(sign1.toLowerCase()) && earthSigns.contains(sign2.toLowerCase()));
  }

  bool _areIncompatibleElements(String sign1, String sign2) {
    final List<String> fireSigns = <String>['aries', 'leo', 'sagittarius'];
    final List<String> earthSigns = <String>['taurus', 'virgo', 'capricorn'];
    final List<String> airSigns = <String>['gemini', 'libra', 'aquarius'];
    final List<String> waterSigns = <String>['cancer', 'scorpio', 'pisces'];

    // Fire + Water, Earth + Air are incompatible
    return (fireSigns.contains(sign1.toLowerCase()) && waterSigns.contains(sign2.toLowerCase())) ||
        (waterSigns.contains(sign1.toLowerCase()) && fireSigns.contains(sign2.toLowerCase())) ||
        (earthSigns.contains(sign1.toLowerCase()) && airSigns.contains(sign2.toLowerCase())) ||
        (airSigns.contains(sign1.toLowerCase()) && earthSigns.contains(sign2.toLowerCase()));
  }

  // Get planet descriptions
  String _getPlanetDescription(String planet, String sign1, String sign2) {
    final Map<String, Map<String, String>> descriptions = <String, Map<String, String>>{
      'Sun': <String, String>{
        'aries': 'Bold, confident, natural leader',
        'taurus': 'Stable, sensual, determined',
        'gemini': 'Versatile, curious, communicative',
        'cancer': 'Nurturing, emotional, protective',
        'leo': 'Dramatic, generous, creative',
        'virgo': 'Analytical, practical, perfectionist',
        'libra': 'Diplomatic, charming, balanced',
        'scorpio': 'Intense, passionate, mysterious',
        'sagittarius': 'Optimistic, adventurous, philosophical',
        'capricorn': 'Ambitious, disciplined, responsible',
        'aquarius': 'Innovative, independent, humanitarian',
        'pisces': 'Compassionate, artistic, intuitive',
      },
    };

    final String desc1 = descriptions[planet]?[sign1.toLowerCase()] ?? 'Unique individual';
    final String desc2 = descriptions[planet]?[sign2.toLowerCase()] ?? 'Unique individual';

    return '$desc1 meets $desc2';
  }

  // Analyze house compatibility
  Map<String, dynamic> _analyzeHouseCompatibility(
    Map<String, dynamic> houses1,
    Map<String, dynamic> houses2,
  ) {
    final Map<String, dynamic> analysis = <String, dynamic>{};

    // 7th house (partnerships)
    analysis['seventh'] = _analyzeHouseOverlay('7th', houses1['seventh'], houses2['seventh']);

    // 5th house (romance)
    analysis['fifth'] = _analyzeHouseOverlay('5th', houses1['fifth'], houses2['fifth']);

    // 8th house (intimacy)
    analysis['eighth'] = _analyzeHouseOverlay('8th', houses1['eighth'], houses2['eighth']);

    // 1st house (identity)
    analysis['first'] = _analyzeHouseOverlay('1st', houses1['first'], houses2['first']);

    return analysis;
  }

  Map<String, dynamic> _analyzeHouseOverlay(
    String house,
    Map<String, dynamic> house1,
    Map<String, dynamic> house2,
  ) {
    final List<String> planets1 = house1['planets'] as List<String>;
    final List<String> planets2 = house2['planets'] as List<String>;

    int score = 70;
    String insight = 'This house has moderate influence on your relationship.';

    if (planets1.isNotEmpty && planets2.isNotEmpty) {
      score = 85;
      insight =
          'Both of you have planets in this house. This area will be very active in your relationship.';
    } else if (planets1.isNotEmpty || planets2.isNotEmpty) {
      score = 75;
      insight =
          'One of you has planets in this house. This area will be important for your relationship.';
    }

    return <String, dynamic>{
      'score': score,
      'insight': insight,
      'planets1': planets1,
      'planets2': planets2,
    };
  }

  // Analyze synastry aspects
  Map<String, dynamic> _analyzeSynastryAspects(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    final Map<String, dynamic> aspects = <String, dynamic>{};

    // Major aspects between personal planets
    aspects['major'] = _findMajorAspects(chart1, chart2);

    // Karmic aspects
    aspects['karmic'] = _findKarmicAspects(chart1, chart2);

    // Sexual chemistry aspects
    aspects['chemistry'] = _findChemistryAspects(chart1, chart2);

    return aspects;
  }

  List<Map<String, dynamic>> _findMajorAspects(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    final List<Map<String, dynamic>> aspects = <Map<String, dynamic>>[];

    // Sun-Moon aspects (most important)
    final String sunMoonAspect = _calculateAspect(
      chart1['planets']['sun']['degree'],
      chart2['planets']['moon']['degree'],
    );

    if (sunMoonAspect != 'No Major Aspect') {
      aspects.add(<String, dynamic>{
        'type': 'Sun-Moon',
        'aspect': sunMoonAspect,
        'description': 'Core emotional connection',
        'importance': 'Critical',
      });
    }

    // Venus-Mars aspects (romantic chemistry)
    final String venusMarsAspect = _calculateAspect(
      chart1['planets']['venus']['degree'],
      chart2['planets']['mars']['degree'],
    );

    if (venusMarsAspect != 'No Major Aspect') {
      aspects.add(<String, dynamic>{
        'type': 'Venus-Mars',
        'aspect': venusMarsAspect,
        'description': 'Romantic and sexual chemistry',
        'importance': 'High',
      });
    }

    return aspects;
  }

  List<Map<String, dynamic>> _findKarmicAspects(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    final List<Map<String, dynamic>> aspects = <Map<String, dynamic>>[];

    // Saturn aspects (karmic lessons)
    final List<Map<String, dynamic>> saturnAspects = _findSaturnAspects(chart1, chart2);
    aspects.addAll(saturnAspects);

    // Pluto aspects (transformation)
    final List<Map<String, dynamic>> plutoAspects = _findPlutoAspects(chart1, chart2);
    aspects.addAll(plutoAspects);

    return aspects;
  }

  List<Map<String, dynamic>> _findChemistryAspects(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    final List<Map<String, dynamic>> aspects = <Map<String, dynamic>>[];

    // Mars-Pluto aspects (intense passion)
    final String marsPlutoAspect = _calculateAspect(
      chart1['planets']['mars']['degree'],
      chart2['planets']['pluto']['degree'],
    );

    if (marsPlutoAspect != 'No Major Aspect') {
      aspects.add(<String, dynamic>{
        'type': 'Mars-Pluto',
        'aspect': marsPlutoAspect,
        'description': 'Intense sexual chemistry and power dynamics',
        'importance': 'High',
      });
    }

    return aspects;
  }

  List<Map<String, dynamic>> _findSaturnAspects(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    // Simplified Saturn aspect analysis
    return <Map<String, dynamic>>[
      <String, dynamic>{
        'type': 'Saturn',
        'aspect': 'Conjunction',
        'description': 'Karmic commitment and lessons',
        'importance': 'High',
      }
    ];
  }

  List<Map<String, dynamic>> _findPlutoAspects(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    // Simplified Pluto aspect analysis
    return <Map<String, dynamic>>[
      <String, dynamic>{
        'type': 'Pluto',
        'aspect': 'Trine',
        'description': 'Transformative relationship potential',
        'importance': 'Medium',
      }
    ];
  }

  // Analyze composite chart
  Map<String, dynamic> _analyzeCompositeChart(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    return <String, dynamic>{
      'sun': _calculateCompositeSun(chart1, chart2),
      'moon': _calculateCompositeMoon(chart1, chart2),
      'venus': _calculateCompositeVenus(chart1, chart2),
      'insight': 'Your composite chart shows the essence of your relationship.',
    };
  }

  Map<String, dynamic> _calculateCompositeSun(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    final degree1 = chart1['planets']['sun']['degree'];
    final degree2 = chart2['planets']['sun']['degree'];
    final compositeDegree = (degree1 + degree2) / 2;

    return <String, dynamic>{
      'degree': compositeDegree,
      'sign': _degreeToSign(compositeDegree),
      'description': 'The core purpose of your relationship',
    };
  }

  Map<String, dynamic> _calculateCompositeMoon(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    final degree1 = chart1['planets']['moon']['degree'];
    final degree2 = chart2['planets']['moon']['degree'];
    final compositeDegree = (degree1 + degree2) / 2;

    return <String, dynamic>{
      'degree': compositeDegree,
      'sign': _degreeToSign(compositeDegree),
      'description': 'The emotional foundation of your relationship',
    };
  }

  Map<String, dynamic> _calculateCompositeVenus(
    Map<String, dynamic> chart1,
    Map<String, dynamic> chart2,
  ) {
    final degree1 = chart1['planets']['venus']['degree'];
    final degree2 = chart2['planets']['venus']['degree'];
    final compositeDegree = (degree1 + degree2) / 2;

    return <String, dynamic>{
      'degree': compositeDegree,
      'sign': _degreeToSign(compositeDegree),
      'description': 'The love and beauty in your relationship',
    };
  }

  String _degreeToSign(double degree) {
    final List<String> signs = <String>[
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
      'Sagittarius',
      'Capricorn',
      'Aquarius',
      'Pisces',
    ];

    final int signIndex = (degree / 30).floor();
    return signs[signIndex % 12];
  }

  // Calculate overall cosmic compatibility
  int _calculateCosmicCompatibility(Map<String, dynamic> analysis) {
    final List planetScores = <dynamic>[
      analysis['planets']['sun']['compatibility'],
      analysis['planets']['moon']['compatibility'],
      analysis['planets']['venus']['compatibility'],
      analysis['planets']['mars']['compatibility'],
      analysis['planets']['mercury']['compatibility'],
    ];

    final List houseScores = <dynamic>[
      analysis['houses']['seventh']['score'],
      analysis['houses']['fifth']['score'],
      analysis['houses']['eighth']['score'],
    ];

    final List allScores = <dynamic>[...planetScores, ...houseScores];
    return (allScores.reduce((a, b) => a + b) / allScores.length).round();
  }

  // Generate astrological insights
  String generateAstrologicalInsight(Map<String, dynamic> compatibility) {
    final int cosmicScore = compatibility['cosmicScore'] as int;
    final String sunInsight = compatibility['planets']['sun']['insight'] as String;
    final String moonInsight = compatibility['planets']['moon']['insight'] as String;
    final String venusInsight = compatibility['planets']['venus']['insight'] as String;

    if (cosmicScore >= 90) {
      return "This is cosmically perfect. Your birth charts are aligned like the stars intended. $sunInsight $moonInsight $venusInsight This is rare and precious. Don't let it go.";
    } else if (cosmicScore >= 80) {
      return 'Your cosmic compatibility is exceptional. $sunInsight $moonInsight $venusInsight The universe is definitely on your side here.';
    } else if (cosmicScore >= 70) {
      return "Good cosmic compatibility. $sunInsight $moonInsight $venusInsight You'll have challenges, but the stars support your connection.";
    } else if (cosmicScore >= 60) {
      return "Moderate cosmic compatibility. $sunInsight $moonInsight $venusInsight This will require work, but it's not impossible.";
    } else {
      return "The stars suggest challenges ahead. $sunInsight $moonInsight $venusInsight This doesn't mean it can't work, but you'll need to work harder.";
    }
  }

  // Generate birth chart reading
  String generateBirthChartReading(Map<String, dynamic> chart) {
    final sun = chart['planets']['sun'];
    final moon = chart['planets']['moon'];
    final venus = chart['planets']['venus'];
    final mars = chart['planets']['mars'];

    return "Your ${sun['sign']} sun gives you ${_getSunDescription(sun['sign'])}. Your ${moon['sign']} moon makes you ${_getMoonDescription(moon['sign'])}. In love, your ${venus['sign']} Venus ${_getVenusDescription(venus['sign'])}. And your ${mars['sign']} Mars ${_getMarsDescription(mars['sign'])}. This is a powerful combination.";
  }

  String _getSunDescription(String sign) {
    final Map<String, String> descriptions = <String, String>{
      'aries': 'natural leadership and bold confidence',
      'taurus': 'unwavering determination and sensual nature',
      'gemini': 'versatile intelligence and curious spirit',
      'cancer': 'deep emotional intelligence and nurturing heart',
      'leo': 'dramatic creativity and generous warmth',
      'virgo': 'analytical precision and practical wisdom',
      'libra': 'diplomatic charm and balanced perspective',
      'scorpio': 'intense passion and mysterious depth',
      'sagittarius': 'optimistic adventure and philosophical mind',
      'capricorn': 'ambitious drive and disciplined approach',
      'aquarius': 'innovative thinking and humanitarian vision',
      'pisces': 'artistic sensitivity and intuitive wisdom',
    };
    return descriptions[sign.toLowerCase()] ?? 'unique qualities';
  }

  String _getMoonDescription(String sign) {
    final Map<String, String> descriptions = <String, String>{
      'aries': 'emotionally bold and quick to react',
      'taurus': 'emotionally stable and deeply sensual',
      'gemini': 'emotionally curious and mentally active',
      'cancer': 'emotionally nurturing and deeply protective',
      'leo': 'emotionally dramatic and passionately expressive',
      'virgo': 'emotionally analytical and practically caring',
      'libra': 'emotionally balanced and diplomatically sensitive',
      'scorpio': 'emotionally intense and psychologically deep',
      'sagittarius': 'emotionally optimistic and philosophically minded',
      'capricorn': 'emotionally disciplined and responsibly caring',
      'aquarius': 'emotionally independent and intellectually detached',
      'pisces': 'emotionally compassionate and spiritually connected',
    };
    return descriptions[sign.toLowerCase()] ?? 'emotionally unique';
  }

  String _getVenusDescription(String sign) {
    final Map<String, String> descriptions = <String, String>{
      'aries': 'loves with passion and excitement',
      'taurus': 'loves with loyalty and sensuality',
      'gemini': 'loves with curiosity and communication',
      'cancer': 'loves with nurturing care and emotional depth',
      'leo': 'loves with dramatic romance and generosity',
      'virgo': 'loves with practical care and attention to detail',
      'libra': 'loves with charm and balanced harmony',
      'scorpio': 'loves with intense passion and deep commitment',
      'sagittarius': 'loves with adventure and philosophical connection',
      'capricorn': 'loves with commitment and practical stability',
      'aquarius': 'loves with independence and intellectual connection',
      'pisces': 'loves with compassion and spiritual connection',
    };
    return descriptions[sign.toLowerCase()] ?? 'loves in a unique way';
  }

  String _getMarsDescription(String sign) {
    final Map<String, String> descriptions = <String, String>{
      'aries': 'drives with bold action and competitive spirit',
      'taurus': 'drives with steady determination and sensual energy',
      'gemini': 'drives with mental agility and versatile action',
      'cancer': 'drives with emotional motivation and protective energy',
      'leo': 'drives with dramatic passion and creative energy',
      'virgo': 'drives with precise action and practical efficiency',
      'libra': 'drives with balanced action and diplomatic energy',
      'scorpio': 'drives with intense focus and transformative energy',
      'sagittarius': 'drives with adventurous spirit and philosophical energy',
      'capricorn': 'drives with disciplined action and ambitious energy',
      'aquarius': 'drives with innovative action and humanitarian energy',
      'pisces': 'drives with intuitive action and spiritual energy',
    };
    return descriptions[sign.toLowerCase()] ?? 'drives with unique energy';
  }

  // Generate astrological question
  String generateAstrologicalQuestion() {
    final List<String> questions = <String>[
      "What's your birth chart like? I want to see the cosmic blueprint.",
      'Tell me about your sun, moon, and rising signs. This matters.',
      "What's your Venus sign? I need to know how you love.",
      "What's your Mars sign? I want to understand your passion.",
      'When were you born? I need to calculate your birth chart.',
      "What's your rising sign? This shows how you present yourself.",
      "Do you know your birth time? It's crucial for accurate astrology.",
      'What house is your Venus in? This affects your love life.',
      'What aspects does your moon make? This shows your emotional nature.',
      'Tell me about your Saturn placement. It shows your karmic lessons.',
    ];
    return _getRandomResponse(questions);
  }

  // Generate cosmic compatibility verdict
  String generateCosmicVerdict(int cosmicScore, Map<String, dynamic> analysis) {
    if (cosmicScore >= 90) {
      return "The stars have aligned perfectly for you two. This is cosmic destiny. Your birth charts are in perfect harmony. Don't question this - it's written in the stars.";
    } else if (cosmicScore >= 80) {
      return 'The cosmos strongly supports this connection. Your astrological compatibility is exceptional. The universe is definitely on your side. Trust the stars.';
    } else if (cosmicScore >= 70) {
      return "The stars show good compatibility. You have cosmic support, but you'll need to work at it. The universe is giving you a chance - don't waste it.";
    } else if (cosmicScore >= 60) {
      return "The stars suggest challenges, but not impossibility. Your cosmic compatibility is moderate. You'll need to work harder, but it's not doomed.";
    } else {
      return "The stars are showing some serious challenges. Your cosmic compatibility is low. This doesn't mean it can't work, but you'll be fighting against the cosmic currents.";
    }
  }
}
