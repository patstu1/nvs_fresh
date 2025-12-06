import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nvs/meatup_core.dart';
import 'package:go_router/go_router.dart';
import '../../../ai_characters/data/ai_character_model.dart';
import '../../../ai_characters/data/ai_character_provider.dart';
import '../../../ai_characters/presentation/widgets/animated_ai_character.dart';

class NvsConnectOnboardingPage extends ConsumerStatefulWidget {
  const NvsConnectOnboardingPage({super.key});

  @override
  ConsumerState<NvsConnectOnboardingPage> createState() => _NvsConnectOnboardingPageState();
}

class _NvsConnectOnboardingPageState extends ConsumerState<NvsConnectOnboardingPage> {
  final PageController _controller = PageController();
  final int _index = 0; // retained for compatibility (unused in long-form)

  final Map<String, dynamic> _answers = <String, dynamic>{};

  late final List<_Question> _questions = <_Question>[
    _Question.section('CORE IDENTITY'),
    _Question.text('full_name', 'Full Name'),
    _Question.text('display_name', 'Preferred Display Name'),
    _Question.text('pronouns', 'Pronouns'),
    _Question.date('birthday', 'Birthday (for astrological profiling)'),
    _Question.text('birth_time_city', 'Birth Time & City (if known)'),
    _Question.text('gender_identity', 'Gender Identity'),
    _Question.text('sexual_orientation', 'Sexual Orientation'),
    _Question.multiselect('role_archetype', 'Role / Sexual Archetype', const <String>[
      'Top Dom Breeder',
      'Top',
      'Vers Top',
      'Vers',
      'Vers Bottom',
      'Bottom',
      'Power Bottom',
    ]),
    _Question.number('age', 'Age'),
    _Question.text('location', 'Current Location (City, Country)'),
    _Question.single(
      'relocate',
      'Willing to relocate for love?',
      const <String>['Yes', 'No', 'Maybe'],
    ),
    _Question.section('MATCH PREFERENCES'),
    _Question.multiselect('intent', "I'm looking for…", const <String>[
      'Long-term relationship',
      'Friends',
      'Casual dating',
      'Marriage',
      'Emotional connection',
      'Just curious',
    ]),
    _Question.multiselect(
      'preferred_gender',
      'Preferred Match Gender(s)',
      const <String>['Men', 'Women', 'Non-binary', 'Trans', 'All'],
    ),
    _Question.range('age_range', 'Preferred Age Range', min: 18, max: 80, start: 24, end: 40),
    _Question.single('geo', 'Geographic Filter', const <String>[
      'Local only',
      'Within my country',
      'USA only',
      'Global connections',
    ]),
    _Question.section('COMMUNICATION STYLE'),
    _Question.single('conflict_style', 'How do you handle conflict?', const <String>[
      'Direct & honest',
      'Avoidant',
      'Emotional',
      'Rational/logical',
      'Passive but internal',
    ]),
    _Question.single(
      'verbal_style',
      'Are you more…',
      const <String>['Verbal', 'Nonverbal', 'Blunt', 'Filtered', 'Warm', 'Dry'],
    ),
    _Question.text(
      'flirt_emoji',
      'Which emoji best represents how you flirt? (😏 😇 😈 🤠 🫦 😶‍🌫️ etc.)',
    ),
    _Question.section('RELATIONSHIP VIBES'),
    _Question.multiselect('open_to', 'What are you currently open to?', const <String>[
      'LTR / Marriage',
      'Friends with chemistry',
      'Monogamous dating',
      'Open relationship',
      'Exploring',
      'Just fun for now',
    ]),
    _Question.single(
      'soulmates',
      'Do you believe in soulmates?',
      const <String>['Yes', 'No', 'Unsure'],
    ),
    _Question.single('kids', 'Do you want kids someday?', const <String>['Yes', 'No', 'Maybe']),
    _Question.single(
      'marriage',
      'Would you ever get married?',
      const <String>['Yes', 'No', 'Maybe'],
    ),
    _Question.single(
      'been_in_love',
      'Have you ever been in love before?',
      const <String>['Yes', 'No'],
    ),
    _Question.section('SOCIAL MAP'),
    _Question.text('instagram', 'Instagram @'),
    _Question.text('tiktok', 'TikTok @'),
    _Question.text('x_twitter', 'X (Twitter) @'),
    _Question.text('threads', 'Threads @'),
    _Question.text('linkedin', 'LinkedIn (optional) @'),
    _Question.single(
      'account_privacy',
      'Are you a public or private account?',
      const <String>['Public', 'Private', 'Mixed'],
    ),
    _Question.single(
      'post_or_lurk',
      'Do you enjoy posting or lurking more?',
      const <String>['Posting', 'Lurking', 'Both'],
    ),
    _Question.section('FAMILY ORIGIN'),
    _Question.single('raised', 'Were you raised…', const <String>[
      'Religiously',
      'Spiritually',
      'Atheist / Agnostic',
      'Culturally but not spiritually',
    ]),
    _Question.longText('current_view_religion', 'Current view on religion/spirituality'),
    _Question.single(
      'birth_order',
      'Birth order',
      const <String>['Only Child', 'Eldest', 'Middle', 'Youngest'],
    ),
    _Question.number('siblings', 'How many siblings?'),
    _Question.longText('family_role', 'What role did you play in your family dynamic?'),
    _Question.section('SOCIAL STYLE + SCENE'),
    _Question.single(
      'go_out_often',
      'Do you go out often?',
      const <String>['Yes', 'No', 'Sometimes'],
    ),
    _Question.multiselect('hang_spots', 'Favorite spots to hang', const <String>[
      'Dive bar',
      'Trendy lounge',
      'Nature/hiking',
      'Raves',
      'House parties',
      'Art gallery',
      'Gym',
      'Brunch spots',
    ]),
    _Question.longText('music_taste', "What's your music taste? (artists/genres)"),
    _Question.longText('dream_friday', 'Your dream Friday night looks like…'),
    _Question.section('ENERGETIC VIBE'),
    _Question.multiselect(
      'strong_traits',
      'Pick your 3 strongest traits',
      const <String>[
        'Mysterious',
        'Loyal',
        'Bold',
        'Silly',
        'Sensitive',
        'Guarded',
        'Outgoing',
        'Wild',
        'Patient',
        'Moody',
      ],
      maxSelect: 3,
    ),
    _Question.multiselect(
      'drawn_traits',
      'Pick 3 you’re drawn to in others',
      const <String>[
        'Confident',
        'Vulnerable',
        'Protective',
        'Driven',
        'Flirty',
        'Nurturing',
        'Calm',
        'Creative',
        'Chaotic good',
        'Cold & hot',
      ],
      maxSelect: 3,
    ),
    _Question.section('FINAL AURA CHECK'),
    _Question.longText('fear_in_love', 'What’s your biggest fear in love?'),
    _Question.longText('toxic_pattern', 'One toxic pattern you’re working on breaking'),
    _Question.longText(
      'turn_on_trait',
      'One trait that always turns you on—emotionally or sexually',
    ),
    _Question.longText(
      'ready_to_share',
      'One thing you’ve never told anyone but you’re ready to share here',
    ),
    _Question.section('CONSENT & SAFETY'),
    _Question.checklist('consent', 'Consent Items', const <String>[
      'I consent to NVS analyzing my profile to generate emotionally intelligent matches.',
      'I understand NVS uses cutting‑edge, encrypted infrastructure to protect all my data.',
      'No data will be sold, shared, or used for advertising.',
      'I can opt out and delete my data at any time.',
    ]),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiCharacterProvider.notifier).showCharacter(AICharacterType.domBot);
      _showDisclaimer();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedConnectOnboarding', true);
    // Persist answers via existing repository hook
    await ref.read(aiCharacterRepositoryProvider).saveRelationshipAnswers(answers: _answers);
    if (!mounted) return;
    context.go('/connect');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                child: _longForm(),
              ),
            ),
            _submitBar(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Stack(
        children: <Widget>[
          Align(
            child: Text(
              'NVS CONNECT – Compatibility Questionnaire',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BellGothic',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
                color: NVSColors.ultraLightMint,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: SizedBox(
              width: 64,
              height: 64,
              child: AnimatedAICharacter(
                characterType: AICharacterType.domBot,
                floating: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDisclaimer() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          backgroundColor: NVSColors.pureBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: NVSColors.ultraLightMint),
          ),
          title: const Text(
            'TRUST + PRIVACY',
            style: TextStyle(fontFamily: 'BellGothic', color: NVSColors.ultraLightMint),
          ),
          content: const Text(
            'Your answers are encrypted and stored securely. We will never post, share, or reveal your responses or social data. Protected by next‑gen encryption across all layers of the app.',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: NVSColors.secondaryText,
              height: 1.3,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'begin',
                style: TextStyle(color: NVSColors.ultraLightMint, fontFamily: 'MagdaCleanMono'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _longForm() {
    final List<Widget> children = <Widget>[];
    for (final _Question q in _questions) {
      if (q.kind == _Kind.section) {
        children.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
            child: Text(
              q.label!,
              style: const TextStyle(
                color: NVSColors.ultraLightMint,
                fontFamily: 'BellGothic',
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ),
        );
        children.add(const Divider(color: Colors.white24));
      } else {
        children.add(_renderQuestion(q));
        children.add(const SizedBox(height: 12));
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget _renderQuestion(_Question q) {
    switch (q.kind) {
      case _Kind.text:
        return _textField(q);
      case _Kind.longText:
        return _textField(q, maxLines: 5);
      case _Kind.number:
        return _textField(q, keyboardType: TextInputType.number);
      case _Kind.date:
        return _textField(q, hint: 'YYYY-MM-DD');
      case _Kind.single:
        return _choices(q, multi: false);
      case _Kind.multiselect:
        return _choices(q, multi: true, maxSelect: q.maxSelect);
      case _Kind.range:
        return _range(q);
      case _Kind.checklist:
        return _checklist(q);
      case _Kind.section:
        return const SizedBox.shrink();
    }
  }

  Widget _textField(_Question q, {int maxLines = 1, TextInputType? keyboardType, String? hint}) {
    final TextEditingController c = TextEditingController(text: (_answers[q.id] ?? '').toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _label(q.label),
        const SizedBox(height: 8),
        TextField(
          controller: c,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: NVSColors.electricPink, fontFamily: 'MagdaCleanMono'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFFF41D6),
              fontFamily: 'MagdaCleanMono',
              fontSize: 12,
            ),
            filled: true,
            fillColor: Colors.black,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: NVSColors.electricPink),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: NVSColors.electricPink, width: 2),
            ),
          ),
          onChanged: (String v) => _answers[q.id] = v.trim(),
        ),
      ],
    );
  }

  Widget _choices(_Question q, {required bool multi, int? maxSelect}) {
    final Set<String> selected = <String>{...((_answers[q.id] as List<String>?) ?? <String>[])};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _label(q.label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: q.options!.map((String opt) {
            final bool isOn = multi ? selected.contains(opt) : _answers[q.id] == opt;
            return ChoiceChip(
              label: Text(
                opt.toLowerCase(),
                style: const TextStyle(color: NVSColors.electricPink, fontFamily: 'MagdaCleanMono'),
              ),
              selected: isOn,
              selectedColor: Colors.black,
              backgroundColor: Colors.black,
              shape: StadiumBorder(
                side: BorderSide(
                  color:
                      isOn ? NVSColors.electricPink : NVSColors.electricPink.withValues(alpha: 0.5),
                ),
              ),
              onSelected: (bool v) {
                setState(() {
                  if (multi) {
                    if (isOn) {
                      selected.remove(opt);
                    } else {
                      if (maxSelect == null || selected.length < maxSelect) selected.add(opt);
                    }
                    _answers[q.id] = selected.toList();
                  } else {
                    _answers[q.id] = opt;
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _range(_Question q) {
    final RangeValues current = (_answers[q.id] is List && (_answers[q.id] as List).length == 2)
        ? RangeValues(
            ((_answers[q.id] as List)[0] as num).toDouble(),
            ((_answers[q.id] as List)[1] as num).toDouble(),
          )
        : RangeValues(q.start!.toDouble(), q.end!.toDouble());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _label(q.label),
        const SizedBox(height: 8),
        RangeSlider(
          values: current,
          min: q.min!.toDouble(),
          max: q.max!.toDouble(),
          divisions: q.max! - q.min!,
          labels: RangeLabels(current.start.round().toString(), current.end.round().toString()),
          activeColor: NVSColors.electricPink,
          inactiveColor: Colors.white24,
          onChanged: (RangeValues v) =>
              setState(() => _answers[q.id] = <num>[v.start.round(), v.end.round()]),
        ),
      ],
    );
  }

  Widget _checklist(_Question q) {
    final Set<String> selected = <String>{...((_answers[q.id] as List<String>?) ?? <String>[])};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _label('consent & safety'),
        const SizedBox(height: 8),
        ...q.options!.map(
          (String opt) => CheckboxListTile(
            value: selected.contains(opt),
            onChanged: (bool? v) => setState(() {
              if (v ?? false) {
                selected.add(opt);
              } else {
                selected.remove(opt);
              }
              _answers[q.id] = selected.toList();
            }),
            title: Text(
              opt.toLowerCase(),
              style: const TextStyle(color: NVSColors.electricPink, fontFamily: 'MagdaCleanMono'),
            ),
            checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            activeColor: NVSColors.electricPink,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }

  Widget _submitBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      color: Colors.black,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _complete,
          style: ElevatedButton.styleFrom(
            backgroundColor: NVSColors.ultraLightMint,
            foregroundColor: Colors.black,
          ),
          child:
              const Text('Submit & Start Matching', style: TextStyle(fontFamily: 'MagdaCleanMono')),
        ),
      ),
    );
  }

  Widget _label(String? text) {
    return Text(
      (text ?? '').toLowerCase(),
      style: const TextStyle(
        color: NVSColors.electricPink,
        fontFamily: 'MagdaCleanMono',
        fontWeight: FontWeight.bold,
        letterSpacing: 0.6,
      ),
    );
  }
}

enum _Kind { section, text, longText, number, date, single, multiselect, range, checklist }

class _Question {
  factory _Question.section(String label) =>
      _Question._('section_$label', _Kind.section, label: label);
  factory _Question.text(String id, String label) => _Question._(id, _Kind.text, label: label);
  factory _Question.longText(String id, String label) =>
      _Question._(id, _Kind.longText, label: label);
  factory _Question.number(String id, String label) => _Question._(id, _Kind.number, label: label);
  factory _Question.date(String id, String label) => _Question._(id, _Kind.date, label: label);
  factory _Question.single(String id, String label, List<String> opts) =>
      _Question._(id, _Kind.single, label: label, options: opts);
  factory _Question.multiselect(String id, String label, List<String> opts, {int? maxSelect}) =>
      _Question._(id, _Kind.multiselect, label: label, options: opts, maxSelect: maxSelect);
  factory _Question.range(
    String id,
    String label, {
    required int min,
    required int max,
    required int start,
    required int end,
  }) =>
      _Question._(id, _Kind.range, label: label, min: min, max: max, start: start, end: end);
  factory _Question.checklist(String id, String label, List<String> opts) =>
      _Question._(id, _Kind.checklist, label: label, options: opts);
  const _Question._(
    this.id,
    this.kind, {
    this.label,
    this.options,
    this.min,
    this.max,
    this.start,
    this.end,
    this.maxSelect,
  });
  final String id;
  final _Kind kind;
  final String? label;
  final List<String>? options;
  final int? min;
  final int? max;
  final int? start;
  final int? end;
  final int? maxSelect;
}
