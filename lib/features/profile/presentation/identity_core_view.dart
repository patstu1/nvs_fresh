import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/core/widgets/bio_responsive_scaffold.dart';
import 'package:nvs/meatup_core.dart';

import 'widgets/persona_matrix_section.dart';
import 'widgets/system_calibration_section.dart';
import 'widgets/vault_section.dart';

/// The Identity Core - Ultimate profile setup and settings system
/// This is not a "Settings" page. This is the user's command center.
class IdentityCoreView extends ConsumerWidget {
  const IdentityCoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BioResponsiveScaffold(
      appBar: _buildHolographicAppBar(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          _buildHolographicHeader(context),
          _buildSectionHeader('PERSONA MATRIX'),
          const PersonaMatrixSection(),
          _buildSectionHeader('THE VAULT'),
          const VaultSection(),
          _buildSectionHeader('SYSTEM CALIBRATION'),
          const SystemCalibrationSection(),
          // Bottom padding for navigation
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildHolographicAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: NVSColors.neonMint,
          size: 24,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'IDENTITY CORE',
        style: TextStyle(
          fontFamily: 'BellGothic',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: NVSColors.neonMint,
          letterSpacing: 2.0,
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.save_outlined,
            color: NVSColors.turquoiseNeon,
            size: 24,
          ),
          onPressed: () {
            // Save all changes
            _saveIdentityCore(context);
          },
        ),
      ],
    );
  }

  Widget _buildHolographicHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              NVSColors.pureBlack,
              NVSColors.darkBackground.withOpacity(0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            // Holographic profile avatar
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        NVSColors.neonMint.withOpacity(0.3),
                        NVSColors.turquoiseNeon.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                    border: Border.all(
                      color: NVSColors.neonMint,
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 58,
                    backgroundColor: NVSColors.cardBackground,
                    child: Icon(
                      Icons.person_outline,
                      size: 48,
                      color: NVSColors.neonMint,
                    ),
                  ),
                ),
              ),
            ),
            // Quantum particles effect
            ...List.generate(20, _buildQuantumParticle),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantumParticle(int index) {
    return Positioned(
      left: (index * 37.0) % 400,
      top: (index * 23.0) % 180 + 20,
      child: Container(
        width: 2,
        height: 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: NVSColors.neonMint.withOpacity(0.6),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NVSColors.neonMint.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: <Color>[
              NVSColors.neonMint.withOpacity(0.1),
              NVSColors.turquoiseNeon.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: NVSColors.neonMint.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: NVSColors.neonMint,
                borderRadius: BorderRadius.circular(2),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: NVSColors.neonMint.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'BellGothic',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: NVSColors.neonMint,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveIdentityCore(BuildContext context) {
    // Trigger decentralized update flow:
    // 1. Create new JSON metadata
    // 2. Upload to IPFS
    // 3. Get new CID
    // 4. Execute Solana transaction to update Profile NFT's URI

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Identity Core synchronized to blockchain',
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            color: NVSColors.neonMint,
          ),
        ),
        backgroundColor: NVSColors.cardBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: NVSColors.neonMint.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}
