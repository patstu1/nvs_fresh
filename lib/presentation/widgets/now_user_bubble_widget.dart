// lib/features/now/presentation/widgets/now_user_bubble_widget.dart

import 'package:flutter/material.dart';
import '../../domain/models/now_user_model.dart';

class NowUserBubble extends StatelessWidget {
  final NowUser user;

  const NowUserBubble({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: user.isOnline
              ? (user.isAnonymous ? Colors.grey : const Color(0xFFB2FFD6))
              : Colors.white10,
          width: 2,
        ),
        boxShadow: [
          if (user.isOnline && !user.isAnonymous)
            BoxShadow(
              color: const Color(0xFFB2FFD6).withValues(alpha: 0.6),
              blurRadius: 6,
              spreadRadius: 1,
            ),
        ],
      ),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.black,
        child: Text(
          user.username[0].toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: user.isOnline
                ? (user.isAnonymous ? Colors.grey : const Color(0xFFB2FFD6))
                : Colors.white24,
            fontFamily: 'MagdaCleanMono',
          ),
        ),
      ),
    );
  }
}
