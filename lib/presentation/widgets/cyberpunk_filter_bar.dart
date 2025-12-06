// packages/grid/lib/presentation/widgets/cyberpunk_filter_bar.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

/// Cyberpunk-styled filter bar with neon animations and glitch effects
class CyberpunkFilterBar extends StatefulWidget {
  final List<String> filters;
  final String? selectedFilter;
  final ValueChanged<String?> onFilterChanged;
  final VoidCallback? onAdvancedFilter;

  const CyberpunkFilterBar({
    super.key,
    required this.filters,
    this.selectedFilter,
    required this.onFilterChanged,
    this.onAdvancedFilter,
  });

  @override
  State<CyberpunkFilterBar> createState() => _CyberpunkFilterBarState();
}

class _CyberpunkFilterBarState extends State<CyberpunkFilterBar> with TickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _scanController = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this)
      ..repeat(reverse: true);

    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: NVSColors.pureBlack,
            border: Border(
              top: BorderSide(color: NVSColors.ultraLightMint.withValues(alpha: 0.3), width: 1),
              bottom: BorderSide(color: NVSColors.turquoiseNeon.withValues(alpha: 0.2), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              // Filter chips
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.filters.length,
                  itemBuilder: (context, index) {
                    final filter = widget.filters[index];
                    final isSelected = widget.selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildFilterChip(filter, isSelected),
                    );
                  },
                ),
              ),

              // Advanced filter button
              if (widget.onAdvancedFilter != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: _buildAdvancedFilterButton(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String filter, bool isSelected) {
    return GestureDetector(
      onTap: () => widget.onFilterChanged(isSelected ? null : filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? NVSColors.ultraLightMint.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? NVSColors.ultraLightMint
                : NVSColors.ultraLightMint.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Text(
          filter.toUpperCase(),
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? NVSColors.ultraLightMint : NVSColors.secondaryText,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedFilterButton() {
    return GestureDetector(
      onTap: widget.onAdvancedFilter,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: NVSColors.turquoiseNeon.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: NVSColors.turquoiseNeon.withValues(alpha: 0.4), width: 1),
          boxShadow: [
            BoxShadow(
              color: NVSColors.turquoiseNeon.withValues(alpha: 0.2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(Icons.tune, color: NVSColors.turquoiseNeon, size: 20),
      ),
    );
  }
}
