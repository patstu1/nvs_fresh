import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// AICompatibilityReport class definition
class AICompatibilityReport {
  final String compatibilityPercent;
  final String cosmicVerdict;

  AICompatibilityReport({
    required this.compatibilityPercent,
    required this.cosmicVerdict,
  });
}

class AiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Generate AI response using Firebase Functions or external API
  Future<String> generateResponse(String prompt) async {
    try {
      // Log AI interaction for analytics
      await _logAIInteraction(prompt);

      // For now, return a sophisticated placeholder
      // In production, this would call your AI service
      return _generateContextualResponse(prompt);
    } catch (e) {
      print('Error generating AI response: $e');
      return 'I apologize, but I\'m having trouble processing that right now. Could you try rephrasing your question?';
    }
  }

  /// Generate personality-based AI response
  Future<String> generatePersonalityResponse(
    String prompt,
    String personalityType,
  ) async {
    try {
      await _logAIInteraction(prompt, personalityType: personalityType);
      return _generatePersonalityBasedResponse(prompt, personalityType);
    } catch (e) {
      print('Error generating personality response: $e');
      return 'Let me think about that... *adjusts personality settings*';
    }
  }

  /// Generate matchmaking insights
  Future<Map<String, dynamic>> generateMatchInsights(
    String userId1,
    String userId2,
  ) async {
    try {
      // Get user profiles for context
      final user1Doc = await _firestore.collection('users').doc(userId1).get();
      final user2Doc = await _firestore.collection('users').doc(userId2).get();

      if (!user1Doc.exists || !user2Doc.exists) {
        throw Exception('User profiles not found');
      }

      return {
        'compatibilityScore': _calculateCompatibility(
          user1Doc.data()!,
          user2Doc.data()!,
        ),
        'strengths': _getRelationshipStrengths(
          user1Doc.data()!,
          user2Doc.data()!,
        ),
        'challenges': _getRelationshipChallenges(
          user1Doc.data()!,
          user2Doc.data()!,
        ),
        'recommendations': _getRecommendations(
          user1Doc.data()!,
          user2Doc.data()!,
        ),
      };
    } catch (e) {
      print('Error generating match insights: $e');
      return {
        'compatibilityScore': 75,
        'strengths': ['Great communication potential'],
        'challenges': ['Different energy levels'],
        'recommendations': ['Try activity-based dates'],
      };
    }
  }

  /// Generates a short personality summary using social profile links.
  Future<String> generatePersonalitySummary({
    required String instagramProfile,
    required String tiktokProfile,
    required String twitterProfile,
  }) async {
    final prompt =
        'Generate a concise, engaging personality summary for a dating profile based on the following social media accounts: Instagram: $instagramProfile, TikTok: $tiktokProfile, Twitter: $twitterProfile.';
    return generateResponse(prompt);
  }

  // Inside the AIService class
  Future<AICompatibilityReport> getCompatibilityReport(
    String targetUserId,
  ) async {
    // We only need the target ID. The current user's ID can be accessed
    // from a user state provider within this service.
    // This is the correct, cleaner architecture.
    print("Fetching compatibility for target: $targetUserId");
    // TODO: Implement the actual API call logic
    return AICompatibilityReport(
      compatibilityPercent: "84%",
      cosmicVerdict:
          "Intel suggests a high probability of chaotic, beautiful entanglement.",
    );
  }

  /// Log AI interaction for analytics
  Future<void> _logAIInteraction(
    String prompt, {
    String? personalityType,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('ai_interactions').add({
        'userId': user.uid,
        'prompt': prompt,
        'personalityType': personalityType,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error logging AI interaction: $e');
    }
  }

  /// Generate contextual response based on prompt analysis
  String _generateContextualResponse(String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    if (lowerPrompt.contains('match') || lowerPrompt.contains('compatible')) {
      return 'Based on your profile and preferences, I see some exciting potential matches. Your authenticity and interests align well with several users nearby. Would you like me to highlight the most promising connections?';
    } else if (lowerPrompt.contains('message') ||
        lowerPrompt.contains('chat')) {
      return 'Great question! Authentic, genuine messages tend to get the best responses. Try mentioning something specific from their profile that caught your attention. What kind of vibe are you going for?';
    } else if (lowerPrompt.contains('profile') || lowerPrompt.contains('bio')) {
      return 'Your profile is your digital first impression! Focus on what makes you uniquely you - your passions, sense of humor, and what you\'re genuinely looking for. Want some specific suggestions?';
    } else if (lowerPrompt.contains('date') ||
        lowerPrompt.contains('meeting')) {
      return 'The best dates feel effortless because there\'s genuine connection. Consider activities that let you both be yourselves - whether that\'s grabbing coffee, exploring a museum, or trying that new restaurant you\'ve been curious about.';
    } else {
      return 'I\'m here to help you navigate the dating world with confidence and authenticity. Whether it\'s profile tips, conversation starters, or relationship advice, what would be most helpful right now?';
    }
  }

  /// Generate personality-based response
  String _generatePersonalityBasedResponse(
    String prompt,
    String personalityType,
  ) {
    switch (personalityType.toLowerCase()) {
      case 'flirty':
        return 'Well hello there... *winks* I love the energy you\'re bringing! Let\'s turn up the charm and see what magic happens. What\'s got you feeling adventurous today? 😏';
      case 'supportive':
        return 'I\'m here for you, and I believe in you completely. Whatever you\'re going through, remember that you\'re worthy of love and connection. Take a deep breath - we\'ll figure this out together. 💙';
      case 'witty':
        return 'Oh, you want to go there? *adjusts imaginary glasses* Well, buckle up buttercup, because I\'ve got opinions and they\'re surprisingly well-informed. What\'s the tea? ☕';
      case 'wise':
        return 'Ah, grasshopper, you seek wisdom in the digital age of romance... *strokes beard thoughtfully* The path to authentic connection often lies not in perfection, but in vulnerability. What truth are you ready to embrace?';
      default:
        return 'Every person and situation is unique, just like you. Let\'s approach this with openness and curiosity. What feels most important to you right now?';
    }
  }

  /// Calculate compatibility score
  int _calculateCompatibility(
    Map<String, dynamic> user1,
    Map<String, dynamic> user2,
  ) {
    int score = 50; // Base score

    // Age compatibility
    final age1 = user1['age'] ?? 25;
    final age2 = user2['age'] ?? 25;
    final ageDiff = (age1 - age2).abs();
    if (ageDiff <= 5) {
      score += 15;
    } else if (ageDiff <= 10)
      score += 5;

    // Interest overlap
    final interests1 = List<String>.from(user1['interests'] ?? []);
    final interests2 = List<String>.from(user2['interests'] ?? []);
    final commonInterests = interests1
        .where((i) => interests2.contains(i))
        .length;
    score += commonInterests * 5;

    // Location proximity (placeholder)
    score += 10;

    return score.clamp(0, 100);
  }

  /// Get relationship strengths
  List<String> _getRelationshipStrengths(
    Map<String, dynamic> user1,
    Map<String, dynamic> user2,
  ) {
    return [
      'Shared values and life goals',
      'Complementary communication styles',
      'Similar energy levels and social preferences',
      'Strong intellectual connection potential',
    ];
  }

  /// Get relationship challenges
  List<String> _getRelationshipChallenges(
    Map<String, dynamic> user1,
    Map<String, dynamic> user2,
  ) {
    return [
      'Different approaches to conflict resolution',
      'Varying levels of emotional expression',
      'Potential scheduling conflicts due to lifestyle differences',
    ];
  }

  /// Get relationship recommendations
  List<String> _getRecommendations(
    Map<String, dynamic> user1,
    Map<String, dynamic> user2,
  ) {
    return [
      'Start with low-pressure activities you both enjoy',
      'Focus on active listening during conversations',
      'Be open about your communication preferences early on',
      'Take time to appreciate each other\'s unique perspectives',
    ];
  }
}
