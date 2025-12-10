// NVS Lookout - Creators Room (Prompt 43)
// Exclusive room for verified OnlyFans creators to network
// Colors: #000000 background, #E3F2DE mint, #6B7F4A olive, #20B2A6 aqua

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutCreatorsRoom extends StatefulWidget {
  const LookoutCreatorsRoom({super.key});

  @override
  State<LookoutCreatorsRoom> createState() => _LookoutCreatorsRoomState();
}

class _LookoutCreatorsRoomState extends State<LookoutCreatorsRoom>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  
  // Mock verification status
  bool _isVerified = false;
  final int _onlineCreators = 47;
  
  final List<_CreatorUser> _creators = List.generate(47, (i) => _CreatorUser.generate(i));

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
        child: _isVerified ? _buildCreatorsRoom() : _buildVerificationPrompt(),
      ),
    );
  }

  // ============ VERIFICATION PROMPT (if not verified) ============
  Widget _buildVerificationPrompt() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Film icon
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _aqua.withOpacity(0.5), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: _aqua.withOpacity(0.2 * _glowController.value),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.movie, color: _aqua, size: 40),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Creators Only',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This room is for verified OnlyFans creators to network and collaborate.',
                    style: TextStyle(
                      color: _olive,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Link account button
                  GestureDetector(
                    onTap: _linkOnlyFansAccount,
                    child: AnimatedBuilder(
                      animation: _glowController,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: _aqua,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: _aqua.withOpacity(0.3 * _glowController.value),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'LINK ONLYFANS ACCOUNT',
                            style: TextStyle(
                              color: _black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Verification takes 24-48 hours',
                    style: TextStyle(color: _olive, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============ CREATORS ROOM (if verified) ============
  Widget _buildCreatorsRoom() {
    return Column(
      children: [
        _buildRoomHeader(),
        Expanded(child: _buildCreatorsGrid()),
        _buildChatBar(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: _mint),
          ),
          const SizedBox(width: 16),
          const Text(
            'Creators Room',
            style: TextStyle(
              color: _mint,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: _black,
        border: Border(bottom: BorderSide(color: _mint.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: _mint),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.movie, color: _aqua, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'Creators Room',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _aqua,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_onlineCreators online',
                    style: const TextStyle(color: _aqua, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.grid_view, color: _mint, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.search, color: _mint, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.75,
      ),
      itemCount: _creators.length,
      itemBuilder: (context, index) => _buildCreatorTile(_creators[index]),
    );
  }

  Widget _buildCreatorTile(_CreatorUser creator) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: creator.isOnline ? _aqua.withOpacity(0.5) : _mint.withOpacity(0.15),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: _mint.withOpacity(0.06),
                child: Icon(Icons.person, color: _mint.withOpacity(0.2), size: 28),
              ),
              // Creator badge
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _aqua,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.movie, color: _black, size: 10),
                ),
              ),
              // Online indicator
              if (creator.isOnline)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _aqua,
                    ),
                  ),
                ),
              // Name overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, _black.withOpacity(0.8)],
                    ),
                  ),
                  child: Text(
                    creator.name,
                    style: const TextStyle(color: _mint, fontSize: 9),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _black,
        border: Border(top: BorderSide(color: _mint.withOpacity(0.1))),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: _olive, size: 18),
              const SizedBox(width: 12),
              Text('Creator Chat', style: TextStyle(color: _olive, fontSize: 14)),
              const Spacer(),
              Icon(Icons.keyboard_arrow_up, color: _olive, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _linkOnlyFansAccount() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _black,
          border: Border.all(color: _mint.withOpacity(0.2)),
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
            const Icon(Icons.link, color: _aqua, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Link Your OnlyFans',
              style: TextStyle(
                color: _mint,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: const TextStyle(color: _mint),
                decoration: InputDecoration(
                  hintText: 'Your OnlyFans profile URL',
                  hintStyle: TextStyle(color: _olive),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.link, color: _olive),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We\'ll verify your account within 24-48 hours. You\'ll receive an email notification when approved.',
              style: TextStyle(color: _olive, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verification request submitted!'),
                    backgroundColor: _aqua,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: _aqua,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'SUBMIT FOR VERIFICATION',
                  style: TextStyle(
                    color: _black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CreatorUser {
  final String id;
  final String name;
  final bool isOnline;

  _CreatorUser({
    required this.id,
    required this.name,
    required this.isOnline,
  });

  static const List<String> _names = [
    'Alex', 'Jordan', 'Casey', 'Sam', 'Tyler', 'Ryan', 'Blake', 'Morgan',
    'Riley', 'Quinn', 'Avery', 'Parker', 'Drew', 'Skyler', 'Jamie', 'Taylor',
  ];

  factory _CreatorUser.generate(int index) {
    final random = Random(index);
    return _CreatorUser(
      id: 'creator_$index',
      name: _names[index % _names.length],
      isOnline: random.nextDouble() > 0.3,
    );
  }
}

