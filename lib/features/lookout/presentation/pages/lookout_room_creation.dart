// NVS Lookout - Custom Room Creation (Prompt 44)
// Users can create custom rooms with themes, rules, and capacity
// Colors: #000000 background, #E3F2DE mint, #6B7F4A olive, #20B2A6 aqua

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutRoomCreation extends StatefulWidget {
  const LookoutRoomCreation({super.key});

  @override
  State<LookoutRoomCreation> createState() => _LookoutRoomCreationState();
}

class _LookoutRoomCreationState extends State<LookoutRoomCreation> {
  static const Color _mint = Color(0xFFE3F2DE);
  static const Color _olive = Color(0xFF6B7F4A);
  static const Color _aqua = Color(0xFF20B2A6);
  static const Color _black = Color(0xFF000000);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  double _capacity = 50;
  String? _positionFilter;
  int _minAge = 18;
  int _maxAge = 99;
  bool _isPublic = true;

  final List<String> _positions = ['Tops Only', 'Bottoms Only', 'Versatile Only', 'All Welcome'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canCreate => _nameController.text.isNotEmpty;

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
        title: const Text(
          'Create Custom Room',
          style: TextStyle(
            color: _mint,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Name (required)
            _buildSectionLabel('Room Name *', required: true),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nameController,
              hint: 'e.g., "NYC After Dark"',
              maxLength: 30,
            ),
            const SizedBox(height: 24),
            
            // Description (optional)
            _buildSectionLabel('Description'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _descriptionController,
              hint: 'What\'s your room about?',
              maxLength: 200,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            
            // Room Capacity (required)
            _buildSectionLabel('Room Capacity *', required: true),
            const SizedBox(height: 8),
            _buildCapacitySlider(),
            const SizedBox(height: 24),
            
            // Position Filter (optional)
            _buildSectionLabel('Position Filter (optional)'),
            const SizedBox(height: 8),
            _buildPositionChips(),
            const SizedBox(height: 24),
            
            // Age Range (optional)
            _buildSectionLabel('Age Range (optional)'),
            const SizedBox(height: 8),
            _buildAgeRange(),
            const SizedBox(height: 24),
            
            // Room Type
            _buildSectionLabel('Room Type'),
            const SizedBox(height: 8),
            _buildRoomTypeSelection(),
            const SizedBox(height: 40),
            
            // Create button
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, {bool required = false}) {
    return Text(
      text,
      style: TextStyle(
        color: required ? _mint : _olive,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int? maxLength,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: _mint.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: _mint),
        maxLength: maxLength,
        maxLines: maxLines,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: _olive),
          border: InputBorder.none,
          counterStyle: TextStyle(color: _olive, fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildCapacitySlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('10', style: TextStyle(color: _olive, fontSize: 12)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _aqua.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _aqua.withOpacity(0.5)),
              ),
              child: Text(
                '${_capacity.toInt()} users',
                style: const TextStyle(
                  color: _aqua,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text('200', style: TextStyle(color: _olive, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: _aqua,
            inactiveTrackColor: _olive.withOpacity(0.3),
            thumbColor: _aqua,
            overlayColor: _aqua.withOpacity(0.2),
          ),
          child: Slider(
            value: _capacity,
            min: 10,
            max: 200,
            divisions: 19,
            onChanged: (value) => setState(() => _capacity = value),
          ),
        ),
        Text(
          'Max 200 users',
          style: TextStyle(color: _olive, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildPositionChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _positions.map((pos) {
        final isSelected = _positionFilter == pos;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              _positionFilter = isSelected ? null : pos;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _aqua : Colors.transparent,
              border: Border.all(
                color: isSelected ? _aqua : _mint.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check, color: _black, size: 16),
                  const SizedBox(width: 6),
                ],
                Text(
                  pos,
                  style: TextStyle(
                    color: isSelected ? _black : _mint,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAgeRange() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text('Min: ', style: TextStyle(color: _olive, fontSize: 13)),
                Expanded(
                  child: DropdownButton<int>(
                    value: _minAge,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    dropdownColor: _black,
                    icon: Icon(Icons.arrow_drop_down, color: _mint),
                    items: List.generate(33, (i) => 18 + i)
                        .map((age) => DropdownMenuItem(
                              value: age,
                              child: Text(
                                '$age',
                                style: const TextStyle(color: _mint),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _minAge = value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text('to', style: TextStyle(color: _olive)),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text('Max: ', style: TextStyle(color: _olive, fontSize: 13)),
                Expanded(
                  child: DropdownButton<int>(
                    value: _maxAge,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    dropdownColor: _black,
                    icon: Icon(Icons.arrow_drop_down, color: _mint),
                    items: [
                      ...List.generate(32, (i) => 19 + i)
                          .map((age) => DropdownMenuItem(
                                value: age,
                                child: Text(
                                  '$age',
                                  style: const TextStyle(color: _mint),
                                ),
                              )),
                      const DropdownMenuItem(
                        value: 99,
                        child: Text('50+', style: TextStyle(color: _mint)),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _maxAge = value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomTypeSelection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _isPublic = true);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isPublic ? _aqua : _mint.withOpacity(0.3),
                width: _isPublic ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isPublic ? _aqua : _olive,
                      width: 2,
                    ),
                  ),
                  child: _isPublic
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: _aqua,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Public (searchable)',
                        style: TextStyle(
                          color: _isPublic ? _mint : _olive,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Anyone can find and join',
                        style: TextStyle(
                          color: _olive,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _isPublic = false);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: !_isPublic ? _aqua : _mint.withOpacity(0.3),
                width: !_isPublic ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: !_isPublic ? _aqua : _olive,
                      width: 2,
                    ),
                  ),
                  child: !_isPublic
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: _aqua,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invite Only',
                        style: TextStyle(
                          color: !_isPublic ? _mint : _olive,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'You approve join requests',
                        style: TextStyle(
                          color: _olive,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: _canCreate ? _createRoom : null,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: _canCreate ? _aqua : _olive.withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          'CREATE ROOM',
          style: TextStyle(
            color: _canCreate ? _black : _olive,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  void _createRoom() {
    HapticFeedback.heavyImpact();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Room "${_nameController.text}" created!'),
        backgroundColor: _aqua,
      ),
    );
  }
}

