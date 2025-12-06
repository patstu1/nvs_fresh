import 'package:flutter/material.dart';
import '../../data/now_map_model.dart';

class MapFiltersPanel extends StatefulWidget {
  final MapFilters filters;
  final Function(MapFilters) onFiltersChanged;

  const MapFiltersPanel({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  State<MapFiltersPanel> createState() => _MapFiltersPanelState();
}

class _MapFiltersPanelState extends State<MapFiltersPanel>
    with TickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  final List<String> _popularTags = [
    'gym', 'coffee', 'music', 'art', 'travel', 'food', 'sports',
    'tech', 'fashion', 'fitness', 'yoga', 'dancing', 'reading',
    'gaming', 'photography', 'cooking', 'hiking', 'swimming'
  ];

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _expandController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF4BEFE0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with toggle
              _buildHeader(),
              
              // Expanded content
              if (_isExpanded) _buildExpandedContent(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Color(0xFF4BEFE0), size: 20),
          const SizedBox(width: 8),
          const Text(
            'Filters',
            style: TextStyle(
              color: Color(0xFF4BEFE0),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${_getActiveFilterCount()} active',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _toggleExpanded,
            icon: AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4BEFE0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return SizeTransition(
      sizeFactor: _expandAnimation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distance filter
            _buildDistanceFilter(),
            const SizedBox(height: 20),
            
            // Tags filter
            _buildTagsFilter(),
            const SizedBox(height: 20),
            
            // Moods filter
            _buildMoodsFilter(),
            const SizedBox(height: 20),
            
            // Roles filter
            _buildRolesFilter(),
            const SizedBox(height: 20),
            
            // Quick toggles
            _buildQuickToggles(),
            const SizedBox(height: 20),
            
            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF4BEFE0),
            inactiveTrackColor: Colors.grey[700],
            thumbColor: const Color(0xFF4BEFE0),
            overlayColor: const Color(0xFF4BEFE0).withValues(alpha: 0.2),
          ),
          child: Slider(
            value: widget.filters.maxDistance / 1000, // Convert to km
            min: 1,
            max: 100,
            divisions: 99,
            onChanged: (value) {
              final newFilters = widget.filters.copyWith(
                maxDistance: value * 1000,
              );
              widget.onFiltersChanged(newFilters);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 km',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            Text(
              '${(widget.filters.maxDistance / 1000).round()} km',
              style: const TextStyle(color: Color(0xFF4BEFE0), fontSize: 12),
            ),
            Text(
              '100 km',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularTags.map((tag) {
            final isSelected = widget.filters.tags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                final newTags = List<String>.from(widget.filters.tags);
                if (selected) {
                  newTags.add(tag);
                } else {
                  newTags.remove(tag);
                }
                final newFilters = widget.filters.copyWith(tags: newTags);
                widget.onFiltersChanged(newFilters);
              },
              backgroundColor: Colors.grey[800],
              selectedColor: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
              checkmarkColor: const Color(0xFF4BEFE0),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[300],
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMoodsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mood',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: UserMood.values.map((mood) {
            final isSelected = widget.filters.moods.contains(mood);
            return FilterChip(
              label: Text(mood.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                final newMoods = List<UserMood>.from(widget.filters.moods);
                if (selected) {
                  newMoods.add(mood);
                } else {
                  newMoods.remove(mood);
                }
                final newFilters = widget.filters.copyWith(moods: newMoods);
                widget.onFiltersChanged(newFilters);
              },
              backgroundColor: Colors.grey[800],
              selectedColor: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
              checkmarkColor: const Color(0xFF4BEFE0),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[300],
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRolesFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Role',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: UserRole.values.map((role) {
            final isSelected = widget.filters.roles.contains(role);
            return FilterChip(
              label: Text(role.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                final newRoles = List<UserRole>.from(widget.filters.roles);
                if (selected) {
                  newRoles.add(role);
                } else {
                  newRoles.remove(role);
                }
                final newFilters = widget.filters.copyWith(roles: newRoles);
                widget.onFiltersChanged(newFilters);
              },
              backgroundColor: Colors.grey[800],
              selectedColor: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
              checkmarkColor: const Color(0xFF4BEFE0),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[300],
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickToggles() {
    return Row(
      children: [
        Expanded(
          child: _buildToggleButton(
            icon: Icons.visibility,
            label: 'Online Only',
            isActive: widget.filters.showOnlineOnly,
            onTap: () {
              final newFilters = widget.filters.copyWith(
                showOnlineOnly: !widget.filters.showOnlineOnly,
              );
              widget.onFiltersChanged(newFilters);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildToggleButton(
            icon: Icons.verified,
            label: 'Verified Only',
            isActive: widget.filters.showVerifiedOnly,
            onTap: () {
              final newFilters = widget.filters.copyWith(
                showVerifiedOnly: !widget.filters.showVerifiedOnly,
              );
              widget.onFiltersChanged(newFilters);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive 
              ? const Color(0xFF4BEFE0).withValues(alpha: 0.2)
              : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? const Color(0xFF4BEFE0) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF4BEFE0) : Colors.grey[400],
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF4BEFE0) : Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              const newFilters = MapFilters();
              widget.onFiltersChanged(newFilters);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[400],
              side: BorderSide(color: Colors.grey[600]!),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Clear All'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _toggleExpanded,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4BEFE0),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Apply'),
          ),
        ),
      ],
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (widget.filters.tags.isNotEmpty) count++;
    if (widget.filters.moods.isNotEmpty) count++;
    if (widget.filters.roles.isNotEmpty) count++;
    if (widget.filters.showOnlineOnly) count++;
    if (widget.filters.showVerifiedOnly) count++;
    if (widget.filters.maxDistance != 50000) count++;
    return count;
  }
} 