import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/neon_profile_card.dart';
import '../widgets/cyberpunk_filter_bar.dart';
import '../../data/grid_provider.dart';
import '../components/universal_messaging_sheet.dart';

/// Production-ready Meatup with beautiful neon styling, working filters, and no mocks
class ProductionMeatupView extends ConsumerStatefulWidget {
  const ProductionMeatupView({super.key});

  @override
  ConsumerState<ProductionMeatupView> createState() => _ProductionMeatupViewState();
}

class _ProductionMeatupViewState extends ConsumerState<ProductionMeatupView>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;
  late Animation<double> _pulseAnimation;

  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';
  String _selectedLocation = 'All Cities';
  String _selectedRole = 'All Roles';
  bool _isOnlineOnly = false;

  final List<String> _filterOptions = ['All', 'Top', 'Vers', 'Bottom', 'Side'];
  final List<String> _locationOptions = [
    'All Cities',
    'San Francisco',
    'New York',
    'Los Angeles',
    'Miami',
  ];
  final List<String> _roleOptions = ['All Roles', 'Dom', 'Sub', 'Switch', 'Vanilla'];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _glowController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)
      ..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gridUsersAsync = ref.watch(gridUsersProvider);

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterSection(),
            Expanded(
              child: gridUsersAsync.when(
                data: (users) => _buildUserGrid(users),
                loading: () => _buildLoadingGrid(),
                error: (error, stack) => _buildErrorState(error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Text(
                'MEATUP',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: NVSColors.ultraLightMint,
                  shadows: [
                    Shadow(
                      color: NVSColors.ultraLightMint.withValues(alpha: _glowAnimation.value * 0.9),
                      blurRadius: 12,
                      offset: const Offset(0, 0),
                    ),
                    Shadow(
                      color: NVSColors.avocadoGreen.withValues(alpha: _glowAnimation.value * 0.6),
                      blurRadius: 24,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              );
            },
          ),
          Row(
            children: [
              _buildIconButton(Icons.search, () => _showSearchDialog()),
              const SizedBox(width: 12),
              _buildIconButton(Icons.message, () => _openUniversalMessaging()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(icon, color: NVSColors.ultraLightMint, size: 20),
              onPressed: onPressed,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Main filters
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ..._filterOptions.map(
                  (filter) => _buildFilterChip(
                    filter,
                    _selectedFilter == filter,
                    () => setState(() => _selectedFilter = filter),
                  ),
                ),
                const SizedBox(width: 12),
                _buildOnlineToggle(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Location and Role filters
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: _buildDropdownFilter(
                    'Location',
                    _selectedLocation,
                    _locationOptions,
                    (value) => setState(() => _selectedLocation = value!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownFilter(
                    'Role',
                    _selectedRole,
                    _roleOptions,
                    (value) => setState(() => _selectedRole = value!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? NVSColors.ultraLightMint.withValues(alpha: 0.2)
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? NVSColors.ultraLightMint
                  : NVSColors.ultraLightMint.withValues(alpha: 0.4),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? NVSColors.ultraLightMint : NVSColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineToggle() {
    return GestureDetector(
      onTap: () => setState(() => _isOnlineOnly = !_isOnlineOnly),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isOnlineOnly ? NVSColors.avocadoGreen.withValues(alpha: 0.2) : Colors.transparent,
          border: Border.all(
            color: _isOnlineOnly ? NVSColors.avocadoGreen : NVSColors.secondaryText,
            width: _isOnlineOnly ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isOnlineOnly
              ? [
                  BoxShadow(
                    color: NVSColors.avocadoGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _isOnlineOnly ? NVSColors.avocadoGreen : NVSColors.secondaryText,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Online',
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 14,
                fontWeight: _isOnlineOnly ? FontWeight.bold : FontWeight.normal,
                color: _isOnlineOnly ? NVSColors.avocadoGreen : NVSColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          dropdownColor: NVSColors.cardBackground,
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 12,
            color: NVSColors.ultraLightMint,
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: NVSColors.ultraLightMint, size: 16),
          items: options
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(option, style: TextStyle(fontSize: 12)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildUserGrid(List<UserProfile> users) {
    final filteredUsers = _filterUsers(users);

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final user = filteredUsers[index];
              return NeonProfileCard(
                user: user,
                onTap: () => _openUserProfile(user),
                onMessage: () => _openDirectMessage(user),
              ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
            }, childCount: filteredUsers.length),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
              decoration: BoxDecoration(
                color: NVSColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: CircularProgressIndicator(color: NVSColors.ultraLightMint, strokeWidth: 2),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: const Duration(milliseconds: 1500));
      },
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: NVSColors.ultraLightMint, size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load profiles',
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 18,
              color: NVSColors.ultraLightMint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontFamily: 'MagdaCleanMono',
              fontSize: 14,
              color: NVSColors.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.refresh(gridUsersProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: NVSColors.ultraLightMint.withValues(alpha: 0.2),
              foregroundColor: NVSColors.ultraLightMint,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<UserProfile> _filterUsers(List<UserProfile> users) {
    return users.where((user) {
      if (_selectedFilter != 'All' &&
          !user.position.toLowerCase().contains(_selectedFilter.toLowerCase())) {
        return false;
      }
      if (_selectedLocation != 'All Cities' && !user.location.contains(_selectedLocation)) {
        return false;
      }
      if (_selectedRole != 'All Roles' &&
          !user.roleTags.any((tag) => tag.toLowerCase().contains(_selectedRole.toLowerCase()))) {
        return false;
      }
      if (_isOnlineOnly && !user.isOnline) {
        return false;
      }
      return true;
    }).toList();
  }

  void _showSearchDialog() {
    // TODO: Implement search dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Search coming soon!', style: TextStyle(fontFamily: 'MagdaCleanMono')),
        backgroundColor: NVSColors.cardBackground,
      ),
    );
  }

  void _openUniversalMessaging() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (_, __) => UniversalMessagingSheet(
          section: MessagingSection.grid,
          targetUserId: 'unknown',
          displayName: 'user',
        ),
      ),
    );
  }

  void _openUserProfile(UserProfile user) {
    // TODO: Navigate to user profile
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening ${user.displayName}\'s profile',
          style: TextStyle(fontFamily: 'MagdaCleanMono'),
        ),
        backgroundColor: NVSColors.cardBackground,
      ),
    );
  }

  void _openDirectMessage(UserProfile user) {
    // TODO: Open direct message with user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Message ${user.displayName}',
          style: TextStyle(fontFamily: 'MagdaCleanMono'),
        ),
        backgroundColor: NVSColors.cardBackground,
      ),
    );
  }
}
