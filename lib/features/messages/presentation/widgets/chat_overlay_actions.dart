// lib/features/messages/presentation/widgets/chat_overlay_actions.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class ChatOverlayActions extends StatelessWidget {
  const ChatOverlayActions({
    required this.onYo,
    required this.onHeart,
    required this.onBlock,
    required this.onMedia,
    required this.onFavorite,
    super.key,
    this.isFavorite = false,
    this.isBlocked = false,
  });
  final VoidCallback onYo;
  final VoidCallback onHeart;
  final VoidCallback onBlock;
  final VoidCallback onMedia;
  final VoidCallback onFavorite;
  final bool isFavorite;
  final bool isBlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground,
        border: const Border(
          top: BorderSide(color: NVSColors.dividerColor),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.neonMint.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // YO Action
          _buildActionButton(
            icon: Icons.waving_hand,
            color: NVSColors.neonLime,
            label: 'YO',
            onPressed: onYo,
            glowColor: NVSColors.neonLime.withValues(alpha: 0.3),
          ),

          // Heart Action
          _buildActionButton(
            icon: Icons.favorite,
            color: NVSColors.electricPink,
            label: 'HEART',
            onPressed: onHeart,
            glowColor: NVSColors.electricPink.withValues(alpha: 0.3),
          ),

          // Media Action
          _buildActionButton(
            icon: Icons.camera_alt,
            color: NVSColors.neonMint,
            label: 'MEDIA',
            onPressed: onMedia,
            glowColor: NVSColors.neonMint.withValues(alpha: 0.3),
          ),

          // Favorite Toggle
          _buildActionButton(
            icon: isFavorite ? Icons.star : Icons.star_outline,
            color: isFavorite ? NVSColors.electricPink : NVSColors.secondaryText,
            label: 'FAV',
            onPressed: onFavorite,
            glowColor: isFavorite ? NVSColors.electricPink.withValues(alpha: 0.3) : null,
          ),

          // Block Action
          _buildActionButton(
            icon: isBlocked ? Icons.block : Icons.block_outlined,
            color: isBlocked ? NVSColors.electricPink : NVSColors.secondaryText,
            label: isBlocked ? 'BLOCKED' : 'BLOCK',
            onPressed: onBlock,
            glowColor: isBlocked ? NVSColors.electricPink.withValues(alpha: 0.3) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
    Color? glowColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: glowColor != null
              ? <BoxShadow>[
                  BoxShadow(
                    color: glowColor,
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
