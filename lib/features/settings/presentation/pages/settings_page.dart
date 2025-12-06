import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/settings_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Map<String, dynamic> _settings = <String, dynamic>{};
  bool _loading = false;

  Future<void> _updateSetting(String key, dynamic value) async {
    setState(() => _loading = true);
    final Map<String, dynamic> newSettings = <String, dynamic>{..._settings, key: value};
    await ref.read(updateUserSettingsProvider(newSettings).future);
    setState(() {
      _settings = newSettings;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Map<String, dynamic>?> settingsAsync = ref.watch(userSettingsProvider);
    final bool isLoading = settingsAsync.isLoading || _loading;

    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        centerTitle: true,
        title: const NvsLogo(letterSpacing: 10),
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : settingsAsync.when(
              error: (Object e, StackTrace st) => Center(child: Text('Error: $e')),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (Map<String, dynamic>? settings) {
                _settings = settings ?? <String, dynamic>{};
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: <Widget>[
                    SwitchListTile(
                      value: (_settings['notifications'] as bool?) ?? true,
                      onChanged: (bool val) => _updateSetting('notifications', val),
                      title: const Text(
                        'enable notifications',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.ultraLightMint,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      value: (_settings['privateAccount'] as bool?) ?? false,
                      onChanged: (bool val) => _updateSetting('privateAccount', val),
                      title: const Text(
                        'private account',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.ultraLightMint,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SwitchListTile(
                      value: (_settings['showOnlineStatus'] as bool?) ?? true,
                      onChanged: (bool val) => _updateSetting('showOnlineStatus', val),
                      title: const Text(
                        'show online status',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.ultraLightMint,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Divider(color: NVSColors.dividerColor),
                    ListTile(
                      title: const Text(
                        'log out',
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          color: NVSColors.ultraLightMint,
                          letterSpacing: 1.2,
                        ),
                      ),
                      trailing: const Icon(Icons.logout, color: NVSColors.ultraLightMint, size: 18),
                      onTap: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('logged out')),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('failed to log out: $e')),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
    );
  }
}
