// NVS Lookout Explore Rooms (Prompt 36)
// Browse available rooms: Public, Position-based, Age groups, Custom rooms
// Search and filter functionality

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutExploreRooms extends StatefulWidget {
  const LookoutExploreRooms({super.key});

  @override
  State<LookoutExploreRooms> createState() => _LookoutExploreRoomsState();
}

class _LookoutExploreRoomsState extends State<LookoutExploreRooms>
    with SingleTickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  // Mock rooms data
  final List<_Room> _allRooms = [
    _Room('main', 'My Room', 'Your personal room', 147, true, 'personal', Icons.home),
    _Room('tops', 'Tops Only', 'Exclusive for tops', 89, true, 'position', Icons.arrow_upward),
    _Room('bottoms', 'Bottoms Only', 'Exclusive for bottoms', 112, true, 'position', Icons.arrow_downward),
    _Room('verse', 'Verse Vibes', 'For versatile guys', 76, true, 'position', Icons.swap_vert),
    _Room('18-25', '18-25', 'Young professionals', 203, true, 'age', Icons.people),
    _Room('25-35', '25-35', 'Mid twenties to thirties', 187, true, 'age', Icons.people),
    _Room('35+', '35+', 'Mature connections', 94, true, 'age', Icons.people),
    _Room('creators', 'Creators Room', 'Verified creators only', 45, true, 'special', Icons.star),
    _Room('local_1', 'NYC Meetup', 'New York locals only', 67, true, 'custom', Icons.location_city),
    _Room('local_2', 'LA Night', 'Los Angeles vibes', 54, true, 'custom', Icons.location_city),
    _Room('theme_1', 'Late Night Chat', 'After midnight crew', 89, true, 'custom', Icons.nightlight),
    _Room('theme_2', 'Fitness Bros', 'Gym enthusiasts', 43, true, 'custom', Icons.fitness_center),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<_Room> get _filteredRooms {
    var rooms = _allRooms;
    
    // Filter by search
    if (_searchController.text.isNotEmpty) {
      rooms = rooms.where((r) => 
        r.name.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }
    
    // Filter by category
    if (_selectedFilter != 'all') {
      rooms = rooms.where((r) => r.category == _selectedFilter).toList();
    }
    
    return rooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabs(),
            Expanded(child: _buildRoomsList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createRoom,
        backgroundColor: _aqua,
        icon: const Icon(Icons.add, color: _black),
        label: const Text(
          'CREATE',
          style: TextStyle(
            color: _black,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
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
          const Text(
            'EXPLORE ROOMS',
            style: TextStyle(
              color: _mint,
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _mint.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: _olive, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: _mint),
              decoration: InputDecoration(
                hintText: 'Search rooms...',
                hintStyle: TextStyle(color: _olive),
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {});
              },
              child: Icon(Icons.close, color: _olive, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFilterChip('All', 'all'),
          _buildFilterChip('Position', 'position'),
          _buildFilterChip('Age', 'age'),
          _buildFilterChip('Custom', 'custom'),
          _buildFilterChip('Special', 'special'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isActive = _selectedFilter == value;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedFilter = value);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? _aqua : _olive.withOpacity(0.4),
          ),
          color: isActive ? _aqua.withOpacity(0.15) : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? _aqua : _mint.withOpacity(0.7),
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomsList() {
    final rooms = _filteredRooms;
    
    if (rooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: _olive, size: 60),
            const SizedBox(height: 16),
            const Text(
              'No rooms found',
              style: TextStyle(color: _mint, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search',
              style: TextStyle(color: _olive, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: rooms.length,
      itemBuilder: (context, index) => _buildRoomCard(rooms[index]),
    );
  }

  Widget _buildRoomCard(_Room room) {
    return GestureDetector(
      onTap: () => _joinRoom(room),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: room.category == 'special'
                ? _aqua.withOpacity(0.5)
                : _mint.withOpacity(0.15),
          ),
          gradient: room.category == 'special'
              ? LinearGradient(
                  colors: [_aqua.withOpacity(0.1), Colors.transparent],
                )
              : null,
        ),
        child: Row(
          children: [
            // Room icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: room.category == 'special' ? _aqua : _olive.withOpacity(0.4),
                ),
                color: room.category == 'special'
                    ? _aqua.withOpacity(0.1)
                    : _mint.withOpacity(0.05),
              ),
              child: Icon(
                room.icon,
                color: room.category == 'special' ? _aqua : _mint.withOpacity(0.6),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Room info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        room.name,
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (room.category == 'special') ...[
                        const SizedBox(width: 8),
                        Icon(Icons.verified, color: _aqua, size: 14),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.description,
                    style: TextStyle(color: _olive, fontSize: 12),
                  ),
                ],
              ),
            ),
            // User count and join
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: room.isLive ? _aqua : _olive,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${room.userCount}',
                      style: const TextStyle(
                        color: _aqua,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _aqua.withOpacity(0.6)),
                  ),
                  child: const Text(
                    'JOIN',
                    style: TextStyle(
                      color: _aqua,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _joinRoom(_Room room) {
    HapticFeedback.mediumImpact();
    // Navigate to room
  }

  void _createRoom() {
    HapticFeedback.mediumImpact();
    // Navigate to room creation
  }
}

class _Room {
  final String id;
  final String name;
  final String description;
  final int userCount;
  final bool isLive;
  final String category;
  final IconData icon;

  _Room(
    this.id,
    this.name,
    this.description,
    this.userCount,
    this.isLive,
    this.category,
    this.icon,
  );
}


