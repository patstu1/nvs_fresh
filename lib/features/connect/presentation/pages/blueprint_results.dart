// NVS Blueprint Results (Prompt 22)
// Full profile analysis results showing user's compatibility blueprint
// Generated from Deep Profile questionnaire responses

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlueprintResults extends StatefulWidget {
  final Map<String, dynamic>? answers;

  const BlueprintResults({super.key, this.answers});

  @override
  State<BlueprintResults> createState() => _BlueprintResultsState();
}

class _BlueprintResultsState extends State<BlueprintResults>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _pulseController;
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;

  // Blueprint data (would be generated from answers in real app)
  final _BlueprintData _blueprint = _BlueprintData(
    archetype: 'The Explorer',
    archetypeDescription: 'You seek adventure and growth in your connections. You value authenticity and are drawn to those who challenge and inspire you.',
    coreTraits: [
      _TraitScore('Independence', 0.85),
      _TraitScore('Emotional Depth', 0.72),
      _TraitScore('Adventure', 0.90),
      _TraitScore('Communication', 0.78),
      _TraitScore('Intimacy', 0.82),
    ],
    attachmentStyle: 'Secure-Avoidant',
    attachmentDescription: 'You value your independence while being capable of deep connection. You need space to maintain your sense of self.',
    loveLanguages: ['Quality Time', 'Physical Touch'],
    idealMatch: 'Someone who shares your adventurous spirit but provides emotional grounding. Look for partners who respect boundaries while encouraging growth.',
    growthAreas: ['Vulnerability', 'Patience', 'Compromise'],
    strengths: ['Authenticity', 'Passion', 'Resilience', 'Communication'],
    redFlags: ['Codependency', 'Lack of ambition', 'Dishonesty'],
    compatibleTypes: ['The Caretaker', 'The Free Spirit', 'The Builder'],
  );

  // ignore: unused_field
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutCubic,
    );
    
    // Start reveal after short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _revealController.forward();
      setState(() => _isRevealed = true);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: _black,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: _mint),
              ),
              title: const Text(
                'YOUR BLUEPRINT',
                style: TextStyle(
                  color: _mint,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 3,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: _shareBlueprint,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Icon(Icons.share, color: _olive),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _revealAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _revealAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _revealAnimation.value)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildArchetypeSection(),
                            const SizedBox(height: 32),
                            _buildCoreTraitsSection(),
                            const SizedBox(height: 32),
                            _buildAttachmentSection(),
                            const SizedBox(height: 32),
                            _buildLoveLanguagesSection(),
                            const SizedBox(height: 32),
                            _buildIdealMatchSection(),
                            const SizedBox(height: 32),
                            _buildStrengthsWeaknessesSection(),
                            const SizedBox(height: 32),
                            _buildCompatibleTypesSection(),
                            const SizedBox(height: 32),
                            _buildActionButtons(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchetypeSection() {
    return Column(
      children: [
        // Archetype orb
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 140,
              height: 140,
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
                      _aqua.withOpacity(0.4),
                      _aqua.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                  border: Border.all(color: _aqua, width: 3),
                ),
                child: Center(
                  child: Icon(Icons.explore, color: _aqua, size: 50),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          _blueprint.archetype.toUpperCase(),
          style: const TextStyle(
            color: _aqua,
            fontSize: 28,
            fontWeight: FontWeight.w300,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _blueprint.archetypeDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _mint.withOpacity(0.85),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildCoreTraitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('CORE TRAITS'),
        const SizedBox(height: 16),
        ..._blueprint.coreTraits.map((trait) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trait.name,
                      style: TextStyle(color: _mint.withOpacity(0.9), fontSize: 14),
                    ),
                    Text(
                      '${(trait.score * 100).toInt()}%',
                      style: const TextStyle(
                        color: _aqua,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildAnimatedProgressBar(trait.score),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAnimatedProgressBar(double value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, child) {
          return LinearProgressIndicator(
            value: animatedValue,
            backgroundColor: _olive.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(
              _aqua.withOpacity(0.7 + (animatedValue * 0.3)),
            ),
            minHeight: 8,
          );
        },
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _aqua.withOpacity(0.4)),
        gradient: LinearGradient(
          colors: [_aqua.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: _aqua, size: 20),
              const SizedBox(width: 10),
              Text(
                'ATTACHMENT STYLE',
                style: TextStyle(
                  color: _aqua,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _blueprint.attachmentStyle,
            style: const TextStyle(
              color: _mint,
              fontSize: 22,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _blueprint.attachmentDescription,
            style: TextStyle(
              color: _mint.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoveLanguagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('LOVE LANGUAGES'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _blueprint.loveLanguages.asMap().entries.map((entry) {
            final isPrimary = entry.key == 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPrimary ? _aqua : _mint.withOpacity(0.4),
                  width: isPrimary ? 2 : 1,
                ),
                color: isPrimary ? _aqua.withOpacity(0.15) : Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isPrimary) ...[
                    Icon(Icons.favorite, color: _aqua, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    entry.value,
                    style: TextStyle(
                      color: isPrimary ? _aqua : _mint,
                      fontSize: 14,
                      fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIdealMatchSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _mint.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: _aqua, size: 20),
              const SizedBox(width: 10),
              _buildSectionHeader('YOUR IDEAL MATCH'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _blueprint.idealMatch,
            style: TextStyle(
              color: _mint.withOpacity(0.85),
              fontSize: 15,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthsWeaknessesSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: _aqua, size: 16),
                  const SizedBox(width: 8),
                  _buildSectionHeader('STRENGTHS'),
                ],
              ),
              const SizedBox(height: 12),
              ..._blueprint.strengths.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _aqua,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      s,
                      style: TextStyle(color: _mint.withOpacity(0.85), fontSize: 14),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, color: _olive, size: 16),
                  const SizedBox(width: 8),
                  _buildSectionHeader('GROWTH AREAS'),
                ],
              ),
              const SizedBox(height: 12),
              ..._blueprint.growthAreas.map((g) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _olive,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      g,
                      style: TextStyle(color: _mint.withOpacity(0.7), fontSize: 14),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompatibleTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('COMPATIBLE ARCHETYPES'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _blueprint.compatibleTypes.map((type) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _aqua.withOpacity(0.5)),
              ),
              child: Text(
                type,
                style: TextStyle(color: _aqua, fontSize: 13),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        // Red flags
        Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.redAccent.shade200, size: 16),
            const SizedBox(width: 8),
            _buildSectionHeader('WATCH OUT FOR'),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _blueprint.redFlags.map((flag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.redAccent.shade200.withOpacity(0.5)),
              ),
              child: Text(
                flag,
                style: TextStyle(
                  color: Colors.redAccent.shade200.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            // Navigate to matches
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: _aqua,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _aqua.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'FIND MY MATCHES',
                style: TextStyle(
                  color: _black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () {
            // Retake questionnaire
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: _olive.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                'RETAKE DEEP PROFILE',
                style: TextStyle(
                  color: _olive,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _olive,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
  }

  void _shareBlueprint() {
    HapticFeedback.selectionClick();
    // Share functionality
  }
}

// ============ DATA MODELS ============
class _BlueprintData {
  final String archetype;
  final String archetypeDescription;
  final List<_TraitScore> coreTraits;
  final String attachmentStyle;
  final String attachmentDescription;
  final List<String> loveLanguages;
  final String idealMatch;
  final List<String> growthAreas;
  final List<String> strengths;
  final List<String> redFlags;
  final List<String> compatibleTypes;

  _BlueprintData({
    required this.archetype,
    required this.archetypeDescription,
    required this.coreTraits,
    required this.attachmentStyle,
    required this.attachmentDescription,
    required this.loveLanguages,
    required this.idealMatch,
    required this.growthAreas,
    required this.strengths,
    required this.redFlags,
    required this.compatibleTypes,
  });
}

class _TraitScore {
  final String name;
  final double score;

  _TraitScore(this.name, this.score);
}

