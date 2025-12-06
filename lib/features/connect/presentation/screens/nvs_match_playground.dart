import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class NvsMatchPlayground extends StatefulWidget {
  const NvsMatchPlayground({super.key});

  @override
  State<NvsMatchPlayground> createState() => _NvsMatchPlaygroundState();
}

class _NvsMatchPlaygroundState extends State<NvsMatchPlayground> with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _glowController;
  late AnimationController _matchController;

  late Animation<double> _cardAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _matchAnimation;

  int currentCardIndex = 0;
  bool isLiked = false;
  bool isPassed = false;
  bool showMatch = false;

  // Mock user data - replace with real API data
  final List<Map<String, dynamic>> users = <Map<String, dynamic>>[
    <String, dynamic>{
      'name': 'Alex',
      'age': 28,
      'location': 'Los Angeles',
      'bio':
          'Digital artist by day, cosmic explorer by night. Looking for someone who can keep up with my energy.',
      'avatar':
          'assets/images/https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=90&h=90&fit=crop&crop=face',
      'tags': <String>['Creative', 'Spiritual', 'Adventure'],
      'matchScore': 87,
    },
    <String, dynamic>{
      'name': 'Jordan',
      'age': 31,
      'location': 'San Francisco',
      'bio':
          'Tech entrepreneur with a passion for sustainable living. Seeking intellectual connection and shared values.',
      'avatar':
          'assets/images/https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=90&h=90&fit=crop&crop=face',
      'tags': <String>['Tech', 'Eco-conscious', 'Intellectual'],
      'matchScore': 92,
    },
    <String, dynamic>{
      'name': 'Miles',
      'age': 26,
      'location': 'New York',
      'bio': "Musician and coffee enthusiast. Let's create something beautiful together.",
      'avatar':
          'assets/images/https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=90&h=90&fit=crop&crop=face',
      'tags': <String>['Music', 'Coffee', 'Art'],
      'matchScore': 78,
    },
  ];

  @override
  void initState() {
    super.initState();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _matchController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _matchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _matchController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _glowController.dispose();
    _matchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Header
            _buildHeader(),

            // Card Stack
            _buildCardStack(),

            // Bottom Controls
            _buildBottomControls(),

            // Match Celebration Overlay
            if (showMatch) _buildMatchCelebration(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFFB0FFF7),
                size: 28,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'MATCH PLAYGROUND',
                  style: TextStyle(
                    color: Color(0xFFB0FFF7),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFB0FFF7),
                  width: 2,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'NVS',
                  style: TextStyle(
                    color: Color(0xFFB0FFF7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Current Card
          if (currentCardIndex < users.length)
            AnimatedBuilder(
              animation: _cardAnimation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(
                    isLiked ? 500 * _cardAnimation.value : -500 * _cardAnimation.value,
                    isPassed ? -300 * _cardAnimation.value : 0,
                  ),
                  child: Transform.rotate(
                    angle: isLiked
                        ? math.pi / 8 * _cardAnimation.value
                        : -math.pi / 8 * _cardAnimation.value,
                    child: _buildUserCard(users[currentCardIndex]),
                  ),
                );
              },
            ),

          // Next Card (peeking)
          if (currentCardIndex + 1 < users.length)
            Transform.scale(
              scale: 0.9,
              child: Opacity(
                opacity: 0.7,
                child: _buildUserCard(users[currentCardIndex + 1]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return GestureDetector(
      onTapDown: (_) => _handleDoubleTap(),
      onPanUpdate: _handleSwipe,
      onPanEnd: _handleSwipeEnd,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.6,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: <Widget>[
              // Background Image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      const Color(0xFFB0FFF7).withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Image.asset(
                  user['avatar'],
                  fit: BoxFit.cover,
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // User Info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Name and Age
                      Row(
                        children: <Widget>[
                          Text(
                            '${user['name']}, ${user['age']}',
                            style: const TextStyle(
                              color: Color(0xFFB0FFF7),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.location_on,
                            color: const Color(0xFFB0FFF7).withValues(alpha: 0.8),
                            size: 20,
                          ),
                          Text(
                            user['location'],
                            style: TextStyle(
                              color: const Color(0xFFB0FFF7).withValues(alpha: 0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Bio
                      Text(
                        user['bio'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 15),

                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: user['tags'].map<Widget>((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB0FFF7).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Color(0xFFB0FFF7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 15),

                      // Match Score
                      Row(
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${user['matchScore']}%',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'NVS MATCH',
                            style: TextStyle(
                              color: Color(0xFFB0FFF7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Like/Pass Indicators
              if (isLiked)
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0FFF7).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Text(
                      'LIKE',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),

              if (isPassed)
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF53A1).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFFFF53A1).withValues(alpha: 0.5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Text(
                      'PASS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Pass Button
            _buildControlButton(
              icon: Icons.close,
              color: const Color(0xFFFF53A1),
              onTap: _handlePass,
            ),

            // Like Button
            _buildControlButton(
              icon: Icons.favorite,
              color: const Color(0xFFB0FFF7),
              onTap: _handleLike,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.2),
              border: Border.all(
                color: color,
                width: 2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: color.withValues(alpha: _glowAnimation.value),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMatchCelebration() {
    return AnimatedBuilder(
      animation: _matchAnimation,
      builder: (BuildContext context, Widget? child) {
        return ColoredBox(
          color: Colors.black.withValues(alpha: 0.8 * _matchAnimation.value),
          child: Center(
            child: Transform.scale(
              scale: _matchAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.favorite,
                      color: Colors.black,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '✨ CONNECTION ACHIEVED ✨',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome to your future...\nor your next mistake.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showMatch = false;
                        });
                        _matchController.reset();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'CONTINUE',
                        style: TextStyle(
                          color: Color(0xFFB0FFF7),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Gesture Handlers
  void _handleDoubleTap() {
    // Implement double tap detection
    _handleLike();
  }

  void _handleSwipe(DragUpdateDetails details) {
    // Visual feedback during swipe
    if (details.delta.dx > 0) {
      setState(() {
        isLiked = true;
        isPassed = false;
      });
    } else if (details.delta.dx < 0) {
      setState(() {
        isPassed = true;
        isLiked = false;
      });
    }
  }

  void _handleSwipeEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx > 500) {
      _handleLike();
    } else if (details.velocity.pixelsPerSecond.dx < -500) {
      _handlePass();
    } else {
      setState(() {
        isLiked = false;
        isPassed = false;
      });
    }
  }

  void _handleLike() {
    setState(() {
      isLiked = true;
      isPassed = false;
    });

    HapticFeedback.mediumImpact();
    _cardController.forward().then((_) {
      _nextCard();
    });

    // Simulate match (50% chance)
    if (math.Random().nextBool()) {
      _showMatchCelebration();
    }
  }

  void _handlePass() {
    setState(() {
      isPassed = true;
      isLiked = false;
    });

    HapticFeedback.lightImpact();
    _cardController.forward().then((_) {
      _nextCard();
    });
  }

  void _nextCard() {
    setState(() {
      currentCardIndex++;
      isLiked = false;
      isPassed = false;
    });
    _cardController.reset();

    // Check if we've gone through all cards
    if (currentCardIndex >= users.length) {
      _showEndOfStack();
    }
  }

  void _showMatchCelebration() {
    setState(() {
      showMatch = true;
    });
    _matchController.forward();
  }

  void _showEndOfStack() {
    // TODO: Navigate to Match Vault or show end message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "You've seen all available matches! Check your Match Vault.",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFB0FFF7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
