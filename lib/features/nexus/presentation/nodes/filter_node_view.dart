import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/features/nexus/presentation/widgets/nvs_chip.dart'; // Our custom chip
import 'package:nvs/features/nexus/presentation/widgets/identity_field.dart'; // We can reuse this for sliders

class FilterNodeView extends StatefulWidget {
  const FilterNodeView({super.key});

  @override
  State<FilterNodeView> createState() => _FilterNodeViewState();
}

class _FilterNodeViewState extends State<FilterNodeView> {
  // Mock state for the filter values
  String _selectedPosition = 'Any';
  RangeValues _ageRange = const RangeValues(25, 45);
  RangeValues _heightRange = const RangeValues(170, 190); // cm
  RangeValues _weightRange = const RangeValues(70, 90); // kg
  bool _onlineNow = false;
  bool _hasPhotos = true;
  bool _recentlyActive = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Section 1: Core Filters (Position, etc.)
          _buildSectionTitle('FILTER BY'),
          _buildChipSelector(
            title: 'Position',
            tags: <String>['Top', 'Vers', 'Bottom', 'Side', 'Any'],
            selectedValue: _selectedPosition,
            onSelected: (String tag) => setState(() => _selectedPosition = tag),
          ),

          const SizedBox(height: 32),

          // Section 2: Body and Stats
          _buildSectionTitle('STATS'),
          // Age Range
          IdentityField(
            label: 'Age',
            value: '${_ageRange.start.round()} - ${_ageRange.end.round()}',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RangeSlider(
              values: _ageRange,
              min: 18,
              max: 99,
              activeColor: NVSColors.primaryNeonMint,
              inactiveColor: NVSColors.dividerColor,
              onChanged: (RangeValues values) => setState(() => _ageRange = values),
            ),
          ),

          const SizedBox(height: 16),

          // Height Range
          IdentityField(
            label: 'Height (cm)',
            value:
                '${_heightRange.start.round()} - ${_heightRange.end.round()}',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RangeSlider(
              values: _heightRange,
              min: 150,
              max: 210,
              activeColor: NVSColors.primaryNeonMint,
              inactiveColor: NVSColors.dividerColor,
              onChanged: (RangeValues values) => setState(() => _heightRange = values),
            ),
          ),

          const SizedBox(height: 16),

          // Weight Range
          IdentityField(
            label: 'Weight (kg)',
            value:
                '${_weightRange.start.round()} - ${_weightRange.end.round()}',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RangeSlider(
              values: _weightRange,
              min: 50,
              max: 150,
              activeColor: NVSColors.primaryNeonMint,
              inactiveColor: NVSColors.dividerColor,
              onChanged: (RangeValues values) => setState(() => _weightRange = values),
            ),
          ),

          const SizedBox(height: 32),

          // Section 3: Online Status
          _buildSectionTitle('STATUS'),
          _buildToggleField(
            label: 'Online Now',
            value: _onlineNow,
            onChanged: (bool value) => setState(() => _onlineNow = value),
          ),
          _buildToggleField(
            label: 'Has Photos',
            value: _hasPhotos,
            onChanged: (bool value) => setState(() => _hasPhotos = value),
          ),
          _buildToggleField(
            label: 'Recently Active',
            value: _recentlyActive,
            onChanged: (bool value) => setState(() => _recentlyActive = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  Widget _buildChipSelector({
    required String title,
    required List<String> tags,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map((String tag) => NvsChip(
                    label: tag,
                    isSelected: selectedValue == tag,
                    onTap: () => onSelected(tag),
                  ),)
              .toList(),
        ),
      ],
    );
  }

  Widget _buildToggleField({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: NVSColors.dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: NVSColors.primaryNeonMint,
            inactiveTrackColor: NVSColors.dividerColor,
          ),
        ],
      ),
    );
  }
}
