// lib/features/now/presentation/widgets/now_user_overlay_widget.dart

import 'package:flutter/material.dart';
import '../../domain/models/now_user_model.dart';

class NowUserOverlay extends StatelessWidget {
  final NowUser user;
  final VoidCallback onClose;

  const NowUserOverlay({super.key, required this.user, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.95),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: onClose,
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 42,
            backgroundColor: Colors.black,
            child: Text(
              user.username[0].toUpperCase(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB2FFD6),
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(user.username,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(user.role.toUpperCase(),
              style: const TextStyle(color: Color(0xFFB2FFD6), fontSize: 14)),
          const SizedBox(height: 8),
          Text("${user.distanceMeters.toInt()}m away",
              style: const TextStyle(color: Colors.white60, fontSize: 13)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                    label: "YO",
                    icon: Icons.waving_hand_rounded,
                    color: Color(0xFFCCFF33),
                    onTap: () => _sendYO(context, user)),
                _ActionButton(
                    label: "MESSAGE",
                    icon: Icons.chat_bubble_outline,
                    color: Color(0xFFB2FFD6),
                    onTap: () => _startMessage(context, user)),
                _ActionButton(
                    label: "PROFILE",
                    icon: Icons.person_outline,
                    color: Color(0xFFFF6699),
                    onTap: () => _openProfile(context, user)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _sendYO(BuildContext context, NowUser user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('YO sent to ${user.username}!'),
        backgroundColor: const Color(0xFFCCFF33),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startMessage(BuildContext context, NowUser user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting chat with ${user.username}...'),
        backgroundColor: const Color(0xFFB2FFD6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openProfile(BuildContext context, NowUser user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${user.username}\'s profile...'),
        backgroundColor: const Color(0xFFFF6699),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }
}
