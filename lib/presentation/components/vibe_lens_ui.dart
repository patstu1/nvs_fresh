// packages/grid/lib/presentation/components/vibe_lens_ui.dart

import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../../data/models/vibe_lens_types.dart';

/// Modal overlay for the VibeLens filter system
/// Provides cinematic animations and lens selection interface
class VibeLensUI extends StatefulWidget {
  final bool isOpen;
  final ValueChanged<VibeLensType> onSelectLens;
  final VoidCallback onClose;

  const VibeLensUI({
    super.key,
    required this.isOpen,
    required this.onSelectLens,
    required this.onClose,
  });

  @override
  State<VibeLensUI> createState() => _VibeLensUIState();
}

class _VibeLensUIState extends State<VibeLensUI> with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late AnimationController _lensController;
  late Animation<double> _overlayAnimation;
  late Animation<double> _lensAnimation;

  bool _showRefineView = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (widget.isOpen) {
      _animateIn();
    }
  }

  void _setupAnimations() {
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _lensController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _overlayAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeInOut),
    );

    _lensAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lensController, curve: Curves.elasticOut),
    );
  }

  void _animateIn() {
    _overlayController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _lensController.forward();
      }
    });
  }

  void _animateOut() {
    _lensController.reverse();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _overlayController.reverse().then((_) {
          widget.onClose();
        });
      }
    });
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _lensController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _overlayAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _overlayAnimation.value,
          child: Container(
            color: NVSColors.pureBlack.withOpacity(0.9),
            child: GestureDetector(
              onTap: _animateOut,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: _showRefineView
                      ? _buildRefineView()
                      : _buildMainLensView(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainLensView() {
    return AnimatedBuilder(
      animation: _lensAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _lensAnimation.value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'VIBE LENS',
                style: TextStyle(
                  fontFamily: 'BellGothic', // Bell Gothic Black
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: NVSColors.primaryNeonMint,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      color: NVSColors.primaryNeonMint.withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Primary lenses
              ..._buildPrimaryLenses(),

              const SizedBox(height: 32),

              // Close button
              _buildCloseButton(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildPrimaryLenses() {
    final lenses = [
      VibeLensType.nearby,
      VibeLensType.trending,
      VibeLensType.newFaces,
      VibeLensType.nomads,
      VibeLensType.refine,
    ];

    return lenses.map((lens) {
      final index = lenses.indexOf(lens);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Transform.translate(
          offset: Offset(
            (index.isEven ? -1 : 1) * 20 * (1 - _lensAnimation.value),
            0,
          ),
          child: _buildLensButton(lens),
        ),
      );
    }).toList();
  }

  Widget _buildLensButton(VibeLensType lens) {
    return GestureDetector(
      onTap: () {
        if (lens == VibeLensType.refine) {
          setState(() => _showRefineView = true);
        } else {
          widget.onSelectLens(lens);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(
            color: NVSColors.primaryNeonMint.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: lens == VibeLensType.refine
              ? NVSColors.primaryNeonMint.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(
          lens.displayName.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'BellGothic', // Bell Gothic Black
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: NVSColors.primaryNeonMint,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildRefineView() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _showRefineView = false),
                child: Icon(
                  Icons.arrow_back,
                  color: NVSColors.primaryNeonMint,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'REFINE',
                style: TextStyle(
                  fontFamily: 'BellGothic',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: NVSColors.primaryNeonMint,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),

        // Refine options
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRefineSection('Position', [
                  'Top',
                  'Vers',
                  'Bottom',
                  'Side',
                ]),
                const SizedBox(height: 24),
                _buildRefineSection('Body Type', [
                  'Athletic',
                  'Average',
                  'Slim',
                  'Thick',
                  'Muscular',
                ]),
                const SizedBox(height: 24),
                _buildRefineSection('Age Range', [
                  '18-25',
                  '26-35',
                  '36-45',
                  '46+',
                ]),

                const Spacer(),

                // Apply button
                _buildApplyButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRefineSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: NVSColors.secondaryText,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) => _buildRefineChip(option)).toList(),
        ),
      ],
    );
  }

  Widget _buildRefineChip(String option) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: NVSColors.primaryNeonMint.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        option,
        style: TextStyle(
          fontFamily: 'MagdaCleanMono',
          fontSize: 12,
          color: NVSColors.primaryNeonMint,
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return GestureDetector(
      onTap: () => widget.onSelectLens(VibeLensType.refine),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: NVSColors.primaryNeonMint.withOpacity(0.2),
          border: Border.all(color: NVSColors.primaryNeonMint, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'APPLY FILTERS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'BellGothic',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: NVSColors.primaryNeonMint,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: _animateOut,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: NVSColors.secondaryText.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(Icons.close, color: NVSColors.secondaryText, size: 24),
      ),
    );
  }
}









