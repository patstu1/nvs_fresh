// NVS Meat Market - Viewed Me (Prompt 31)
// Shows profiles that have viewed the current user with stats
// Colors: #000000 background, #E3F2DE mint, #6B7F4A olive, #20B2A6 aqua

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeatMarketViewedMe extends StatefulWidget {
  const MeatMarketViewedMe({super.key});

  @override
  State<MeatMarketViewedMe> createState() => _MeatMarketViewedMeState();
}

class _MeatMarketViewedMeState extends State<MeatMarketViewedMe> {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  String _selectedTimeFilter = 'Today';
  final List<String> _timeFilters = ['Today', 'This Week', 'All Time'];
  
  final List<_ViewedUser> _viewedUsers = List.generate(15, (i) => _ViewedUser.generate(i));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      appBar: AppBar(
        backgroundColor: _black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _mint),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'VIEWED YOU',
          style: TextStyle(
            color: _mint,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _viewedUsers.isEmpty ? _buildEmptyState() : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Time filter pills
        _buildTimeFilters(),
        // View stats card
        _buildViewStatsCard(),
        // List
        Expanded(child: _buildViewersList()),
      ],
    );
  }

  Widget _buildTimeFilters() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _timeFilters.length,
        itemBuilder: (context, index) {
          final filter = _timeFilters[index];
          final isSelected = filter == _selectedTimeFilter;
          
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedTimeFilter = filter);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? _aqua : Colors.transparent,
                border: Border.all(
                  color: isSelected ? _aqua : _mint.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? _black : _mint,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildViewStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: _mint.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '47 views this week',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.trending_up, color: _aqua, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '+12 from last week',
                      style: TextStyle(color: _aqua, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Mini trend line
          SizedBox(
            width: 80,
            height: 40,
            child: CustomPaint(
              painter: _TrendLinePainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewersList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _viewedUsers.length,
      itemBuilder: (context, index) => _buildViewerTile(_viewedUsers[index]),
    );
  }

  Widget _buildViewerTile(_ViewedUser user) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: user.isNew ? _aqua.withOpacity(0.5) : _mint.withOpacity(0.15),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Profile photo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: user.isOnline ? _aqua : _mint.withOpacity(0.3),
                width: user.isOnline ? 2 : 1,
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
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user.isOnline) ...[
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _aqua,
                        ),
                      ),
                    ],
                    if (user.isNew) ...[
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
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Viewed you ${user.viewedAgo}',
                  style: const TextStyle(color: _olive, fontSize: 12),
                ),
                if (user.viewCount > 1)
                  Row(
                    children: [
                      const Text('🔥 ', style: TextStyle(fontSize: 10)),
                      Text(
                        'Viewed ${user.viewCount} times',
                        style: TextStyle(color: _aqua, fontSize: 11),
                      ),
                    ],
                  ),
                if (user.mutualView)
                  Text(
                    'You also viewed',
                    style: TextStyle(color: _mint.withOpacity(0.6), fontSize: 11),
                  ),
              ],
            ),
          ),
          // Arrow
          Icon(Icons.arrow_forward_ios, color: _olive, size: 16),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.visibility_off, color: _mint.withOpacity(0.5), size: 64),
          const SizedBox(height: 16),
          const Text(
            'No views yet',
            style: TextStyle(
              color: _mint,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete your profile and add photos to get noticed',
            style: TextStyle(color: _olive, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _aqua,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: _black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE4FFF0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.4, size.height * 0.7);
    path.lineTo(size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ViewedUser {
  final String id;
  final String name;
  final String viewedAgo;
  final bool isOnline;
  final bool isNew;
  final int viewCount;
  final bool mutualView;

  _ViewedUser({
    required this.id,
    required this.name,
    required this.viewedAgo,
    required this.isOnline,
    required this.isNew,
    required this.viewCount,
    required this.mutualView,
  });

  static const List<String> _names = [
    'Marcus', 'Jordan', 'Alex', 'Ryan', 'Tyler', 'Chris', 'Jake', 'Matt',
    'Derek', 'Sam', 'Blake', 'Kyle', 'Ethan', 'Noah', 'Liam', 'Mason',
  ];

  factory _ViewedUser.generate(int index) {
    final random = Random(index);
    final hoursAgo = random.nextInt(48);
    return _ViewedUser(
      id: 'viewed_$index',
      name: _names[index % _names.length],
      viewedAgo: hoursAgo == 0 ? 'just now' : '${hoursAgo} hours ago',
      isOnline: random.nextDouble() > 0.5,
      isNew: index < 3,
      viewCount: random.nextDouble() > 0.7 ? random.nextInt(5) + 2 : 1,
      mutualView: random.nextDouble() > 0.6,
    );
  }
}


