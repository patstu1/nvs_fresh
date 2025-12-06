
// lib/features/profile/presentation/pages/profile_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/profile_setup_controller.dart';
import 'package:nvs/theme/nvs_palette.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileSetupProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: Color(0xFFB2FFD6),
            ),),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to edit screen
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        children: <Widget>[
          if (profile.profilePhotoUrl != null)
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profile.profilePhotoUrl!),
              ),
            ),
          const SizedBox(height: 20),
          _displayField('Name', profile.displayName),
          _displayField('Age', profile.age?.toString()),
          _displayField('Pronouns', profile.pronouns),
          _displayField('Gender', profile.gender),
          _displayField('Position', profile.position),
          _displayField('About', profile.aboutMe),
          _displayField('Role Tags', profile.roleTags.join(', ')),
          _displayField('Mood Tags', profile.moodTags.join(', ')),
          _displayField('Traits', profile.traits.join(', ')),
          if (profile.privateAlbumUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Private Album',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'MagdaCleanMono',
                          color: Color(0xFFB2FFD6),),),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: profile.privateAlbumUrls
                          .map((path) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(path,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,),
                                ),
                              ),)
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Toggle incognito state
            },
            icon: Icon(profile.isIncognito
                ? Icons.visibility_off
                : Icons.visibility,),
            label: Text(
              profile.isIncognito ? 'Go Visible' : 'Go Incognito',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCCFF33),
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label.toUpperCase(),
              style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 12,
                  color: Color(0xFFB2FFD6),),),
          const SizedBox(height: 4),
          Text(
            value?.isNotEmpty ?? false ? value! : '—',
            style: const TextStyle(
                fontFamily: 'TradeGothic',
                fontSize: 14,
                color: Colors.white70,),
          ),
        ],
      ),
    );
  }
}
