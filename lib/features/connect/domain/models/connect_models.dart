import 'package:flutter/material.dart';

/// Model for chat messages in the Resonance Session
class ChatMessage {
  // For Curator video clips

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isFromCurator,
    required this.timestamp,
    this.videoClipPath,
  });
  final String id;
  final String content;
  final bool isFromCurator;
  final DateTime timestamp;
  final String? videoClipPath;

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isFromCurator,
    DateTime? timestamp,
    String? videoClipPath,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromCurator: isFromCurator ?? this.isFromCurator,
      timestamp: timestamp ?? this.timestamp,
      videoClipPath: videoClipPath ?? this.videoClipPath,
    );
  }
}

/// Model for Curator questions
class CuratorQuestion {
  // For image selection

  const CuratorQuestion({
    required this.questionId,
    required this.questionText,
    required this.responseType,
    this.choices,
    this.imageUrls,
  });
  final String questionId;
  final String questionText;
  final QuestionType responseType;
  final List<String>? choices; // For multiple choice
  final List<String>? imageUrls;
}

/// Types of questions the Curator can ask
enum QuestionType {
  text,
  multipleChoice,
  imageSelect,
  slider,
  yesNo,
}

/// State of the conversation with the Curator
class ConversationState {
  const ConversationState({
    required this.messages,
    required this.currentQuestions,
    required this.responses,
    required this.isComplete,
    this.sessionId,
  });

  factory ConversationState.initial() {
    return const ConversationState(
      messages: <ChatMessage>[],
      currentQuestions: <CuratorQuestion>[],
      responses: <String, dynamic>{},
      isComplete: false,
    );
  }
  final List<ChatMessage> messages;
  final List<CuratorQuestion> currentQuestions;
  final Map<String, dynamic> responses;
  final bool isComplete;
  final String? sessionId;

  ConversationState copyWith({
    List<ChatMessage>? messages,
    List<CuratorQuestion>? currentQuestions,
    Map<String, dynamic>? responses,
    bool? isComplete,
    String? sessionId,
  }) {
    return ConversationState(
      messages: messages ?? this.messages,
      currentQuestions: currentQuestions ?? this.currentQuestions,
      responses: responses ?? this.responses,
      isComplete: isComplete ?? this.isComplete,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

/// Model for user's aura signature visualization data
class AuraSignatureData {
  // For different chakra/energy centers

  const AuraSignatureData({
    required this.color1,
    required this.color2,
    required this.color3,
    required this.rotationSpeed,
    required this.particleDensity,
    required this.glowIntensity,
    required this.pulsationRate,
    required this.energyLevels,
  });

  factory AuraSignatureData.defaultSignature() {
    return const AuraSignatureData(
      color1: Color(0xFF00FFD0), // Neon mint
      color2: Color(0xFF4BEFE0), // Turquoise
      color3: Color(0xFF7DFFC7), // Light mint
      rotationSpeed: 1.0,
      particleDensity: 0.7,
      glowIntensity: 0.8,
      pulsationRate: 1.2,
      energyLevels: <double>[0.8, 0.6, 0.9, 0.7, 0.5, 0.8, 0.6], // 7 chakra levels
    );
  }
  final Color color1;
  final Color color2;
  final Color color3;
  final double rotationSpeed;
  final double particleDensity;
  final double glowIntensity;
  final double pulsationRate;
  final List<double> energyLevels;

  AuraSignatureData copyWith({
    Color? color1,
    Color? color2,
    Color? color3,
    double? rotationSpeed,
    double? particleDensity,
    double? glowIntensity,
    double? pulsationRate,
    List<double>? energyLevels,
  }) {
    return AuraSignatureData(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      color3: color3 ?? this.color3,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
      particleDensity: particleDensity ?? this.particleDensity,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      pulsationRate: pulsationRate ?? this.pulsationRate,
      energyLevels: energyLevels ?? this.energyLevels,
    );
  }
}

/// Model for match profiles
class MatchProfile {
  const MatchProfile({
    required this.userId,
    required this.name,
    required this.photos,
    required this.compatibilityScore,
    required this.curatorInsight,
    required this.auraSignatureData,
    required this.profileData,
  });
  final String userId;
  final String name;
  final List<String> photos;
  final double compatibilityScore;
  final String curatorInsight;
  final AuraSignatureData auraSignatureData;
  final Map<String, dynamic> profileData;

  MatchProfile copyWith({
    String? userId,
    String? name,
    List<String>? photos,
    double? compatibilityScore,
    String? curatorInsight,
    AuraSignatureData? auraSignatureData,
    Map<String, dynamic>? profileData,
  }) {
    return MatchProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      photos: photos ?? this.photos,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      curatorInsight: curatorInsight ?? this.curatorInsight,
      auraSignatureData: auraSignatureData ?? this.auraSignatureData,
      profileData: profileData ?? this.profileData,
    );
  }
}

/// Model for API responses
class ResonanceSessionResponse {
  const ResonanceSessionResponse({
    required this.success,
    required this.isComplete,
    this.nextQuestions,
    this.error,
  });
  final bool success;
  final List<CuratorQuestion>? nextQuestions;
  final bool isComplete;
  final String? error;
}

class MatchQueueResponse {
  const MatchQueueResponse({
    required this.matches,
    this.error,
  });
  final List<MatchProfile> matches;
  final String? error;
}

class ConnectionResponse {
  const ConnectionResponse({
    required this.success,
    this.chatThreadId,
    this.error,
  });
  final String? chatThreadId;
  final bool success;
  final String? error;
}

