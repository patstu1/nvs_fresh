import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../domain/models/connect_models.dart';
import 'question_widgets.dart';

/// Beautiful, minimalist chat UI for the Curator conversation
/// Built on the Universal Messenger design principles
class CuratorChatInterface extends StatefulWidget {
  const CuratorChatInterface({
    required this.messages,
    required this.currentQuestions,
    required this.onQuestionAnswered,
    super.key,
  });
  final List<ChatMessage> messages;
  final List<CuratorQuestion> currentQuestions;
  final Function(String questionId, dynamic response) onQuestionAnswered;

  @override
  State<CuratorChatInterface> createState() => _CuratorChatInterfaceState();
}

class _CuratorChatInterfaceState extends State<CuratorChatInterface> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _typingController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _typingAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CuratorChatInterface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      // Scroll to bottom when new message is added
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Chat messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: widget.messages.length,
            itemBuilder: (BuildContext context, int index) {
              final ChatMessage message = widget.messages[index];
              return _buildMessageBubble(message, index);
            },
          ),
        ),

        // Current questions
        if (widget.currentQuestions.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: widget.currentQuestions.map(_buildQuestionWidget).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message, int index) {
    final bool isFromCurator = message.isFromCurator;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isFromCurator ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isFromCurator) _buildCuratorAvatar(),
          if (isFromCurator) const SizedBox(width: 12),
          Flexible(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOutBack,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isFromCurator
                    ? NVSColors.cardBackground.withValues(alpha: 0.7)
                    : NVSColors.neonMint.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isFromCurator
                      ? NVSColors.neonMint.withValues(alpha: 0.3)
                      : NVSColors.neonMint.withValues(alpha: 0.6),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: (isFromCurator ? NVSColors.neonMint : NVSColors.ultraLightMint)
                        .withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 16,
                  color: isFromCurator ? NVSColors.ultraLightMint : NVSColors.pureBlack,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (!isFromCurator) const SizedBox(width: 12),
          if (!isFromCurator) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildCuratorAvatar() {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                NVSColors.neonMint.withValues(alpha: _typingAnimation.value),
                NVSColors.ultraLightMint.withValues(alpha: 0.3),
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.neonMint.withValues(alpha: 0.4),
                blurRadius: 16,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: NVSColors.pureBlack,
            size: 20,
          ),
        );
      },
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
        border: Border.all(
          color: NVSColors.ultraLightMint.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.person,
        color: NVSColors.ultraLightMint,
        size: 20,
      ),
    );
  }

  Widget _buildQuestionWidget(CuratorQuestion question) {
    switch (question.responseType) {
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestion(
          question: question,
          onAnswered: (String response) => widget.onQuestionAnswered(question.questionId, response),
        );

      case QuestionType.imageSelect:
        return ImageSelectQuestion(
          question: question,
          onAnswered: (String response) => widget.onQuestionAnswered(question.questionId, response),
        );

      case QuestionType.slider:
        return SliderQuestion(
          question: question,
          onAnswered: (double response) => widget.onQuestionAnswered(question.questionId, response),
        );

      case QuestionType.yesNo:
        return YesNoQuestion(
          question: question,
          onAnswered: (bool response) => widget.onQuestionAnswered(question.questionId, response),
        );

      case QuestionType.text:
        return TextInputQuestion(
          question: question,
          onAnswered: (String response) => widget.onQuestionAnswered(question.questionId, response),
        );
    }
  }
}
