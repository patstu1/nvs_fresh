import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/theme/nvs_palette.dart';
// Removed mock data import for now - will be replaced with proper data layer

/// Main Grid view for browsing user profiles
/// Features neon glow effects and cyberpunk styling
class NVSGridView extends ConsumerStatefulWidget {
  const NVSGridView({super.key});

  @override
  ConsumerState<NVSGridView> createState() => _NVSGridViewState();
}

class _NVSGridViewState extends ConsumerState<NVSGridView>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No placeholders: defer to real data wiring. Render clean neon shell if empty.
    final List<Map<String, dynamic>> users = <Map<String, dynamic>>[];

    return Scaffold(
      backgroundColor: NVSPalette.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar with NVS branding
            SliverAppBar(
              backgroundColor: NVSPalette.background,
              elevation: 0,
              floating: true,
              snap: true,
              title: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Text(
                    'Grid',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: NVSPalette.primary,
                      shadows: [
                        Shadow(
                          color: NVSPalette.primary.withValues(
                            alpha: _glowAnimation.value * 0.8,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                        Shadow(
                          color: NVSPalette.secondaryDark.withValues(
                            alpha: _glowAnimation.value * 0.4,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.tune, color: NVSPalette.primary),
                  onPressed: () {
                    // TODO: Open filter/settings
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Stats Bar
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: NVSPalette.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: NVSPalette.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: NVSPalette.primaryGlow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Online', '${users.length}'),
                    _buildStatItem('Nearby', '${(users.length * 0.7).round()}'),
                    _buildStatItem('Active', '${(users.length * 0.4).round()}'),
                  ],
                ),
              ),
            ),

            // User Grid (no placeholders, clean neon grid if empty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return _buildUserCard(users[index], index);
                }, childCount: users.length),
              ),
            ),

            // Bottom padding for navigation
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: NVSPalette.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 12,
            color: NVSPalette.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, int index) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final delayedGlow = (_glowAnimation.value + (index * 0.1)) % 1.0;

        return GestureDetector(
          onTap: () {
            // TODO: Navigate to user profile
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Viewing ${user['name']}\'s profile'),
                backgroundColor: NVSPalette.surfaceDark,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: NVSPalette.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: NVSPalette.primary.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: NVSPalette.primary.withValues(
                    alpha: delayedGlow * 0.3,
                  ),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: NVSPalette.secondaryDark.withValues(
                    alpha: delayedGlow * 0.2,
                  ),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Image
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: NVSPalette.primary.withValues(alpha: 0.1),
                    ),
                    child: user['avatar'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              user['avatar']!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholderAvatar(user['name']),
                            ),
                          )
                        : _buildPlaceholderAvatar(user['name']),
                  ),
                ),

                // User Info
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'],
                          style: const TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: NVSPalette.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user['location'] ?? 'Location unknown',
                          style: const TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 11,
                            color: NVSPalette.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderAvatar(String name) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NVSPalette.primary.withValues(alpha: 0.2),
            NVSPalette.secondaryDark.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: NVSPalette.primary,
          ),
        ),
      ),
    );
  }
}
