import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/connect_models.dart';

/// Provider to track if user has completed the Resonance Session
final StateProvider<bool> resonanceSessionCompleteProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) => false);

/// Provider for the current conversation state
final StateNotifierProvider<ConversationNotifier, ConversationState> conversationStateProvider =
    StateNotifierProvider<ConversationNotifier, ConversationState>(
        (StateNotifierProviderRef<ConversationNotifier, ConversationState> ref) {
  return ConversationNotifier();
});

/// Provider for match queue
final StateNotifierProvider<MatchQueueNotifier, List<MatchProfile>> matchQueueProvider =
    StateNotifierProvider<MatchQueueNotifier, List<MatchProfile>>(
        (StateNotifierProviderRef<MatchQueueNotifier, List<MatchProfile>> ref) {
  return MatchQueueNotifier();
});

/// Provider for user's aura signature data
final StateProvider<AuraSignatureData?> userAuraSignatureProvider =
    StateProvider<AuraSignatureData?>((StateProviderRef<AuraSignatureData?> ref) => null);

/// Notifier for conversation state management
class ConversationNotifier extends StateNotifier<ConversationState> {
  ConversationNotifier() : super(ConversationState.initial());

  void addMessage(ChatMessage message) {
    state = state.copyWith(
      messages: <ChatMessage>[...state.messages, message],
    );
  }

  void addCuratorQuestion(CuratorQuestion question) {
    state = state.copyWith(
      currentQuestions: <CuratorQuestion>[...state.currentQuestions, question],
    );
  }

  void submitResponse(String questionId, dynamic response) {
    // Remove the answered question
    final List<CuratorQuestion> updatedQuestions =
        state.currentQuestions.where((CuratorQuestion q) => q.questionId != questionId).toList();

    state = state.copyWith(
      currentQuestions: updatedQuestions,
      responses: <String, dynamic>{...state.responses, questionId: response},
    );
  }

  void completeSession() {
    state = state.copyWith(isComplete: true);
  }

  void reset() {
    state = ConversationState.initial();
  }
}

/// Notifier for match queue management
class MatchQueueNotifier extends StateNotifier<List<MatchProfile>> {
  MatchQueueNotifier() : super(<MatchProfile>[]);

  void loadMatches(List<MatchProfile> matches) {
    state = matches;
  }

  void passOnCurrentMatch() {
    if (state.isNotEmpty) {
      state = state.skip(1).toList();
    }
  }

  void connectWithCurrentMatch() {
    if (state.isNotEmpty) {
      // Handle connection logic here
      state = state.skip(1).toList();
    }
  }
}
