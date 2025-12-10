// NVS Message Hub - Central messaging interface with section tabs
// Colors: #000000 background, #E4FFF0 accent only

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'meat_market_messages.dart';
import 'tradeblock_messages.dart';
import 'lookout_messages.dart';
import 'connect_messages.dart';

class MessageHub extends StatefulWidget {
  final int initialSection;
  
  const MessageHub({super.key, this.initialSection = 0});

  @override
  State<MessageHub> createState() => _MessageHubState();
}

class _MessageHubState extends State<MessageHub> with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late int _selectedSection;
  late PageController _pageController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Mock unread counts per section
  final Map<int, int> _unreadCounts = {
    0: 5,  // Meat Market
    1: 2,  // TradeBlock
    2: 8,  // Lookout
    3: 1,  // Connect
  };

  final List<String> _sectionNames = [
    'MEAT MARKET',
    'TRADEBLOCK',
    'LOOKOUT',
    'CONNECT',
  ];

  final List<IconData> _sectionIcons = [
    Icons.grid_view_rounded,
    Icons.swap_horiz_rounded,
    Icons.remove_red_eye_outlined,
    Icons.psychology_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection;
    _pageController = PageController(initialPage: _selectedSection);
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onSectionChanged(int index) {
    if (index == _selectedSection) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedSection = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSectionTabs(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _selectedSection = index);
                },
                children: const [
                  MeatMarketMessages(),
                  TradeBlockMessages(),
                  LookoutMessages(),
                  ConnectMessages(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back, color: _mint, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Text(
                  'MESSAGES',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        color: _mint.withOpacity(0.5 * _glowAnimation.value),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildTotalUnread(),
        ],
      ),
    );
  }

  Widget _buildTotalUnread() {
    final total = _unreadCounts.values.fold(0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _mint.withOpacity(0.3 * _glowAnimation.value),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            '$total NEW',
            style: const TextStyle(
              color: _mint,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(4, (index) => _buildTab(index)),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final isSelected = _selectedSection == index;
    final unread = _unreadCounts[index] ?? 0;

    return GestureDetector(
      onTap: () => _onSectionChanged(index),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _mint.withOpacity(0.1) : Colors.transparent,
              border: Border.all(
                color: isSelected ? _mint : _mint.withOpacity(0.2),
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _mint.withOpacity(0.25 * _glowAnimation.value),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _sectionIcons[index],
                  color: isSelected ? _mint : _mint.withOpacity(0.5),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _sectionNames[index],
                  style: TextStyle(
                    color: isSelected ? _mint : _mint.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                if (unread > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _mint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$unread',
                      style: const TextStyle(
                        color: _black,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

