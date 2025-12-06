import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class NowFilterSidebar extends StatefulWidget {
  const NowFilterSidebar({
    required this.onClose,
    required this.onFiltersChanged,
    super.key,
  });
  final VoidCallback onClose;
  final Function(Map<String, dynamic>) onFiltersChanged;

  @override
  State<NowFilterSidebar> createState() => _NowFilterSidebarState();
}

class _NowFilterSidebarState extends State<NowFilterSidebar> {
  // Filter states (like Sniffies)
  bool _showOnlineOnly = true;
  bool _showHosting = false;
  bool _showPictures = false;
  bool _showVerified = false;
  double _maxDistance = 5.0; // km
  RangeValues _ageRange = const RangeValues(18, 65);

  // Sniffies-style categories
  final List<String> _selectedTypes = <String>[];
  final List<String> _availableTypes = <String>[
    'Chat',
    'Friends',
    'Dates',
    'Right Now',
    'Networking',
    'Groups',
    'Events',
    'Travel',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            NVSColors.pureBlack,
            NVSColors.pureBlack.withOpacity(0.95),
            NVSColors.primaryNeonMint.withOpacity(0.05),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: NVSColors.primaryNeonMint.withOpacity(0.3),
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.primaryNeonMint.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          // Header
          _buildHeader(),

          // Filters content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildQuickFilters(),
                  const SizedBox(height: 24),
                  _buildDistanceFilter(),
                  const SizedBox(height: 24),
                  _buildAgeFilter(),
                  const SizedBox(height: 24),
                  _buildTypeFilter(),
                  const SizedBox(height: 24),
                  _buildActivityFilter(),
                ],
              ),
            ),
          ),

          // Apply button
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: NVSColors.primaryNeonMint.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.tune,
            color: NVSColors.primaryNeonMint,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Text(
            'CRUISERS',
            style: TextStyle(
              fontFamily: 'BellGothic',
              color: NVSColors.primaryNeonMint,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: NVSColors.primaryNeonMint.withOpacity(0.3),
                ),
              ),
              child: const Icon(
                Icons.close,
                color: NVSColors.primaryNeonMint,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'QUICK FILTERS',
          style: TextStyle(
            fontFamily: 'BellGothic',
            color: NVSColors.ultraLightMint,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        _buildToggleFilter('Online Now', _showOnlineOnly, (bool value) {
          setState(() => _showOnlineOnly = value);
          _notifyFiltersChanged();
        }),
        _buildToggleFilter('Hosting', _showHosting, (bool value) {
          setState(() => _showHosting = value);
          _notifyFiltersChanged();
        }),
        _buildToggleFilter('Has Pictures', _showPictures, (bool value) {
          setState(() => _showPictures = value);
          _notifyFiltersChanged();
        }),
        _buildToggleFilter('Verified', _showVerified, (bool value) {
          setState(() => _showVerified = value);
          _notifyFiltersChanged();
        }),
      ],
    );
  }

  Widget _buildToggleFilter(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color:
                      value ? NVSColors.primaryNeonMint : NVSColors.ultraLightMint.withOpacity(0.3),
                  width: 2,
                ),
                color: value ? NVSColors.primaryNeonMint : Colors.transparent,
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: NVSColors.pureBlack,
                      size: 14,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'MagdaCleanMono',
                color: value ? NVSColors.primaryNeonMint : NVSColors.ultraLightMint,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'MAX DISTANCE',
          style: TextStyle(
            fontFamily: 'BellGothic',
            color: NVSColors.ultraLightMint,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: NVSColors.primaryNeonMint,
            inactiveTrackColor: NVSColors.ultraLightMint.withOpacity(0.2),
            thumbColor: NVSColors.primaryNeonMint,
            overlayColor: NVSColors.primaryNeonMint.withOpacity(0.2),
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: _maxDistance,
            min: 0.5,
            max: 50.0,
            divisions: 99,
            onChanged: (double value) {
              setState(() => _maxDistance = value);
              _notifyFiltersChanged();
            },
          ),
        ),
        Text(
          '${_maxDistance.toStringAsFixed(1)} km',
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: NVSColors.primaryNeonMint,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAgeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'AGE RANGE',
          style: TextStyle(
            fontFamily: 'BellGothic',
            color: NVSColors.ultraLightMint,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: NVSColors.primaryNeonMint,
            inactiveTrackColor: NVSColors.ultraLightMint.withOpacity(0.2),
            thumbColor: NVSColors.primaryNeonMint,
            overlayColor: NVSColors.primaryNeonMint.withOpacity(0.2),
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: RangeSlider(
            values: _ageRange,
            min: 18,
            max: 80,
            divisions: 62,
            onChanged: (RangeValues values) {
              setState(() => _ageRange = values);
              _notifyFiltersChanged();
            },
          ),
        ),
        Text(
          '${_ageRange.start.round()} - ${_ageRange.end.round()} years',
          style: const TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: NVSColors.primaryNeonMint,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'LOOKING FOR',
          style: TextStyle(
            fontFamily: 'BellGothic',
            color: NVSColors.ultraLightMint,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTypes.map((String type) {
            final bool isSelected = _selectedTypes.contains(type);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTypes.remove(type);
                  } else {
                    _selectedTypes.add(type);
                  }
                });
                _notifyFiltersChanged();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? NVSColors.primaryNeonMint
                        : NVSColors.ultraLightMint.withOpacity(0.3),
                  ),
                  color:
                      isSelected ? NVSColors.primaryNeonMint.withOpacity(0.1) : Colors.transparent,
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    color: isSelected ? NVSColors.primaryNeonMint : NVSColors.ultraLightMint,
                    fontSize: 11,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActivityFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'ACTIVITY STATUS',
          style: TextStyle(
            fontFamily: 'BellGothic',
            color: NVSColors.ultraLightMint,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: NVSColors.primaryNeonMint.withOpacity(0.2),
            ),
            color: NVSColors.primaryNeonMint.withOpacity(0.05),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: NVSColors.primaryNeonMint,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Active: 23 users',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: NVSColors.primaryNeonMint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: NVSColors.ultraLightMint.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Nearby: 47 users',
                    style: TextStyle(
                      fontFamily: 'MagdaCleanMono',
                      color: NVSColors.ultraLightMint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: NVSColors.primaryNeonMint.withOpacity(0.2),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _notifyFiltersChanged();
            widget.onClose();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: NVSColors.primaryNeonMint,
            foregroundColor: NVSColors.pureBlack,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'APPLY FILTERS',
            style: TextStyle(
              fontFamily: 'BellGothic',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  void _notifyFiltersChanged() {
    widget.onFiltersChanged(<String, dynamic>{
      'onlineOnly': _showOnlineOnly,
      'hosting': _showHosting,
      'pictures': _showPictures,
      'verified': _showVerified,
      'maxDistance': _maxDistance,
      'ageRange': _ageRange,
      'types': _selectedTypes,
    });
  }
}
