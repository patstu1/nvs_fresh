// lib/features/profile_setup/presentation/pages/profile_info_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/profile_setup_controller.dart';
import 'profile_photo_upload.dart';

class ProfileInfoForm extends ConsumerStatefulWidget {
  const ProfileInfoForm({super.key});

  @override
  ConsumerState<ProfileInfoForm> createState() => _ProfileInfoFormState();
}

class _ProfileInfoFormState extends ConsumerState<ProfileInfoForm> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _pronounsController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  void _next() {
    final int? age = int.tryParse(_ageController.text.trim());
    final String pronouns = _pronounsController.text.trim();
    final String gender = _genderController.text.trim();
    final String about = _aboutMeController.text.trim();

    ref.read(profileSetupProvider.notifier).update(
          age: age,
          pronouns: pronouns,
          gender: gender,
          aboutMe: about,
        );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePhotoUpload()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Your Details',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'MagdaCleanMono',
                color: Color(0xFFB2FFD6),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This info helps others understand your vibe.',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'TradeGothic',
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 32),
            _buildField(_ageController, 'Age'),
            const SizedBox(height: 20),
            _buildField(_pronounsController, 'Pronouns'),
            const SizedBox(height: 20),
            _buildField(_genderController, 'Gender'),
            const SizedBox(height: 20),
            _buildField(_aboutMeController, 'About You', maxLines: 5),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _next,
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

  Widget _buildField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      cursorColor: const Color(0xFFB2FFD6),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
