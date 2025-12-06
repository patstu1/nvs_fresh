// lib/features/now/presentation/widgets/now_user_bubble.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/now_user_model.dart';
import 'package:nvs/meatup_core.dart';

class NowUserBubble extends StatefulWidget {
  final NowUser user;

  const NowUserBubble({super.key, required this.user});

  @override
  State<NowUserBubble> createState() => _NowUserBubbleState();
}

class _NowUserBubbleState extends State<NowUserBubble> {
  bool flash = false;

  @override
  void initState() {
    super.initState();
    if (widget.user.isViewingYou) {
      flash = true;
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() => flash = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = flash
        ? NVSColors.avocadoGreen
        : NVSColors.ultraLightMint.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: () => debugPrint('Tapped ${widget.user.username}'),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: glowColor,
              blurRadius: flash ? 22 : 10,
              spreadRadius: flash ? 4 : 2,
            )
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            widget.user.avatarUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
