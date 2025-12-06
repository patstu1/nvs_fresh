import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/grid_mock_users.dart';
import '../../domain/models/grid_user_model.dart';
import '../widgets/grid_user_card_widget.dart';
import '../widgets/nvs_universal_toolbar.dart';

class SimpleGridPage extends ConsumerStatefulWidget {
  const SimpleGridPage({super.key});

  @override
  ConsumerState<SimpleGridPage> createState() => _SimpleGridPageState();
}

class _SimpleGridPageState extends ConsumerState<SimpleGridPage>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;
  Set<String> favorites = {};
  int _currentToolbarIndex = 0; // Track current toolbar selection

  @override
  void initState() {
    super.initState();

    // Header animation
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOut,
    ));

    // Start header animation
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _handleProfileClick(GridUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: NVSColors.pureBlack,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: NVSColors.neonMint, width: 1),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: NVSColors.secondaryText,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: NVSColors.neonMint,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'MagdaCleanMono',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: TextStyle(
                        color: NVSColors.neonMint,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.role,
                      style: TextStyle(
                        color: NVSColors.neonLime,
                        fontSize: 16,
                        fontFamily: 'MagdaCleanMono',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: NVSColors.neonMint,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('YO sent to ${user.name}!'),
                                  backgroundColor: NVSColors.neonMint,
                                ),
                              );
                            },
                            child: const Text(
                              'YO',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MagdaCleanMono',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: NVSColors.neonLime,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Starting chat with ${user.name}...'),
                                  backgroundColor: NVSColors.neonLime,
                                ),
                              );
                            },
                            child: const Text(
                              'MESSAGE',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MagdaCleanMono',
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _handleFavoriteToggle(GridUser user) {
    setState(() {
      if (favorites.contains(user.name)) {
        favorites.remove(user.name);
      } else {
        favorites.add(user.name);
      }
    });
  }

  void _handleProfileCirclePress() {
    // TODO: Navigate to profile setup/edit
  }

  void _handleToolbarNavigation(int index) {
    setState(() {
      _currentToolbarIndex = index;
    });
    // Handle navigation based on toolbar selection
    // Removed all SnackBars for navigation
    // Add actual navigation logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    final users = gridMockUsers; // Use GridUser mock data directly

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildCustomHeader()),
            SliverToBoxAdapter(child: _buildSearchAndFilters()),
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final user = users[index];
                    return GridUserCard(
                      user: user,
                      onTap: () => _handleProfileClick(user),
                    );
                  },
                  childCount: users.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NVSUniversalToolbar(
        currentIndex: _currentToolbarIndex,
        onTabChanged: _handleToolbarNavigation,
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        border: const Border(
          bottom: BorderSide(
            color: NVSColors.aquaOutline,
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.18),
            blurRadius: 32,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Circle (upper left)
          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-20 * (1 - _headerAnimation.value), 0),
                child: Opacity(
                  opacity: _headerAnimation.value,
                  child: GestureDetector(
                    onTap: _handleProfileCirclePress,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: NVSColors.pureBlack,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: NVSColors.ultraLightMint,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: NVSColors.ultraLightMint.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                          // Minimal aqua accent
                          BoxShadow(
                            color: NVSColors.aquaOutline.withValues(alpha: 0.1),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        color: NVSColors.ultraLightMint,
                        size: 24,
                        shadows: [
                          Shadow(
                            color: NVSColors.ultraLightMint.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Spacer to center NVS
          const Spacer(),

          // Large NVS branding (center)
          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - _headerAnimation.value)),
                child: Opacity(
                  opacity: _headerAnimation.value,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Stack(
                      children: [
                        // Enhanced outline/stroke layer
                        Text(
                          'NVS',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 14,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 4.0 // Thicker outline
                              ..color = NVSColors
                                  .neonMint, // Lighter turquoise outline
                            shadows: [
                              Shadow(
                                color: NVSColors.neonMint.withValues(alpha: 0.5),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                              ),
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.7),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                        ),
                        // Ultra light mint fill layer
                        Text(
                          'NVS',
                          style: TextStyle(
                            fontFamily: 'MagdaCleanMono',
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 14,
                            foreground: Paint()
                              ..color = NVSColors
                                  .ultraLightMint, // Ultra pale mint neon
                            shadows: [
                              Shadow(
                                color:
                                    NVSColors.ultraLightMint.withValues(alpha: 0.7),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                              ),
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Spacer and filter icon
          const Spacer(),

          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(20 * (1 - _headerAnimation.value), 0),
                child: Opacity(
                  opacity: _headerAnimation.value,
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_alt_outlined,
                      color: NVSColors.ultraLightMint,
                      size: 24,
                      shadows: [
                        Shadow(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    onPressed: () {
                      _showFilterSheet(context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: NVSColors.pureBlack.withValues(alpha: 0.95),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border.all(
              color: NVSColors.neonMint.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: NVSColors.neonMint.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'FILTER GRID',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildFilterButton(Icons.local_fire_department, 'Popular'),
                  _buildFilterButton(Icons.star_outline, 'New'),
                  _buildFilterButton(Icons.location_on_outlined, 'Nearby'),
                  _buildFilterButton(Icons.favorite_border, 'Favorites'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: NVSColors.pureBlack,
        border: Border(
          bottom: BorderSide(
            color: NVSColors.aquaOutline,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search bar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: NVSColors.pureBlack,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: TextField(
              style: const TextStyle(
                color: NVSColors.ultraLightMint,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Explore cities, venues, users...',
                hintStyle: TextStyle(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.7),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFilterButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NVSColors.aquaOutline,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: NVSColors.ultraLightMint.withValues(alpha: 0.8),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: NVSColors.ultraLightMint.withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
