// packages/grid/lib/presentation/widgets/trade_tile.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class TradeTile extends StatelessWidget {
  final UserProfile user;

  const TradeTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        border: Border.all(
          color: user.status.isOnline
              ? NVSColors.primaryNeonMint.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (user.status.isOnline)
            BoxShadow(
              color: NVSColors.primaryNeonMint.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with status indicator
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: user.status.isOnline
                                  ? NVSColors.primaryNeonMint
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: user.avatarUrl.isNotEmpty
                                ? Image.network(
                                    user.avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildFallbackAvatar();
                                    },
                                  )
                                : _buildFallbackAvatar(),
                          ),
                        ),
                        // Online status indicator
                        if (user.status.isOnline)
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: NVSColors.primaryNeonMint,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: NVSColors.pureBlack,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: NVSColors.primaryNeonMint
                                        .withOpacity(0.5),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Name
                Expanded(
                  flex: 1,
                  child: Text(
                    user.displayName,
                    style: NvsTextStyles.body.copyWith(
                      color: user.status.isOnline ? Colors.white : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Status text
                Expanded(
                  flex: 1,
                  child: Text(
                    user.status.isOnline ? 'ACTIVE' : 'AWAY',
                    style: NvsTextStyles.label.copyWith(
                      color: user.status.isOnline
                          ? NVSColors.primaryNeonMint
                          : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Verification badge
          if (user.verification.isVerified)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: NVSColors.turquoiseNeon,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: NVSColors.turquoiseNeon.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.black, size: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1a1a1a),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
          style: NvsTextStyles.display.copyWith(
            fontSize: 24,
            color: NVSColors.primaryNeonMint,
          ),
        ),
      ),
    );
  }
}
