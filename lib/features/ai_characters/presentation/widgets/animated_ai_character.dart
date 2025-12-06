import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../data/ai_character_model.dart';
import '../../data/ai_character_provider.dart';

class AnimatedAICharacter extends ConsumerStatefulWidget {
  const AnimatedAICharacter({
    required this.characterType,
    super.key,
    this.showSpeechBubble = true,
    this.onTap,
    this.floating = false,
  });
  final AICharacterType characterType;
  final bool showSpeechBubble;
  final VoidCallback? onTap;
  final bool floating;

  @override
  ConsumerState<AnimatedAICharacter> createState() => _AnimatedAICharacterState();
}

class _AnimatedAICharacterState extends ConsumerState<AnimatedAICharacter>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _mouthController;
  late AnimationController _floatController;
  late Animation<double> _blinkAnimation;
  late Animation<double> _mouthAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Blink animation
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Mouth animation
    _mouthController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _mouthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mouthController, curve: Curves.easeInOut),
    );

    // Floating animation
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    // Start floating animation
    if (widget.floating) {
      _floatController.repeat(reverse: true);
    }

    // Start blink animation
    _scheduleBlink();
  }

  void _scheduleBlink() {
    Future.delayed(Duration(seconds: 2 + (DateTime.now().millisecond % 3)), () {
      if (mounted) {
        _blinkController.forward().then((_) {
          _blinkController.reverse();
          _scheduleBlink();
        });
      }
    });
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _mouthController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AICharacterRuntimeState characterState = ref.watch(
      widget.characterType == AICharacterType.domBot ? domBotProvider : webmasterProvider,
    );

    if (!characterState.isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: characterState.opacity,
      duration: const Duration(milliseconds: 300),
      child: Stack(
        children: <Widget>[
          // Floating animation
          if (widget.floating)
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(0, 5 * _floatAnimation.value),
                  child: _buildCharacterAvatar(characterState),
                );
              },
            )
          else
            _buildCharacterAvatar(characterState),

          // Speech bubble
          if (widget.showSpeechBubble && characterState.currentMessage.isNotEmpty)
            _buildSpeechBubble(characterState),

          // Quick prompts
          if (characterState.isVisible && characterState.currentMessage.isEmpty)
            _buildQuickPrompts(characterState),
        ],
      ),
    );
  }

  Widget _buildCharacterAvatar(AICharacterRuntimeState characterState) {
    final AICharacterModel character = characterState.character;
    final bool isSpeaking = characterState.isSpeaking;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: characterState.size.width,
        height: characterState.size.height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: character.accentColor.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            // Base avatar
            ClipOval(
              child: Image.asset(
                character.avatarPath,
                width: characterState.size.width,
                height: characterState.size.height,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return _buildPlaceholderAvatar(character, characterState);
                },
              ),
            ),

            // Blinking eyes
            if (characterState.currentState == AICharacterState.idle) _buildBlinkingEyes(),

            // Mouth animation when speaking
            if (isSpeaking) _buildMouthAnimation(),

            // State-specific animations
            _buildStateAnimation(characterState),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar(
    AICharacterModel character,
    AICharacterRuntimeState characterState,
  ) {
    return Container(
      width: characterState.size.width,
      height: characterState.size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            character.accentColor,
            character.accentColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        character.type == AICharacterType.domBot ? Icons.favorite : Icons.security,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBlinkingEyes() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Left eye
          AnimatedBuilder(
            animation: _blinkAnimation,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: 20,
                height: 20 * _blinkAnimation.value,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
          // Right eye
          AnimatedBuilder(
            animation: _blinkAnimation,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: 20,
                height: 20 * _blinkAnimation.value,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMouthAnimation() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: _mouthAnimation,
          builder: (BuildContext context, Widget? child) {
            return Container(
              width: 30,
              height: 15 * _mouthAnimation.value,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStateAnimation(AICharacterRuntimeState characterState) {
    switch (characterState.currentState) {
      case AICharacterState.speaking:
        return _buildSpeakingAnimation(characterState);
      case AICharacterState.listening:
        return _buildListeningAnimation(characterState);
      case AICharacterState.thinking:
        return _buildThinkingAnimation(characterState);
      case AICharacterState.warning:
        return _buildWarningAnimation(characterState);
      case AICharacterState.excited:
        return _buildExcitedAnimation(characterState);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSpeakingAnimation(AICharacterRuntimeState characterState) {
    return Lottie.asset(
      'assets/animations/${widget.characterType.name}_speaking.json',
      width: characterState.size.width,
      height: characterState.size.height,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return _buildFallbackStateAnimation(AICharacterState.speaking);
      },
    );
  }

  Widget _buildListeningAnimation(AICharacterRuntimeState characterState) {
    return Lottie.asset(
      'assets/animations/${widget.characterType.name}_listening.json',
      width: characterState.size.width,
      height: characterState.size.height,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return _buildFallbackStateAnimation(AICharacterState.listening);
      },
    );
  }

  Widget _buildThinkingAnimation(AICharacterRuntimeState characterState) {
    return Lottie.asset(
      'assets/animations/${widget.characterType.name}_thinking.json',
      width: characterState.size.width,
      height: characterState.size.height,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return _buildFallbackStateAnimation(AICharacterState.thinking);
      },
    );
  }

  Widget _buildWarningAnimation(AICharacterRuntimeState characterState) {
    return Lottie.asset(
      'assets/animations/${widget.characterType.name}_warning.json',
      width: characterState.size.width,
      height: characterState.size.height,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return _buildFallbackStateAnimation(AICharacterState.warning);
      },
    );
  }

  Widget _buildExcitedAnimation(AICharacterRuntimeState characterState) {
    return Lottie.asset(
      'assets/animations/${widget.characterType.name}_excited.json',
      width: characterState.size.width,
      height: characterState.size.height,
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return _buildFallbackStateAnimation(AICharacterState.excited);
      },
    );
  }

  Widget _buildFallbackStateAnimation(AICharacterState state) {
    // This is a fallback in case the Lottie animation fails to load
    // You can customize this to show a different placeholder for each state
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final AICharacterRuntimeState characterState = ref.watch(
          widget.characterType == AICharacterType.domBot ? domBotProvider : webmasterProvider,
        );
        return Container(
          width: characterState.size.width,
          height: characterState.size.height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: characterState.character.accentColor.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Icon(
              _getIconForState(state),
              size: 60,
              color: characterState.character.accentColor,
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForState(AICharacterState state) {
    switch (state) {
      case AICharacterState.speaking:
        return Icons.record_voice_over;
      case AICharacterState.listening:
        return Icons.hearing;
      case AICharacterState.thinking:
        return Icons.sync;
      case AICharacterState.warning:
        return Icons.warning;
      case AICharacterState.excited:
        return Icons.celebration;
      default:
        return Icons.person;
    }
  }

  Widget _buildSpeechBubble(AICharacterRuntimeState characterState) {
    return Positioned(
      bottom: characterState.size.height + 20,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: characterState.character.accentColor,
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: characterState.character.accentColor.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              characterState.character.name,
              style: TextStyle(
                color: characterState.character.accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              characterState.currentMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPrompts(AICharacterRuntimeState characterState) {
    final AICharacterModel character = characterState.character;
    return Positioned(
      bottom: characterState.size.height + 20,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: character.quickPrompts
              .take(3)
              .map((String prompt) => _buildQuickPromptButton(prompt, characterState))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildQuickPromptButton(
    String prompt,
    AICharacterRuntimeState characterState,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(aiCharacterProvider.notifier).sendUserMessage(
                  widget.characterType,
                  prompt,
                );
          },
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: characterState.character.accentColor.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              prompt,
              style: TextStyle(
                color: characterState.character.accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
