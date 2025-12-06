import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class SettingsNodeView extends StatefulWidget {
  const SettingsNodeView({super.key});

  @override
  State<SettingsNodeView> createState() => _SettingsNodeViewState();
}

class _SettingsNodeViewState extends State<SettingsNodeView> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.primaryNeonMint.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Node Title
            const Text(
              'SETTINGS',
              style: TextStyle(
                color: NVSColors.primaryNeonMint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'SYSTEM CONFIGURATION',
              style: TextStyle(
                color: NVSColors.secondaryText.withValues(alpha: 0.7),
                fontSize: 12,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 30),

            // Settings Options
            _buildSettingItem(
              'NOTIFICATIONS',
              'Push alerts and messages',
              _notificationsEnabled,
              (bool value) => setState(() => _notificationsEnabled = value),
              Icons.notifications_outlined,
            ),

            _buildSettingItem(
              'LOCATION',
              'GPS tracking for nearby features',
              _locationEnabled,
              (bool value) => setState(() => _locationEnabled = value),
              Icons.location_on_outlined,
            ),

            _buildSettingItem(
              'HAPTIC FEEDBACK',
              'Touch vibrations and responses',
              _hapticFeedbackEnabled,
              (bool value) => setState(() => _hapticFeedbackEnabled = value),
              Icons.vibration,
            ),

            _buildSettingItem(
              'DARK MODE',
              'System visual theme',
              _darkModeEnabled,
              (bool value) => setState(() => _darkModeEnabled = value),
              Icons.dark_mode_outlined,
            ),

            const SizedBox(height: 20),

            // Divider
            Container(
              height: 1,
              color: NVSColors.dividerColor.withValues(alpha: 0.3),
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),

            // Action Buttons
            _buildActionItem(
              'PRIVACY',
              'Data and security settings',
              Icons.security,
              () {
                // TODO: Navigate to privacy settings
              },
            ),

            _buildActionItem(
              'ABOUT',
              'App info and version',
              Icons.info_outline,
              () {
                // TODO: Show about dialog
              },
            ),

            _buildActionItem(
              'LOGOUT',
              'Sign out of account',
              Icons.logout,
              () {
                // TODO: Handle logout
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: NVSColors.primaryNeonMint.withValues(alpha: 0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: NVSColors.secondaryText.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: NVSColors.primaryNeonMint,
            activeTrackColor: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
            inactiveThumbColor: NVSColors.secondaryText,
            inactiveTrackColor: NVSColors.dividerColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final Color iconColor = isDestructive
        ? Colors.red.withValues(alpha: 0.7)
        : NVSColors.primaryNeonMint.withValues(alpha: 0.7);
    final Color titleColor = isDestructive ? Colors.red : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: NVSColors.secondaryText.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: NVSColors.secondaryText.withValues(alpha: 0.5),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
