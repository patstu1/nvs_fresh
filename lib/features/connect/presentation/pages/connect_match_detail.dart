// NVS Connect Match Detail (Prompt 10)
// Full profile view of a matched user with compatibility breakdown
// Includes AI insights, conversation starters, and action buttons

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectMatchDetail extends StatefulWidget {
  final String? userId;

  const ConnectMatchDetail({super.key, this.userId});

  @override
  State<ConnectMatchDetail> createState() => _ConnectMatchDetailState();
}

class _ConnectMatchDetailState extends State<ConnectMatchDetail>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  late AnimationController _pulseController;
  late PageController _photoController;
  int _currentPhotoIndex = 0;

  // Mock user data
  final String _name = 'Alex';
  final int _age = 28;
  final String _position = 'Top';
  final String _distance = '0.5 mi';
  final int _compatibility = 94;
  final String _bio = 'Adventure seeker and coffee enthusiast. Looking for genuine connections and good conversations. Let\'s grab a drink sometime.';
  final List<String> _interests = ['Travel', 'Fitness', 'Coffee', 'Photography', 'Hiking'];
  final List<String> _photos = ['1', '2', '3', '4'];
  final bool _isOnline = true;
  final String _lastActive = 'Online now';

  // Compatibility breakdown
  final Map<String, int> _compatibilityBreakdown = {
    'Interests': 95,
    'Lifestyle': 92,
    'Preferences': 96,
    'Values': 90,
    'Communication': 88,
  };

  // AI Conversation Starters
  final List<String> _conversationStarters = [
    'Ask about their recent hiking trip',
    'Share your favorite coffee spot',
    'Talk about travel bucket lists',
  ];

  @override
  void initState() {
    super.initState();
    _photoController = PageController();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _photoController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildPhotoHeader(),
              SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameSection(),
                      const SizedBox(height: 24),
                      _buildCompatibilitySection(),
                      const SizedBox(height: 24),
                      _buildAIInsightsSection(),
                      const SizedBox(height: 24),
                      _buildBioSection(),
                      const SizedBox(height: 24),
                      _buildInterestsSection(),
                      const SizedBox(height: 24),
                      _buildConversationStarters(),
                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomActionBar(),
        ],
      ),
    );
  }

  Widget _buildPhotoHeader() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: _black,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: _mint),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_vert, color: _mint),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Photo carousel
            PageView.builder(
              controller: _photoController,
              onPageChanged: (index) => setState(() => _currentPhotoIndex = index),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return Container(
                  color: _mint.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: _mint.withOpacity(0.3),
                    size: 100,
                  ),
                );
              },
            ),
            // Photo indicators
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _photos.length,
                  (index) => Container(
                    width: index == _currentPhotoIndex ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: index == _currentPhotoIndex
                          ? _aqua
                          : _mint.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
            // Gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, _black],
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$_name, $_age',
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_isOnline)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _aqua,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    _position,
                    style: TextStyle(color: _olive, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.location_on, color: _olive, size: 14),
                  Text(
                    ' $_distance',
                    style: TextStyle(color: _olive, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _lastActive,
                style: TextStyle(color: _aqua.withOpacity(0.8), fontSize: 12),
              ),
            ],
          ),
        ),
        // Large compatibility badge
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _aqua, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: _aqua.withOpacity(0.4 * _pulseController.value),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_compatibility%',
                      style: const TextStyle(
                        color: _aqua,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'match',
                      style: TextStyle(color: _olive, fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ============ COMPATIBILITY BREAKDOWN (Prompt 11) ============
  Widget _buildCompatibilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('COMPATIBILITY'),
            GestureDetector(
              onTap: _showFullBreakdown,
              child: Text(
                'See details',
                style: TextStyle(color: _aqua, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._compatibilityBreakdown.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildCompatibilityBar(entry.key, entry.value),
          );
        }),
      ],
    );
  }

  Widget _buildCompatibilityBar(String label, int value) {
    final color = value >= 90 ? _aqua : (value >= 80 ? _mint : _olive);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: _mint.withOpacity(0.8), fontSize: 13),
            ),
            Text(
              '$value%',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: _olive.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsightsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _aqua.withOpacity(0.4)),
        gradient: LinearGradient(
          colors: [_aqua.withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: _aqua, size: 18),
              const SizedBox(width: 8),
              const Text(
                'NVS INSIGHT',
                style: TextStyle(
                  color: _aqua,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$_name shares your love for adventure and values genuine connections. Their communication style aligns well with yours. High potential for meaningful conversations."',
            style: TextStyle(
              color: _mint.withOpacity(0.9),
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ABOUT'),
        const SizedBox(height: 12),
        Text(
          _bio,
          style: TextStyle(
            color: _mint.withOpacity(0.85),
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('INTERESTS'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _interests.map((interest) {
            final isShared = ['Travel', 'Coffee', 'Hiking'].contains(interest);
    return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isShared ? _aqua : _olive.withOpacity(0.4),
                ),
                color: isShared ? _aqua.withOpacity(0.15) : Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
                children: [
                  if (isShared) ...[
                    Icon(Icons.check, color: _aqua, size: 14),
                    const SizedBox(width: 6),
                  ],
          Text(
                    interest,
            style: TextStyle(
                      color: isShared ? _aqua : _mint.withOpacity(0.7),
                      fontSize: 13,
            ),
          ),
        ],
      ),
            );
          }).toList(),
        ),
      ],
    );
}

  Widget _buildConversationStarters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb_outline, color: _aqua, size: 18),
            const SizedBox(width: 8),
            _buildSectionHeader('CONVERSATION STARTERS'),
          ],
        ),
        const SizedBox(height: 12),
        ..._conversationStarters.map((starter) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              // Copy to clipboard or start chat
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _olive.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      starter,
                      style: TextStyle(
                        color: _mint.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(Icons.send, color: _aqua, size: 18),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: _black,
          border: Border(top: BorderSide(color: _mint.withOpacity(0.1))),
        ),
        child: Row(
          children: [
            // Pass button
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _olive.withOpacity(0.5)),
                ),
                child: Icon(Icons.close, color: _olive, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            // Message button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  // Open chat
                },
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      height: 50,
                decoration: BoxDecoration(
                        color: _aqua,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                    BoxShadow(
                            color: _aqua.withOpacity(0.4 * _glowController.value),
                            blurRadius: 15,
                            spreadRadius: 2,
                    ),
                  ],
                ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.chat_bubble, color: _black, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'MESSAGE',
                            style: TextStyle(
                              color: _black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
          ),
        ],
      ),
    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Like button
            GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                // Like user
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _aqua),
                  color: _aqua.withOpacity(0.15),
                ),
                child: const Icon(Icons.favorite, color: _aqua, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _olive,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
  }

  void _showFullBreakdown() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return _CompatibilityBreakdownSheet(
            compatibility: _compatibility,
            breakdown: _compatibilityBreakdown,
            scrollController: scrollController,
          );
        },
      ),
    );
  }
}

