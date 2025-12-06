// lib/features/messages/presentation/widgets/chat_media_picker.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/nvs_colors.dart';

class ChatMediaPicker extends StatelessWidget {
  const ChatMediaPicker({
    required this.onMediaSelected, super.key,
  });
  final void Function(String path, bool isPrivate) onMediaSelected;

  Future<void> _pick(BuildContext context, bool private) async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onMediaSelected(picked.path, private);
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickVideo(BuildContext context, bool private) async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      onMediaSelected(picked.path, private);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: NVSColors.pureBlack.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: NVSColors.secondaryText,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            const Text(
              'Select Media',
              style: TextStyle(
                color: NVSColors.neonMint,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'MagdaCleanMono',
              ),
            ),

            const SizedBox(height: 30),

            // Media options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  // Public Photo
                  _buildMediaOption(
                    context: context,
                    icon: Icons.photo_library,
                    label: 'Public Photo',
                    color: NVSColors.neonMint,
                    onTap: () => _pick(context, false),
                  ),

                  const SizedBox(height: 16),

                  // Private Photo
                  _buildMediaOption(
                    context: context,
                    icon: Icons.lock_outline,
                    label: 'Private Photo',
                    color: NVSColors.electricPink,
                    onTap: () => _pick(context, true),
                  ),

                  const SizedBox(height: 16),

                  // Public Video
                  _buildMediaOption(
                    context: context,
                    icon: Icons.videocam,
                    label: 'Public Video',
                    color: NVSColors.neonLime,
                    onTap: () => _pickVideo(context, false),
                  ),

                  const SizedBox(height: 16),

                  // Private Video
                  _buildMediaOption(
                    context: context,
                    icon: Icons.video_camera_back,
                    label: 'Private Video',
                    color: NVSColors.electricPink,
                    onTap: () => _pickVideo(context, true),
                  ),

                  const SizedBox(height: 30),

                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: NVSColors.secondaryText,
                          fontSize: 16,
                          fontFamily: 'MagdaCleanMono',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.black),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'MagdaCleanMono',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
      ),
    );
  }
}
