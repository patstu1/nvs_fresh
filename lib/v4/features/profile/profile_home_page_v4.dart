import 'package:flutter/material.dart';

import '../../core/v4_dependencies.dart';
import '../../../models/user_profile.dart';

class ProfileHomePageV4 extends StatelessWidget {
  const ProfileHomePageV4({super.key});

  static final UserProfile _demoProfile = UserProfile(
    id: 'v4-demo-user',
    displayName: 'ONYX FABLE',
    city: 'Neo Vegas',
    role: 'Vault Architect',
    age: 32,
    roleEmoji: '🛰️',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    lastSeen: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSPalette.surfaceDark,
      appBar: AppBar(
        title: const Text('PROFILE'),
        backgroundColor: NVSPalette.surfaceDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ProfileHeader(profile: _demoProfile),
            const SizedBox(height: 16),
            _QuickStats(profile: _demoProfile),
            const SizedBox(height: 16),
            _ProfileActions(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NVSPalette.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: NVSPalette.mediumGray),
              ),
              child: Text(
                'Vaultline stories, identity layers, and collectible badges will surface here as we backfill data from previous seasons.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: NVSPalette.lightGray),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSPalette.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: NVSPalette.mediumGray),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  NVSPalette.neonLime,
                  NVSPalette.surfaceDark,
                ],
              ),
            ),
            child: Center(
              child: Text(
                profile.displayName.substring(0, 1),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: NVSPalette.surfaceDark),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  profile.displayName,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(letterSpacing: 1.2),
                ),
                const SizedBox(height: 6),
                Text(
                  '${profile.roleEmoji ?? ''} ${profile.role ?? 'Role pending'}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: NVSPalette.lightGray),
                ),
                const SizedBox(height: 6),
                Text(
                  profile.city ?? 'Unknown location',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: NVSPalette.mediumGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _StatTile(
            label: 'AGE',
            value: profile.age?.toString() ?? '--',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            label: 'LOCATION',
            value: profile.city ?? 'Undisclosed',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            label: 'ROLE',
            value: profile.role ?? 'Pending',
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVSPalette.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NVSPalette.mediumGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: NVSPalette.lightGray),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _ProfileActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: const Text('EDIT PROFILE'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('VIEW VAULTLINE'),
          ),
        ),
      ],
    );
  }
}
