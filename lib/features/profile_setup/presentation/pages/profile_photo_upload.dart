// lib/features/profile_setup/presentation/pages/profile_photo_upload.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../state/profile_setup_controller.dart';
import 'profile_interests_tags.dart';

class ProfilePhotoUpload extends ConsumerStatefulWidget {
  const ProfilePhotoUpload({super.key});

  @override
  ConsumerState<ProfilePhotoUpload> createState() => _ProfilePhotoUploadState();
}

class _ProfilePhotoUploadState extends ConsumerState<ProfilePhotoUpload> {
  final ImagePicker _picker = ImagePicker();
  File? avatarFile;
  final List<File> privateFiles = <File>[];

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => avatarFile = File(picked.path));
      ref.read(profileSetupProvider.notifier).update(
            profilePhotoUrl: picked.path,
          );
    }
  }

  Future<void> _pickPrivateMedia() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => privateFiles.add(File(picked.path)));
      ref.read(profileSetupProvider.notifier).update(
        privateAlbumUrls: <String>[...privateFiles.map((File f) => f.path)],
      );
    }
  }

  void _next() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileInterestsTags()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Photos',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 24,
                color: Color(0xFFB2FFD6),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Upload your profile photo and private album.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'TradeGothic',
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _pickAvatar,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white10,
                backgroundImage: avatarFile != null ? FileImage(avatarFile!) : null,
                child: avatarFile == null
                    ? const Icon(Icons.camera_alt_outlined, color: Colors.white38)
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Private Album',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  ...privateFiles.map(
                    (File file) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickPrivateMedia,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white10,
                      ),
                      child: const Icon(Icons.add, color: Colors.white38),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
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
}
