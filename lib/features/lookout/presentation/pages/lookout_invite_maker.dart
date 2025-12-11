// NVS Lookout Invite Maker (Prompt 45)
// Canva-style invite creation for custom rooms
// AI theme generation similar to Midjourney style
// Templates, customization, and sharing options

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LookoutInviteMaker extends StatefulWidget {
  final String? roomId;
  final String? roomName;

  const LookoutInviteMaker({
    super.key,
    this.roomId,
    this.roomName,
  });

  @override
  State<LookoutInviteMaker> createState() => _LookoutInviteMakerState();
}

class _LookoutInviteMakerState extends State<LookoutInviteMaker>
    with TickerProviderStateMixin {
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _olive = Color(0xFFE4FFF0);
  static const Color _aqua = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);

  late AnimationController _glowController;
  late AnimationController _pulseController;

  int _selectedTemplateIndex = 0;
  int _selectedThemeIndex = 0;
  bool _isGenerating = false;
  bool _showAIPrompt = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _aiPromptController = TextEditingController();

  // Template styles
  final List<_InviteTemplate> _templates = [
    _InviteTemplate('Minimal', Icons.lens_blur, [_mint, _black]),
    _InviteTemplate('Neon', Icons.flash_on, [_aqua, Colors.purple]),
    _InviteTemplate('Gradient', Icons.gradient, [Colors.deepPurple, _aqua]),
    _InviteTemplate('Dark', Icons.dark_mode, [_black, _olive]),
    _InviteTemplate('Glow', Icons.auto_awesome, [_aqua, _mint]),
    _InviteTemplate('Bold', Icons.format_bold, [Colors.red, Colors.orange]),
  ];

  // AI-generated themes (Midjourney-style)
  final List<_AITheme> _aiThemes = [
    _AITheme('Cyberpunk Night', 'Neon-lit streets, rain-soaked reflections'),
    _AITheme('Ethereal Dreams', 'Soft glows, floating particles, dreamscape'),
    _AITheme('Industrial Edge', 'Metal textures, harsh lighting, raw power'),
    _AITheme('Tropical Heat', 'Sunset vibes, palm silhouettes, warm hues'),
    _AITheme('Cosmic Void', 'Deep space, starfields, nebula colors'),
    _AITheme('Urban Jungle', 'Concrete meets nature, green overtones'),
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.roomName ?? 'My Room';
    _subtitleController.text = 'Join the vibe';
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _aiPromptController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPreview(),
                    const SizedBox(height: 24),
                    _buildTextCustomization(),
                    const SizedBox(height: 24),
                    _buildTemplateSelector(),
                    const SizedBox(height: 24),
                    _buildAIThemeSection(),
                    const SizedBox(height: 24),
                    _buildShareOptions(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: _mint),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'CREATE INVITE',
              style: TextStyle(
                color: _mint,
                fontSize: 18,
                fontWeight: FontWeight.w300,
                letterSpacing: 3,
              ),
            ),
          ),
          GestureDetector(
            onTap: _saveInvite,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _aqua,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'SAVE',
                style: TextStyle(
                  color: _black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final template = _templates[_selectedTemplateIndex];
    
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: template.colors,
            ),
            border: Border.all(color: _aqua.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: template.colors.first.withOpacity(0.3 * _glowController.value),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative elements based on template
              _buildTemplateDecoration(template),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Room title
                    Text(
                      _titleController.text.toUpperCase(),
                      style: const TextStyle(
                        color: _mint,
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      _subtitleController.text,
                      style: TextStyle(
                        color: _mint.withOpacity(0.7),
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Join button preview
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: _aqua),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: _aqua.withOpacity(0.5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: const Text(
                        'TAP TO JOIN',
                        style: TextStyle(
                          color: _aqua,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // NVS watermark
              Positioned(
                bottom: 12,
                right: 12,
                child: Text(
                  'NVS',
                  style: TextStyle(
                    color: _mint.withOpacity(0.3),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemplateDecoration(_InviteTemplate template) {
    switch (template.name) {
      case 'Neon':
        return CustomPaint(
          size: const Size(double.infinity, 220),
          painter: _NeonLinesPainter(_glowController.value),
        );
      case 'Glow':
        return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0 + (0.2 * _pulseController.value),
                  colors: [
                    _aqua.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextCustomization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('CUSTOMIZE TEXT'),
        const SizedBox(height: 12),
        // Title input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _mint.withOpacity(0.2)),
          ),
          child: TextField(
            controller: _titleController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: _mint),
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(color: _olive),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Subtitle input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _mint.withOpacity(0.2)),
          ),
          child: TextField(
            controller: _subtitleController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: _mint),
            decoration: InputDecoration(
              labelText: 'Subtitle',
              labelStyle: TextStyle(color: _olive),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('TEMPLATES'),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _templates.length,
            itemBuilder: (context, index) {
              final template = _templates[index];
              final isSelected = _selectedTemplateIndex == index;
              
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedTemplateIndex = index);
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: template.colors,
                    ),
                    border: Border.all(
                      color: isSelected ? _aqua : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: _aqua.withOpacity(0.4), blurRadius: 10)]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(template.icon, color: _mint, size: 24),
                      const SizedBox(height: 6),
                      Text(
                        template.name,
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAIThemeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: _aqua, size: 16),
                const SizedBox(width: 8),
                _buildSectionHeader('AI THEMES'),
              ],
            ),
            GestureDetector(
              onTap: () => setState(() => _showAIPrompt = !_showAIPrompt),
              child: Text(
                _showAIPrompt ? 'Hide' : 'Custom',
                style: TextStyle(color: _aqua, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // AI prompt input (toggleable)
        if (_showAIPrompt) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _aqua.withOpacity(0.4)),
              gradient: LinearGradient(
                colors: [_aqua.withOpacity(0.1), Colors.transparent],
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _aiPromptController,
                  maxLines: 2,
                  style: const TextStyle(color: _mint),
                  decoration: InputDecoration(
                    hintText: 'Describe your theme (e.g., "neon tokyo nightlife")',
                    hintStyle: TextStyle(color: _olive),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _generateAITheme,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _aqua,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: _isGenerating
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(_black),
                              ),
                            )
                          : const Text(
                              'GENERATE WITH AI',
                              style: TextStyle(
                                color: _black,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        // Pre-made AI themes
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _aiThemes.length,
            itemBuilder: (context, index) {
              final theme = _aiThemes[index];
              final isSelected = _selectedThemeIndex == index;
              
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedThemeIndex = index);
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? _aqua : _mint.withOpacity(0.2),
                    ),
                    color: isSelected ? _aqua.withOpacity(0.1) : Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        theme.name,
                        style: TextStyle(
                          color: isSelected ? _aqua : _mint,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        theme.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _olive, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShareOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SHARE'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildShareButton(Icons.copy, 'Copy Link', _copyLink),
            _buildShareButton(Icons.share, 'Share', _shareInvite),
            _buildShareButton(Icons.qr_code, 'QR Code', _showQRCode),
            _buildShareButton(Icons.download, 'Save Image', _saveImage),
          ],
        ),
      ],
    );
  }

  Widget _buildShareButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _aqua.withOpacity(0.5)),
            ),
            child: Icon(icon, color: _aqua, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: _mint.withOpacity(0.8), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _olive,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
  }

  void _generateAITheme() async {
    if (_aiPromptController.text.trim().isEmpty) return;
    
    setState(() => _isGenerating = true);
    HapticFeedback.mediumImpact();
    
    // Simulate AI generation
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isGenerating = false);
    HapticFeedback.heavyImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Theme generated!'),
        backgroundColor: _aqua,
      ),
    );
  }

  void _copyLink() {
    HapticFeedback.selectionClick();
    Clipboard.setData(const ClipboardData(text: 'https://nvs.app/room/invite/abc123'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Link copied!'),
        backgroundColor: _aqua,
      ),
    );
  }

  void _shareInvite() {
    HapticFeedback.selectionClick();
    // Native share
  }

  void _showQRCode() {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: _mint.withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'SCAN TO JOIN',
                style: TextStyle(
                  color: _mint,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _mint,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.qr_code, color: _black, size: 150),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: _olive),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveImage() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Invite saved to photos!'),
        backgroundColor: _aqua,
      ),
    );
  }

  void _saveInvite() {
    HapticFeedback.mediumImpact();
    Navigator.pop(context);
  }
}

// ============ DATA MODELS ============
class _InviteTemplate {
  final String name;
  final IconData icon;
  final List<Color> colors;

  _InviteTemplate(this.name, this.icon, this.colors);
}

class _AITheme {
  final String name;
  final String description;

  _AITheme(this.name, this.description);
}

// ============ NEON LINES PAINTER ============
class _NeonLinesPainter extends CustomPainter {
  final double animation;

  _NeonLinesPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE4FFF0).withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw animated diagonal lines
    for (int i = 0; i < 10; i++) {
      final offset = (animation * 50 + i * 30) % size.width;
      canvas.drawLine(
        Offset(offset, 0),
        Offset(offset - 50, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NeonLinesPainter oldDelegate) =>
      animation != oldDelegate.animation;
}

