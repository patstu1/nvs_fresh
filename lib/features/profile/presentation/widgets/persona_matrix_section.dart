import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/theme/quantum_design_tokens.dart';

/// The Persona Matrix - Complete profile editing system
/// Contains all user-defined profile data from competitor analysis
class PersonaMatrixSection extends ConsumerWidget {
  const PersonaMatrixSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        // BASIC STATS
        _buildSubsectionHeader('CORE IDENTITY'),
        const EditableMatrixRow(label: 'Display Name', value: 'CryptoKnight'),
        const EditableMatrixRow(
          label: 'About Me',
          value:
              'Certified tech innovator. Blockchain architect. Seeking authentic connections in the digital realm.',
          isMultiline: true,
        ),
        const EditableMatrixRow(label: 'Age', value: '39'),
        const EditableMatrixRow(label: 'Height', value: "6'2\""),
        const EditableMatrixRow(label: 'Weight', value: '185 lbs'),
        const EditableMatrixRow(label: 'Body Type', value: 'Athletic'),
        const EditableMatrixRow(label: 'Ethnicity', value: 'Mixed'),
        const EditableMatrixRow(label: 'Position', value: 'Versatile'),
        const EditableMatrixRow(label: 'Relationship Status', value: 'Single'),

        // TRIBES & INTERESTS
        _buildSubsectionHeader('NEURAL TRIBES'),
        const EditableMatrixRow(label: 'My Tribes', value: 'Tech, Crypto, Fitness, Cyberpunk'),
        const EditableMatrixRow(label: 'Looking For', value: 'Dates, Friends, Networking, LTR'),
        const EditableMatrixRow(label: 'Accepts NSFW', value: 'Yes'),

        // LOCATION & AVAILABILITY
        _buildSubsectionHeader('SPATIAL COORDINATES'),
        const EditableMatrixRow(label: 'Location', value: 'Los Angeles, CA'),
        const EditableMatrixRow(label: 'Distance Range', value: '25 miles'),
        const EditableMatrixRow(label: 'Travel', value: 'Yes, worldwide'),
        const EditableMatrixRow(label: 'Host', value: 'Yes'),
        const EditableMatrixRow(label: 'Availability', value: 'Evenings & weekends'),

        // HEALTH & SAFETY
        _buildSubsectionHeader('BIOMETRIC STATUS'),
        const EditableMatrixRow(label: 'HIV Status', value: 'Negative, on PrEP'),
        const EditableMatrixRow(label: 'Last Tested', value: 'January 2024'),
        const EditableMatrixRow(label: 'Vaccinated', value: 'COVID-19, Mpox, Hepatitis'),
        const EditableMatrixRow(label: 'Safe Sex', value: 'Always'),

        // LIFESTYLE & PREFERENCES
        _buildSubsectionHeader('LIFESTYLE MATRIX'),
        const EditableMatrixRow(label: 'Smoking', value: 'No'),
        const EditableMatrixRow(label: 'Drinking', value: 'Socially'),
        const EditableMatrixRow(label: 'Drugs', value: '420 friendly'),
        const EditableMatrixRow(label: 'Kinks', value: 'Tech roleplay, VR'),
        const EditableMatrixRow(label: 'Languages', value: 'English, Spanish, Python'),

        // SOCIAL LINKS
        _buildSubsectionHeader('DIGITAL FOOTPRINT'),
        const EditableMatrixRow(label: 'Instagram', value: '@cryptoknight_la'),
        const EditableMatrixRow(label: 'Twitter', value: '@blockchain_bro'),
        const EditableMatrixRow(label: 'Spotify', value: 'Cyberpunk 2077 OST'),
        const EditableMatrixRow(label: 'TikTok', value: 'Tech tutorials'),
        const EditableMatrixRow(label: 'OnlyFans', value: 'Link on request'),

        // VERIFICATION & BADGES
        _buildSubsectionHeader('AUTHENTICATION PROTOCOLS'),
        const VerificationBadge(label: 'Photo Verified', isVerified: true),
        const VerificationBadge(label: 'Video Verified', isVerified: false),
        const VerificationBadge(label: 'ID Verified', isVerified: true),
        const VerificationBadge(label: 'STI Tested', isVerified: true),
        const VerificationBadge(label: 'Income Verified', isVerified: false),

