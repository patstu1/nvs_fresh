import 'package:flutter/material.dart';

enum AICharacterType {
  domBot,
  webmaster,
  eliasVoss,
}

enum AICharacterState {
  idle,
  speaking,
  thinking,
  excited,
  concerned,
  happy,
  serious,
  listening,
  warning,
}

class AICharacterModel {
  const AICharacterModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.type,
    required this.avatarPath,
    required this.description,
    required this.personality,
    required this.quickPrompts,
    required this.responses,
    required this.accentColor,
    required this.backgroundColor,
    required this.greeting,
    required this.farewell,
    required this.voiceSettings,
    required this.animationSettings,
    required this.capabilities,
  });

  factory AICharacterModel.domBot() {
    return const AICharacterModel(
      id: 'nvs',
      name: 'NVS',
      displayName: 'NVS',
      type: AICharacterType.domBot,
      avatarPath: 'assets/images/nvs_silhouette.png',
      description: 'Your conversational AI matchmaker — empathetic, direct, and human-like.',
      personality:
          'Grounded, emotionally intelligent, and warm. NVS listens first, mirrors your intentions, and guides you with clear, human conversation.',
      quickPrompts: <String>[
        'Who am I compatible with?',
        'Review my profile signal',
        'Help me update my vibe',
        'What should I lead with?',
        'Show likely intros near me',
        'How do I improve my matches?',
      ],
      responses: <String, String>{
        'greeting': 'Hey — I’m NVS. I’ll keep this simple: tell me what you want, and I’ll help you get there.',
        'matchmaking':
            'Got it. I’m scanning your profile signal and recent behavior to surface high‑compatibility intros.',
        'advice': 'Let’s be real: clarity beats games. If you name your intent and stay consistent, you’ll attract the right energy.',
        'flirting': 'Lead with presence, not performance. One honest line > five clever ones.',
        'encouragement': 'You’re closer than you think. Small adjustments to your profile signal will compound fast.',
      },
      accentColor: Color(0xFF4BEFE0),
      backgroundColor: Color(0xFF1A1A1A),
      greeting:
          'I’m NVS — your match strategist. I’ll ask a few questions, then suggest specific, high‑fit intros.',
      farewell: 'I’ll be here when you’re ready to continue. Your signal updates in real time.',
      voiceSettings: TTSVoiceSettings(
        voiceId: 'en-US-Neural2-F',
        pitch: 1.1,
        rate: 0.9,
        volume: 0.8,
        language: 'en-US',
      ),
      animationSettings: AnimationSettings(
        blinkInterval: Duration(seconds: 3),
        mouthMovementSpeed: 0.8,
        eyeMovementRange: 0.1,
        floatingAmplitude: 5.0,
        floatingSpeed: 2.0,
        glowIntensity: 0.6,
        pulseIntensity: 0.3,
      ),
      capabilities: <String, dynamic>{
        'matchmaking': true,
        'profile_analysis': true,
        'dating_advice': true,
        'flirt_coaching': true,
        'relationship_tips': true,
        'astrology_compatibility': true,
        'personality_analysis': true,
        'style_advice': true,
      },
    );
  }

  factory AICharacterModel.webmaster() {
    return const AICharacterModel(
      id: 'webmaster',
      name: 'Webmaster',
      displayName: 'Webmaster',
      type: AICharacterType.webmaster,
      avatarPath: 'assets/ai_characters/webmaster_avatar.png',
      description: 'Your mysterious tech guardian and rule enforcer',
      personality:
          'Calm, authoritative, mysterious, and protective. Webmaster is the guardian of the YoBro community, ensuring safety and order.',
      quickPrompts: <String>[
        'Report a user',
        'Help with features',
        'Privacy settings',
        'Community guidelines',
        'Account security',
        'Content review',
      ],
      responses: <String, String>{
        'greeting':
            'Greetings, user. I am Webmaster, guardian of this digital realm. How may I assist you?',
        'warning': 'I must inform you that this behavior violates our community guidelines.',
        'help': "I'm here to help you navigate our platform safely and effectively.",
        'security':
            'Your security and privacy are my top priorities. Let me guide you through the settings.',
        'enforcement': 'I have reviewed the reported content and taken appropriate action.',
      },
      accentColor: Color(0xFF6366F1),
      backgroundColor: Color(0xFF0F0F23),
      greeting:
          'Greetings, user. I am Webmaster, guardian of this digital realm. How may I assist you today?',
      farewell: "Stay safe, user. I'll be watching over the community.",
      voiceSettings: TTSVoiceSettings(
        voiceId: 'en-US-Neural2-D',
        pitch: 0.9,
        rate: 0.8,
        volume: 0.7,
        language: 'en-US',
      ),
      animationSettings: AnimationSettings(
        blinkInterval: Duration(seconds: 4),
        mouthMovementSpeed: 0.7,
        eyeMovementRange: 0.05,
        floatingAmplitude: 3.0,
        floatingSpeed: 1.5,
        glowIntensity: 0.4,
        pulseIntensity: 0.2,
      ),
      capabilities: <String, dynamic>{
        'rule_enforcement': true,
        'user_reports': true,
        'content_moderation': true,
        'help_support': true,
        'privacy_guidance': true,
        'security_advice': true,
        'community_guidelines': true,
        'account_management': true,
      },
    );
  }
  final String id;
  final String name;
  final String displayName;
  final AICharacterType type;
  final String avatarPath;
  final String description;
  final String personality;
  final List<String> quickPrompts;
  final Map<String, String> responses;
  final Color accentColor;
  final Color backgroundColor;
  final String greeting;
  final String farewell;
  final TTSVoiceSettings voiceSettings;
  final AnimationSettings animationSettings;
  final Map<String, dynamic> capabilities;

  static List<AICharacterModel> getAllCharacters() {
    return <AICharacterModel>[
      AICharacterModel.domBot(),
      AICharacterModel.webmaster(),
    ];
  }

  static AICharacterModel? getById(String id) {
    return getAllCharacters().where((AICharacterModel character) => character.id == id).firstOrNull;
  }

  static AICharacterModel? getByType(AICharacterType type) {
    return getAllCharacters()
        .where((AICharacterModel character) => character.type == type)
        .firstOrNull;
  }
}

