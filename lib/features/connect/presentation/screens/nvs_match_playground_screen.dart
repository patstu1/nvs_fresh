import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class NvsMatchPlaygroundScreen extends StatefulWidget {
  const NvsMatchPlaygroundScreen({super.key});

  @override
  State<NvsMatchPlaygroundScreen> createState() => _NvsMatchPlaygroundScreenState();
}

class _NvsMatchPlaygroundScreenState extends State<NvsMatchPlaygroundScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardAnimationController;
  late AnimationController _matchCelebrationController;
  late AnimationController _nvsCommentaryController;
  late AnimationController _glowController;

  late Animation<double> _cardSlideAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _matchCelebrationAnimation;
  late Animation<double> _glowAnimation;

  final PageController _pageController = PageController();

  List<Map<String, dynamic>> _potentialMatches = <Map<String, dynamic>>[];
  int _currentCardIndex = 0;
  bool _isShowingMatchCelebration = false;
  String _nvsCommentary = '';
  bool _showNvsCommentary = false;
  final List<String> _chosenMates = <String>[];
  final List<String> _passedProfiles = <String>[];

  @override
  void initState() {
    super.initState();

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _matchCelebrationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _nvsCommentaryController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _cardSlideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _cardScaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _matchCelebrationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _matchCelebrationController,
        curve: Curves.elasticOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _loadPotentialMatches();
  }

  void _loadPotentialMatches() {
    // Mock data - prioritize users who already liked the current user
    _potentialMatches = <Map<String, dynamic>>[
      <String, dynamic>{
        'id': '1',
        'name': 'Jordan',
        'age': 26,
        'avatar':
            'assets/images/https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=120&h=120&fit=crop&crop=face',
        'compatibilityScore': 87,
        'hasLikedYou': true,
        'zodiacSign': 'Aquarius',
        'tags': <String>['Artistic', 'Tech', 'Spiritual'],
        'distance': '2.3 km',
        'bio': 'Creative soul seeking deep connections',
        'isOnline': true,
      },
      <String, dynamic>{
        'id': '2',
        'name': 'Marcus',
        'age': 29,
        'avatar':
            'assets/images/https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=120&h=120&fit=crop&crop=face',
        'compatibilityScore': 92,
        'hasLikedYou': true,
        'zodiacSign': 'Scorpio',
        'tags': <String>['Fitness', 'Travel', 'Foodie'],
        'distance': '1.8 km',
        'bio': 'Adventure seeker with a passion for life',
        'isOnline': false,
      },
      <String, dynamic>{
        'id': '3',
        'name': 'David',
        'age': 24,
        'avatar':
            'assets/images/https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=120&h=120&fit=crop&crop=face',
        'compatibilityScore': 73,
        'hasLikedYou': false,
        'zodiacSign': 'Gemini',
        'tags': <String>['Music', 'Art', 'Coffee'],
        'distance': '5.1 km',
        'bio': 'Music producer by day, dreamer by night',
        'isOnline': true,
      },
      <String, dynamic>{
        'id': '4',
        'name': 'Ryan',
        'age': 31,
        'avatar':
            'assets/images/https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=120&h=120&fit=crop&crop=face',
        'compatibilityScore': 95,
        'hasLikedYou': true,
        'zodiacSign': 'Leo',
        'tags': <String>['Fashion', 'Design', 'Books'],
        'distance': '3.7 km',
        'bio': 'Designer with a love for beautiful things',
        'isOnline': true,
      },
    ];

    // Sort by those who liked you first, then by compatibility score
    _potentialMatches.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      if (a['hasLikedYou'] && !b['hasLikedYou']) return -1;
      if (!a['hasLikedYou'] && b['hasLikedYou']) return 1;
      return b['compatibilityScore'].compareTo(a['compatibilityScore']);
    });

    setState(() {});
  }

  void _onSwipeUp() {
    _handlePass();
  }

  void _onDoubleTap() {
    _handleLike();
  }

  void _handlePass() {
    if (_currentCardIndex >= _potentialMatches.length) return;

    final Map<String, dynamic> currentProfile = _potentialMatches[_currentCardIndex];
    _passedProfiles.add(currentProfile['id']);

    _showNvsPassCommentary();
    _animateCardExit(CardExitDirection.up);
  }

  void _handleLike() {
    if (_currentCardIndex >= _potentialMatches.length) return;

    final Map<String, dynamic> currentProfile = _potentialMatches[_currentCardIndex];
    _chosenMates.add(currentProfile['id']);

    if (currentProfile['hasLikedYou']) {
      _handleMatch(currentProfile);
    } else {
      _showNvsLikeCommentary();
      _animateCardExit(CardExitDirection.right);
    }
  }

  void _handleMatch(Map<String, dynamic> matchedProfile) {
    setState(() {
      _isShowingMatchCelebration = true;
      _nvsCommentary = '✨ Connection achieved. Welcome to your future… or your next mistake.';
    });

    _matchCelebrationController.forward();

    // Show NVS match commentary
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showNvsCommentary = true;
      });
      _nvsCommentaryController.forward();
    });

    // Hide celebration after 3 seconds and continue
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isShowingMatchCelebration = false;
        _showNvsCommentary = false;
      });
      _matchCelebrationController.reset();
      _nvsCommentaryController.reset();
      _animateCardExit(CardExitDirection.match);
    });
  }

  void _showNvsPassCommentary() {
    final List<String> comments = <String>[
      'Not feeling it? Trust your instincts.',
      'Moving on. Smart choice.',
      'Next.',
      'Your standards are showing. Good.',
    ];

    setState(() {
      _nvsCommentary = comments[math.Random().nextInt(comments.length)];
      _showNvsCommentary = true;
    });

    _nvsCommentaryController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showNvsCommentary = false;
      });
      _nvsCommentaryController.reset();
    });
  }

  void _showNvsLikeCommentary() {
    final List<String> comments = <String>[
      "Interesting choice. Let's see if they feel the same.",
      'Bold move. I respect it.',
      'Added to your vault. Fingers crossed.',
      'Now we wait and see...',
    ];

    setState(() {
      _nvsCommentary = comments[math.Random().nextInt(comments.length)];
      _showNvsCommentary = true;
    });

    _nvsCommentaryController.forward();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showNvsCommentary = false;
      });
      _nvsCommentaryController.reset();
    });
  }

  void _animateCardExit(CardExitDirection direction) {
    _cardAnimationController.forward().then((_) {
      setState(() {
        _currentCardIndex++;
      });
      _cardAnimationController.reset();

      if (_currentCardIndex >= _potentialMatches.length) {
        _showPlaygroundComplete();
      }
    });
  }

  void _showPlaygroundComplete() {
    setState(() {
      _nvsCommentary =
          "That's everyone for now. Check your Chosen Mates vault or explore more profiles.";
      _showNvsCommentary = true;
    });

    _nvsCommentaryController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/connect/chosen-mates');
    });
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _matchCelebrationController.dispose();
    _nvsCommentaryController.dispose();
    _glowController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // Background ambient effects
            _buildBackgroundEffects(),

            // Main content
            Column(
              children: <Widget>[
                // Header
                _buildHeader(),

                // Card Stack
                Expanded(
                  child: _buildCardStack(),
                ),

                // Action Buttons
                _buildActionButtons(),

                const SizedBox(height: 20),
              ],
            ),

            // Match Celebration Overlay
            if (_isShowingMatchCelebration) _buildMatchCelebration(),

            // NVS Commentary
            if (_showNvsCommentary) _buildNvsCommentary(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.5,
                colors: <Color>[
                  const Color(0xFFB0FFF7).withValues(alpha: 0.05 * _glowAnimation.value),
                  const Color(0xFF000000),
                  const Color(0xFFFF53A1).withValues(alpha: 0.03 * _glowAnimation.value),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFB0FFF7),
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'MATCH PLAYGROUND',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/connect/chosen-mates'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFF53A1).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xFFFF53A1),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress indicator
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _potentialMatches.isEmpty
                  ? 0
                  : (_currentCardIndex / _potentialMatches.length).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    if (_potentialMatches.isEmpty || _currentCardIndex >= _potentialMatches.length) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite,
              size: 80,
              color: Color(0xFF333333),
            ),
            SizedBox(height: 20),
            Text(
              'No more profiles',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for more matches',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          // Background cards (for depth effect)
          if (_currentCardIndex + 1 < _potentialMatches.length)
            Positioned(
              top: 10,
              left: 5,
              right: 5,
              bottom: 20,
              child: Transform.scale(
                scale: 0.95,
                child: _buildProfileCard(
                  _potentialMatches[_currentCardIndex + 1],
                  false,
                ),
              ),
            ),

          // Current card
          AnimatedBuilder(
            animation: _cardAnimationController,
            builder: (BuildContext context, Widget? child) {
              return Transform.translate(
                offset: Offset(
                  _cardSlideAnimation.value * MediaQuery.of(context).size.width,
                  -_cardSlideAnimation.value * 50,
                ),
                child: Transform.scale(
                  scale: _cardScaleAnimation.value,
                  child: _buildProfileCard(
                    _potentialMatches[_currentCardIndex],
                    true,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile, bool isActive) {
    return GestureDetector(
      onTap: isActive ? _onDoubleTap : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              const Color(0xFF1A1A1A).withValues(alpha: 0.9),
              const Color(0xFF0A0A0A).withValues(alpha: 0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: profile['hasLikedYou']
                ? const Color(0xFFFF53A1).withValues(alpha: 0.6)
                : const Color(0xFFB0FFF7).withValues(alpha: 0.3),
            width: profile['hasLikedYou'] ? 3 : 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: profile['hasLikedYou']
                  ? const Color(0xFFFF53A1).withValues(alpha: 0.2)
                  : const Color(0xFFB0FFF7).withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Column(
            children: <Widget>[
              // Profile image area
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Profile image
                    Image.asset(
                      profile['avatar'],
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return const ColoredBox(
                          color: Color(0xFF333333),
                          child: Icon(
                            Icons.person,
                            color: Color(0xFFB0FFF7),
                            size: 80,
                          ),
                        );
                      },
                    ),

                    // Gradient overlay
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

                    // Liked you indicator
                    if (profile['hasLikedYou'])
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF53A1),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0xFFFF53A1).withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Text(
                            'LIKED YOU',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),

                    // Online indicator
                    if (profile['isOnline'])
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB0FFF7),
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        )
                            .animate(
                              onPlay: (AnimationController controller) => controller.repeat(),
                            )
                            .scale(
                              duration: 1000.ms,
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.2, 1.2),
                            )
                            .then()
                            .scale(
                              duration: 1000.ms,
                              begin: const Offset(1.2, 1.2),
                              end: const Offset(0.8, 0.8),
                            ),
                      ),

                    // Compatibility score
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          '${profile['compatibilityScore']}% MATCH',
                          style: const TextStyle(
                            color: Colors.black,
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

              // Profile info area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Name, age, zodiac
                      Row(
                        children: <Widget>[
                          Text(
                            '${profile['name']}, ${profile['age']}',
                            style: const TextStyle(
                              color: Color(0xFFE6FFF4),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF53A1).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFF53A1).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              profile['zodiacSign'],
                              style: const TextStyle(
                                color: Color(0xFFFF53A1),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Distance
                      Text(
                        profile['distance'],
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Bio
                      Text(
                        profile['bio'],
                        style: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 16,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 12),

                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (profile['tags'] as List<String>).take(3).map((String tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Color(0xFFB0FFF7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Pass button
          GestureDetector(
            onTap: _onSwipeUp,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: <Color>[
                    const Color(0xFF666666).withValues(alpha: 0.3),
                    const Color(0xFF333333).withValues(alpha: 0.5),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF666666).withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xFF666666),
                size: 30,
              ),
            ),
          ),

          // Like button
          GestureDetector(
            onTap: _onDoubleTap,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (BuildContext context, Widget? child) {
                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFFFF53A1), Color(0xFFFF1493)],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color:
                            const Color(0xFFFF53A1).withValues(alpha: 0.4 * _glowAnimation.value),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 35,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCelebration() {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.8),
        child: Center(
          child: AnimatedBuilder(
            animation: _matchCelebrationAnimation,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _matchCelebrationAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Celebration icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFFB0FFF7), Color(0xFFFF53A1)],
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 60,
                      ),
                    )
                        .animate(onPlay: (AnimationController controller) => controller.repeat())
                        .rotate(duration: 2000.ms)
                        .scale(
                          duration: 1000.ms,
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1.2, 1.2),
                        )
                        .then()
                        .scale(
                          duration: 1000.ms,
                          begin: const Offset(1.2, 1.2),
                          end: const Offset(0.8, 0.8),
                        ),

                    const SizedBox(height: 30),

                    // Match text
                    const Text(
                      "IT'S A MATCH!",
                      style: TextStyle(
                        color: Color(0xFFB0FFF7),
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                        shadows: <Shadow>[
                          Shadow(
                            color: Color(0xFFB0FFF7),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNvsCommentary() {
    return Positioned(
      bottom: 120,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _nvsCommentaryController,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _nvsCommentaryController.value)),
            child: Opacity(
              opacity: _nvsCommentaryController.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      const Color(0xFF1A1A1A).withValues(alpha: 0.95),
                      const Color(0xFF0A0A0A).withValues(alpha: 0.98),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFFB0FFF7).withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                        ),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _nvsCommentary,
                        style: const TextStyle(
                          color: Color(0xFFE6FFF4),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum CardExitDirection { up, right, match }
