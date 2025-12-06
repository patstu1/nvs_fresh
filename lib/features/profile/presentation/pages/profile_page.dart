import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

/// Main Profile page for user settings and profile management
/// Uses BellGothic and MagdaCleanMono fonts [[memory:4642926]]
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Text(
                      'PROFILE',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: NVSColors.neonMint,
                        letterSpacing: 4,
                        shadows: <Shadow>[
                          Shadow(
                            color: NVSColors.neonMint.withValues(alpha: 0.8),
                            blurRadius: 20,
                          ),
                          Shadow(
                            color: NVSColors.neonMint.withValues(alpha: 0.4),
                            blurRadius: 40,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: <Widget>[
                    // Profile Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: NVSColors.cardBackground,
                        border: Border.all(
                          color: NVSColors.neonMint.withValues(alpha: 0.5),
                          width: 3,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: NVSColors.neonMint.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: NVSColors.neonMint,
                        size: 60,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // User Name
                    const Text(
                      'Your Profile',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: NVSColors.ultraLightMint,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Profile Options
                    _buildProfileOption(
                      icon: Icons.edit,
                      title: 'Edit Profile',
                      subtitle: 'Update your information',
                      onTap: () {},
                    ),

                    _buildProfileOption(
                      icon: Icons.settings,
                      title: 'Settings',
                      subtitle: 'Privacy and preferences',
                      onTap: () {},
                    ),

                    _buildProfileOption(
                      icon: Icons.auto_awesome,
                      title: 'Your Aura Signature',
                      subtitle: 'View your energy profile',
                      onTap: () {},
                    ),

                    _buildProfileOption(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get assistance',
                      onTap: () {},
                    ),

                    _buildProfileOption(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'Log out of your account',
                      onTap: () {},
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NVSColors.cardBackground.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDestructive
                    ? Colors.red.withValues(alpha: 0.3)
                    : NVSColors.neonMint.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: isDestructive
                      ? Colors.red
                      : NVSColors.neonMint,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'BellGothic',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDestructive
                              ? Colors.red
                              : NVSColors.ultraLightMint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 14,
                          color: NVSColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: NVSColors.secondaryText,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}