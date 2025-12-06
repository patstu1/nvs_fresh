// lib/features/live/presentation/widgets/live_user_bubble_widget.dart

import 'package:flutter/material.dart';

class LiveUserBubble extends StatelessWidget {
  const LiveUserBubble({
    required this.avatarUrl,
    super.key,
    this.isSpeaking = false,
    this.isOnline = true,
  });
  final String avatarUrl;
  final bool isSpeaking;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final ImageProvider imageProvider = avatarUrl.startsWith('http')
        ? NetworkImage(avatarUrl)
        : AssetImage(avatarUrl) as ImageProvider;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          if (isOnline)
            BoxShadow(
              color: isSpeaking ? const Color(0xFFCCFF33) : const Color(0xFFB2FFD6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
        ],
        border: Border.all(
          color: isSpeaking ? const Color(0xFFCCFF33) : const Color(0xFFB2FFD6),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundImage: imageProvider,
        radius: 28,
        backgroundColor: Colors.black,
      ),
    );
  }
}
