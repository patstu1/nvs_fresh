import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterIcon(Icons.filter_alt),
          _buildFilterIcon(Icons.location_on),
          _buildFilterIcon(Icons.access_time),
          _buildFilterIcon(Icons.arrow_downward),
          const Spacer(),
          _buildFilterChip('Popular', true),
          const SizedBox(width: 8),
          _buildFilterChip('New', false),
          const SizedBox(width: 8),
          _buildFilterChip('Nearby', false),
          const SizedBox(width: 8),
          _buildFilterIcon(Icons.person),
        ],
      ),
    );
  }

  Widget _buildFilterIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(icon, color: NVSColors.neonMint),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? NVSColors.neonMint : Colors.transparent,
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : NVSColors.neonMint,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
