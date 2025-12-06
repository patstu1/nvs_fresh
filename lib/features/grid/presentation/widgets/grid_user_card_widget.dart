// lib/features/grid/presentation/widgets/grid_user_card_widget.dart
import 'package:flutter/material.dart';
import 'package:nvs/features/grid/domain/models/grid_user_model.dart';
import 'package:nvs/meatup_core.dart';

class GridUserCardWidget extends StatelessWidget {
  const GridUserCardWidget({
    required this.user,
    super.key,
    this.onTap,
  });
  final GridUserModel user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderColor,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    user.displayName[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      color: AppTheme.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.distance,
                    style: const TextStyle(
                      color: AppTheme.secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
