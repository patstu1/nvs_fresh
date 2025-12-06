import 'package:flutter/material.dart';
import 'dart:math' as math;

/// NVS AI Voice Service - Provides sophisticated, emotionally intelligent commentary
/// with optional text-to-speech functionality for the CONNECT experience.
///
/// Note: To enable voice functionality, add flutter_tts: ^3.8.5 to pubspec.yaml
class NvsAiVoiceService {
  factory NvsAiVoiceService() => _instance;
  NvsAiVoiceService._internal();
  static final NvsAiVoiceService _instance = NvsAiVoiceService._internal();

  // Optional TTS - will be null if flutter_tts is not available
  dynamic _flutterTts;
  bool _isInitialized = false;
  bool _isVoiceEnabled = false; // Disabled by default since TTS package is optional
  final double _speechRate = 0.5;
  final double _volume = 0.8;
  final double _pitch = 1.0;

  /// Initialize the TTS service (optional - requires flutter_tts package)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Try to initialize flutter_tts if available
      // Uncomment and modify these lines if you add flutter_tts package:
      // _flutterTts = FlutterTts();
      // await _flutterTts.setLanguage('en-US');
      // await _flutterTts.setSpeechRate(_speechRate);
      // await _flutterTts.setVolume(_volume);
      // await _flutterTts.setPitch(_pitch);
      // _isVoiceEnabled = true;

