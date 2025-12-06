import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/live_room_model.dart';
import '../data/room_theme.dart';

/// AI-driven theme management system that analyzes user sentiment and automatically
/// suggests optimal themes based on group dynamics, chat patterns, and user behavior.
///
/// This system implements patent-pending "AI-driven, context-adaptive virtual environments"
/// technology that creates personalized, dynamic room experiences.
class ThemeManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sentiment analysis weights
  static const double _chatActivityWeight = 0.3;
  static const double _userMovementWeight = 0.2;
  static const double _audioLevelWeight = 0.25;
  static const double _interactionPatternWeight = 0.25;

  // Theme transition thresholds
  static const double _highEnergyThreshold = 0.7;
  static const double _lowEnergyThreshold = 0.3;
  static const int _minParticipantsForAnalysis = 3;

  // Cache for performance
  final Map<String, SentimentAnalysis> _sentimentCache = <String, SentimentAnalysis>{};
  final Map<String, Timer> _analysisTimers = <String, Timer>{};

  /// Analyzes current room sentiment and suggests optimal theme
  Future<RoomTheme> analyzeAndSuggestTheme(String roomId) async {
    try {
      final SentimentAnalysis analysis = await _performSentimentAnalysis(roomId);
      final RoomTheme suggestedTheme = _determineOptimalTheme(analysis);

      // Cache the analysis
      _sentimentCache[roomId] = analysis;

      // Log for AI training
      await _logThemeSuggestion(roomId, analysis, suggestedTheme);

      return suggestedTheme;
    } catch (e) {
      debugPrint('Theme analysis failed: $e');
      return RoomTheme.cyberpunkRave; // Default fallback
    }
  }

  /// Performs comprehensive sentiment analysis on room participants
  Future<SentimentAnalysis> _performSentimentAnalysis(String roomId) async {
    final LiveRoom? room = await _getRoomData(roomId);
    if (room == null) {
      throw Exception('Room not found');
    }

    if (room.participants.length < _minParticipantsForAnalysis) {
      return SentimentAnalysis.defaultAnalysis();
    }

    final SentimentAnalysis analysis = SentimentAnalysis();

    // Analyze chat activity patterns
    await _analyzeChatActivity(roomId, analysis);

    // Analyze user movement and interaction patterns
    await _analyzeUserInteractions(roomId, analysis);

    // Analyze audio levels and patterns
    await _analyzeAudioPatterns(roomId, analysis);

    // Analyze user profiles and preferences
    await _analyzeUserProfiles(room.participants, analysis);

    // Calculate weighted sentiment score
    analysis.calculateOverallSentiment();

    return analysis;
  }

  /// Analyzes chat activity patterns for sentiment indicators
  Future<void> _analyzeChatActivity(
    String roomId,
    SentimentAnalysis analysis,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> messages = await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      if (messages.docs.isEmpty) {
        analysis.chatActivityScore = 0.5; // Neutral
        return;
      }

      int totalMessages = 0;
      int positiveEmojis = 0;
      int negativeEmojis = 0;
      int questionCount = 0;
      int exclamationCount = 0;
      final Set<String> activeUsers = <String>{};

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in messages.docs) {
        final Map<String, dynamic> message = doc.data();
        final String text = message['message']?.toString().toLowerCase() ?? '';

        totalMessages++;
        activeUsers.add(message['userId'] ?? '');

        // Analyze emoji patterns
        if (_containsPositiveEmojis(text)) positiveEmojis++;
        if (_containsNegativeEmojis(text)) negativeEmojis++;

        // Analyze punctuation patterns
        if (text.contains('?')) questionCount++;
        if (text.contains('!')) exclamationCount++;
      }

      // Calculate chat activity score
      final double messageRate = totalMessages / 10; // Messages per 10 minutes
      final double emojiRatio = positiveEmojis / (positiveEmojis + negativeEmojis + 1);
      final double punctuationEnergy = (exclamationCount - questionCount) / (totalMessages + 1);
      final double userEngagement = activeUsers.length / messages.docs.length;

      analysis.chatActivityScore = _normalizeScore(
        (messageRate * 0.3) +
            (emojiRatio * 0.3) +
            (punctuationEnergy * 0.2) +
            (userEngagement * 0.2),
      );
    } catch (e) {
      debugPrint('Chat analysis failed: $e');
      analysis.chatActivityScore = 0.5;
    }
  }

  /// Analyzes user interaction patterns and movement
  Future<void> _analyzeUserInteractions(
    String roomId,
    SentimentAnalysis analysis,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> participants =
          await _firestore.collection('rooms').doc(roomId).collection('participants').get();

      if (participants.docs.isEmpty) {
        analysis.userInteractionScore = 0.5;
        return;
      }

      int videoEnabledCount = 0;
      int audioEnabledCount = 0;
      int screenSharingCount = 0;
      final List<DateTime> joinTimes = <DateTime>[];

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in participants.docs) {
        final Map<String, dynamic> participant = doc.data();

        if (participant['isVideoEnabled'] == true) videoEnabledCount++;
        if (participant['isAudioEnabled'] == true) audioEnabledCount++;
        if (participant['isScreenSharing'] == true) screenSharingCount++;

        final DateTime joinTime = (participant['joinedAt'] as Timestamp).toDate();
        joinTimes.add(joinTime);
      }

      final int totalParticipants = participants.docs.length;
      final double videoRatio = videoEnabledCount / totalParticipants;
      final double audioRatio = audioEnabledCount / totalParticipants;
      final double sharingRatio = screenSharingCount / totalParticipants;

      // Calculate interaction score based on engagement levels
      analysis.userInteractionScore = _normalizeScore(
        (videoRatio * 0.4) + (audioRatio * 0.4) + (sharingRatio * 0.2),
      );
    } catch (e) {
      debugPrint('User interaction analysis failed: $e');
      analysis.userInteractionScore = 0.5;
    }
  }

  /// Analyzes audio patterns and levels
  Future<void> _analyzeAudioPatterns(
    String roomId,
    SentimentAnalysis analysis,
  ) async {
    try {
      // This would integrate with WebRTC audio analysis
      // For now, we'll simulate based on user audio states
      final QuerySnapshot<Map<String, dynamic>> participants =
          await _firestore.collection('rooms').doc(roomId).collection('participants').get();

      int audioEnabledCount = 0;
      int speakingCount = 0;

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in participants.docs) {
        final Map<String, dynamic> participant = doc.data();
        if (participant['isAudioEnabled'] == true) {
          audioEnabledCount++;
          // Simulate speaking detection based on recent activity
          if (participant['lastActivity'] != null) {
            final DateTime lastActivity = (participant['lastActivity'] as Timestamp).toDate();
            if (DateTime.now().difference(lastActivity).inMinutes < 2) {
              speakingCount++;
            }
          }
        }
      }

      final int totalParticipants = participants.docs.length;
      final double audioEngagement = audioEnabledCount / totalParticipants;
      final double speakingEngagement = speakingCount / (audioEnabledCount + 1);

      analysis.audioLevelScore = _normalizeScore(
        (audioEngagement * 0.6) + (speakingEngagement * 0.4),
      );
    } catch (e) {
      debugPrint('Audio analysis failed: $e');
      analysis.audioLevelScore = 0.5;
    }
  }

  /// Analyzes user profiles and preferences for theme compatibility
  Future<void> _analyzeUserProfiles(
    List<String> userIds,
    SentimentAnalysis analysis,
  ) async {
    try {
      final List<Map<String, dynamic>?> profiles = await Future.wait(
        userIds.map(_getUserProfile),
      );

      final List<Map<String, dynamic>?> validProfiles =
          profiles.where((Map<String, dynamic>? profile) => profile != null).toList();
      if (validProfiles.isEmpty) {
        analysis.userProfileScore = 0.5;
        return;
      }

      // Analyze user interests and preferences
      final List<String> allInterests = <String>[];
      final List<String> allMoods = <String>[];

      for (final Map<String, dynamic>? profile in validProfiles) {
        allInterests.addAll(profile!['interests'] ?? <String>[]);
        allMoods.addAll(profile['moods'] ?? <String>[]);
      }

      // Calculate preference scores for different themes
      final Map<RoomTheme, double> themePreferences = _calculateThemePreferences(
        allInterests,
        allMoods,
      );
      analysis.userProfileScore = _getAveragePreference(themePreferences);
    } catch (e) {
      debugPrint('User profile analysis failed: $e');
      analysis.userProfileScore = 0.5;
    }
  }

  /// Determines optimal theme based on sentiment analysis
  RoomTheme _determineOptimalTheme(SentimentAnalysis analysis) {
    final double overallScore = analysis.overallSentiment;

    // High energy scenarios
    if (overallScore > _highEnergyThreshold) {
      if (analysis.chatActivityScore > 0.7) {
        return RoomTheme.cyberpunkRave;
      } else if (analysis.userInteractionScore > 0.6) {
        return RoomTheme.midnightClub;
      } else {
        return RoomTheme.urbanSunset;
      }
    }

    // Low energy scenarios
    if (overallScore < _lowEnergyThreshold) {
      if (analysis.userProfileScore > 0.6) {
        return RoomTheme.digitalGarden;
      } else {
        return RoomTheme.chillLoft;
      }
    }

    // Medium energy scenarios
    if (analysis.audioLevelScore > 0.6) {
      return RoomTheme.techLounge;
    } else if (analysis.chatActivityScore > 0.5) {
      return RoomTheme.neonNoir;
    } else {
      return RoomTheme.cosmicVoid;
    }
  }

  /// Starts continuous sentiment monitoring for a room
  void startSentimentMonitoring(String roomId) {
    if (_analysisTimers.containsKey(roomId)) {
      _analysisTimers[roomId]?.cancel();
    }

    _analysisTimers[roomId] = Timer.periodic(
      const Duration(minutes: 2),
      (_) => _performContinuousAnalysis(roomId),
    );
  }

  /// Stops sentiment monitoring for a room
  void stopSentimentMonitoring(String roomId) {
    _analysisTimers[roomId]?.cancel();
    _analysisTimers.remove(roomId);
    _sentimentCache.remove(roomId);
  }

  /// Performs continuous analysis and theme suggestions
  Future<void> _performContinuousAnalysis(String roomId) async {
    try {
      final RoomTheme currentTheme = await _getCurrentRoomTheme(roomId);
      final RoomTheme suggestedTheme = await analyzeAndSuggestTheme(roomId);

      // Only suggest change if significantly different
      if (currentTheme != suggestedTheme) {
        final double confidence = _calculateThemeChangeConfidence(roomId);
        if (confidence > 0.7) {
          await _suggestThemeChange(roomId, suggestedTheme, confidence);
        }
      }
    } catch (e) {
      debugPrint('Continuous analysis failed: $e');
    }
  }

  /// Calculates confidence level for theme change suggestion
  double _calculateThemeChangeConfidence(String roomId) {
    final SentimentAnalysis? analysis = _sentimentCache[roomId];
    if (analysis == null) return 0.0;

    // Higher confidence if all metrics align
    final List<double> scores = <double>[
      analysis.chatActivityScore,
      analysis.userInteractionScore,
      analysis.audioLevelScore,
      analysis.userProfileScore,
    ];

    final double variance = _calculateVariance(scores);
    return 1.0 - variance; // Lower variance = higher confidence
  }

  /// Suggests theme change to room participants
  Future<void> _suggestThemeChange(
    String roomId,
    RoomTheme newTheme,
    double confidence,
  ) async {
    try {
      final ThemeConfig themeConfig = ThemeConfig.getTheme(newTheme);

      await _firestore.collection('rooms').doc(roomId).collection('messages').add(<String, dynamic>{
        'userId': 'system',
        'displayName': 'AI Theme Manager',
        'message': '🎨 Based on the room\'s energy, I suggest switching to "${themeConfig.name}"!',
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'themeChange',
        'metadata': <String, Object>{
          'suggestedTheme': newTheme.name,
          'confidence': confidence,
          'reason': _getThemeChangeReason(newTheme),
        },
      });
    } catch (e) {
      debugPrint('Theme change suggestion failed: $e');
    }
  }

  /// Gets reason for theme change suggestion
  String _getThemeChangeReason(RoomTheme theme) {
    switch (theme) {
      case RoomTheme.cyberpunkRave:
        return 'High energy detected - perfect for an electrifying experience!';
      case RoomTheme.chillLoft:
        return 'Relaxed vibes detected - time to unwind and connect.';
      case RoomTheme.neonNoir:
        return 'Mysterious atmosphere building - embrace the dark side.';
      case RoomTheme.digitalGarden:
        return "Organic energy flowing - let's grow together.";
      case RoomTheme.urbanSunset:
        return 'Warm, social vibes - perfect for golden hour connections.';
      case RoomTheme.midnightClub:
        return 'Sophisticated energy rising - exclusive vibes only.';
      case RoomTheme.techLounge:
        return "Productive energy detected - let's innovate together.";
      case RoomTheme.cosmicVoid:
        return 'Ethereal energy flowing - explore the infinite.';
    }
  }

  /// Helper methods for sentiment analysis
  bool _containsPositiveEmojis(String text) {
    final List<String> positiveEmojis = <String>[
      '😊',
      '😄',
      '😍',
      '🥰',
      '😎',
      '🔥',
      '💯',
      '✨',
      '💖',
      '😏',
    ];
    return positiveEmojis.any((String emoji) => text.contains(emoji));
  }

  bool _containsNegativeEmojis(String text) {
    final List<String> negativeEmojis = <String>[
      '😞',
      '😔',
      '😢',
      '😭',
      '😤',
      '😡',
      '💔',
      '😴',
      '😐',
    ];
    return negativeEmojis.any((String emoji) => text.contains(emoji));
  }

  double _normalizeScore(double score) {
    return score.clamp(0.0, 1.0);
  }

  double _calculateVariance(List<double> scores) {
    if (scores.isEmpty) return 0.0;
    final double mean = scores.reduce((double a, double b) => a + b) / scores.length;
    final Iterable<num> squaredDifferences = scores.map((double score) => pow(score - mean, 2));
    return squaredDifferences.reduce((num a, num b) => a + b) / scores.length;
  }

  Map<RoomTheme, double> _calculateThemePreferences(
    List<String> interests,
    List<String> moods,
  ) {
    final Map<RoomTheme, double> preferences = <RoomTheme, double>{};

    for (final RoomTheme theme in RoomTheme.values) {
      final ThemeConfig themeConfig = ThemeConfig.getTheme(theme);

      double score = 0.0;

      // Match interests with theme tags
      for (final String interest in interests) {
        if (themeConfig.tags.contains(interest.toLowerCase())) {
          score += 0.3;
        }
      }

      // Match moods with theme characteristics
      for (final String mood in moods) {
        if (_matchesMoodToTheme(mood, theme)) {
          score += 0.2;
        }
      }

      preferences[theme] = _normalizeScore(score);
    }

    return preferences;
  }

  bool _matchesMoodToTheme(String mood, RoomTheme theme) {
    final Map<String, List<RoomTheme>> moodThemeMap = <String, List<RoomTheme>>{
      'energetic': <RoomTheme>[RoomTheme.cyberpunkRave, RoomTheme.midnightClub],
      'relaxed': <RoomTheme>[RoomTheme.chillLoft, RoomTheme.digitalGarden],
      'mysterious': <RoomTheme>[RoomTheme.neonNoir, RoomTheme.cosmicVoid],
      'social': <RoomTheme>[RoomTheme.urbanSunset, RoomTheme.techLounge],
      'focused': <RoomTheme>[RoomTheme.techLounge, RoomTheme.cosmicVoid],
      'playful': <RoomTheme>[RoomTheme.cyberpunkRave, RoomTheme.urbanSunset],
    };

    return moodThemeMap[mood.toLowerCase()]?.contains(theme) ?? false;
  }

  double _getAveragePreference(Map<RoomTheme, double> preferences) {
    if (preferences.isEmpty) return 0.5;
    return preferences.values.reduce((double a, double b) => a + b) / preferences.length;
  }

  /// Database helper methods
  Future<LiveRoom?> _getRoomData(String roomId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('rooms').doc(roomId).get();
      if (doc.exists) {
        return LiveRoom.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get room data: $e');
      return null;
    }
  }

  Future<RoomTheme> _getCurrentRoomTheme(String roomId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('rooms').doc(roomId).get();
      if (doc.exists) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return RoomTheme.values.firstWhere(
          (RoomTheme theme) => theme.name == data['theme'],
          orElse: () => RoomTheme.cyberpunkRave,
        );
      }
      return RoomTheme.cyberpunkRave;
    } catch (e) {
      return RoomTheme.cyberpunkRave;
    }
  }

  Future<Map<String, dynamic>?> _getUserProfile(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _logThemeSuggestion(
    String roomId,
    SentimentAnalysis analysis,
    RoomTheme theme,
  ) async {
    try {
      await _firestore.collection('ai_analytics').add(<String, dynamic>{
        'roomId': roomId,
        'timestamp': FieldValue.serverTimestamp(),
        'analysis': analysis.toMap(),
        'suggestedTheme': theme.name,
        'type': 'theme_suggestion',
      });
    } catch (e) {
      debugPrint('Failed to log theme suggestion: $e');
    }
  }
}

/// Sentiment analysis data structure
class SentimentAnalysis {
  SentimentAnalysis();

  SentimentAnalysis.defaultAnalysis() {
    chatActivityScore = 0.5;
    userInteractionScore = 0.5;
    audioLevelScore = 0.5;
    userProfileScore = 0.5;
    overallSentiment = 0.5;
  }
  double chatActivityScore = 0.5;
  double userInteractionScore = 0.5;
  double audioLevelScore = 0.5;
  double userProfileScore = 0.5;
  double overallSentiment = 0.5;

  void calculateOverallSentiment() {
    overallSentiment = chatActivityScore * ThemeManager._chatActivityWeight +
        userInteractionScore * ThemeManager._userMovementWeight +
        audioLevelScore * ThemeManager._audioLevelWeight +
        userProfileScore * ThemeManager._interactionPatternWeight;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatActivityScore': chatActivityScore,
      'userInteractionScore': userInteractionScore,
      'audioLevelScore': audioLevelScore,
      'userProfileScore': userProfileScore,
      'overallSentiment': overallSentiment,
    };
  }
}
