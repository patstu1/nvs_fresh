// NVS Lookout Themed Rooms (Prompts 39-42)
// Specialized rooms: Position-based (Tops/Bottoms/Verse), Age-based, Custom themed
// Each with its own entry requirements and atmosphere

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutThemedRooms extends StatefulWidget {
  const LookoutThemedRooms({super.key});

  @override
  State<LookoutThemedRooms> createState() => _LookoutThemedRoomsState();
}

class _LookoutThemedRoomsState extends State<LookoutThemedRooms>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  int _selectedCategory = 0;

  // Room categories
  final List<_RoomCategory> _categories = [
    _RoomCategory(
      'POSITION',
      Icons.swap_vert,
      [
        _ThemedRoom('tops', 'TOPS ONLY', 'Exclusive for tops', 89, Icons.arrow_upward, _RoomRequirement.position, 'top'),
        _ThemedRoom('bottoms', 'BOTTOMS ONLY', 'Exclusive for bottoms', 112, Icons.arrow_downward, _RoomRequirement.position, 'bottom'),
        _ThemedRoom('verse', 'VERSE VIBES', 'For versatile guys', 76, Icons.swap_vert, _RoomRequirement.position, 'verse'),
        _ThemedRoom('sides', 'SIDES', 'Non-penetrative connections', 34, Icons.people, _RoomRequirement.position, 'side'),
      ],
    ),
    _RoomCategory(
      'AGE',
      Icons.calendar_today,
      [
        _ThemedRoom('18-25', '18-25', 'Young professionals', 203, Icons.person, _RoomRequirement.age, '18-25'),
        _ThemedRoom('25-35', '25-35', 'Mid twenties to thirties', 187, Icons.person, _RoomRequirement.age, '25-35'),
        _ThemedRoom('35-45', '35-45', 'Thirties to forties', 94, Icons.person, _RoomRequirement.age, '35-45'),
        _ThemedRoom('45+', '45+', 'Mature connections', 56, Icons.person, _RoomRequirement.age, '45+'),
      ],
    ),
    _RoomCategory(
      'THEMED',
      Icons.palette,
      [
        _ThemedRoom('fitness', 'FITNESS BROS', 'Gym enthusiasts', 67, Icons.fitness_center, _RoomRequirement.none, null),
        _ThemedRoom('late_night', 'LATE NIGHT', 'After midnight crew', 145, Icons.nightlight, _RoomRequirement.none, null),
        _ThemedRoom('travelers', 'TRAVELERS', 'Visiting or exploring', 43, Icons.flight, _RoomRequirement.none, null),
        _ThemedRoom('bears', 'BEARS & CUBS', 'Bear community', 78, Icons.pets, _RoomRequirement.none, null),
        _ThemedRoom('kink', 'KINK FRIENDLY', 'Open-minded space', 89, Icons.lock, _RoomRequirement.none, null),
        _ThemedRoom('dating', 'LOOKING FOR MORE', 'Relationship-minded', 56, Icons.favorite, _RoomRequirement.none, null),
      ],
    ),
    _RoomCategory(
      'LOCAL',
      Icons.location_on,
      [
        _ThemedRoom('nyc', 'NYC', 'New York City', 234, Icons.location_city, _RoomRequirement.location, 'NYC'),
        _ThemedRoom('la', 'LOS ANGELES', 'LA vibes', 187, Icons.location_city, _RoomRequirement.location, 'LA'),
        _ThemedRoom('chicago', 'CHICAGO', 'Windy city', 89, Icons.location_city, _RoomRequirement.location, 'CHI'),
        _ThemedRoom('miami', 'MIAMI', 'Beach vibes', 112, Icons.location_city, _RoomRequirement.location, 'MIA'),
      ],
    ),
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
            _buildCategoryTabs(),
            Expanded(child: _buildRoomsGrid()),
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
          const Expanded(
            child: Text(
              'THEMED ROOMS',
              style: TextStyle(
                color: _mint,
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 3,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showInfo,
            child: Icon(Icons.info_outline, color: _olive),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isActive = _selectedCategory == index;
          
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedCategory = index);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isActive ? _aqua : _olive.withOpacity(0.4),
                  width: isActive ? 2 : 1,
                ),
                color: isActive ? _aqua.withOpacity(0.15) : Colors.transparent,
              ),
              child: Row(
                children: [
                  Icon(
                    category.icon,
                    color: isActive ? _aqua : _olive,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.name,
                    style: TextStyle(
                      color: isActive ? _aqua : _olive,
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoomsGrid() {
    final rooms = _categories[_selectedCategory].rooms;
    
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.9,
      ),
      itemCount: rooms.length,
      itemBuilder: (context, index) => _buildRoomCard(rooms[index]),
    );
  }

  Widget _buildRoomCard(_ThemedRoom room) {
    return GestureDetector(
      onTap: () => _joinRoom(room),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _aqua.withOpacity(0.3)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _aqua.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _aqua.withOpacity(0.1 * _glowController.value),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Room icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _aqua.withOpacity(0.5)),
                    color: _aqua.withOpacity(0.1),
                  ),
                  child: Icon(room.icon, color: _aqua, size: 24),
                ),
                const SizedBox(height: 14),
                // Room name
                Text(
                  room.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  room.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _olive,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                // User count
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _aqua,
                        boxShadow: [
                          BoxShadow(
                            color: _aqua.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${room.userCount} online',
                      style: TextStyle(
                        color: _aqua,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Requirement indicator
                if (room.requirement != _RoomRequirement.none) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _olive.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, color: _olive, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          _getRequirementText(room.requirement),
                          style: TextStyle(color: _olive, fontSize: 10),
                        ),
                      ],
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

  String _getRequirementText(_RoomRequirement req) {
    switch (req) {
      case _RoomRequirement.position:
        return 'Position required';
      case _RoomRequirement.age:
        return 'Age verified';
      case _RoomRequirement.location:
        return 'Location based';
      case _RoomRequirement.none:
        return '';
    }
  }

  void _joinRoom(_ThemedRoom room) {
    HapticFeedback.mediumImpact();
    
    // Check requirements
    if (room.requirement != _RoomRequirement.none) {
      _showRequirementDialog(room);
    } else {
      // Navigate to room
      _enterRoom(room);
    }
  }

  void _showRequirementDialog(_ThemedRoom room) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _aqua.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user, color: _aqua, size: 48),
              const SizedBox(height: 16),
              Text(
                'ROOM REQUIREMENTS',
                style: const TextStyle(
                  color: _mint,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _getRequirementMessage(room),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _mint.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: _olive.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'CANCEL',
                            style: TextStyle(color: _olive, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _enterRoom(room);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _aqua,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            'ENTER',
                            style: TextStyle(
                              color: _black,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
    );
  }

  String _getRequirementMessage(_ThemedRoom room) {
    switch (room.requirement) {
      case _RoomRequirement.position:
        return 'This room is for ${room.requirementValue}s only. Your profile indicates you qualify. Continue?';
      case _RoomRequirement.age:
        return 'This room is for ages ${room.requirementValue}. Your profile age has been verified. Continue?';
      case _RoomRequirement.location:
        return 'This room is for users in ${room.requirementValue}. Your location qualifies. Continue?';
      case _RoomRequirement.none:
        return '';
    }
  }

  void _enterRoom(_ThemedRoom room) {
    // Navigate to room
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _mint.withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ABOUT THEMED ROOMS',
                style: TextStyle(
                  color: _mint,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoItem(Icons.swap_vert, 'Position Rooms', 'Based on your profile position preference'),
              _buildInfoItem(Icons.calendar_today, 'Age Rooms', 'Verified age ranges for better connections'),
              _buildInfoItem(Icons.palette, 'Themed Rooms', 'Interest-based communities'),
              _buildInfoItem(Icons.location_on, 'Local Rooms', 'Connect with people in your area'),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: _aqua),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'GOT IT',
                      style: TextStyle(color: _aqua, fontSize: 13),
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

  Widget _buildInfoItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _aqua, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: _olive, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============ DATA MODELS ============
class _RoomCategory {
  final String name;
  final IconData icon;
  final List<_ThemedRoom> rooms;

  _RoomCategory(this.name, this.icon, this.rooms);
}

class _ThemedRoom {
  final String id;
  final String name;
  final String description;
  final int userCount;
  final IconData icon;
  final _RoomRequirement requirement;
  final String? requirementValue;

  _ThemedRoom(
    this.id,
    this.name,
    this.description,
    this.userCount,
    this.icon,
    this.requirement,
    this.requirementValue,
  );
}

enum _RoomRequirement {
  none,
  position,
  age,
  location,
}

