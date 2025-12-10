// NVS Connect Match List (Prompt 9)
// Full list of AI-generated matches with compatibility scores
// Includes filters, sorting, and match queue

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectMatchList extends StatefulWidget {
  const ConnectMatchList({super.key});

  @override
  State<ConnectMatchList> createState() => _ConnectMatchListState();
}

class _ConnectMatchListState extends State<ConnectMatchList>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  
  String _sortBy = 'compatibility';
  String _filterBy = 'all';
  bool _showNewOnly = false;

  // Mock matches
  final List<_MockMatch> _matches = [
    _MockMatch('Alex', 94, '0.5 mi', true, true, 'Top', 28),
    _MockMatch('Jordan', 91, '1.2 mi', true, false, 'Verse', 32),
    _MockMatch('Casey', 87, '0.8 mi', false, true, 'Bottom', 26),
    _MockMatch('Sam', 85, '2.3 mi', true, false, 'Verse Top', 30),
    _MockMatch('Riley', 82, '0.3 mi', false, false, 'Top', 29),
    _MockMatch('Morgan', 79, '1.5 mi', true, true, 'Bottom', 27),
    _MockMatch('Taylor', 76, '3.1 mi', false, false, 'Side', 34),
    _MockMatch('Drew', 74, '0.9 mi', true, false, 'Verse Bottom', 25),
    _MockMatch('Jamie', 71, '2.0 mi', false, true, 'Top', 31),
    _MockMatch('Quinn', 68, '1.8 mi', true, false, 'Bottom', 28),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFiltersBar(),
            _buildMatchStats(),
            Expanded(child: _buildMatchList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: _mint),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR MATCHES',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3,
                  ),
                ),
                Text(
                  '${_matches.length} compatible profiles found',
                  style: TextStyle(color: _olive, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showSortOptions,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.sort, color: _mint, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', _filterBy == 'all', () => setState(() => _filterBy = 'all')),
          _buildFilterChip('Online', _filterBy == 'online', () => setState(() => _filterBy = 'online')),
          _buildFilterChip('90%+', _filterBy == '90+', () => setState(() => _filterBy = '90+')),
          _buildFilterChip('New', _showNewOnly, () => setState(() => _showNewOnly = !_showNewOnly)),
          _buildFilterChip('Nearby', _filterBy == 'nearby', () => setState(() => _filterBy = 'nearby')),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? _aqua : _olive.withOpacity(0.4),
          ),
          color: isActive ? _aqua.withOpacity(0.15) : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? _aqua : _mint.withOpacity(0.7),
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMatchStats() {
    final onlineCount = _matches.where((m) => m.isOnline).length;
    final highMatchCount = _matches.where((m) => m.compatibility >= 85).length;
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _aqua.withOpacity(0.3)),
        gradient: LinearGradient(
          colors: [_aqua.withOpacity(0.08), Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('$onlineCount', 'Online Now'),
          Container(width: 1, height: 30, color: _olive.withOpacity(0.3)),
          _buildStatItem('$highMatchCount', '85%+ Match'),
          Container(width: 1, height: 30, color: _olive.withOpacity(0.3)),
          _buildStatItem('${_matches.length}', 'Total'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _aqua,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: _olive, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildMatchList() {
    var filteredMatches = _matches;
    
    if (_filterBy == 'online') {
      filteredMatches = _matches.where((m) => m.isOnline).toList();
    } else if (_filterBy == '90+') {
      filteredMatches = _matches.where((m) => m.compatibility >= 90).toList();
    } else if (_filterBy == 'nearby') {
      filteredMatches = _matches.where((m) => double.parse(m.distance.split(' ')[0]) < 1.0).toList();
    }
    
    if (_showNewOnly) {
      filteredMatches = filteredMatches.where((m) => m.isNew).toList();
    }
    
    // Sort
    if (_sortBy == 'compatibility') {
      filteredMatches.sort((a, b) => b.compatibility.compareTo(a.compatibility));
    } else if (_sortBy == 'distance') {
      filteredMatches.sort((a, b) {
        final aVal = double.parse(a.distance.split(' ')[0]);
        final bVal = double.parse(b.distance.split(' ')[0]);
        return aVal.compareTo(bVal);
      });
    } else if (_sortBy == 'recent') {
      // Already sorted by recent in mock data
    }

    if (filteredMatches.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredMatches.length,
      itemBuilder: (context, index) => _buildMatchCard(filteredMatches[index]),
    );
  }

  Widget _buildMatchCard(_MockMatch match) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // Navigate to match detail
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: match.compatibility >= 90
                ? _aqua.withOpacity(0.5)
                : _mint.withOpacity(0.15),
          ),
          gradient: match.compatibility >= 90
              ? LinearGradient(
                  colors: [_aqua.withOpacity(0.08), Colors.transparent],
                )
              : null,
        ),
        child: Row(
          children: [
            // Profile photo
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: match.compatibility >= 90 ? _aqua : _mint.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: _mint.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: _mint.withOpacity(0.4),
                        size: 30,
                      ),
                    ),
                  ),
                ),
                // Online indicator
                if (match.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _aqua,
                        border: Border.all(color: _black, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        match.name,
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (match.isNew) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _aqua,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: _black,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${match.age} · ${match.position}',
                        style: TextStyle(color: _olive, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.location_on, color: _olive, size: 12),
                      Text(
                        match.distance,
                        style: TextStyle(color: _olive, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Compatibility score
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: match.compatibility >= 90
                        ? _aqua.withOpacity(0.2)
                        : _mint.withOpacity(0.1),
                    boxShadow: match.compatibility >= 90
                        ? [
                            BoxShadow(
                              color: _aqua.withOpacity(0.3 * _glowController.value),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    '${match.compatibility}%',
                    style: TextStyle(
                      color: match.compatibility >= 90 ? _aqua : _mint,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: _olive, size: 60),
          const SizedBox(height: 16),
          const Text(
            'No matches found',
            style: TextStyle(color: _mint, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(color: _olive, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SORT BY',
              style: TextStyle(
                color: _mint,
                fontSize: 16,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            _buildSortOption('Compatibility', 'compatibility'),
            _buildSortOption('Distance', 'distance'),
            _buildSortOption('Recently Active', 'recent'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final isSelected = _sortBy == value;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _sortBy = value);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? _aqua : _olive,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? _aqua : _mint,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockMatch {
  final String name;
  final int compatibility;
  final String distance;
  final bool isOnline;
  final bool isNew;
  final String position;
  final int age;

  _MockMatch(
    this.name,
    this.compatibility,
    this.distance,
    this.isOnline,
    this.isNew,
    this.position,
    this.age,
  );
}

