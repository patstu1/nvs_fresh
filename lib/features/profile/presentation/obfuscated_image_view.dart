// lib/features/profile/presentation/obfuscated_image_view.dart

import 'package:flutter/material.dart';

class ObfuscatedImageView extends StatelessWidget {
  const ObfuscatedImageView({
    required this.imageUrl, required this.isRevealedInitially, super.key,
  });
  final String imageUrl;
  final bool isRevealedInitially;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[800],
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.person, color: Colors.grey),
                );
              },
            )
          : const Icon(Icons.person, color: Colors.grey),
    );
  }
}
