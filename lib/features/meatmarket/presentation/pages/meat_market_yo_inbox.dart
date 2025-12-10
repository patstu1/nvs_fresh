// NVS Meat Market - YO Inbox (Prompt 33)
// Shows all YOs received and sent with mutual matching
// Colors: #000000 background, #E3F2DE mint, #6B7F4A olive, #20B2A6 aqua

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeatMarketYoInbox extends StatefulWidget {
  const MeatMarketYoInbox({super.key});

  @override
  State<MeatMarketYoInbox> createState() => _MeatMarketYoInboxState();
}

class _MeatMarketYoInboxState extends State<MeatMarketYoInbox>
    with SingleTickerProviderStateMixin {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  late TabController _tabController;
  
  // Mock data
  final List<_YoUser> _receivedYos = List.generate(8, (i) => _YoUser.generate(i, received: true));
  final List<_YoUser> _sentYos = List.generate(5, (i) => _YoUser.generate(i + 10, received: false));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_YoUser> get _mutualYos => _receivedYos.where((u) => u.isMutual).toList();
  List<_YoUser> get _pendingReceivedYos => _receivedYos.where((u) => !u.isMutual).toList();

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
          'YOs',
          style: TextStyle(
            color: _mint,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _aqua,
          labelColor: _aqua,
          unselectedLabelColor: _olive,
          tabs: const [
            Tab(text: 'RECEIVED'),
            Tab(text: 'SENT'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReceivedTab(),
          _buildSentTab(),
        ],
      ),
    );
  }

  Widget _buildReceivedTab() {
    if (_receivedYos.isEmpty) {
      return _buildEmptyState(
        icon: Icons.waving_hand,
        title: 'No YOs yet',
        subtitle: 'When someone\'s interested, they\'ll YO you',
        buttonText: 'Browse Meat Market',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Mutual YOs section (top)
        if (_mutualYos.isNotEmpty) ...[
          Row(
            children: [
              Text(
                'MUTUAL YOs 🔥',
                style: TextStyle(
                  color: _aqua,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                '${_mutualYos.length}',
                style: TextStyle(color: _aqua, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._mutualYos.map((user) => _buildYoCard(user, showYoBack: false, isMutual: true)),
          const SizedBox(height: 24),
        ],
        
        // Pending received YOs
        if (_pendingReceivedYos.isNotEmpty) ...[
          Text(
            'RECEIVED',
            style: TextStyle(
              color: _olive,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          ..._pendingReceivedYos.map((user) => _buildYoCard(user, showYoBack: true)),
        ],
      ],
    );
  }

  Widget _buildSentTab() {
    if (_sentYos.isEmpty) {
      return _buildEmptyState(
        icon: Icons.waving_hand,
        title: 'You haven\'t YO\'d anyone',
        subtitle: 'YO someone to show you\'re interested',
        buttonText: 'Browse Meat Market',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: _sentYos.map((user) => _buildSentYoCard(user)).toList(),
    );
  }

  Widget _buildYoCard(_YoUser user, {bool showYoBack = false, bool isMutual = false}) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isMutual ? _aqua.withOpacity(0.5) : (user.isNew ? _aqua : _mint.withOpacity(0.15)),
          width: isMutual ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isMutual
            ? [BoxShadow(color: _aqua.withOpacity(0.2), blurRadius: 8)]
            : null,
      ),
      child: Row(
        children: [
          // Profile photo with border
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: user.isNew ? _aqua : _mint.withOpacity(0.3),
                width: user.isNew ? 2 : 1,
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
          // Name and time
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
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isMutual ? 'You both YO\'d! Tap to message' : 'YO\'d you ${user.timeAgo}',
                  style: TextStyle(
                    color: isMutual ? _aqua : _olive,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          if (showYoBack && !user.yoedBack) ...[
            GestureDetector(
              onTap: () => _yoBack(user),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _aqua,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'YO Back',
                  style: TextStyle(
                    color: _black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (user.yoedBack || isMutual)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isMutual ? _aqua : _olive.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isMutual ? 'Mutual YO!' : 'YO\'d Back',
                style: TextStyle(
                  color: isMutual ? _black : _mint,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Message',
                style: TextStyle(color: _mint, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentYoCard(_YoUser user) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: _mint.withOpacity(0.15)),
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
              border: Border.all(color: _mint.withOpacity(0.3)),
            ),
            child: ClipOval(
              child: Container(
                color: _mint.withOpacity(0.1),
                child: Icon(Icons.person, color: _mint.withOpacity(0.4), size: 30),
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
                Text(
                  user.name,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You YO\'d ${user.timeAgo}',
                  style: const TextStyle(color: _olive, fontSize: 12),
                ),
              ],
            ),
          ),
          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: user.yoedBack ? _aqua : _olive.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.yoedBack ? 'YO\'d Back!' : user.seen ? 'Seen' : 'Not seen',
              style: TextStyle(
                color: user.yoedBack ? _black : _olive,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _mint.withOpacity(0.5), size: 64),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: _mint,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: _olive, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _aqua,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
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

  void _yoBack(_YoUser user) {
    HapticFeedback.heavyImpact();
    setState(() {
      user.yoedBack = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('YO sent to ${user.name}!'),
        backgroundColor: _aqua,
      ),
    );
  }
}

class _YoUser {
  final String id;
  final String name;
  final String timeAgo;
  final bool isOnline;
  final bool isNew;
  final bool isMutual;
  final bool seen;
  bool yoedBack;

  _YoUser({
    required this.id,
    required this.name,
    required this.timeAgo,
    required this.isOnline,
    required this.isNew,
    required this.isMutual,
    required this.seen,
    required this.yoedBack,
  });

  static const List<String> _names = [
    'Alex', 'Jordan', 'Casey', 'Sam', 'Tyler', 'Ryan', 'Blake', 'Morgan',
    'Riley', 'Quinn', 'Avery', 'Parker', 'Drew', 'Skyler', 'Jamie', 'Taylor',
  ];

  factory _YoUser.generate(int index, {required bool received}) {
    final random = Random(index);
    return _YoUser(
      id: 'yo_user_$index',
      name: _names[index % _names.length],
      timeAgo: '${random.nextInt(12) + 1} hours ago',
      isOnline: random.nextDouble() > 0.5,
      isNew: received && random.nextDouble() > 0.6,
      isMutual: received && random.nextDouble() > 0.7,
      seen: !received && random.nextDouble() > 0.3,
      yoedBack: received ? random.nextDouble() > 0.6 : random.nextDouble() > 0.7,
    );
  }
}

