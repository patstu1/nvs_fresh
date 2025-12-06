import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemCalibrationSection extends ConsumerWidget {
  const SystemCalibrationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        // ACCOUNT MATRIX
        const CalibrationDivider(title: 'ACCOUNT MATRIX'),
        const CalibrationRow(
          label: 'Membership',
          value: 'NVS+ Premium',
          icon: Icons.diamond_outlined,
          trailing: Icons.upgrade,
        ),
        const CalibrationRow(
          label: 'Email',
          value: 'crypto***@protonmail.com',
          icon: Icons.email_outlined,
        ),
        const CalibrationRow(
          label: 'Wallet Address',
          value: '0x742d...A9B2',
          icon: Icons.account_balance_wallet_outlined,
        ),
        const CalibrationRow(
          label: 'Genesis Verification',
          value: 'Biometric Enrolled',
          icon: Icons.fingerprint,
          statusColor: Colors.green,
        ),

        // NOTIFICATION MATRIX
        const CalibrationDivider(title: 'NOTIFICATION MATRIX'),
        const CalibrationToggle(
          label: 'Haptic Whispers',
          description: 'Feel private messages through device haptics',
          icon: Icons.vibration,
          value: true,
        ),
        const CalibrationToggle(
          label: 'Nexus Pings',
          description: 'Notifications when users enter your proximity',
          icon: Icons.radar,
          value: true,
        ),
        const CalibrationToggle(
          label: 'Match Alerts',
          description: 'Instant notifications for high compatibility matches',
          icon: Icons.favorite_outline,
          value: false,
        ),
        const CalibrationToggle(
          label: 'System Broadcasts',
          description: 'Updates about new features and global events',
          icon: Icons.campaign_outlined,
          value: true,
        ),

        // PRIVACY & SECURITY MATRIX
        const CalibrationDivider(title: 'PRIVACY & SECURITY MATRIX'),
        const CalibrationRow(
          label: 'Privacy Settings',
          value: 'Advanced Configuration',
          icon: Icons.privacy_tip_outlined,
          trailing: Icons.arrow_forward_ios,
        ),
        const CalibrationToggle(
          label: 'Quantum Cloak (Go Incognito)',
          description: 'Activate cryptographic zero-knowledge proofs for true anonymity',
          icon: Icons.visibility_off_outlined,
          value: false,
          isPremium: true,
        ),
        const CalibrationRow(
          label: 'Discreet App Icon',
          value: 'Calculator Pro',
          icon: Icons.apps_outlined,
          trailing: Icons.arrow_forward_ios,
        ),
        const CalibrationRow(
          label: 'PIN & Biometric Lock',
          value: 'Face ID + PIN',
          icon: Icons.security_outlined,
          trailing: Icons.arrow_forward_ios,
        ),
        const CalibrationRow(
          label: 'Two-Factor Authentication',
          value: 'Enabled via Authenticator',
          icon: Icons.shield_outlined,
          statusColor: Colors.green,
        ),

        // DATA SOVEREIGNTY MATRIX
        const CalibrationDivider(title: 'DATA SOVEREIGNTY'),
        const CalibrationRow(
          label: 'Download Identity Core',
          value: 'Export all personal data',
          icon: Icons.download_outlined,
          trailing: Icons.arrow_forward_ios,
        ),
        const CalibrationRow(
          label: 'IPFS Node Status',
          value: 'Synchronized',
          icon: Icons.cloud_sync_outlined,
          statusColor: Colors.green,
        ),
        const CalibrationRow(
          label: 'Blockchain Transactions',
          value: 'View on Solana Explorer',
          icon: Icons.link_outlined,
          trailing: Icons.arrow_forward_ios,
        ),

        // DISPLAY PREFERENCES
        const CalibrationDivider(title: 'DISPLAY PREFERENCES'),
        const CalibrationToggle(
          label: 'Bio-Responsive UI',
          description: 'UI reacts to ambient light and biometric data',
          icon: Icons.auto_awesome_outlined,
          value: true,
        ),
        const CalibrationToggle(
          label: 'Shader Effects',
          description: 'Hardware-accelerated visual effects',
          icon: Icons.grain_outlined,
          value: true,
        ),
        const CalibrationToggle(
          label: 'Haptic Feedback',
          description: 'Enhanced tactile responses throughout the app',
          icon: Icons.touch_app_outlined,
          value: true,
        ),
        const CalibrationRow(
          label: 'Theme Intensity',
          value: 'Maximum Cyberpunk',
          icon: Icons.palette_outlined,
          trailing: Icons.arrow_forward_ios,
        ),

        // ADVANCED FEATURES
        const CalibrationDivider(title: 'ADVANCED FEATURES'),
        const CalibrationToggle(
          label: 'AI Match Learning',
          description: 'Allow AI to learn from your interactions to improve matches',
          icon: Icons.psychology_outlined,
          value: true,
        ),
        const CalibrationToggle(
          label: 'Location History',
          description: 'Track locations for enhanced NOW section experience',
          icon: Icons.location_history_outlined,
          value: false,
        ),
        const CalibrationToggle(
          label: 'Usage Analytics',
          description: 'Anonymous usage data to improve the platform',
          icon: Icons.analytics_outlined,
          value: true,
        ),

        // DANGER ZONE
        const CalibrationDivider(title: 'DANGER ZONE', isWarning: true),
        const CalibrationRow(
          label: 'Reset Identity Core',
          value: 'Clear all personal data',
          icon: Icons.refresh_outlined,
          trailing: Icons.arrow_forward_ios,
          isDangerous: true,
        ),
        const CalibrationRow(
          label: 'Deactivate Profile',
          value: 'Temporarily hide from NVS',
          icon: Icons.pause_circle_outline,
          trailing: Icons.arrow_forward_ios,
          isDangerous: true,
        ),

        // Final action buttons
        const SizedBox(height: 32),
        const LogoutButton(),
        const SizedBox(height: 16),
        const DeleteProfileButton(),
        const SizedBox(height: 40),
      ]),
    );
  }
}

