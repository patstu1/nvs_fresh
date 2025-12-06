
// lib/features/profile/presentation/pages/profile_review_submit.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/features/profile_setup/state/profile_setup_controller.dart';

class ProfileReviewSubmit extends ConsumerWidget {
  const ProfileReviewSubmit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileSetupProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Preview',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: Color(0xFFB2FFD6),
              fontSize: 18,
            ),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 12),
            if (profile.profilePhotoUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(profile.profilePhotoUrl!),
                ),
              ),
            const SizedBox(height: 20),
            _field('Name', profile.displayName),
            _field('Age', profile.age?.toString() ?? '-'),
            _field('Pronouns', profile.pronouns),
            _field('Gender', profile.gender),
            _field('Position', profile.position),
            _field('About Me', profile.aboutMe),
            _field('Tags (Role)', profile.roleTags.join(', ')),
            _field('Tags (Mood)', profile.moodTags.join(', ')),
            _field('Traits', profile.traits.join(', ')),
            _field('Instagram', profile.instagram),
            _field('Private Album', '${profile.privateAlbumUrls.length} image(s)'),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCCFF33),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                // TODO: Save to Firebase or backend
                Navigator.popUntil(context, (Route route) => route.isFirst);
              },
              child: const Text('Save and Finish'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label.toUpperCase(),
            style: const TextStyle(
                color: Color(0xFFB2FFD6),
                fontFamily: 'MagdaCleanMono',
                fontSize: 13,),),
        const SizedBox(height: 4),
        Text(value?.isNotEmpty ?? false ? value! : '—',
            style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'TradeGothic',
                fontSize: 14,),),
        const SizedBox(height: 16),
      ],
    );
  }
}
