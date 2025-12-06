// lib/features/now/presentation/widgets/now_user_overlay.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../domain/models/now_user_model.dart';

class NowUserOverlay extends StatelessWidget {
  final NowUser? selectedUser;
  final VoidCallback? onClose;

  const NowUserOverlay({
    super.key,
    this.selectedUser,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: NVSColors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: NVSColors.mintGlow,
        ),
        child: selectedUser != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedUser!.isAnonymous
                            ? "Anonymous User"
                            : selectedUser!.username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: NVSColors.ultraLightMint,
                          fontFamily: 'MagdaCleanMono',
                        ),
                      ),
                      if (onClose != null)
                        IconButton(
                          icon:
                              Icon(Icons.close, color: NVSColors.secondaryText),
                          onPressed: onClose,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (selectedUser!.tags.isNotEmpty)
                    Text(
                      selectedUser!.tags.join(" • "),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildActionButton(
                          "YO", Icons.waving_hand, NVSColors.avocadoGreen),
                      const SizedBox(width: 12),
                      _buildActionButton("MESSAGE", Icons.chat_bubble_outline,
                          NVSColors.turquoiseNeon),
                      const SizedBox(width: 12),
                      _buildActionButton("PROFILE", Icons.person_outline,
                          NVSColors.electricPink),
                    ],
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'MagdaCleanMono',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
