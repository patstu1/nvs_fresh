import 'package:flutter/material.dart';
import '../widgets/photo_manager.dart';
import '../widgets/identity_field.dart';

class SelfNodeView extends StatelessWidget {
  const SelfNodeView({super.key});

  void _editField(String fieldName) {
    // TODO: Implement field editing functionality
    debugPrint('Editing field: $fieldName');
    // Future: Open edit dialog or navigate to edit screen
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Section 1: Photo Management
          Text(
            'PHOTOS',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 16),
          // Production-ready PhotoManager with reorder functionality
          const PhotoManager(),

          const SizedBox(height: 32),

          // Section 2: Identity (Name, About Me, Tags)
          Text(
            'IDENTITY',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 16),
          // TODO: Replace with custom, editable TextFields
          Text(
            'Display Name: Emsculpt/Emface',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'About Me: Certified tech here...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: 32),

          // Section 3: Stats (The Data Points)
          Text(
            'STATS',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 16),
          // We will build a reusable 'IdentityField' widget for all these rows
          // to keep the code clean and beautiful.
          // IdentityField(label: "Age", value: "39"),
          // IdentityField(label: "Height", value: "6'0\""),
          // IdentityField(label: "Position", value: "Versatile"),
          // ... and so on for every single stat.

          // Identity Fields - Real profile data
          Column(
            children: <Widget>[
              IdentityField(
                label: 'Age',
                value: '29',
                onTap: () => _editField('Age'),
              ),
              IdentityField(
                label: 'Height',
                value: "6'0\"",
                onTap: () => _editField('Height'),
              ),
              IdentityField(
                label: 'Position',
                value: 'Versatile',
                onTap: () => _editField('Position'),
              ),
              IdentityField(
                label: 'Body Type',
                value: 'Athletic',
                onTap: () => _editField('Body Type'),
              ),
              IdentityField(
                label: 'Ethnicity',
                value: 'Mixed',
                onTap: () => _editField('Ethnicity'),
              ),
              IdentityField(
                label: 'Looking For',
                value: 'Dating, Friends',
                onTap: () => _editField('Looking For'),
              ),
              const IdentityField(
                label: 'Profile Views',
                value: '247',
                // No onTap - read-only stat
              ),
              const IdentityField(
                label: 'Member Since',
                value: 'Jan 2024',
                // No onTap - read-only stat
              ),
            ],
          ),
        ],
      ),
    );
  }
}
