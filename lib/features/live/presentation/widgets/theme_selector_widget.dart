import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/room_theme.dart';

/// Theme selector widget with AI-curated themes and cyberpunk aesthetics.
///
/// Features:
/// - Multiple dynamic themes with previews
/// - AI-suggested themes based on room sentiment
/// - Premium theme indicators
/// - Smooth animations and transitions
/// - Cyberpunk styling with neon effects
class ThemeSelectorWidget extends StatefulWidget {
  const ThemeSelectorWidget({
    required this.currentTheme,
    required this.onThemeSelected,
    required this.onClose,
    super.key,
  });
  final RoomTheme currentTheme;
  final Function(RoomTheme) onThemeSelected;
  final VoidCallback onClose;

  @override
  State<ThemeSelectorWidget> createState() => _ThemeSelectorWidgetState();
}

class _ThemeSelectorWidgetState extends State<ThemeSelectorWidget> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _glowController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;

  RoomTheme? _selectedTheme;
  final bool _isPremiumUser = false; // This would be determined by user subscription

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _selectedTheme = widget.currentTheme;
  }

  @override
  void dispose() {
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Slide animation for overlay
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    // Glow animation for cyberpunk effect
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start animations
    _slideController.forward();
    _glowController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.8),
      child: SlideTransition(
        position: _slideAnimation,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xFF1A1A1A), Colors.black],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                // Header
                _buildHeader(),

                // Theme grid
                Expanded(child: _buildThemeGrid()),

                // Bottom actions
                _buildBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          const Icon(Icons.palette, color: Color(0xFF4BEFE0), size: 24),

          const SizedBox(width: 12),

          const Text(
            'Choose Theme',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // AI suggestion indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4BEFE0).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF4BEFE0).withValues(alpha: 0.5),
              ),
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.psychology, color: Color(0xFF4BEFE0), size: 16),
                SizedBox(width: 6),
                Text(
                  'AI Curated',
                  style: TextStyle(
                    color: Color(0xFF4BEFE0),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Close button
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close, color: Color(0xFF4BEFE0), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeGrid() {
    final Map<RoomTheme, ThemeConfig> themes = ThemeConfig.getAllThemes();

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: themes.length,
      itemBuilder: (BuildContext context, int index) {
        final ThemeConfig theme = themes.values.elementAt(index);
        final bool isSelected = _selectedTheme == theme.theme;
        final bool isPremium = theme.isPremium && !_isPremiumUser;

        return _buildThemeCard(theme, isSelected, isPremium);
      },
    );
  }

  Widget _buildThemeCard(ThemeConfig theme, bool isSelected, bool isPremium) {
    return GestureDetector(
      onTap: () {
        if (isPremium) {
          _showPremiumDialog();
        } else {
          setState(() {
            _selectedTheme = theme.theme;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4BEFE0)
                : const Color(0xFF4BEFE0).withValues(alpha: 0.3),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF4BEFE0).withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: <Widget>[
              // Theme background
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      theme.primaryColor.withValues(alpha: 0.3),
                      theme.secondaryColor.withValues(alpha: 0.2),
                      theme.accentColor.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: CustomPaint(painter: ThemePreviewPainter(theme)),
              ),

              // Overlay for premium themes
              if (isPremium)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.lock,
                          color: Color(0xFFFFD700),
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Theme info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        theme.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        theme.description,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Selected indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4BEFE0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.black, size: 16),
                  ),
                ),

              // Premium indicator
              if (theme.isPremium)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300)).scale(
          begin: const Offset(0.8, 0.8),
          duration: const Duration(milliseconds: 300),
        );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          // Cancel button
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onClose,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4BEFE0),
                side: const BorderSide(color: Color(0xFF4BEFE0)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Apply button
          Expanded(
            child: ElevatedButton(
              onPressed: _selectedTheme != null ? _applyTheme : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4BEFE0),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Theme',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyTheme() {
    if (_selectedTheme != null) {
      widget.onThemeSelected(_selectedTheme!);
    }
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Premium Theme',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'This theme is exclusive to premium users. Upgrade your account to unlock all premium themes and features.',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to premium upgrade
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
            ),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for theme preview backgrounds
class ThemePreviewPainter extends CustomPainter {
  ThemePreviewPainter(this.theme);
  final ThemeConfig theme;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw animated grid pattern
    const double gridSpacing = 20.0;

    paint.color = theme.primaryColor.withValues(alpha: 0.3);

    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw accent circles
    paint.color = theme.accentColor.withValues(alpha: 0.2);
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 15, paint);

    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.7), 20, paint);

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.8), 10, paint);
  }

  @override
  bool shouldRepaint(ThemePreviewPainter oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
