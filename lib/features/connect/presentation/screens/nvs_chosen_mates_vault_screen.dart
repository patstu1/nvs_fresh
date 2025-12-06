import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NvsChosenMatesVaultScreen extends StatefulWidget {
  const NvsChosenMatesVaultScreen({super.key});

  @override
  State<NvsChosenMatesVaultScreen> createState() => _NvsChosenMatesVaultScreenState();
}

class _NvsChosenMatesVaultScreenState extends State<NvsChosenMatesVaultScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _nvsController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _nvsBreathingAnimation;

  List<Map<String, dynamic>> _chosenMates = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _liveMatches = <Map<String, dynamic>>[];
  bool _showMatches = true; // Toggle between Chosen Mates and Live Matches

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _nvsController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _nvsBreathingAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _nvsController, curve: Curves.easeInOut),
    );

    _loadChosenMates();
  }

  void _loadChosenMates() {
    // Mock data - Users you've liked
    _chosenMates = <Map<String, dynamic>>[
      <String, dynamic>{
        'id': '1',
        'name': 'Jordan',
        'age': 26,
        'avatar':
            'assets/images/https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop&crop=face',
        'compatibilityScore': 87,
        'isMatch': false,
        'hasViewedProfile': true,
        'isOnline': true,
        'lastSeen': 'Online now',
        'zodiacSign': 'Aquarius',
        'tags': <String>['Artistic', 'Tech', 'Spiritual'],
        'bio': 'Creative soul seeking deep connections',
        'likedAt': DateTime.now().subtract(const Duration(hours: 2)),
        'nvsNote': 'Strong aesthetic alignment. They appreciate depth.',
      },
      <String, dynamic>{
        'id': '2',
        'name': 'Marcus',
        'age': 29,
        'avatar':
            'assets/images/https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop&crop=face',
        'compatibilityScore': 92,
        'isMatch': true,
        'hasViewedProfile': true,
        'isOnline': false,
        'lastSeen': '2 hours ago',
        'zodiacSign': 'Scorpio',
        'tags': <String>['Fitness', 'Travel', 'Foodie'],
        'bio': 'Adventure seeker with a passion for life',
        'likedAt': DateTime.now().subtract(const Duration(days: 1)),
        'matchedAt': DateTime.now().subtract(const Duration(hours: 6)),
        'nvsNote': 'High compatibility across all metrics. Promising connection.',
        'isTyping': false,
        'unreadMessages': 3,
      },
      <String, dynamic>{
        'id': '3',
        'name': 'Ryan',
        'age': 31,
        'avatar':
            'assets/images/https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop&crop=face',
        'compatibilityScore': 95,
        'isMatch': true,
        'hasViewedProfile': false,
        'isOnline': true,
        'lastSeen': 'Online now',
        'zodiacSign': 'Leo',
        'tags': <String>['Fashion', 'Design', 'Books'],
        'bio': 'Designer with a love for beautiful things',
        'likedAt': DateTime.now().subtract(const Duration(days: 2)),
        'matchedAt': DateTime.now().subtract(const Duration(minutes: 30)),
        'nvsNote': "Exceptional match. Don't overthink this one.",
        'isTyping': true,
        'unreadMessages': 0,
      },
      <String, dynamic>{
        'id': '4',
        'name': 'David',
        'age': 24,
        'avatar':
            'assets/images/https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop&crop=face',
        'compatibilityScore': 73,
        'isMatch': false,
        'hasViewedProfile': false,
        'isOnline': false,
        'lastSeen': '1 day ago',
        'zodiacSign': 'Gemini',
        'tags': <String>['Music', 'Art', 'Coffee'],
        'bio': 'Music producer by day, dreamer by night',
        'likedAt': DateTime.now().subtract(const Duration(days: 3)),
        'nvsNote': 'Solid foundation, but timing might be everything.',
      },
    ];

    // Separate live matches for easier management
    _liveMatches =
        _chosenMates.where((Map<String, dynamic> mate) => mate['isMatch'] == true).toList();

    setState(() {});
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _nvsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Header with NVS branding
            _buildHeader(),

            // Toggle between Chosen Mates and Live Matches
            _buildToggleSection(),

            // Content
            Expanded(
              child: _showMatches ? _buildLiveMatches() : _buildChosenMates(),
            ),
          ],
        ),
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

              // NVS Logo with breathing animation
              AnimatedBuilder(
                animation: _nvsBreathingAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: _nvsBreathingAnimation.value,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFFB0FFF7).withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/connect/settings'),
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
                    Icons.settings,
                    color: Color(0xFFB0FFF7),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'CHOSEN MATES VAULT',
            style: TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              shadows: <Shadow>[
                Shadow(
                  color: Color(0xFFB0FFF7),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your curated collection of potential connections',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showMatches = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _showMatches ? const Color(0xFFB0FFF7) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: _showMatches ? Colors.black : const Color(0xFFB0FFF7),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'LIVE MATCHES (${_liveMatches.length})',
                      style: TextStyle(
                        color: _showMatches ? Colors.black : const Color(0xFFB0FFF7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showMatches = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_showMatches ? const Color(0xFFB0FFF7) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.archive,
                      color: !_showMatches ? Colors.black : const Color(0xFFB0FFF7),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ALL LIKED (${_chosenMates.length})',
                      style: TextStyle(
                        color: !_showMatches ? Colors.black : const Color(0xFFB0FFF7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMatches() {
    if (_liveMatches.isEmpty) {
      return _buildEmptyState(
        'No live matches yet',
        'Keep swiping to find your perfect connections',
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Section header
          Row(
            children: <Widget>[
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: const Icon(
                      Icons.favorite,
                      color: Color(0xFFFF53A1),
                      size: 24,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              const Text(
                'ACTIVE CONNECTIONS',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Live matches list
          Expanded(
            child: ListView.builder(
              itemCount: _liveMatches.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMatchCard(_liveMatches[index], true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChosenMates() {
    if (_chosenMates.isEmpty) {
      return _buildEmptyState(
        'Your vault is empty',
        'Start swiping to add profiles to your collection',
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Section header
          const Row(
            children: <Widget>[
              Icon(
                Icons.archive,
                color: Color(0xFFB0FFF7),
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'YOUR COLLECTION',
                style: TextStyle(
                  color: Color(0xFFB0FFF7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Chosen mates grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: _chosenMates.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildProfileCard(_chosenMates[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match, bool isLiveMatch) {
    return GestureDetector(
      onTap: () => _openMatchDetails(match),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              const Color(0xFF1A1A1A).withValues(alpha: 0.9),
              const Color(0xFF0A0A0A).withValues(alpha: 0.95),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: match['isMatch']
                ? const Color(0xFFFF53A1).withValues(alpha: 0.6)
                : const Color(0xFFB0FFF7).withValues(alpha: 0.3),
            width: match['isMatch'] ? 3 : 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: match['isMatch']
                  ? const Color(0xFFFF53A1).withValues(alpha: 0.2)
                  : const Color(0xFFB0FFF7).withValues(alpha: 0.1),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            // Avatar with status indicator
            Stack(
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFB0FFF7),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      match['avatar'],
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return const ColoredBox(
                          color: Color(0xFF333333),
                          child: Icon(
                            Icons.person,
                            color: Color(0xFFB0FFF7),
                            size: 35,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Online indicator
                if (match['isOnline'])
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB0FFF7),
                        shape: BoxShape.circle,
                        border: Border.all(width: 2),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    )
                        .animate(onPlay: (AnimationController controller) => controller.repeat())
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
              ],
            ),

            const SizedBox(width: 16),

            // Profile info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Name and compatibility
                  Row(
                    children: <Widget>[
                      Text(
                        '${match['name']}, ${match['age']}',
                        style: const TextStyle(
                          color: Color(0xFFE6FFF4),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${match['compatibilityScore']}%',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Status and last seen
                  Row(
                    children: <Widget>[
                      if (match['isTyping'])
                        const Row(
                          children: <Widget>[
                            Icon(
                              Icons.edit,
                              color: Color(0xFFFF53A1),
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'typing...',
                              style: TextStyle(
                                color: Color(0xFFFF53A1),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          match['lastSeen'],
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 12,
                          ),
                        ),
                      const Spacer(),
                      if (match['unreadMessages'] > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF53A1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${match['unreadMessages']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // NVS note
                  Text(
                    match['nvsNote'],
                    style: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Action button
            Column(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF53A1).withValues(alpha: 0.1),
                    border: Border.all(
                      color: const Color(0xFFFF53A1).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.message,
                    color: Color(0xFFFF53A1),
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    return GestureDetector(
      onTap: () => _openProfileDetails(profile),
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: profile['isMatch']
                ? const Color(0xFFFF53A1).withValues(alpha: 0.6)
                : const Color(0xFFB0FFF7).withValues(alpha: 0.3),
            width: profile['isMatch'] ? 3 : 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: profile['isMatch']
                  ? const Color(0xFFFF53A1).withValues(alpha: 0.2)
                  : const Color(0xFFB0FFF7).withValues(alpha: 0.1),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: <Widget>[
              // Profile image
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      profile['avatar'],
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return const ColoredBox(
                          color: Color(0xFF333333),
                          child: Icon(
                            Icons.person,
                            color: Color(0xFFB0FFF7),
                            size: 40,
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

                    // Match indicator
                    if (profile['isMatch'])
                      Positioned(
                        top: 10,
                        right: 10,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (BuildContext context, Widget? child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF53A1),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: const Color(0xFFFF53A1).withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    // Compatibility score
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${profile['compatibilityScore']}%',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile info
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${profile['name']}, ${profile['age']}',
                        style: const TextStyle(
                          color: Color(0xFFE6FFF4),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        profile['zodiacSign'],
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                        ),
                      ),

                      const Spacer(),

                      // Status indicator
                      Row(
                        children: <Widget>[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: profile['isOnline']
                                  ? const Color(0xFFB0FFF7)
                                  : const Color(0xFF666666),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            profile['isOnline'] ? 'Online' : profile['lastSeen'],
                            style: TextStyle(
                              color: profile['isOnline']
                                  ? const Color(0xFFB0FFF7)
                                  : const Color(0xFF666666),
                              fontSize: 10,
                            ),
                          ),
                        ],
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

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: 0.3 + (0.4 * _glowAnimation.value),
                child: const Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Color(0xFFB0FFF7),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFFB0FFF7),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/connect/playground'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFFB0FFF7), Color(0xFF00F0FF)],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Text(
                'START SWIPING',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openMatchDetails(Map<String, dynamic> match) {
    // TODO: Navigate to detailed match view with messaging
    Navigator.pushNamed(
      context,
      '/connect/match-details',
      arguments: match,
    );
  }

  void _openProfileDetails(Map<String, dynamic> profile) {
    // TODO: Navigate to full compatibility report
    Navigator.pushNamed(
      context,
      '/connect/compatibility-details',
      arguments: profile,
    );
  }
}
