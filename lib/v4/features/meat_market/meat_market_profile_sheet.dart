import 'package:flutter/material.dart';
import 'package:nvs/models/user_profile.dart';

import '../../core/v4_dependencies.dart';

class MeatMarketProfileSheet extends StatelessWidget {
  const MeatMarketProfileSheet({required this.user, super.key});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.surfaceDark,
      appBar: AppBar(
        title: Text(user.displayName),
        backgroundColor: NVSPalette.surfaceDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: NVSPalette.surfaceDark,
                backgroundImage:
                    user.primaryAvatar.isNotEmpty ? NetworkImage(user.primaryAvatar) : null,
                child: user.primaryAvatar.isNotEmpty
                    ? null
                    : Text(
                        user.displayName.isNotEmpty ? user.displayName[0] : '?',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '${user.age ?? '—'} • ${user.distanceLabel}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: NVSPalette.lightGray),
              ),
            ),
            const SizedBox(height: 24),
            _ProfileInfoRow(
              label: 'Role',
              value: user.role ?? user.sexualRole ?? '—',
            ),
            _ProfileInfoRow(
              label: 'Location',
              value: user.city ?? user.location ?? 'Unknown',
            ),
            _ProfileInfoRow(
              label: 'Match',
              value: user.compatibilityScore != null
                  ? '${user.compatibilityScore!.toStringAsFixed(0)}%'
                  : 'Syncing',
            ),
            const SizedBox(height: 24),
            Text(
              'Bio',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              user.bio?.trim().isNotEmpty == true
                  ? user.bio!.trim()
                  : 'This profile has not shared a bio yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            if (user.interests.isNotEmpty) ...<Widget>[
              Text(
                'Interests',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: user.interests.take(12).map((String interest) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: NVSPalette.surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NVSPalette.mediumGray),
                    ),
                    child: Text(
                      interest,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: NVSPalette.lightGray),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('YO'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('MESSAGE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              label.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: NVSPalette.lightGray),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