        const SizedBox(height: 32),
      ]),
    );
  }

  Widget _buildSubsectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'MagdaCleanMono',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: QuantumDesignTokens.turquoiseNeon,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// Interactive row for editing profile data
class EditableMatrixRow extends StatefulWidget {
  const EditableMatrixRow({
    required this.label, required this.value, super.key,
    this.isMultiline = false,
    this.onTap,
  });
  final String label;
  final String value;
  final bool isMultiline;
  final VoidCallback? onTap;

  @override
  State<EditableMatrixRow> createState() => _EditableMatrixRowState();
}

class _EditableMatrixRowState extends State<EditableMatrixRow> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: QuantumDesignTokens.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isEditing
              ? QuantumDesignTokens.neonMint.withOpacity(0.5)
              : QuantumDesignTokens.cardBackground.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'BellGothic',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: QuantumDesignTokens.textSecondary,
          ),
        ),
        subtitle: _isEditing
            ? TextField(
                controller: _controller,
                maxLines: widget.isMultiline ? null : 1,
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 13,
                  color: QuantumDesignTokens.textPrimary,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter ${widget.label.toLowerCase()}...',
                  hintStyle: TextStyle(
                    color: QuantumDesignTokens.textSecondary.withOpacity(0.6),
                  ),
                ),
                onSubmitted: (_) => _stopEditing(),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _controller.text.isEmpty
                      ? 'Tap to add ${widget.label.toLowerCase()}'
                      : _controller.text,
                  style: TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 13,
                    color: _controller.text.isEmpty
                        ? QuantumDesignTokens.textSecondary.withOpacity(0.6)
                        : QuantumDesignTokens.textPrimary,
                    fontStyle: _controller.text.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
        trailing: _isEditing
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.check, color: QuantumDesignTokens.neonMint, size: 20),
                    onPressed: _stopEditing,
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: QuantumDesignTokens.textSecondary, size: 20),
                    onPressed: _cancelEditing,
                  ),
                ],
              )
            : Icon(
                Icons.edit_outlined,
                color: QuantumDesignTokens.turquoiseNeon.withOpacity(0.7),
                size: 18,
              ),
        onTap: widget.onTap ?? _startEditing,
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _stopEditing() {
    setState(() {
      _isEditing = false;
    });
    // Here you would save the data to your backend/blockchain
    _saveToBlockchain();
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _controller.text = widget.value; // Reset to original value
    });
  }

  void _saveToBlockchain() {
    // Trigger decentralized update flow:
    // 1. Create new JSON metadata
    // 2. Upload to IPFS -> get new CID
    // 3. Execute Solana transaction to update Profile NFT
    print('Saving ${widget.label}: ${_controller.text} to blockchain...');
  }
}

/// Verification badge widget
class VerificationBadge extends StatelessWidget {
  const VerificationBadge({
    required this.label, required this.isVerified, super.key,
  });
  final String label;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: QuantumDesignTokens.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isVerified
              ? QuantumDesignTokens.neonMint.withOpacity(0.5)
              : QuantumDesignTokens.textSecondary.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          isVerified ? Icons.verified : Icons.verified_outlined,
          color: isVerified ? QuantumDesignTokens.neonMint : QuantumDesignTokens.textSecondary,
          size: 24,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontFamily: 'BellGothic',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isVerified ? QuantumDesignTokens.neonMint : QuantumDesignTokens.textSecondary,
          ),
        ),
        subtitle: Text(
          isVerified ? 'Verified' : 'Not verified',
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 12,
            color: isVerified
                ? QuantumDesignTokens.neonMint.withOpacity(0.8)
                : QuantumDesignTokens.textSecondary.withOpacity(0.6),
          ),
        ),
        trailing: isVerified
            ? const Icon(
                Icons.check_circle,
                color: QuantumDesignTokens.neonMint,
                size: 20,
              )
            : TextButton(
                onPressed: () {
                  // Start verification process
                  _startVerification(context, label);
                },
                child: const Text(
                  'VERIFY',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: QuantumDesignTokens.turquoiseNeon,
                  ),
                ),
              ),
      ),
    );
  }

  void _startVerification(BuildContext context, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting $type verification process...',
          style: const TextStyle(fontFamily: 'MagdaCleanMono'),
        ),
        backgroundColor: QuantumDesignTokens.cardBackground,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
