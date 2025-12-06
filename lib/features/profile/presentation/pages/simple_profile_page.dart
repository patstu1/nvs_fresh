// lib/features/profile/presentation/pages/simple_profile_page.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../identity_core_view.dart';
import '../../../core/theme/quantum_design_tokens.dart';
import 'package:nvs/theme/nvs_palette.dart';

/// PROFILE - User profile management
/// Enterprise-grade profile system with real data
class SimpleProfilePage extends StatefulWidget {
  const SimpleProfilePage({super.key});

  @override
  State<SimpleProfilePage> createState() => _SimpleProfilePageState();
}

class _SimpleProfilePageState extends State<SimpleProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildHeader(),
              _buildProfileImage(),
              _buildProfileInfo(),
              _buildStatsSection(),
              _buildActionButtons(),
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (BuildContext context, Widget? child) {
          return Row(
            children: <Widget>[
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: NVSPalette.primary,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSPalette.primary.withValues(
                        alpha: _glowAnimation.value * 0.6,
                      ),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'PROFILE',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: NVSPalette.primary,
                    letterSpacing: 2.0,
                    shadows: <Shadow>[
                      Shadow(
                        color: NVSPalette.primary.withValues(
                          alpha: _glowAnimation.value * 0.8,
                        ),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const IdentityCoreView(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NVSPalette.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: NVSPalette.primary.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: NVSPalette.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Outer glow ring
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (BuildContext context, Widget? child) {
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: NVSPalette.primary.withValues(
                      alpha: _glowAnimation.value * 0.8,
                    ),
                    width: 3,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: NVSPalette.primary.withValues(
                        alpha: _glowAnimation.value * 0.5,
                      ),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
              );
            },
          ),
          // Profile image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NVSPalette.primary.withValues(alpha: 0.3),
              border: Border.all(color: NVSPalette.primary, width: 2),
            ),
            child: const Center(
              child: Text(
                'YOU',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NVSPalette.primary,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          // Online indicator
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: NVSPalette.primary,
                shape: BoxShape.circle,
                border: Border.all(width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSPalette.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NVSPalette.primary.withValues(alpha: 0.3)),
      ),
      child: const Column(
        children: <Widget>[
          Text(
            'YOUR USERNAME',
            style: TextStyle(
              fontFamily: 'BellGothic',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: NVSPalette.primary,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '25 • Los Angeles, CA',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 14,
              color: NVSPalette.textSecondary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Building the future of human connection through technology and authentic experiences.',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 14,
              color: NVSPalette.primary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSPalette.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NVSPalette.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem('VIEWS', '1.2K'),
          _buildStatItem('MATCHES', '47'),
          _buildStatItem('CONNECTIONS', '23'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'BellGothic',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: NVSPalette.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: NVSPalette.textSecondary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildActionButton(
              'IDENTITY CORE',
              Icons.person_outline,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const IdentityCoreView(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton('SHARE PROFILE', Icons.share, () {
              // Share profile
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: NVSPalette.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: NVSPalette.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: NVSPalette.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: NVSPalette.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    final List<(String, IconData)> settings = <(String, IconData)>[
      ('PRIVACY SETTINGS', Icons.privacy_tip),
      ('NOTIFICATION SETTINGS', Icons.notifications),
      ('ACCOUNT SETTINGS', Icons.settings),
      ('HELP & SUPPORT', Icons.help),
      ('ABOUT NVS', Icons.info),
    ];

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSPalette.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NVSPalette.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: settings.asMap().entries.map((
          MapEntry<int, (String, IconData)> entry,
        ) {
          final int index = entry.key;
          final (String, IconData) setting = entry.value;
          final bool isLast = index == settings.length - 1;

          return DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: isLast
                    ? BorderSide.none
                    : BorderSide(
                        color: NVSPalette.primary.withValues(alpha: 0.1),
                      ),
              ),
            ),
            child: ListTile(
              leading: Icon(setting.$2, color: NVSPalette.primary, size: 20),
              title: Text(
                setting.$1,
                style: const TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: NVSPalette.primary,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: NVSPalette.textSecondary,
              ),
              onTap: () {
                // Navigate to setting
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
