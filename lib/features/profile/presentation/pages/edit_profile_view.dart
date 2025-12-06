// lib/features/profile/presentation/pages/edit_profile_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nvs/features/profile_setup/domain/models/user_profile.dart' as setup;
import 'package:nvs/features/profile_setup/state/profile_setup_controller.dart';
import 'package:nvs/meatup_core.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _pronounsController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? avatarFile;

  @override
  void initState() {
    super.initState();
    final setup.UserProfile profile = ref.read(profileSetupProvider);
    _nameController.text = profile.displayName;
    _aboutController.text = profile.aboutMe ?? '';
    _pronounsController.text = profile.pronouns ?? '';
    _positionController.text = profile.position ?? '';
  }

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => avatarFile = File(picked.path));
      ref
          .read(profileSetupProvider.notifier)
          .update(profilePhotoUrl: picked.path);
    }
  }

  void _saveChanges() {
    ref.read(profileSetupProvider.notifier).update(
          displayName: _nameController.text.trim(),
          aboutMe: _aboutController.text.trim(),
          pronouns: _pronounsController.text.trim(),
          position: _positionController.text.trim(),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final setup.UserProfile profile = ref.watch(profileSetupProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Profile',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              color: NVSColors.avocadoGreen,
            ),),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check, color: NVSColors.avocadoGreen),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 60),
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: avatarFile != null
                    ? FileImage(avatarFile!)
                    : (profile.profilePhotoUrl != null
                        ? AssetImage(profile.profilePhotoUrl!)
                        : null) as ImageProvider<Object>?,
                backgroundColor: Colors.white10,
                child: avatarFile == null && profile.profilePhotoUrl == null
                    ? const Icon(Icons.camera_alt, color: Colors.white38)
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildField('Display Name', _nameController),
          const SizedBox(height: 18),
          _buildField('Pronouns', _pronounsController),
          const SizedBox(height: 18),
          _buildField('Position', _positionController),
          const SizedBox(height: 18),
          _buildField('About Me', _aboutController, maxLines: 4),
        ],
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller,
      {int maxLines = 1,}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      cursorColor: NVSColors.avocadoGreen,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30),
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
