// lib/features/now/presentation/pages/now_view_new.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/now_mock_users.dart';
import 'package:nvs/domain/models/now_user_model.dart';
import '../widgets/now_user_bubble.dart';
import '../widgets/now_user_overlay.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/theme/nvs_palette.dart';

class NowViewNew extends ConsumerStatefulWidget {
  const NowViewNew({super.key});

  @override
  ConsumerState<NowViewNew> createState() => _NowViewNewState();
}

class _NowViewNewState extends ConsumerState<NowViewNew> {
  NowUser? selectedUser;

  void _selectUser(NowUser user) {
    setState(() {
      selectedUser = user;
    });
  }

  void _closeOverlay() {
    setState(() {
      selectedUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = nowMockUsers;

    return Container(
      color: NVSPalette.background,
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  NVSPalette.surfaceDark.withValues(alpha: 0.3),
                  NVSPalette.background,
                  NVSPalette.background,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),

          // User bubbles
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  Text(
                    'NOW',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: NVSPalette.primary,
                      shadows: NVSPalette.NVSPalette.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Live map • ${users.length} users nearby',
                    style: TextStyle(
                      color: NVSPalette.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // User grid
                  Expanded(
                    child: Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 40,
                            ),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return GestureDetector(
                            onTap: () => _selectUser(user),
                            child: NowUserBubble(user: user),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User overlay
          if (selectedUser != null)
            NowUserOverlay(selectedUser: selectedUser, onClose: _closeOverlay),
        ],
      ),
    );
  }
}
