import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart' as core;
import 'package:nvs/features/profile_setup/domain/models/user_profile.dart' as ProfileSetup;
import 'package:nvs/features/profile_setup/state/profile_setup_controller.dart';
import '../pages/edit_profile_view.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileSetup.UserProfile profile = ref.watch(profileSetupProvider);

    return ColoredBox(
      color: core.NVSColors.pureBlack,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Centered NVS Logo + edit button to the right
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 12),
                  child: core.NvsLogo(letterSpacing: 10),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: core.NVSColors.avocadoGreen),
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const EditProfileView(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Profile card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: core.NVSColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: core.NVSColors.ultraLightMint),
                  boxShadow: core.NVSColors.mintGlow,
                ),
                child: Column(
                  children: <Widget>[
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: core.NVSColors.pureBlack,
                        shape: BoxShape.circle,
                        border: Border.all(color: core.NVSColors.avocadoGreen, width: 2),
                      ),
                      child: profile.profilePhotoUrl?.isNotEmpty ?? false
                          ? ClipOval(
                              child: Image.asset(
                                profile.profilePhotoUrl!,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            )
                          : Center(
                              child: Text(
                                profile.displayName.isNotEmpty
                                    ? profile.displayName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: core.NVSColors.avocadoGreen,
                                  fontFamily: 'BellGothic',
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      profile.displayName.isNotEmpty ? profile.displayName : 'Your Profile',
                      style: const TextStyle(
                        fontFamily: 'BellGothic',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: core.NVSColors.ultraLightMint,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...<Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: core.NVSColors.avocadoGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: core.NVSColors.avocadoGreen),
                        ),
                        child: Text(
                          'Age ${profile.age ?? '-'}',
                          style: const TextStyle(
                            fontFamily: 'BellGothic',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: core.NVSColors.avocadoGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (profile.pronouns?.isNotEmpty ?? false)
                      Text(
                        profile.pronouns!,
                        style: const TextStyle(fontSize: 14, color: core.NVSColors.secondaryText),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Profile details
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (profile.aboutMe?.isNotEmpty ?? false) ...<Widget>[
                        _buildSection('About', profile.aboutMe!),
                        const SizedBox(height: 16),
                      ],
                      if (profile.roleTags.isNotEmpty) ...<Widget>[
                        _buildTagSection('Role Tags', profile.roleTags),
                        const SizedBox(height: 16),
                      ],
                      if (profile.moodTags.isNotEmpty) ...<Widget>[
                        _buildTagSection('Mood Tags', profile.moodTags),
                        const SizedBox(height: 16),
                      ],
                      if (profile.traits.isNotEmpty) ...<Widget>[
                        _buildTagSection('Traits', profile.traits),
                        const SizedBox(height: 16),
                      ],
                      if (profile.privateAlbumUrls.isNotEmpty) ...<Widget>[
                        const Text(
                          'PRIVATE ALBUM',
                          style: TextStyle(
                            fontFamily: 'BellGothic',
                            fontSize: 14,
                            color: core.NVSColors.avocadoGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${profile.privateAlbumUrls.length} photo(s)',
                          style: const TextStyle(color: core.NVSColors.secondaryText, fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 14,
            color: core.NVSColors.avocadoGreen,
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4)),
      ],
    );
  }

  Widget _buildTagSection(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 14,
            color: core.NVSColors.avocadoGreen,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (String tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: core.NVSColors.avocadoGreen.withValues(alpha: 0.2),
                    border: Border.all(color: core.NVSColors.avocadoGreen),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: core.NVSColors.avocadoGreen, fontSize: 12),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
