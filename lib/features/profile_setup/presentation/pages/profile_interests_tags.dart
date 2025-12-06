// lib/features/profile_setup/presentation/pages/profile_interests_tags.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/profile_setup_controller.dart';
import 'profile_review_submit.dart';

class ProfileInterestsTags extends ConsumerStatefulWidget {
  const ProfileInterestsTags({super.key});

  @override
  ConsumerState<ProfileInterestsTags> createState() => _ProfileInterestsTagsState();
}

class _ProfileInterestsTagsState extends ConsumerState<ProfileInterestsTags> {
  final List<String> roles = <String>[
    'Top Dom',
    'Top',
    'Vers Top',
    'Vers',
    'Vers Bottom',
    'Bottom',
    'Power Bottom',
  ];

  final List<String> moods = <String>[
    'Curious',
    'Shy',
    'Bold',
    'Discreet',
    'Experimental',
    'Sensual',
    'Playful',
  ];

  final List<String> traits = <String>[
    'Empath',
    'Loyal',
    'Adventurous',
    'Private',
    'Confident',
    'Generous',
    'Ambitious',
  ];

  final Set<String> selectedRoles = <String>{};
  final Set<String> selectedMoods = <String>{};
  final Set<String> selectedTraits = <String>{};

  void _toggle(Set<String> group, String value) {
    setState(() {
      if (group.contains(value)) {
        group.remove(value);
      } else {
        group.add(value);
      }
    });
  }

  void _submit() {
    ref.read(profileSetupProvider.notifier).update(
          roleTags: selectedRoles.toList(),
          moodTags: selectedMoods.toList(),
          traits: selectedTraits.toList(),
        );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileReviewSubmit()),
    );
  }

  Widget _buildTagGroup(String label, List<String> tags, Set<String> selectedSet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: Color(0xFFB2FFD6),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tags.map((String tag) {
            final bool selected = selectedSet.contains(tag);
            return GestureDetector(
              onTap: () => _toggle(selectedSet, tag),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      selected ? const Color(0xFFCCFF33).withValues(alpha: 0.25) : Colors.white10,
                  border: Border.all(
                    color: selected ? const Color(0xFFCCFF33) : Colors.white24,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 13,
                    color: selected ? const Color(0xFFCCFF33) : Colors.white70,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(28, 60, 28, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Select Tags',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'MagdaCleanMono',
                color: Color(0xFFB2FFD6),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'These help define your presence.',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'TradeGothic',
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTagGroup('Role', roles, selectedRoles),
                    _buildTagGroup('Mood', moods, selectedMoods),
                    _buildTagGroup('Traits', traits, selectedTraits),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFF33),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