class TTSVoiceSettings {
  const TTSVoiceSettings({
    required this.voiceId,
    required this.pitch,
    required this.rate,
    required this.volume,
    required this.language,
  });

  factory TTSVoiceSettings.fromMap(Map<String, dynamic> map) {
    return TTSVoiceSettings(
      voiceId: map['voiceId'] ?? 'en-US-Neural2-F',
      pitch: map['pitch']?.toDouble() ?? 1.0,
      rate: map['rate']?.toDouble() ?? 1.0,
      volume: map['volume']?.toDouble() ?? 1.0,
      language: map['language'] ?? 'en-US',
    );
  }
  final String voiceId;
  final double pitch;
  final double rate;
  final double volume;
  final String language;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'voiceId': voiceId,
      'pitch': pitch,
      'rate': rate,
      'volume': volume,
      'language': language,
    };
  }
}

class AnimationSettings {
  const AnimationSettings({
    required this.blinkInterval,
    required this.mouthMovementSpeed,
    required this.eyeMovementRange,
    required this.floatingAmplitude,
    required this.floatingSpeed,
    required this.glowIntensity,
    required this.pulseIntensity,
  });

  factory AnimationSettings.fromMap(Map<String, dynamic> map) {
    return AnimationSettings(
      blinkInterval: Duration(milliseconds: map['blinkInterval'] ?? 3000),
      mouthMovementSpeed: map['mouthMovementSpeed']?.toDouble() ?? 1.0,
      eyeMovementRange: map['eyeMovementRange']?.toDouble() ?? 0.1,
      floatingAmplitude: map['floatingAmplitude']?.toDouble() ?? 5.0,
      floatingSpeed: map['floatingSpeed']?.toDouble() ?? 2.0,
      glowIntensity: map['glowIntensity']?.toDouble() ?? 0.5,
      pulseIntensity: map['pulseIntensity']?.toDouble() ?? 0.3,
    );
  }
  final Duration blinkInterval;
  final double mouthMovementSpeed;
  final double eyeMovementRange;
  final double floatingAmplitude;
  final double floatingSpeed;
  final double glowIntensity;
  final double pulseIntensity;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'blinkInterval': blinkInterval.inMilliseconds,
      'mouthMovementSpeed': mouthMovementSpeed,
      'eyeMovementRange': eyeMovementRange,
      'floatingAmplitude': floatingAmplitude,
      'floatingSpeed': floatingSpeed,
      'glowIntensity': glowIntensity,
      'pulseIntensity': pulseIntensity,
    };
  }
}

// DUPLICATE CLASS REMOVED TO FIX BUILD ERROR
// class AICharacterState {
//   final AICharacterModel character;
//   final AICharacterState currentState;
//   final bool isVisible;
//   final bool isSpeaking;
//   final String currentMessage;
//   final DateTime lastInteraction;
//   final Map<String, dynamic> context;

//   const AICharacterState({
//     required this.character,
//     required this.currentState,
//     required this.isVisible,
//     required this.isSpeaking,
//     required this.currentMessage,
//     required this.lastInteraction,
//     required this.context,
//   });

//   AICharacterState copyWith({
//     AICharacterModel? character,
//     AICharacterState? currentState,
//     bool? isVisible,
//     bool? isSpeaking,
//     String? currentMessage,
//     DateTime? lastInteraction,
//     Map<String, dynamic>? context,
//   }) {
//     return AICharacterState(
//       character: character ?? this.character,
//       currentState: currentState ?? this.currentState,
//       isVisible: isVisible ?? this.isVisible,
//       isSpeaking: isSpeaking ?? this.isSpeaking,
//       currentMessage: currentMessage ?? this.currentMessage,
//       lastInteraction: lastInteraction ?? this.lastInteraction,
//       context: context ?? this.context,
//     );
//   }
// }

class AICharacterInteraction {
  const AICharacterInteraction({
    required this.characterId,
    required this.userId,
    required this.message,
    required this.response,
    required this.timestamp,
    required this.metadata,
  });

  factory AICharacterInteraction.fromMap(Map<String, dynamic> map) {
    return AICharacterInteraction(
      characterId: map['characterId'] ?? '',
      userId: map['userId'] ?? '',
      message: map['message'] ?? '',
      response: map['response'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      metadata: Map<String, dynamic>.from(map['metadata'] ?? <dynamic, dynamic>{}),
    );
  }
  final String characterId;
  final String userId;
  final String message;
  final String response;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'characterId': characterId,
      'userId': userId,
      'message': message,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}
