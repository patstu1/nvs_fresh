// NVS Deep Profile Flow (Prompts 12-21)
// Multi-section psychological questionnaire for better matching
// Includes: Intro, Values, Lifestyle, Relationship, Intimacy, Communication, Future, Conflict, Kinks, Summary

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeepProfileFlow extends StatefulWidget {
  const DeepProfileFlow({super.key});

  @override
  State<DeepProfileFlow> createState() => _DeepProfileFlowState();
}

class _DeepProfileFlowState extends State<DeepProfileFlow>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  late AnimationController _pulseController;
  late AnimationController _glowController;
  late PageController _pageController;
  
  int _currentSection = 0;
  final int _totalSections = 10;
  
  // Answers storage
  final Map<String, dynamic> _answers = {};

  final List<_DeepProfileSection> _sections = [
    _DeepProfileSection(
      id: 'intro',
      title: 'DEEP PROFILE',
      subtitle: 'Getting to know the real you',
      questions: [],
      isIntro: true,
    ),
    _DeepProfileSection(
      id: 'values',
      title: 'VALUES',
      subtitle: 'What matters most to you',
      questions: [
        _Question('values_honesty', 'How important is honesty in a relationship?', _QuestionType.slider),
        _Question('values_independence', 'How much do you value personal independence?', _QuestionType.slider),
        _Question('values_family', 'How important is family to you?', _QuestionType.slider),
        _Question('values_career', 'How career-focused are you?', _QuestionType.slider),
        _Question('values_growth', 'How important is personal growth?', _QuestionType.slider),
      ],
    ),
    _DeepProfileSection(
      id: 'lifestyle',
      title: 'LIFESTYLE',
      subtitle: 'Your daily rhythm',
      questions: [
        _Question('lifestyle_social', 'How social are you?', _QuestionType.slider, leftLabel: 'Introvert', rightLabel: 'Extrovert'),
        _Question('lifestyle_schedule', 'Early bird or night owl?', _QuestionType.slider, leftLabel: 'Early Bird', rightLabel: 'Night Owl'),
        _Question('lifestyle_fitness', 'How important is fitness?', _QuestionType.slider),
        _Question('lifestyle_travel', 'How often do you like to travel?', _QuestionType.slider, leftLabel: 'Homebody', rightLabel: 'Wanderlust'),
        _Question('lifestyle_spontaneous', 'How spontaneous are you?', _QuestionType.slider, leftLabel: 'Planner', rightLabel: 'Spontaneous'),
      ],
    ),
    _DeepProfileSection(
      id: 'relationship',
      title: 'RELATIONSHIP',
      subtitle: 'What you\'re looking for',
      questions: [
        _Question('rel_type', 'What type of connection?', _QuestionType.multiSelect, options: ['Casual', 'Dating', 'Relationship', 'Open', 'FWB']),
        _Question('rel_pace', 'Preferred relationship pace?', _QuestionType.slider, leftLabel: 'Slow', rightLabel: 'Fast'),
        _Question('rel_exclusivity', 'Views on exclusivity?', _QuestionType.slider, leftLabel: 'Mono', rightLabel: 'Open'),
        _Question('rel_time', 'How much time together?', _QuestionType.slider, leftLabel: 'Space', rightLabel: 'Together'),
      ],
    ),
    _DeepProfileSection(
      id: 'intimacy',
      title: 'INTIMACY',
      subtitle: 'Physical connection preferences',
      questions: [
        _Question('int_importance', 'How important is physical intimacy?', _QuestionType.slider),
        _Question('int_frequency', 'Ideal frequency?', _QuestionType.slider, leftLabel: 'Less', rightLabel: 'More'),
        _Question('int_adventure', 'How adventurous are you?', _QuestionType.slider, leftLabel: 'Vanilla', rightLabel: 'Adventurous'),
        _Question('int_chemistry', 'Physical chemistry vs emotional connection?', _QuestionType.slider, leftLabel: 'Emotional', rightLabel: 'Physical'),
      ],
    ),
    _DeepProfileSection(
      id: 'communication',
      title: 'COMMUNICATION',
      subtitle: 'How you connect',
      questions: [
        _Question('comm_style', 'Communication style?', _QuestionType.slider, leftLabel: 'Direct', rightLabel: 'Subtle'),
        _Question('comm_frequency', 'How often do you like to text?', _QuestionType.slider, leftLabel: 'Minimal', rightLabel: 'Constant'),
        _Question('comm_conflict', 'How do you handle disagreements?', _QuestionType.slider, leftLabel: 'Avoid', rightLabel: 'Confront'),
        _Question('comm_affection', 'How do you express affection?', _QuestionType.multiSelect, options: ['Words', 'Touch', 'Gifts', 'Acts', 'Time']),
      ],
    ),
    _DeepProfileSection(
      id: 'future',
      title: 'FUTURE',
      subtitle: 'Where you\'re headed',
      questions: [
        _Question('future_goals', 'What are your goals?', _QuestionType.multiSelect, options: ['Career', 'Family', 'Travel', 'Home', 'Adventure', 'Stability']),
        _Question('future_location', 'Would you relocate for a relationship?', _QuestionType.slider, leftLabel: 'Never', rightLabel: 'Definitely'),
        _Question('future_kids', 'Thoughts on children?', _QuestionType.singleSelect, options: ['Want', 'Open', 'No thanks', 'Have kids']),
        _Question('future_timeline', 'Relationship timeline?', _QuestionType.slider, leftLabel: 'No rush', rightLabel: 'Ready now'),
      ],
    ),
    _DeepProfileSection(
      id: 'conflict',
      title: 'CONFLICT',
      subtitle: 'Working through challenges',
      questions: [
        _Question('conflict_style', 'Conflict resolution style?', _QuestionType.singleSelect, options: ['Talk it out', 'Cool off first', 'Compromise', 'Avoid']),
        _Question('conflict_patience', 'How patient are you?', _QuestionType.slider),
        _Question('conflict_forgive', 'How easily do you forgive?', _QuestionType.slider),
        _Question('conflict_dealbreakers', 'What are your dealbreakers?', _QuestionType.multiSelect, options: ['Dishonesty', 'Jealousy', 'Disrespect', 'Different goals', 'Poor communication']),
      ],
    ),
    _DeepProfileSection(
      id: 'kinks',
      title: 'DESIRES',
      subtitle: 'Your deeper preferences',
      questions: [
        _Question('kink_role', 'Role preference?', _QuestionType.slider, leftLabel: 'Dominant', rightLabel: 'Submissive'),
        _Question('kink_interests', 'Interests? (Select all that apply)', _QuestionType.multiSelect, options: ['Vanilla', 'Light BDSM', 'Roleplay', 'Exhibitionism', 'Group', 'Other']),
        _Question('kink_explore', 'Openness to exploring?', _QuestionType.slider),
        _Question('kink_boundaries', 'How firm are your boundaries?', _QuestionType.slider, leftLabel: 'Flexible', rightLabel: 'Firm'),
      ],
    ),
    _DeepProfileSection(
      id: 'summary',
      title: 'COMPLETE',
      subtitle: 'Your Deep Profile is ready',
      questions: [],
      isSummary: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _nextSection() {
    if (_currentSection < _totalSections - 1) {
      setState(() => _currentSection++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      HapticFeedback.selectionClick();
    } else {
      // Complete
      Navigator.pop(context, _answers);
    }
  }

  void _previousSection() {
    if (_currentSection > 0) {
      setState(() => _currentSection--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final section = _sections[index];
                  if (section.isIntro) {
                    return _buildIntroSection(section);
                  } else if (section.isSummary) {
                    return _buildSummarySection();
                  } else {
                    return _buildQuestionSection(section);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: _previousSection,
            child: const Icon(Icons.arrow_back, color: _mint),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _sections[_currentSection].title,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  _sections[_currentSection].subtitle,
                  style: TextStyle(color: _olive, fontSize: 12),
                ),
              ],
            ),
          ),
          if (!_sections[_currentSection].isIntro && !_sections[_currentSection].isSummary)
            GestureDetector(
              onTap: _nextSection,
              child: Text('Skip', style: TextStyle(color: _olive, fontSize: 14)),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_totalSections, (index) {
          final isCompleted = index < _currentSection;
          final isCurrent = index == _currentSection;
          
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < _totalSections - 1 ? 4 : 0),
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isCompleted || isCurrent ? _aqua : _olive.withOpacity(0.3),
                boxShadow: isCurrent
                    ? [BoxShadow(color: _aqua.withOpacity(0.5), blurRadius: 6)]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ============ INTRO SECTION (Prompt 12) ============
  Widget _buildIntroSection(_DeepProfileSection section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Animated orb
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _aqua.withOpacity(0.4 * _pulseController.value + 0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _aqua.withOpacity(0.5),
                        _aqua.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                    border: Border.all(color: _aqua, width: 2),
                  ),
                  child: Center(
                    child: Icon(Icons.psychology, color: _aqua, size: 50),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          const Text(
            'DEEP PROFILE',
            style: TextStyle(
              color: _mint,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'A journey into who you really are',
            style: TextStyle(color: _olive, fontSize: 16),
          ),
          const SizedBox(height: 40),
          _buildIntroFeature(Icons.auto_awesome, 'Better Matches', 'AI-powered compatibility based on who you truly are'),
          _buildIntroFeature(Icons.psychology, 'Self Discovery', 'Learn about your patterns and preferences'),
          _buildIntroFeature(Icons.lock, 'Private', 'Your answers are never shown to others'),
          _buildIntroFeature(Icons.timer, '10 Minutes', 'That\'s all it takes to unlock deeper connections'),
          const SizedBox(height: 40),
          _buildContinueButton('BEGIN'),
        ],
      ),
    );
  }

  Widget _buildIntroFeature(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _aqua.withOpacity(0.4)),
            ),
            child: Icon(icon, color: _aqua, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: _olive, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============ QUESTION SECTIONS (Prompts 13-20) ============
  Widget _buildQuestionSection(_DeepProfileSection section) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 20),
        ...section.questions.map((q) => _buildQuestion(q)),
        const SizedBox(height: 40),
        _buildContinueButton('CONTINUE'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildQuestion(_Question question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: const TextStyle(
              color: _mint,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          if (question.type == _QuestionType.slider)
            _buildSliderQuestion(question),
          if (question.type == _QuestionType.multiSelect)
            _buildMultiSelectQuestion(question),
          if (question.type == _QuestionType.singleSelect)
            _buildSingleSelectQuestion(question),
        ],
      ),
    );
  }

  Widget _buildSliderQuestion(_Question question) {
    final value = (_answers[question.id] as double?) ?? 0.5;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              question.leftLabel ?? 'Low',
              style: TextStyle(color: _olive, fontSize: 12),
            ),
            Text(
              question.rightLabel ?? 'High',
              style: TextStyle(color: _olive, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            activeTrackColor: _aqua,
            inactiveTrackColor: _olive.withOpacity(0.3),
            thumbColor: _aqua,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayColor: _aqua.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            onChanged: (v) => setState(() => _answers[question.id] = v),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectQuestion(_Question question) {
    final selected = (_answers[question.id] as List<String>?) ?? [];
    
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: question.options.map((option) {
        final isSelected = selected.contains(option);
        
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              final newSelected = List<String>.from(selected);
              if (isSelected) {
                newSelected.remove(option);
              } else {
                newSelected.add(option);
              }
              _answers[question.id] = newSelected;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? _aqua : _olive.withOpacity(0.4),
              ),
              color: isSelected ? _aqua.withOpacity(0.15) : Colors.transparent,
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? _aqua : _mint.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleSelectQuestion(_Question question) {
    final selected = _answers[question.id] as String?;
    
    return Column(
      children: question.options.map((option) {
        final isSelected = selected == option;
        
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _answers[question.id] = option);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _aqua : _olive.withOpacity(0.3),
              ),
              color: isSelected ? _aqua.withOpacity(0.1) : Colors.transparent,
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? _aqua : _olive,
                      width: 2,
                    ),
                    color: isSelected ? _aqua : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: _black, size: 12)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? _aqua : _mint,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ============ SUMMARY SECTION (Prompt 21) ============
  Widget _buildSummarySection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Success animation
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _aqua.withOpacity(0.5 * _glowController.value),
                      blurRadius: 40,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _aqua.withOpacity(0.2),
                    border: Border.all(color: _aqua, width: 3),
                  ),
                  child: const Icon(Icons.check, color: _aqua, size: 60),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          const Text(
            'DEEP PROFILE COMPLETE',
            style: TextStyle(
              color: _mint,
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'NVS AI is now analyzing your responses to create your unique Blueprint.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _mint.withOpacity(0.8),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _aqua.withOpacity(0.4)),
              gradient: LinearGradient(
                colors: [_aqua.withOpacity(0.1), Colors.transparent],
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.auto_awesome, color: _aqua, size: 30),
                const SizedBox(height: 16),
                const Text(
                  'WHAT HAPPENS NEXT?',
                  style: TextStyle(
                    color: _aqua,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                _buildNextStep('1', 'Blueprint Generated', 'Your unique compatibility profile'),
                _buildNextStep('2', 'Better Matches', 'Profiles matched to your true self'),
                _buildNextStep('3', 'AI Insights', 'Personalized dating recommendations'),
              ],
            ),
          ),
          const SizedBox(height: 40),
          _buildContinueButton('VIEW MY BLUEPRINT'),
        ],
      ),
    );
  }

  Widget _buildNextStep(String number, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _aqua),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: _aqua,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: _olive, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(String label) {
    return GestureDetector(
      onTap: _nextSection,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: _aqua,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _aqua.withOpacity(0.3 * _pulseController.value + 0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: _black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============ DATA MODELS ============
class _DeepProfileSection {
  final String id;
  final String title;
  final String subtitle;
  final List<_Question> questions;
  final bool isIntro;
  final bool isSummary;

  _DeepProfileSection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.questions,
    this.isIntro = false,
    this.isSummary = false,
  });
}

class _Question {
  final String id;
  final String text;
  final _QuestionType type;
  final List<String> options;
  final String? leftLabel;
  final String? rightLabel;

  _Question(
    this.id,
    this.text,
    this.type, {
    this.options = const [],
    this.leftLabel,
    this.rightLabel,
  });
}

enum _QuestionType {
  slider,
  multiSelect,
  singleSelect,
}

