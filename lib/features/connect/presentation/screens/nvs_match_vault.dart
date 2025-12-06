import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NvsMatchVault extends StatefulWidget {
  const NvsMatchVault({super.key});

  @override
  State<NvsMatchVault> createState() => _NvsMatchVaultState();
}

class _NvsMatchVaultState extends State<NvsMatchVault> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  String selectedFilter = 'All';
  final List<String> filters = <String>['All', 'Live Matches', 'Pending', 'Recent'];

  // Mock data - replace with real API data
  final List<Map<String, dynamic>> chosenMates = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': '1',
      'name': 'Alex',
      'age': 28,
      'location': 'Los Angeles',
      'avatar':
          'assets/images/https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=75&h=75&fit=crop&crop=face',
      'matchScore': 87,
      'status': 'live_match', // live_match, pending, recent
      'isOnline': true,
      'isTyping': false,
      'lastMessage': 'Hey! Loved your profile. Want to grab coffee?',
      'lastMessageTime': '2 min ago',
      'tags': <String>['Creative', 'Spiritual', 'Adventure'],
      'compatibility': <String, int>{
        'emotional': 85,
        'sexual': 92,
        'long_term': 78,
        'communication': 88,
      },
      'nvsNote': "This one has potential. Don't let them slip away.",
    },
    <String, dynamic>{
      'id': '2',
      'name': 'Jordan',
      'age': 31,
      'location': 'San Francisco',
      'avatar':
          'assets/images/https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=75&h=75&fit=crop&crop=face',
      'matchScore': 92,
      'status': 'live_match',
      'isOnline': false,
      'isTyping': false,
      'lastMessage': 'Thanks for the like! Your aesthetic is 🔥',
      'lastMessageTime': '1 hour ago',
      'tags': <String>['Tech', 'Eco-conscious', 'Intellectual'],
      'compatibility': <String, int>{
        'emotional': 88,
        'sexual': 95,
        'long_term': 85,
        'communication': 90,
      },
      'nvsNote': 'High compatibility alert! This could be the one.',
    },
    <String, dynamic>{
      'id': '3',
      'name': 'Miles',
      'age': 26,
      'location': 'New York',
      'avatar':
          'assets/images/https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=75&h=75&fit=crop&crop=face',
      'matchScore': 78,
      'status': 'pending',
      'isOnline': true,
      'isTyping': true,
      'lastMessage': null,
      'lastMessageTime': null,
      'tags': <String>['Music', 'Coffee', 'Art'],
      'compatibility': <String, int>{
        'emotional': 75,
        'sexual': 82,
        'long_term': 70,
        'communication': 85,
      },
      'nvsNote': 'Good vibes, but might need more time to develop.',
    },
  ];

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredMates = _getFilteredMates();

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Header
            _buildHeader(),

            // Filter Bar
            _buildFilterBar(),

            // Stats
            _buildStats(),

            // Match List
            Expanded(
              child: _buildMatchList(filteredMates),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              child: Column(
                children: <Widget>[
                  Text(
                    'CHOSEN MATES',
                    style: TextStyle(
                      color: Color(0xFFB0FFF7),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Your curated collection',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
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
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (BuildContext context, int index) {
          final String filter = filters[index];
          final bool isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
              HapticFeedback.lightImpact();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB0FFF7).withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFB0FFF7)
                      : const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                ),
                boxShadow: isSelected
                    ? <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFB0FFF7)
                      : const Color(0xFFB0FFF7).withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  letterSpacing: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStats() {
    final int liveMatches =
        chosenMates.where((Map<String, dynamic> mate) => mate['status'] == 'live_match').length;
    final int pending =
        chosenMates.where((Map<String, dynamic> mate) => mate['status'] == 'pending').length;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildStatItem(
              'Live Matches',
              liveMatches.toString(),
              const Color(0xFFB0FFF7),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Pending',
              pending.toString(),
              const Color(0xFFFF53A1),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
          ),
          Expanded(
            child: _buildStatItem(
              'Total',
              chosenMates.length.toString(),
              const Color(0xFF00F0FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchList(List<Map<String, dynamic>> mates) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: mates.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildMatchCard(mates[index]);
      },
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> mate) {
    final bool isLiveMatch = mate['status'] == 'live_match';
    final isOnline = mate['isOnline'] ?? false;
    final isTyping = mate['isTyping'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(
          color: isLiveMatch
              ? const Color(0xFFB0FFF7).withValues(alpha: 0.5)
              : const Color(0xFFB0FFF7).withValues(alpha: 0.3),
          width: isLiveMatch ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.black,
            const Color(0xFFB0FFF7).withValues(alpha: 0.05),
          ],
        ),
        boxShadow: isLiveMatch
            ? <BoxShadow>[
                BoxShadow(
                  color: const Color(0xFFB0FFF7).withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showMatchDetails(mate),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                // Avatar with status
                Stack(
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(mate['avatar']),
                      ),
                    ),

                    // Online indicator
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF00FF00),
                            border: Border.all(
                              width: 2,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: const Color(0xFF00FF00).withValues(alpha: 0.5),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Typing indicator
                    if (isTyping)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (BuildContext context, Widget? child) {
                            return Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    const Color(0xFFB0FFF7).withValues(alpha: _glowAnimation.value),
                                border: Border.all(
                                  color: const Color(0xFFB0FFF7),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '...',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 15),

                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '${mate['name']}, ${mate['age']}',
                            style: const TextStyle(
                              color: Color(0xFFB0FFF7),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.location_on,
                            color: const Color(0xFFB0FFF7).withValues(alpha: 0.7),
                            size: 16,
                          ),
                          Text(
                            mate['location'],
                            style: TextStyle(
                              color: const Color(0xFFB0FFF7).withValues(alpha: 0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Match score
                      Row(
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
                            child: Center(
                              child: Text(
                                '${mate['matchScore']}%',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isLiveMatch ? 'LIVE MATCH' : 'PENDING',
                            style: TextStyle(
                              color:
                                  isLiveMatch ? const Color(0xFFB0FFF7) : const Color(0xFFFF53A1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Last message or status
                      if (mate['lastMessage'] != null) ...<Widget>[
                        Text(
                          mate['lastMessage'],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          mate['lastMessageTime'],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ] else ...<Widget>[
                        Text(
                          isTyping ? 'Typing...' : 'No messages yet',
                          style: TextStyle(
                            color: isTyping
                                ? const Color(0xFFB0FFF7)
                                : Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Action buttons
                Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => _showCompatibilityBreakdown(mate),
                      icon: const Icon(
                        Icons.analytics,
                        color: Color(0xFFB0FFF7),
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _sendMessage(mate),
                      icon: const Icon(
                        Icons.message,
                        color: Color(0xFFB0FFF7),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredMates() {
    switch (selectedFilter) {
      case 'Live Matches':
        return chosenMates
            .where((Map<String, dynamic> mate) => mate['status'] == 'live_match')
            .toList();
      case 'Pending':
        return chosenMates
            .where((Map<String, dynamic> mate) => mate['status'] == 'pending')
            .toList();
      case 'Recent':
        return chosenMates.take(3).toList(); // Show last 3
      default:
        return chosenMates;
    }
  }

  void _showMatchDetails(Map<String, dynamic> mate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => _buildMatchDetailsSheet(mate),
    );
  }

  Widget _buildMatchDetailsSheet(Map<String, dynamic> mate) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF000000),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: Color(0xFFB0FFF7),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFB0FFF7).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Header
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(mate['avatar']),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${mate['name']}, ${mate['age']}',
                              style: const TextStyle(
                                color: Color(0xFFB0FFF7),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              mate['location'],
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB0FFF7).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFB0FFF7),
                                ),
                              ),
                              child: Text(
                                '${mate['matchScore']}% Match',
                                style: const TextStyle(
                                  color: Color(0xFFB0FFF7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // NVS Note
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0FFF7).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFFB0FFF7).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'NVS NOTE',
                          style: TextStyle(
                            color: Color(0xFFB0FFF7),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mate['nvsNote'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showCompatibilityBreakdown(mate),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB0FFF7).withValues(alpha: 0.2),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'COMPATIBILITY',
                            style: TextStyle(
                              color: Color(0xFFB0FFF7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _sendMessage(mate),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB0FFF7),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'MESSAGE',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
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
    );
  }

  void _showCompatibilityBreakdown(Map<String, dynamic> mate) {
    // TODO: Navigate to compatibility breakdown screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Showing compatibility breakdown for ${mate['name']}',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFB0FFF7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _sendMessage(Map<String, dynamic> mate) {
    // TODO: Navigate to chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening chat with ${mate['name']}',
          style: const TextStyle(color: Colors.black),
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
