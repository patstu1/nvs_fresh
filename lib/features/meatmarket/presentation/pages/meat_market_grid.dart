// NVS Meat Market Grid - Full Implementation
// Based on Prompts 23-33: Grid View, Filters, Quick Actions, Vision Mode
// Colors: #000000 matte black, #E4FFF0 mint ONLY - no fills, outline glows only

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeatMarketGrid extends StatefulWidget {
  const MeatMarketGrid({super.key});

  @override
  State<MeatMarketGrid> createState() => _MeatMarketGridState();
}

class _MeatMarketGridState extends State<MeatMarketGrid>
    with TickerProviderStateMixin {
  // Global NVS colors - mint and black only, no fills
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0); // Map to mint
  static const Color _aqua = Color(0xFFE4FFF0);  // Map to mint  
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _pulseController;

  String _selectedFilter = 'NEARBY';
  final List<String> _filters = ['NEARBY', 'ONLINE', 'NEW', 'FRESH', 'VISION', 'COMPATIBILITY'];
  bool _isVisionMode = false;
  int _gridColumns = 3; // Default 3 columns

  // Mock users with full profile data
  final List<_GridUser> _users = List.generate(50, (i) => _GridUser.generate(i));

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onFilterTap(String filter) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedFilter = filter;
      _isVisionMode = filter == 'VISION';
    });
  }

  List<_GridUser> get _filteredUsers {
    switch (_selectedFilter) {
      case 'ONLINE':
        return _users.where((u) => u.isOnline).toList();
      case 'NEW':
        return _users.where((u) => u.isNew).toList();
      case 'FRESH':
        return _users.where((u) => u.isFresh).toList();
      case 'VISION':
        return _users.where((u) => u.isLive).toList();
      case 'COMPATIBILITY':
        return _users.where((u) => u.compatibilityScore > 70).toList()
          ..sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
      default:
        return _users..sort((a, b) => a.distanceMiles.compareTo(b.distanceMiles));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterBar(),
            if (_isVisionMode) _buildVisionBanner(),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Text(
                'MEAT MARKET',
                style: TextStyle(
                  color: _mint,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: _mint.withOpacity(0.5 * _glowAnimation.value),
                      blurRadius: 15,
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          // Grid size toggle
          _buildHeaderIcon(
            _gridColumns == 3 ? Icons.grid_view : Icons.grid_on,
            () {
              setState(() {
                _gridColumns = _gridColumns == 3 ? 4 : 3;
              });
            },
          ),
          const SizedBox(width: 10),
          _buildHeaderIcon(Icons.tune_rounded, _showFiltersModal),
          const SizedBox(width: 10),
          _buildHeaderIcon(Icons.search_rounded, _showSearchModal),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: _mint.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: _mint, size: 20),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          final isVision = filter == 'VISION';
          final isCompatibility = filter == 'COMPATIBILITY';

          return GestureDetector(
            onTap: () => _onFilterTap(filter),
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? _aqua.withOpacity(0.15) : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? _aqua
                          : isVision || isCompatibility
                              ? _mint.withOpacity(0.5)
                              : _mint.withOpacity(0.2),
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: _aqua.withOpacity(0.3 * _glowAnimation.value),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isVision) ...[
                        Icon(
                          Icons.videocam_rounded,
                          color: isSelected ? _aqua : _mint.withOpacity(0.6),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                      ],
                      if (isCompatibility) ...[
                        Icon(
                          Icons.psychology_rounded,
                          color: isSelected ? _aqua : _mint.withOpacity(0.6),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? _aqua : _mint.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildVisionBanner() {
    final liveCount = _users.where((u) => u.isLive).length;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: _aqua.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [_aqua.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5 + 0.5 * _pulseController.value),
                      blurRadius: 8,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'VISION MODE • Live camera feeds',
              style: TextStyle(
                color: _mint.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _aqua.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _aqua.withOpacity(0.5)),
            ),
            child: Text(
              '$liveCount LIVE',
              style: const TextStyle(
                color: _aqua,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final displayUsers = _filteredUsers;
    
    if (displayUsers.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridColumns,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.72,
      ),
      itemCount: displayUsers.length,
      itemBuilder: (context, index) => _buildUserTile(displayUsers[index]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isVisionMode ? Icons.videocam_off : Icons.person_search,
            color: _olive,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            _isVisionMode ? 'No live feeds right now' : 'No users found',
            style: TextStyle(
              color: _mint,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isVisionMode 
                ? 'Check back soon for live users'
                : 'Try adjusting your filters',
            style: TextStyle(
              color: _olive,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(_GridUser user) {
    return GestureDetector(
      onTap: () => _openFullProfile(user),
      onLongPress: () => _showQuickActions(user),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          final showLive = _isVisionMode || user.isLive;
          final showCompatibility = _selectedFilter == 'COMPATIBILITY';
          
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: showLive
                    ? _aqua
                    : user.isOnline
                        ? _mint.withOpacity(0.5)
                        : _mint.withOpacity(0.15),
                width: showLive ? 2 : 1,
              ),
              boxShadow: showLive
                  ? [
                      BoxShadow(
                        color: _aqua.withOpacity(0.4 * _glowAnimation.value),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : user.isOnline
                      ? [
                          BoxShadow(
                            color: _mint.withOpacity(0.15 * _glowAnimation.value),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Avatar placeholder with gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _mint.withOpacity(0.08),
                          _olive.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      color: _mint.withOpacity(0.2),
                      size: 48,
                    ),
                  ),
                  
                  // Live indicator
                  if (showLive)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: _aqua,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: _aqua.withOpacity(0.5 * _pulseController.value),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: _black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: _black,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  
                  // Online dot (when not live)
                  if (user.isOnline && !showLive)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _aqua,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _aqua.withOpacity(0.6 * _pulseController.value),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  
                  // Verified badge
                  if (user.isVerified && !showLive)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Icon(
                        Icons.verified,
                        color: _aqua.withOpacity(0.8),
                        size: 16,
                      ),
                    ),
                  
                  // Compatibility score badge
                  if (showCompatibility)
                    Positioned(
                      bottom: 50,
                      right: 6,
                      child: _buildCompatibilityBadge(user.compatibilityScore),
                    ),
                  
                  // Bottom gradient
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, _black.withOpacity(0.95)],
                        ),
                      ),
                    ),
                  ),
                  
                  // User info
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${user.name}, ${user.age}',
                                style: const TextStyle(
                                  color: _mint,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${user.distanceMiles.toStringAsFixed(1)} mi${user.isOnline ? " • Online" : ""}',
                          style: TextStyle(
                            color: _olive,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompatibilityBadge(int score) {
    Color ringColor;
    if (score >= 90) {
      ringColor = _aqua;
    } else if (score >= 75) {
      ringColor = _mint;
    } else {
      ringColor = _olive;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _black.withOpacity(0.8),
        border: Border.all(color: ringColor, width: 2),
        boxShadow: score >= 90
            ? [BoxShadow(color: _aqua.withOpacity(0.4), blurRadius: 8)]
            : null,
      ),
      child: Center(
        child: Text(
          '$score%',
          style: TextStyle(
            color: ringColor,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  void _showQuickActions(_GridUser user) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _black,
          border: Border.all(color: _mint.withOpacity(0.3)),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _mint.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // User preview
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: user.isOnline ? _aqua : _mint.withOpacity(0.3),
                      width: user.isOnline ? 2 : 1,
                    ),
                    boxShadow: user.isOnline
                        ? [BoxShadow(color: _aqua.withOpacity(0.3), blurRadius: 12)]
                        : null,
                  ),
                  child: ClipOval(
                    child: Container(
                      color: _mint.withOpacity(0.1),
                      child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${user.name}, ${user.age}',
                            style: const TextStyle(
                              color: _mint,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.verified, color: _aqua.withOpacity(0.8), size: 18),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.distanceMiles.toStringAsFixed(1)} mi away${user.isOnline ? " • Online now" : ""}',
                        style: TextStyle(
                          color: _olive,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.height} • ${user.bodyType} • ${user.position}',
                        style: TextStyle(
                          color: _mint.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.chat_bubble_outline, 'MESSAGE', _mint, () {
                  Navigator.pop(context);
                  // TODO: Open message
                }),
                _buildActionButton(Icons.waving_hand, 'YO', _aqua, () {
                  Navigator.pop(context);
                  _sendYo(user);
                }),
                _buildActionButton(Icons.person_outline, 'PROFILE', _mint, () {
                  Navigator.pop(context);
                  _openFullProfile(user);
                }),
                if (user.isLive || _isVisionMode)
                  _buildActionButton(Icons.videocam_outlined, 'WATCH', _aqua, () {
                    Navigator.pop(context);
                    // TODO: Open video
                  }),
                _buildActionButton(Icons.bookmark_border, 'SAVE', _olive, () {
                  Navigator.pop(context);
                  // TODO: Save user
                }),
              ],
            ),
            const SizedBox(height: 20),
            // Block button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showBlockConfirmation(user);
              },
              child: Text(
                'Block ${user.name}',
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              border: Border.all(color: color.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _sendYo(_GridUser user) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('YO sent to ${user.name}!'),
        backgroundColor: _aqua,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openFullProfile(_GridUser user) {
    // TODO: Navigate to full profile view (Prompt 27)
    HapticFeedback.selectionClick();
  }

  void _showBlockConfirmation(_GridUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _mint.withOpacity(0.2)),
        ),
        title: Text(
          'Block ${user.name}?',
          style: const TextStyle(color: _mint),
        ),
        content: Text(
          'They won\'t be able to see your profile or message you.',
          style: TextStyle(color: _olive),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: _olive)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Block user
            },
            child: Text('Block', style: TextStyle(color: Colors.red.shade300)),
          ),
        ],
      ),
    );
  }

  void _showFiltersModal() {
    // TODO: Implement full filter modal (Prompt 24)
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FilterModal(),
    );
  }

  void _showSearchModal() {
    // TODO: Implement search (Prompt 25)
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SearchModal(),
    );
  }
}

// Filter Modal Widget
class _FilterModal extends StatefulWidget {
  @override
  State<_FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<_FilterModal> {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  String _selectedOnline = 'all';
  final Set<String> _selectedBodyTypes = {};
  final Set<String> _selectedLookingFor = {};
  final Set<String> _selectedPositions = {};

  final List<String> _bodyTypes = ['Slim', 'Average', 'Toned', 'Muscular', 'Stocky', 'Large'];
  final List<String> _lookingFor = ['Chat', 'Dates', 'Friends', 'Networking', 'Hookups', 'Relationship'];
  final List<String> _positions = ['Top', 'Bottom', 'Vers', 'Vers Top', 'Vers Bottom', 'Side'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: _black,
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _mint.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'FILTERS',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedOnline = 'all';
                      _selectedBodyTypes.clear();
                      _selectedLookingFor.clear();
                      _selectedPositions.clear();
                    });
                  },
                  child: Text('Reset', style: TextStyle(color: _olive)),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSectionHeader('ONLINE STATUS'),
                const SizedBox(height: 12),
                _buildOnlineChips(),
                const SizedBox(height: 24),
                
                _buildSectionHeader('BODY TYPE'),
                const SizedBox(height: 12),
                _buildChipGroup(_bodyTypes, _selectedBodyTypes),
                const SizedBox(height: 24),
                
                _buildSectionHeader('LOOKING FOR'),
                const SizedBox(height: 12),
                _buildChipGroup(_lookingFor, _selectedLookingFor),
                const SizedBox(height: 24),
                
                _buildSectionHeader('POSITION'),
                const SizedBox(height: 12),
                _buildChipGroup(_positions, _selectedPositions),
                const SizedBox(height: 100),
              ],
            ),
          ),
          
          // Apply button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _black,
              border: Border(top: BorderSide(color: _mint.withOpacity(0.1))),
            ),
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _aqua,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'SHOW RESULTS',
                    style: TextStyle(
                      color: _black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _olive,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildOnlineChips() {
    final options = [
      ('all', 'Show all'),
      ('now', 'Online now'),
      ('today', 'Online today'),
      ('week', 'This week'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = _selectedOnline == opt.$1;
        return GestureDetector(
          onTap: () => setState(() => _selectedOnline = opt.$1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _aqua : Colors.transparent,
              border: Border.all(color: isSelected ? _aqua : _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              opt.$2,
              style: TextStyle(
                color: isSelected ? _black : _mint,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChipGroup(List<String> options, Set<String> selected) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selected.remove(opt);
              } else {
                selected.add(opt);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _aqua : Colors.transparent,
              border: Border.all(color: isSelected ? _aqua : _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: isSelected ? _black : _mint,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Search Modal Widget
class _SearchModal extends StatefulWidget {
  @override
  State<_SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<_SearchModal> {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _black = Color(0xFF000000);

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: _black,
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: _mint),
                ),
                Expanded(
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: _mint.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: _olive, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: _mint),
                            decoration: InputDecoration(
                              hintText: 'Search by name...',
                              hintStyle: TextStyle(color: _olive),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            child: Icon(Icons.close, color: _mint, size: 18),
                          ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: _olive)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _searchController.text.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: _olive, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Search for someone',
                          style: TextStyle(color: _mint, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter a name to find profiles',
                          style: TextStyle(color: _olive, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: 5, // Mock results
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _mint.withOpacity(0.1),
                          child: Icon(Icons.person, color: _mint.withOpacity(0.5)),
                        ),
                        title: Text(
                          'User ${index + 1}',
                          style: const TextStyle(color: _mint, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${(index * 0.5 + 0.1).toStringAsFixed(1)} mi away',
                          style: TextStyle(color: _olive),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: _olive, size: 16),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// User model with full profile data
class _GridUser {
  final String id;
  final String name;
  final int age;
  final double distanceMiles;
  final bool isOnline;
  final bool isVerified;
  final bool isLive;
  final bool isNew;
  final bool isFresh;
  final int lastSeen;
  final String height;
  final String bodyType;
  final String position;
  final int compatibilityScore;

  _GridUser({
    required this.id,
    required this.name,
    required this.age,
    required this.distanceMiles,
    required this.isOnline,
    required this.isVerified,
    required this.isLive,
    required this.isNew,
    required this.isFresh,
    required this.lastSeen,
    required this.height,
    required this.bodyType,
    required this.position,
    required this.compatibilityScore,
  });

  static const List<String> _names = [
    'Marcus', 'Jordan', 'Alex', 'Ryan', 'Tyler', 'Chris', 'Jake', 'Matt',
    'Derek', 'Sam', 'Blake', 'Kyle', 'Ethan', 'Noah', 'Liam', 'Mason',
    'Lucas', 'Oliver', 'Aiden', 'Carter', 'Jayden', 'Luke', 'Dylan', 'Gavin',
  ];

  static const List<String> _heights = ["5'7\"", "5'8\"", "5'9\"", "5'10\"", "5'11\"", "6'0\"", "6'1\"", "6'2\""];
  static const List<String> _bodyTypes = ['Slim', 'Toned', 'Average', 'Muscular', 'Athletic', 'Stocky'];
  static const List<String> _positions = ['Top', 'Bottom', 'Vers', 'Vers Top', 'Vers Bottom', 'Side'];

  factory _GridUser.generate(int index) {
    final random = Random(index);
    return _GridUser(
      id: 'user_$index',
      name: _names[index % _names.length],
      age: 21 + random.nextInt(25),
      distanceMiles: random.nextDouble() * 15,
      isOnline: random.nextDouble() > 0.3,
      isVerified: random.nextDouble() > 0.5,
      isLive: random.nextDouble() > 0.85,
      isNew: random.nextDouble() > 0.8,
      isFresh: random.nextDouble() > 0.7,
      lastSeen: random.nextInt(120),
      height: _heights[random.nextInt(_heights.length)],
      bodyType: _bodyTypes[random.nextInt(_bodyTypes.length)],
      position: _positions[random.nextInt(_positions.length)],
      compatibilityScore: 50 + random.nextInt(50),
    );
  }
}
