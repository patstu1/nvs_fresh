import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ai_character_model.dart';
import 'ai_character_repository.dart';

// NEW: Runtime state class for AI characters
class AICharacterRuntimeState {
  const AICharacterRuntimeState({
    required this.character,
    this.currentState = AICharacterState.idle,
    this.currentMessage = '',
    this.isSpeaking = false,
    this.isListening = false,
    this.isVisible = false,
    this.opacity = 0.0,
    this.position = Offset.zero,
    this.size = const Size(200, 200),
  });
  final AICharacterModel character;
  final AICharacterState currentState;
  final String currentMessage;
  final bool isSpeaking;
  final bool isListening;
  final bool isVisible;
  final double opacity;
  final Offset position;
  final Size size;

  AICharacterRuntimeState copyWith({
    AICharacterState? currentState,
    String? currentMessage,
    bool? isSpeaking,
    bool? isListening,
    bool? isVisible,
    double? opacity,
    Offset? position,
    Size? size,
  }) {
    return AICharacterRuntimeState(
      character: character,
      currentState: currentState ?? this.currentState,
      currentMessage: currentMessage ?? this.currentMessage,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isListening: isListening ?? this.isListening,
      isVisible: isVisible ?? this.isVisible,
      opacity: opacity ?? this.opacity,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

// Repository provider
final Provider<AICharacterRepository> aiCharacterRepositoryProvider =
    Provider<AICharacterRepository>((ProviderRef<AICharacterRepository> ref) {
  return AICharacterRepository();
});

// AI Character State Notifier
class AICharacterNotifier extends StateNotifier<Map<AICharacterType, AICharacterRuntimeState>> {
  AICharacterNotifier(this._repository) : super(<AICharacterType, AICharacterRuntimeState>{}) {
    _initializeCharacters();
  }
  final AICharacterRepository _repository;
  final TextEditingController _messageController = TextEditingController();

  void _initializeCharacters() {
    state = <AICharacterType, AICharacterRuntimeState>{
      AICharacterType.domBot: AICharacterRuntimeState(
        character: AICharacterModel.domBot(),
      ),
      AICharacterType.webmaster: AICharacterRuntimeState(
        character: AICharacterModel.webmaster(),
      ),
    };
  }

  // Show character with animation
  Future<void> showCharacter(AICharacterType type) async {
    final AICharacterRuntimeState? character = state[type];
    if (character == null) return;

    // Animate in
    for (double opacity = 0.0; opacity <= 1.0; opacity += 0.1) {
      state = <AICharacterType, AICharacterRuntimeState>{
        ...state,
        type: character.copyWith(
          isVisible: true,
          opacity: opacity,
          currentState: AICharacterState.idle,
        ),
      };
      await Future.delayed(const Duration(milliseconds: 50));
    }

    // Show greeting
    await speakMessage(type, character.character.greeting);
  }

  // Hide character with animation
  Future<void> hideCharacter(AICharacterType type) async {
    final AICharacterRuntimeState? character = state[type];
    if (character == null) return;

    // Say farewell
    await speakMessage(type, character.character.farewell);

    // Animate out
    for (double opacity = 1.0; opacity >= 0.0; opacity -= 0.1) {
      state = <AICharacterType, AICharacterRuntimeState>{
        ...state,
        type: character.copyWith(
          opacity: opacity,
        ),
      };
      await Future.delayed(const Duration(milliseconds: 50));
    }

    state = <AICharacterType, AICharacterRuntimeState>{
      ...state,
      type: character.copyWith(
        isVisible: false,
        opacity: 0.0,
        currentState: AICharacterState.idle,
        currentMessage: '',
        isSpeaking: false,
        isListening: false,
      ),
    };
  }

  // Speak a message with TTS and animation
  Future<void> speakMessage(AICharacterType type, String message) async {
    final AICharacterRuntimeState? character = state[type];
    if (character == null) return;

    // Update state to speaking
    state = <AICharacterType, AICharacterRuntimeState>{
      ...state,
      type: character.copyWith(
        currentState: AICharacterState.speaking,
        currentMessage: message,
        isSpeaking: true,
      ),
    };

    // Save conversation to Firebase
    await _repository.saveConversationMessage(
      characterType: type,
      message: message,
      isUserMessage: false,
      metadata: <String, dynamic>{
        'characterName': character.character.name,
        'messageType': 'ai_response',
      },
    );

    // Simulate TTS duration (replace with actual TTS)
    await Future.delayed(Duration(milliseconds: message.length * 100));

    // Return to idle state
    state = <AICharacterType, AICharacterRuntimeState>{
      ...state,
      type: character.copyWith(
        currentState: AICharacterState.idle,
        isSpeaking: false,
      ),
    };
  }

  // Send user message
  Future<void> sendUserMessage(AICharacterType type, String message) async {
    final AICharacterRuntimeState? character = state[type];
    if (character == null) return;

    // Save user message
    await _repository.saveConversationMessage(
      characterType: type,
      message: message,
      isUserMessage: true,
      metadata: <String, dynamic>{
        'messageType': 'user_input',
      },
    );

    // Update state to listening
    state = <AICharacterType, AICharacterRuntimeState>{
      ...state,
      type: character.copyWith(
        currentState: AICharacterState.listening,
        isListening: true,
      ),
    };

    // Generate AI response based on character type
    final String response = await _generateAIResponse(type, message);

    // Return to idle and speak response
    state = <AICharacterType, AICharacterRuntimeState>{
      ...state,
      type: character.copyWith(
        currentState: AICharacterState.idle,
        isListening: false,
      ),
    };

    await speakMessage(type, response);
  }

  // Generate AI response based on character and message
  Future<String> _generateAIResponse(
    AICharacterType type,
    String userMessage,
  ) async {
    switch (type) {
      case AICharacterType.domBot:
        return _generateDomBotResponse(userMessage);
      case AICharacterType.webmaster:
        return _generateWebmasterResponse(userMessage);
      case AICharacterType.eliasVoss:
        return _generateEliasVossResponse(userMessage);
    }
  }

  // DomBot response generation
  Future<String> _generateDomBotResponse(String userMessage) async {
    final String lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('match') || lowerMessage.contains('find')) {
      return "I'd love to help you find your perfect match! Let me analyze your preferences and find someone who complements your energy perfectly. What's your ideal type?";
    } else if (lowerMessage.contains('flirt') || lowerMessage.contains('tip')) {
      return "Flirting is an art, darling! Start with genuine compliments, maintain eye contact, and don't be afraid to show your personality. Confidence is the sexiest trait!";
    } else if (lowerMessage.contains('advice') || lowerMessage.contains('help')) {
      return "Love advice from your favorite AI? Here's the tea: be authentic, communicate openly, and never settle for less than you deserve. You're a catch!";
    } else if (lowerMessage.contains('compatibility') || lowerMessage.contains('analyze')) {
      return "Let me dive deep into your compatibility! I'll check your astrological alignment, style preferences, and relationship goals. This is going to be fun!";
    } else {
      return "I love your energy! Tell me more about what you're looking for in a relationship. I'm here to help you find your perfect match!";
    }
  }

  // Webmaster response generation
  Future<String> _generateWebmasterResponse(String userMessage) async {
    final String lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('report') || lowerMessage.contains('violation')) {
      return 'I take rule violations very seriously. Please provide details about the incident, and I will investigate immediately. Your safety is my priority.';
    } else if (lowerMessage.contains('rule') || lowerMessage.contains('policy')) {
      return "The community guidelines are designed to ensure everyone's safety and enjoyment. Respect, consent, and authenticity are non-negotiable.";
    } else if (lowerMessage.contains('privacy') || lowerMessage.contains('security')) {
      return "Your privacy and security are paramount. All data is encrypted, and I monitor for any suspicious activity. You're protected here.";
    } else if (lowerMessage.contains('help') || lowerMessage.contains('support')) {
      return "I'm here to help with any issues you encounter. Whether it's technical problems or community concerns, I'll assist you promptly.";
    } else {
      return "How may I assist you with the platform's security and community guidelines?";
    }
  }

  // Get conversation history
  Stream<QuerySnapshot> getConversationHistory(AICharacterType type) {
    return _repository.getConversationHistory(type);
  }

  // Update character position (for floating animations)
  void updateCharacterPosition(AICharacterType type, Offset position) {
    final AICharacterRuntimeState? character = state[type];
    if (character == null) return;

    state = <AICharacterType, AICharacterRuntimeState>{
      ...state,
      type: character.copyWith(position: position),
    };
  }

  // Trigger character animation
  void triggerAnimation(AICharacterType type, AICharacterState animationState) {
    final AICharacterRuntimeState? character = state[type];
    if (character == null) return;

    state = <AICharacterType, AICharacterRuntimeState>{
      ...state,
      type: character.copyWith(currentState: animationState),
    };

    // Return to idle after animation
    Future.delayed(const Duration(seconds: 2), () {
      state = <AICharacterType, AICharacterRuntimeState>{
        ...state,
        type: character.copyWith(currentState: AICharacterState.idle),
      };
    });
  }

  // Get message controller
  TextEditingController get messageController => _messageController;

  // Elias Voss response generation
  Future<String> _generateEliasVossResponse(String userMessage) async {
    final String lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('brand') || lowerMessage.contains('style')) {
      return "Darling, your brand is your essence distilled into pure visual poetry. Let's craft something that makes the competition weep with envy.";
    } else if (lowerMessage.contains('strategy') || lowerMessage.contains('market')) {
      return "Strategic thinking is an art form, love. We're not just entering markets - we're redefining them entirely.";
    }

    return "Tell me more, gorgeous. I'm here to elevate your vision to stratospheric heights.";
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

// Provider for AI Character state
final StateNotifierProvider<AICharacterNotifier, Map<AICharacterType, AICharacterRuntimeState>>
    aiCharacterProvider =
    StateNotifierProvider<AICharacterNotifier, Map<AICharacterType, AICharacterRuntimeState>>((
  StateNotifierProviderRef<AICharacterNotifier, Map<AICharacterType, AICharacterRuntimeState>> ref,
) {
  final AICharacterRepository repository = ref.watch(aiCharacterRepositoryProvider);
  return AICharacterNotifier(repository);
});

// Individual character providers
final Provider<AICharacterRuntimeState> domBotProvider =
    Provider<AICharacterRuntimeState>((ProviderRef<AICharacterRuntimeState> ref) {
  final Map<AICharacterType, AICharacterRuntimeState> characters = ref.watch(aiCharacterProvider);
  return characters[AICharacterType.domBot] ??
      AICharacterRuntimeState(
        character: AICharacterModel.domBot(),
      );
});

final Provider<AICharacterRuntimeState> webmasterProvider =
    Provider<AICharacterRuntimeState>((ProviderRef<AICharacterRuntimeState> ref) {
  final Map<AICharacterType, AICharacterRuntimeState> characters = ref.watch(aiCharacterProvider);
  return characters[AICharacterType.webmaster] ??
      AICharacterRuntimeState(
        character: AICharacterModel.webmaster(),
      );
});
