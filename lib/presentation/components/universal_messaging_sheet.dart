// packages/grid/lib/presentation/components/universal_messaging_sheet.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

/// Universal messaging sheet for grid interactions
/// This is a placeholder implementation - in production this would connect to the messaging system
class UniversalMessagingSheet extends StatelessWidget {
  final MessagingSection section;
  final String? targetUserId;
  final String? displayName;

  const UniversalMessagingSheet({
    super.key,
    required this.section,
    this.targetUserId,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.message, color: NVSColors.ultraLightMint, size: 24),
                const SizedBox(width: 12),
                Text(
                  'MESSAGES',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: NVSColors.ultraLightMint,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: NVSColors.secondaryText, size: 24),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: NVSColors.turquoiseNeon.withValues(alpha: 0.5),
                    size: 64,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Messaging Coming Soon',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 18,
                      color: NVSColors.ultraLightMint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Direct messaging will be available in the next update',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 12,
                      color: NVSColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (displayName != null)
                    Text(
                      'Would you like to connect with $displayName?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'MagdaCleanMono',
                        fontSize: 14,
                        color: NVSColors.turquoiseNeon,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Enum for messaging sections
enum MessagingSection { grid, now, connect, live }