// ============ FULL COMPATIBILITY BREAKDOWN SHEET (Prompt 11) ============
class _CompatibilityBreakdownSheet extends StatelessWidget {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  final int compatibility;
  final Map<String, int> breakdown;
  final ScrollController scrollController;

  const _CompatibilityBreakdownSheet({
    required this.compatibility,
    required this.breakdown,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _black,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: _mint.withOpacity(0.1)),
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _olive.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Title
          const Text(
            'COMPATIBILITY BREAKDOWN',
            style: TextStyle(
              color: _mint,
              fontSize: 18,
              fontWeight: FontWeight.w300,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 24),
          // Overall score
          _buildOverallScore(),
          const SizedBox(height: 32),
          // Detailed breakdown
          ...breakdown.entries.map((entry) => _buildDetailedCategory(entry.key, entry.value)),
          const SizedBox(height: 24),
          // Explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _olive.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: _olive, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'HOW IS THIS CALCULATED?',
                      style: TextStyle(
                        color: _olive,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'NVS AI analyzes multiple dimensions of compatibility including shared interests, lifestyle preferences, relationship goals, communication patterns, and core values. Each category is weighted based on what matters most to successful connections.',
                  style: TextStyle(
                    color: _mint.withOpacity(0.7),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScore() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _aqua, width: 4),
              boxShadow: [
                BoxShadow(
                  color: _aqua.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$compatibility%',
                style: const TextStyle(
                  color: _aqua,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Overall Compatibility',
            style: TextStyle(color: _olive, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCategory(String category, int score) {
    final color = score >= 90 ? _aqua : (score >= 80 ? _mint : _olive);
    final descriptions = {
      'Interests': 'Shared hobbies and passions',
      'Lifestyle': 'Daily habits and life approach',
      'Preferences': 'Dating and relationship preferences',
      'Values': 'Core beliefs and priorities',
      'Communication': 'Conversation and expression style',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descriptions[category] ?? '',
                    style: TextStyle(color: _olive, fontSize: 11),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color.withOpacity(0.15),
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Text(
                  '$score%',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: _olive.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
