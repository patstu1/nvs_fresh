import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nvs/meatup_core.dart';

class FilterToolbar extends StatelessWidget {
  const FilterToolbar({
    required this.currentFilter,
    required this.currentSort,
    required this.onFilterChanged,
    required this.onSortChanged,
    super.key,
  });
  final String currentFilter;
  final String currentSort;
  final Function(String) onFilterChanged;
  final Function(String) onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          // Signal Filter
          Expanded(
            child: _buildFilterDropdown(
              'Signal',
              <String>['Signal', 'Match', 'Online'],
              currentFilter,
              onFilterChanged,
            ),
          ),
          const SizedBox(width: 12),
          // AI Sort
          Expanded(
            child: _buildFilterDropdown(
              'AI Sort',
              <String>['Similarity', 'Opposition', 'Obsession'],
              currentSort,
              onSortChanged,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: -1, duration: const Duration(milliseconds: 600));
  }

  Widget _buildFilterDropdown(
    String label,
    List<String> options,
    String currentValue,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: NVSColors.nvsBlack,
        border: Border.all(
          color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          dropdownColor: NVSColors.nvsBlack,
          style: TextStyle(
            fontFamily: 'MagdaClean',
            fontSize: 14,
            foreground: Paint()..color = NVSColors.ultraLightMint,
            letterSpacing: 0.5,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: NVSColors.ultraLightMint,
            size: 20,
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  fontFamily: 'MagdaClean',
                  fontSize: 14,
                  foreground: Paint()..color = NVSColors.ultraLightMint,
                  letterSpacing: 0.5,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
