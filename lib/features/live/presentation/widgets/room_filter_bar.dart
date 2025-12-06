import 'package:flutter/material.dart';

class RoomFilterBar extends StatelessWidget {
  const RoomFilterBar({
    required this.selectedTag,
    required this.distance,
    required this.capacity,
    required this.privateOnly,
    required this.aiCurated,
    required this.onChanged,
    super.key,
  });
  final String selectedTag;
  final double distance;
  final int capacity;
  final bool privateOnly;
  final bool aiCurated;
  final void Function({
    String? tag,
    double? distance,
    int? capacity,
    bool? privateOnly,
    bool? aiCurated,
  }) onChanged;

  @override
  Widget build(BuildContext context) {
    // Normalize selected values to match dropdown item values
    final String normalizedTag = (selectedTag.isEmpty || selectedTag.toLowerCase() == 'all')
        ? ''
        : selectedTag.toUpperCase();
    final Set<int> capacityOptions = <int>{25, 50, 100, 200};
    final int? normalizedCapacity = capacityOptions.contains(capacity) ? capacity : null;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          // Distance slider
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Distance',
                  style: TextStyle(color: Color(0xFF08F3F0), fontSize: 12),
                ),
                Slider(
                  value: distance,
                  min: 0.2,
                  max: 50,
                  divisions: 100,
                  label: '${distance.toStringAsFixed(1)} km',
                  activeColor: const Color(0xFF08F3F0),
                  inactiveColor: const Color(0xFFE4FFF0),
                  onChanged: (double v) => onChanged(distance: v),
                ),
              ],
            ),
          ),
          // Tag dropdown
          DropdownButton<String>(
            value: normalizedTag.isEmpty ? null : normalizedTag,
            hint: const Text('Tag', style: TextStyle(color: Color(0xFF08F3F0))),
            dropdownColor: Colors.black,
            style: const TextStyle(color: Color(0xFF08F3F0)),
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem(value: '', child: Text('All')),
              DropdownMenuItem(value: 'NSFW', child: Text('NSFW')),
              DropdownMenuItem(value: 'KINK', child: Text('KINK')),
              DropdownMenuItem(value: 'COZY', child: Text('COZY')),
              DropdownMenuItem(value: 'ASTRO', child: Text('ASTRO')),
              DropdownMenuItem(value: 'GLOBAL', child: Text('Global')),
            ],
            onChanged: (String? v) => onChanged(tag: (v ?? '').toUpperCase()),
          ),
          // Capacity
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Capacity',
                  style: TextStyle(color: Color(0xFF08F3F0), fontSize: 12),
                ),
                DropdownButton<int>(
                  value: normalizedCapacity,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Color(0xFF08F3F0)),
                  hint: const Text(
                    'Cap',
                    style: TextStyle(color: Color(0xFF08F3F0)),
                  ),
                  items: const <DropdownMenuItem<int>>[
                    DropdownMenuItem(value: 25, child: Text('25')),
                    DropdownMenuItem(value: 50, child: Text('50')),
                    DropdownMenuItem(value: 100, child: Text('100')),
                    DropdownMenuItem(value: 200, child: Text('200')),
                  ],
                  onChanged: (int? v) => onChanged(capacity: v ?? 200),
                ),
              ],
            ),
          ),
          // Private only toggle
          Row(
            children: <Widget>[
              const Text(
                'Private',
                style: TextStyle(color: Color(0xFF08F3F0), fontSize: 12),
              ),
              Switch(
                value: privateOnly,
                activeThumbColor: const Color(0xFF08F3F0),
                onChanged: (bool v) => onChanged(privateOnly: v),
              ),
            ],
          ),
          // AI curated toggle
          Row(
            children: <Widget>[
              const Text(
                'AI',
                style: TextStyle(color: Color(0xFF08F3F0), fontSize: 12),
              ),
              Switch(
                value: aiCurated,
                activeThumbColor: const Color(0xFF08F3F0),
                onChanged: (bool v) => onChanged(aiCurated: v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
