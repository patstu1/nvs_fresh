import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class FilterNodeView extends StatefulWidget {
  const FilterNodeView({super.key});

  @override
  State<FilterNodeView> createState() => _FilterNodeViewState();
}

class _FilterNodeViewState extends State<FilterNodeView> {
  // Filter states
  bool _showOnlineOnly = true;
  bool _showNearbyOnly = false;
  double _maxDistance = 50.0;
  final Set<String> _selectedInterests = <String>{'music', 'art'};

  final List<String> _availableInterests = <String>[
    'music',
    'art',
    'tech',
    'fitness',
    'travel',
    'food',
    'books',
    'gaming',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.primaryNeonMint.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Node Title
            const Text(
              'FILTER',
              style: TextStyle(
                color: NVSColors.primaryNeonMint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'SIGNAL PARAMETERS',
              style: TextStyle(
                color: NVSColors.secondaryText.withValues(alpha: 0.7),
                fontSize: 12,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 30),

            // Online Toggle
            _buildToggleFilter(
              'ONLINE ONLY',
              _showOnlineOnly,
              (bool value) => setState(() => _showOnlineOnly = value),
            ),
            const SizedBox(height: 20),

            // Nearby Toggle
            _buildToggleFilter(
              'NEARBY ONLY',
              _showNearbyOnly,
              (bool value) => setState(() => _showNearbyOnly = value),
            ),
            const SizedBox(height: 20),

            // Distance Slider
            _buildDistanceFilter(),
            const SizedBox(height: 20),

            // Interest Chips
            _buildInterestFilter(),
            const SizedBox(height: 30),

            // Apply Button
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  colors: <Color>[
                    NVSColors.primaryNeonMint.withValues(alpha: 0.2),
                    NVSColors.primaryNeonMint.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(
                  color: NVSColors.primaryNeonMint.withValues(alpha: 0.5),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () {
                    // TODO: Apply filters
                  },
                  child: const Center(
                    child: Text(
                      'APPLY FILTERS',
                      style: TextStyle(
                        color: NVSColors.primaryNeonMint,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
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

  Widget _buildToggleFilter(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: NVSColors.primaryNeonMint,
          activeTrackColor: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
          inactiveThumbColor: NVSColors.secondaryText,
          inactiveTrackColor: NVSColors.dividerColor,
        ),
      ],
    );
  }

  Widget _buildDistanceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'MAX DISTANCE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
            Text(
              '${_maxDistance.round()} KM',
              style: const TextStyle(
                color: NVSColors.primaryNeonMint,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: NVSColors.primaryNeonMint,
            inactiveTrackColor: NVSColors.dividerColor,
            thumbColor: NVSColors.primaryNeonMint,
            overlayColor: NVSColors.primaryNeonMint.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _maxDistance,
            min: 1,
            max: 100,
            onChanged: (double value) => setState(() => _maxDistance = value),
          ),
        ),
      ],
    );
  }

  Widget _buildInterestFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'INTERESTS',
          style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableInterests.map((String interest) {
            final bool isSelected = _selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedInterests.remove(interest);
                  } else {
                    _selectedInterests.add(interest);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? NVSColors.primaryNeonMint.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected
                        ? NVSColors.primaryNeonMint
                        : NVSColors.dividerColor,
                  ),
                ),
                child: Text(
                  interest.toUpperCase(),
                  style: TextStyle(
                    color: isSelected
                        ? NVSColors.primaryNeonMint
                        : NVSColors.secondaryText,
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
