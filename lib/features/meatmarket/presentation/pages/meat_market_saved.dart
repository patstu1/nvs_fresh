// NVS Meat Market - Saved/Favorites View (Prompt 30)
// Shows all bookmarked profiles with edit mode for bulk operations
// Colors: #000000 background, #E3F2DE mint, #6B7F4A olive, #20B2A6 aqua

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MeatMarketSaved extends StatefulWidget {
  const MeatMarketSaved({super.key});

  @override
  State<MeatMarketSaved> createState() => _MeatMarketSavedState();
}

class _MeatMarketSavedState extends State<MeatMarketSaved> {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  bool _editMode = false;
  final Set<String> _selectedIds = {};
  
  final List<_SavedUser> _savedUsers = List.generate(12, (i) => _SavedUser.generate(i));

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SAVED',
              style: TextStyle(
                color: _mint,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_savedUsers.length} profiles',
              style: const TextStyle(color: _olive, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _editMode = !_editMode;
                if (!_editMode) _selectedIds.clear();
              });
            },
            child: Text(
              _editMode ? 'Done' : 'Edit',
              style: const TextStyle(color: _aqua),
            ),
          ),
        ],
      ),
      body: _savedUsers.isEmpty ? _buildEmptyState() : _buildGrid(),
      bottomNavigationBar: _editMode && _selectedIds.isNotEmpty
          ? _buildEditModeBottomBar()
          : null,
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 0.72,
      ),
      itemCount: _savedUsers.length,
      itemBuilder: (context, index) => _buildUserTile(_savedUsers[index]),
    );
  }

  Widget _buildUserTile(_SavedUser user) {
    final isSelected = _selectedIds.contains(user.id);
    
    return GestureDetector(
      onTap: () {
        if (_editMode) {
          setState(() {
            if (isSelected) {
              _selectedIds.remove(user.id);
            } else {
              _selectedIds.add(user.id);
            }
          });
          HapticFeedback.selectionClick();
        } else {
          // Open profile
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? _aqua
                : user.isOnline
                    ? _mint.withOpacity(0.5)
                    : _mint.withOpacity(0.15),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: _aqua.withOpacity(0.3), blurRadius: 8)]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Photo placeholder
              Container(
                color: _mint.withOpacity(0.08),
                child: Icon(
                  Icons.person,
                  color: _mint.withOpacity(0.2),
                  size: 48,
                ),
              ),
              // Saved bookmark icon (filled, top right)
              Positioned(
                top: 6,
                right: 6,
                child: Icon(
                  Icons.bookmark,
                  color: _mint,
                  size: 18,
                ),
              ),
              // Online indicator
              if (user.isOnline)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _aqua,
                      boxShadow: [
                        BoxShadow(color: _aqua.withOpacity(0.5), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              // Edit mode checkbox
              if (_editMode)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? _aqua : _black.withOpacity(0.6),
                      border: Border.all(
                        color: isSelected ? _aqua : _mint.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: _black, size: 14)
                        : null,
                  ),
                ),
              // Bottom gradient
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, _black.withOpacity(0.9)],
                    ),
                  ),
                ),
              ),
              // User info
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name}, ${user.age}',
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Saved ${user.savedAgo}',
                      style: TextStyle(
                        color: _olive,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border, color: _mint.withOpacity(0.5), size: 64),
          const SizedBox(height: 16),
          const Text(
            'No saved profiles',
            style: TextStyle(
              color: _mint,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the bookmark on any profile to save it here',
            style: TextStyle(color: _olive, fontSize: 14),
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
              child: const Text(
                'Browse Meat Market',
                style: TextStyle(
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

  Widget _buildEditModeBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _black,
        border: Border(top: BorderSide(color: _mint.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _editMode = false;
                    _selectedIds.clear();
                  });
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: _olive),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: _olive),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _removeSelected,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Remove ${_selectedIds.length} saved',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeSelected() {
    HapticFeedback.heavyImpact();
    setState(() {
      _savedUsers.removeWhere((u) => _selectedIds.contains(u.id));
      _selectedIds.clear();
      _editMode = false;
    });
  }
}

class _SavedUser {
  final String id;
  final String name;
  final int age;
  final bool isOnline;
  final String savedAgo;

  _SavedUser({
    required this.id,
    required this.name,
    required this.age,
    required this.isOnline,
    required this.savedAgo,
  });

  static const List<String> _names = [
    'Marcus', 'Jordan', 'Alex', 'Ryan', 'Tyler', 'Chris', 'Jake', 'Matt',
    'Derek', 'Sam', 'Blake', 'Kyle', 'Ethan', 'Noah', 'Liam', 'Mason',
  ];

  factory _SavedUser.generate(int index) {
    final random = Random(index);
    final daysAgo = random.nextInt(14);
    return _SavedUser(
      id: 'saved_$index',
      name: _names[index % _names.length],
      age: 21 + random.nextInt(20),
      isOnline: random.nextDouble() > 0.6,
      savedAgo: daysAgo == 0 ? 'today' : '${daysAgo}d ago',
    );
  }
}