      _isInitialized = true;
    } catch (e) {
      // TTS not available, continue with text-only mode
      debugPrint('TTS not available: $e');
      _isVoiceEnabled = false;
    }
  }

  /// Speak NVS commentary with personality (requires flutter_tts package)
  Future<void> speak(
    String text, {
    VoiceContext context = VoiceContext.general,
  }) async {
    if (!_isVoiceEnabled || !_isInitialized || _flutterTts == null) {
      // Fallback: just return without speaking
      debugPrint('NVS would say: $text');
      return;
    }

    try {
      // Adjust voice characteristics based on context
      switch (context) {
        case VoiceContext.compatibility:
          // await _flutterTts.setSpeechRate(0.4); // Slower for analysis
          // await _flutterTts.setPitch(0.9); // Slightly lower for authority
          break;
        case VoiceContext.match:
          // await _flutterTts.setSpeechRate(0.6); // Normal pace for excitement
          // await _flutterTts.setPitch(1.1); // Slightly higher for celebration
          break;
        case VoiceContext.sarcasm:
          // await _flutterTts.setSpeechRate(0.5); // Deliberate pace
          // await _flutterTts.setPitch(0.8); // Lower for dry delivery
          break;
        default:
        // await _flutterTts.setSpeechRate(_speechRate);
        // await _flutterTts.setPitch(_pitch);
      }

      // await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  /// Generate compatibility commentary based on score and zodiac
  String generateCompatibilityCommentary({
    required int compatibilityScore,
    String? userZodiac,
    String? matchZodiac,
    List<String>? sharedInterests,
  }) {
    final math.Random random = math.Random();

    // High compatibility (85+)
    if (compatibilityScore >= 85) {
      final List<String> highScoreComments = <String>[
        "This isn't just attraction. You two vibrate on a frequency I haven't seen in weeks.",
        "Exceptional compatibility. Don't overthink this one.",
        "The data doesn't lie. This could be something special.",
        'High compatibility across all metrics. Promising connection.',
      ];

      if (userZodiac == 'Leo' && matchZodiac == 'Aquarius') {
        return 'Leo meets Aquarius? Prepare for intellectual sparks and emotional chaos. Worth the ride.';
      }

      return highScoreComments[random.nextInt(highScoreComments.length)];
    }

    // Good compatibility (70-84)
    else if (compatibilityScore >= 70) {
      final List<String> goodScoreComments = <String>[
        "This could be electric — just don't ghost each other after 48 hours.",
        'Solid foundation here. Give it a chance.',
        'Strong potential, but timing might be everything.',
        'Good compatibility. See where this leads.',
      ];

      if (userZodiac == 'Aquarius') {
        return "Aquarius? Really? I'll let you learn the hard way.";
      }

      return goodScoreComments[random.nextInt(goodScoreComments.length)];
    }

    // Moderate compatibility (50-69)
    else if (compatibilityScore >= 50) {
      final List<String> moderateScoreComments = <String>[
        "We both know you fall too fast. Let's try someone different this time.",
        "Interesting choice. I see what you're drawn to, and I understand why.",
        'Moderate compatibility. Proceed with awareness.',
        'This could work with effort, but why settle?',
      ];

      return moderateScoreComments[random.nextInt(moderateScoreComments.length)];
    }

    // Lower compatibility
    else {
      final List<String> lowScoreComments = <String>[
        'I understand the attraction, but trust the data on this one.',
        "Sometimes the heart wants what the algorithm knows isn't wise.",
        'Low compatibility detected. But you do you.',
        'This is a learning experience waiting to happen.',
      ];

      return lowScoreComments[random.nextInt(lowScoreComments.length)];
    }
  }

  /// Generate match celebration commentary
  String generateMatchCommentary({
    required String matchName,
    required int compatibilityScore,
  }) {
    final math.Random random = math.Random();

    final List<String> matchComments = <String>[
      'Connection achieved. Welcome to your future… or your next mistake.',
      "It's a match! Now don't mess this up.",
      '$matchName liked you back. The universe is speaking.',
      'Match confirmed. Time to see if chemistry translates to conversation.',
      'Mutual attraction detected. Proceed with confidence.',
    ];

    return matchComments[random.nextInt(matchComments.length)];
  }

  /// Generate swipe commentary
  String generateSwipeCommentary({
    required SwipeAction action,
    String? profileName,
  }) {
    final math.Random random = math.Random();

    switch (action) {
      case SwipeAction.like:
        final List<String> likeComments = <String>[
          "Interesting choice. Let's see if they feel the same.",
          'Bold move. I respect it.',
          'Added to your vault. Fingers crossed.',
          'Now we wait and see...',
          'Good instincts. Trust them.',
        ];
        return likeComments[random.nextInt(likeComments.length)];

      case SwipeAction.pass:
        final List<String> passComments = <String>[
          'Not feeling it? Trust your instincts.',
          'Moving on. Smart choice.',
          'Next.',
          'Your standards are showing. Good.',
          'Onwards and upwards.',
        ];
        return passComments[random.nextInt(passComments.length)];

      case SwipeAction.superLike:
        final List<String> superLikeComments = <String>[
          'Going all in? I admire the confidence.',
          "Bold strategy. Let's see if it pays off.",
          'Making a statement. I like it.',
          'Taking no prisoners. Respect.',
        ];
        return superLikeComments[random.nextInt(superLikeComments.length)];
    }
  }

  /// Generate personalized insights based on user patterns
  String generatePersonalizedInsight({
    required int totalLikes,
    required int totalMatches,
    required List<String> preferredTypes,
  }) {
    final math.Random random = math.Random();

    if (totalLikes > 20 && totalMatches < 3) {
      return "You're very selective, but your match rate suggests you might be too picky. Consider expanding your criteria.";
    }

    if (totalMatches > totalLikes * 0.8) {
      return "High match rate detected. You're clearly attractive to your type. Stay confident.";
    }

    if (preferredTypes.contains('Artistic') && preferredTypes.contains('Tech')) {
      return "You're drawn to creative technologists. Interesting pattern. Quality over quantity approach.";
    }

    final List<String> generalInsights = <String>[
      'Your swiping patterns reveal someone who values depth over surface attraction.',
      'I notice you gravitate toward certain personality types. Consistency is key.',
      'Your preferences suggest emotional intelligence matters more than looks. Wise choice.',
      'Pattern analysis indicates you value intellectual connection. Proceed accordingly.',
    ];

    return generalInsights[random.nextInt(generalInsights.length)];
  }

  /// Generate contextual advice
  String generateAdvice({
    required AdviceContext context,
    Map<String, dynamic>? data,
  }) {
    final math.Random random = math.Random();

    switch (context) {
      case AdviceContext.noMatches:
        return 'No matches yet? Quality takes time. Your person is worth the wait.';

      case AdviceContext.tooFastSwiping:
        return "Slow down. This isn't Grindr. Quality over quantity, remember?";

      case AdviceContext.repeatPattern:
        return 'I notice you keep choosing the same type. Sometimes growth means breaking patterns.';

      case AdviceContext.lowActivity:
        return 'Connection requires presence. Try being more active in your search.';

      case AdviceContext.highActivity:
        return "You're very active. Good. But remember, desperation has a scent.";

      case AdviceContext.perfectMatch:
        return "This is as close to perfect as my algorithms get. Don't sabotage yourself.";
    }
  }

  /// Enable/disable voice functionality
  void setVoiceEnabled(bool enabled) {
    _isVoiceEnabled = enabled && _flutterTts != null;
  }

  /// Check if voice is enabled and available
  bool get isVoiceEnabled => _isVoiceEnabled && _flutterTts != null;

  /// Stop current speech
  Future<void> stop() async {
    if (_isInitialized && _flutterTts != null) {
      try {
        // await _flutterTts.stop();
      } catch (e) {
        debugPrint('TTS stop error: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    if (_isInitialized && _flutterTts != null) {
      try {
        stop();
      } catch (e) {
        debugPrint('TTS dispose error: $e');
      }
    }
  }
}

/// Voice context for adjusting speech characteristics
enum VoiceContext {
  general,
  compatibility,
  match,
  sarcasm,
}

/// Swipe actions for commentary
enum SwipeAction {
  like,
  pass,
  superLike,
}

/// Advice contexts
enum AdviceContext {
  noMatches,
  tooFastSwiping,
  repeatPattern,
  lowActivity,
  highActivity,
  perfectMatch,
}

/// Widget for displaying NVS commentary with optional voice
class NvsCommentaryWidget extends StatefulWidget {
  const NvsCommentaryWidget({
    required this.commentary,
    super.key,
    this.voiceContext = VoiceContext.general,
    this.autoSpeak = true,
    this.onComplete,
  });
  final String commentary;
  final VoiceContext voiceContext;
  final bool autoSpeak;
  final VoidCallback? onComplete;

  @override
  State<NvsCommentaryWidget> createState() => _NvsCommentaryWidgetState();
}

class _NvsCommentaryWidgetState extends State<NvsCommentaryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final NvsAiVoiceService _voiceService = NvsAiVoiceService();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    if (widget.autoSpeak) {
      _voiceService.speak(widget.commentary, context: widget.voiceContext);
    }

    // Auto-complete after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  const Color(0xFF1A1A1A).withValues(alpha: 0.95),
                  const Color(0xFF0A0A0A).withValues(alpha: 0.98),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                    ),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'NVS',
                        style: TextStyle(
                          color: Color(0xFFB0FFF7),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.commentary,
                        style: const TextStyle(
                          color: Color(0xFFE6FFF4),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_voiceService.isVoiceEnabled)
                  GestureDetector(
                    onTap: () => _voiceService.speak(
                      widget.commentary,
                      context: widget.voiceContext,
                    ),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
                        border: Border.all(
                          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        color: Color(0xFFB0FFF7),
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
