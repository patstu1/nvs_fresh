import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:nvs/meatup_core.dart';
import '../../domain/models/connect_models.dart';
import '../../domain/providers/connect_providers.dart';
import '../widgets/curator_chat_interface.dart';
import '../widgets/curator_video_player.dart';
import '../../data/curator_conversation_data.dart';

/// Full-screen immersive chat interface for conversation with "The Curator"
/// Integrates video clips and interactive questions within the chat flow
class ResonanceSession extends ConsumerStatefulWidget {
  const ResonanceSession({super.key});

  @override
  ConsumerState<ResonanceSession> createState() => _ResonanceSessionState();
}

class _ResonanceSessionState extends ConsumerState<ResonanceSession> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  VideoPlayerController? _videoController;
  bool _showVideo = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeSession();
  }

  void _setupAnimations() {
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeSession() async {
    // Add initial Curator welcome message
    final ChatMessage welcomeMessage = ChatMessage(
      id: 'welcome',
      content:
          'Welcome to your Resonance Session. I am The Curator, and I will be your guide through this journey of connection and discovery.',
      isFromCurator: true,
      timestamp: DateTime.now(),
      videoClipPath: 'assets/videos/curator_intro.mp4', // We'll use a placeholder
    );

    // Use post-frame callback to avoid provider modification during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationStateProvider.notifier).addMessage(welcomeMessage);
    });

    // Show intro video after a brief delay
    Future.delayed(const Duration(seconds: 2), _playIntroVideo);

    // Add first question after video
    Future.delayed(const Duration(seconds: 8), _addFirstQuestion);

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _playIntroVideo() async {
    try {
      // Use existing video asset
      _videoController = VideoPlayerController.asset('assets/videos/blurrr_mint.mov');
      await _videoController!.initialize();

      setState(() {
        _showVideo = true;
      });

      _videoController!.play();
      _videoController!.setLooping(false);

      // Hide video when finished
      _videoController!.addListener(() {
        if (_videoController!.value.position >= _videoController!.value.duration) {
          setState(() {
            _showVideo = false;
          });
        }
      });
    } catch (e) {
      // Fallback if video fails to load
      debugPrint('Video initialization failed: $e');
      setState(() {
        _showVideo = false;
      });
    }
  }

  void _addFirstQuestion() {
    final CuratorQuestion firstQuestion = CuratorConversationData.getFirstQuestion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationStateProvider.notifier).addCuratorQuestion(firstQuestion);
    });

    final ChatMessage questionMessage = ChatMessage(
      id: 'question_1',
      content: firstQuestion.questionText,
      isFromCurator: true,
      timestamp: DateTime.now(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationStateProvider.notifier).addMessage(questionMessage);
    });
  }

  void _onQuestionAnswered(String questionId, dynamic response) {
    ref.read(conversationStateProvider.notifier).submitResponse(questionId, response);

    // Add user's response to chat
    final ChatMessage userMessage = ChatMessage(
      id: 'user_response_$questionId',
      content: response.toString(),
      isFromCurator: false,
      timestamp: DateTime.now(),
    );

    ref.read(conversationStateProvider.notifier).addMessage(userMessage);

    // Get next question or complete session
    _handleNextStep();
  }

  void _handleNextStep() {
    final ConversationState conversationState = ref.read(conversationStateProvider);

    if (conversationState.responses.length >= 5) {
      // Session complete after 5 questions
      _completeSession();
    } else {
      // Add next question
      Future.delayed(const Duration(seconds: 2), () {
        final CuratorQuestion? nextQuestion = CuratorConversationData.getNextQuestion(
          conversationState.responses.length,
        );

        if (nextQuestion != null) {
          ref.read(conversationStateProvider.notifier).addCuratorQuestion(nextQuestion);

          final ChatMessage questionMessage = ChatMessage(
            id: 'question_${conversationState.responses.length + 1}',
            content: nextQuestion.questionText,
            isFromCurator: true,
            timestamp: DateTime.now(),
          );

          ref.read(conversationStateProvider.notifier).addMessage(questionMessage);
        }
      });
    }
  }

  void _completeSession() {
    ref.read(conversationStateProvider.notifier).completeSession();

    final ChatMessage completionMessage = ChatMessage(
      id: 'completion',
      content:
          'Your resonance profile is complete. I can see your unique energy signature clearly now. Let me show you your personalized dashboard.',
      isFromCurator: true,
      timestamp: DateTime.now(),
    );

    ref.read(conversationStateProvider.notifier).addMessage(completionMessage);

    // Generate user's aura signature from responses
    final Map<String, dynamic> responses = ref.read(conversationStateProvider).responses;
    final AuraSignatureData auraData = _generateAuraSignature(responses);
    ref.read(userAuraSignatureProvider.notifier).state = auraData;

    // Navigate to dashboard after delay
    Future.delayed(const Duration(seconds: 3), () {
      ref.read(resonanceSessionCompleteProvider.notifier).state = true;
    });
  }

  AuraSignatureData _generateAuraSignature(Map<String, dynamic> responses) {
    // Generate aura based on user responses
    // This is a simplified version - in production, this would be more sophisticated
    return AuraSignatureData.defaultSignature().copyWith(
      rotationSpeed: responses.length > 3 ? 1.5 : 0.8,
      glowIntensity:
          responses.values.where((v) => v.toString().contains('yes')).length > 2 ? 0.9 : 0.6,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConversationState conversationState = ref.watch(conversationStateProvider);

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.5,
                  colors: <Color>[
                    NVSColors.neonMint.withValues(alpha: 0.05),
                    NVSColors.pureBlack,
                  ],
                ),
              ),
            ),

            // Main chat interface
            Column(
              children: <Widget>[
                // Header
                _buildHeader(),

                // Chat messages
                Expanded(
                  child: CuratorChatInterface(
                    messages: conversationState.messages,
                    currentQuestions: conversationState.currentQuestions,
                    onQuestionAnswered: _onQuestionAnswered,
                  ),
                ),
              ],
            ),

            // Video overlay
            if (_showVideo && _videoController != null)
              CuratorVideoPlayer(
                controller: _videoController,
                onVideoComplete: () {
                  setState(() {
                    _showVideo = false;
                  });
                },
              ),

            // Ambient glow effect
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (BuildContext context, Widget? child) {
                return Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: NVSColors.neonMint.withValues(
                              alpha: 0.1 * _glowAnimation.value,
                            ),
                            blurRadius: 100,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (BuildContext context, Widget? child) {
              return Text(
                'RESONANCE SESSION',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.neonMint,
                  shadows: <Shadow>[
                    Shadow(
                      color: NVSColors.neonMint.withValues(
                        alpha: _glowAnimation.value,
                      ),
                      blurRadius: 20,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Discovering your unique energy signature',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 14,
              color: NVSColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
