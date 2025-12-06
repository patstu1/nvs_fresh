// lib/features/profile_setup/presentation/pages/profile_review_submit.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/features/profile_setup/domain/models/user_profile.dart';
import '../../state/profile_setup_controller.dart';
import 'package:nvs/meatup_core.dart' hide UserProfile;

class ProfileReviewSubmit extends ConsumerStatefulWidget {
  const ProfileReviewSubmit({super.key});

  @override
  ConsumerState<ProfileReviewSubmit> createState() => _ProfileReviewSubmitState();
}

class _ProfileReviewSubmitState extends ConsumerState<ProfileReviewSubmit> {
  bool _isSubmitting = false;

  Future<void> _submitProfile() async {
    setState(() => _isSubmitting = true);

    final UserProfile profile = ref.read(profileSetupProvider);

    // Simulate profile submission
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSubmitting = false);

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Profile Created!',
            style: TextStyle(color: NVSColors.avocadoGreen),
          ),
          content: const Text(
            'Welcome to NVS! Your profile has been created successfully.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/main',
                  (Route route) => false,
                );
              },
              child: const Text(
                'Get Started',
                style: TextStyle(color: NVSColors.avocadoGreen),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProfile profile = ref.watch(profileSetupProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Review Your Profile',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'MagdaCleanMono',
                color: NVSColors.avocadoGreen,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Make sure everything looks good before submitting.',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'TradeGothic',
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildReviewSection('Display Name', profile.displayName),
                    if (profile.age != null) _buildReviewSection('Age', profile.age.toString()),
                    if (profile.pronouns?.isNotEmpty == true)
                      _buildReviewSection('Pronouns', profile.pronouns!),
                    if (profile.gender?.isNotEmpty == true)
                      _buildReviewSection('Gender', profile.gender!),
                    if (profile.aboutMe?.isNotEmpty == true)
                      _buildReviewSection('About', profile.aboutMe!),
                    const SizedBox(height: 20),
                    if (profile.roleTags.isNotEmpty) ...<Widget>[
                      const Text(
                        'ROLE TAGS',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.avocadoGreen,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.roleTags.map(_buildTag).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (profile.moodTags.isNotEmpty) ...<Widget>[
                      const Text(
                        'MOOD TAGS',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.avocadoGreen,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.moodTags.map(_buildTag).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (profile.traits.isNotEmpty) ...<Widget>[
                      const Text(
                        'TRAITS',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.avocadoGreen,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: profile.traits.map(_buildTag).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (profile.profilePhotoUrl?.isNotEmpty == true) ...<Widget>[
                      const Text(
                        'PROFILE PHOTO',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.avocadoGreen,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '✓ Photo uploaded',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (profile.privateAlbumUrls.isNotEmpty) ...<Widget>[
                      const Text(
                        'PRIVATE ALBUM',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.avocadoGreen,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${profile.privateAlbumUrls.length} photo(s) uploaded',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: NVSColors.avocadoGreen,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Create Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: NVSColors.neonGreen,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: NVSColors.neonGreen.withValues(alpha: 0.2),
        border: Border.all(color: NVSColors.neonGreen),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: NVSColors.neonGreen,
          fontSize: 12,
        ),
      ),
    );
  }
}
