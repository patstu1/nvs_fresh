import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class IdentityField extends StatelessWidget {
  // Make onTap optional

  const IdentityField({
    required this.label,
    required this.value,
    super.key,
    this.onTap,
  });
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
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
            Row(
              children: <Widget>[
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (onTap != null) // Only show the chevron if it's tappable
                  const SizedBox(width: 8),
                if (onTap != null)
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: NVSColors.secondaryText,
                    size: 14,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