class CalibrationDivider extends StatelessWidget {
  const CalibrationDivider({
    required this.title, super.key,
    this.isWarning = false,
  });
  final String title;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final MaterialColor color = isWarning ? Colors.red : Colors.cyan;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    color.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalibrationRow extends StatelessWidget {
  const CalibrationRow({
    required this.label, required this.value, required this.icon, super.key,
    this.trailing,
    this.statusColor,
    this.isDangerous = false,
  });
  final String label;
  final String value;
  final IconData icon;
  final IconData? trailing;
  final Color? statusColor;
  final bool isDangerous;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDangerous ? Colors.red.withOpacity(0.3) : Colors.grey[700]!.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDangerous ? Colors.red.withOpacity(0.7) : Colors.cyan.withOpacity(0.7),
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isDangerous ? Colors.red[300] : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: statusColor ?? Colors.grey[400],
            fontSize: 12,
          ),
        ),
        trailing: trailing != null
            ? Icon(
                trailing,
                color: Colors.grey[400],
                size: 16,
              )
            : null,
        onTap: () {
          // Handle navigation or action
          print('Tapped: $label');
        },
      ),
    );
  }
}

class CalibrationToggle extends StatefulWidget {
  const CalibrationToggle({
    required this.label, required this.description, required this.icon, required this.value, super.key,
    this.isPremium = false,
  });
  final String label;
  final String description;
  final IconData icon;
  final bool value;
  final bool isPremium;

  @override
  State<CalibrationToggle> createState() => _CalibrationToggleState();
}

class _CalibrationToggleState extends State<CalibrationToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _value ? Colors.cyan.withOpacity(0.5) : Colors.grey[700]!.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        leading: Icon(
          widget.icon,
          color: Colors.cyan.withOpacity(0.7),
          size: 20,
        ),
        title: Row(
          children: <Widget>[
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.isPremium) ...<Widget>[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'NVS+',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          widget.description,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            height: 1.3,
          ),
        ),
        trailing: Switch(
          value: _value,
          onChanged: widget.isPremium && !_value
              ? null
              : (bool value) {
                  setState(() {
                    _value = value;
                  });
                  // Save setting
                  print('Toggle ${widget.label}: $value');
                },
          activeThumbColor: Colors.cyan,
          inactiveThumbColor: Colors.grey[600],
          inactiveTrackColor: Colors.grey[800],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          'LOG OUT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Log Out',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to log out? You'll need to reconnect your wallet.",
          style: TextStyle(color: Colors.grey),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class DeleteProfileButton extends StatelessWidget {
  const DeleteProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showDeleteDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withOpacity(0.1),
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.withOpacity(0.3)),
          ),
        ),
        icon: const Icon(Icons.delete_forever, size: 20),
        label: const Text(
          'DELETE IDENTITY CORE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete Identity Core',
          style: TextStyle(color: Colors.red),
        ),
        content: const Text(
          'This will permanently delete your profile, photos, and all associated data. This action cannot be undone.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showConfirmationDialog(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Final Confirmation',
          style: TextStyle(color: Colors.red),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Type 'DELETE' to confirm permanent deletion:",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'DELETE',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform deletion with multi-step confirmation
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('DELETE FOREVER'),
          ),
        ],
      ),
    );
  }
}
