import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/nvs_colors.dart';

class GridViewWidget extends ConsumerStatefulWidget {
  const GridViewWidget({super.key});

  @override
  ConsumerState<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends ConsumerState<GridViewWidget> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<MockUser> _mockUsers = <MockUser>[
    MockUser(
      id: '1',
      username: 'AlexFlex',
      role: 'Top',
      tags: <String>['Kinky', 'Dominant'],
      matchPercentage: 94,
    ),
    MockUser(
      id: '2',
      username: 'SamStorm',
      role: 'Vers Top',
      tags: <String>['Romantic', 'Switch'],
      matchPercentage: 87,
    ),
    MockUser(
      id: '3',
      username: 'JordanWild',
      role: 'Bottom',
      tags: <String>['Experimental', 'Submissive'],
      matchPercentage: 92,
    ),
    MockUser(
      id: '4',
      username: 'CaseyBlaze',
      role: 'Power Bottom',
      tags: <String>['Primal', 'Rough'],
      matchPercentage: 89,
    ),
    MockUser(
      id: '5',
      username: 'RileyPulse',
      role: 'Vers',
      tags: <String>['Gentle', 'Service'],
      matchPercentage: 85,
    ),
    MockUser(
      id: '6',
      username: 'TaylorNeon',
      role: 'Top Dom',
      tags: <String>['Vanilla', 'Caring'],
      matchPercentage: 91,
    ),
    MockUser(
      id: '7',
      username: 'MorganGlow',
      role: 'Vers Bottom',
      tags: <String>['Brat', 'Playful'],
      matchPercentage: 88,
    ),
    MockUser(
      id: '8',
      username: 'BlakeThunder',
      role: 'Top',
      tags: <String>['Kinky', 'Intense'],
      matchPercentage: 93,
    ),
    MockUser(
      id: '9',
      username: 'AveryShine',
      role: 'Bottom',
      tags: <String>['Sweet', 'Caring'],
      matchPercentage: 86,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: AppBar(
        backgroundColor: NVSColors.pureBlack,
        elevation: 0,
        title: Text(
          'GRID',
          style: TextStyle(
            color: NVSColors.ultraLightMint,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: NVSFonts.primary,
            letterSpacing: 2,
            shadows: <Shadow>[
              Shadow(color: NVSColors.ultraLightMint.withValues(alpha: 0.5), blurRadius: 8),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.tune, color: NVSColors.ultraLightMint),
            onPressed: () {
              // Open filters
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Search bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: NVSColors.cardBackground,
              borderRadius: BorderRadius.circular(25),
              border:
                  Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.35), width: 1.6),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: NVSColors.ultraLightMint.withValues(alpha: 0.10),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.search, color: NVSColors.secondaryText, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: NVSColors.ultraLightMint, fontFamily: NVSFonts.primary),
                    decoration: InputDecoration(
                      hintText: 'Search by role, tags, or vibe...',
                      hintStyle: TextStyle(
                        color: NVSColors.secondaryText,
                        fontFamily: NVSFonts.primary,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid content
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _mockUsers.length,
              itemBuilder: (BuildContext context, int index) {
                final MockUser user = _mockUsers[index];
                return _buildUserCard(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(MockUser user) {
    return GestureDetector(
      onTap: () => _handleUserTap(user),
      onLongPress: () => _handleUserLongPress(user),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (BuildContext context, Widget? child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: NVSColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.40), width: 1.8),
              boxShadow: user.matchPercentage > 90
                  ? <BoxShadow>[
                      BoxShadow(
                        color:
                            NVSColors.ultraLightMint.withValues(alpha: _glowAnimation.value * 0.45),
                        blurRadius: 22,
                        spreadRadius: 4,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: <Widget>[
                // Avatar
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                        width: 1.4,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: NVSColors.ultraLightMint.withValues(alpha: 0.08),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user.username[0].toUpperCase(),
                        style: const TextStyle(
                          color: NVSColors.ultraLightMint,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: NVSFonts.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                // User info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: <Widget>[
                        Text(
                          user.username,
                          style: const TextStyle(
                            color: NVSColors.ultraLightMint,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: NVSFonts.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2),

                        Text(
                          user.role,
                          style: const TextStyle(
                            color: NVSColors.secondaryText,
                            fontSize: 10,
                            fontFamily: NVSFonts.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // Match percentage
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getMatchColor(user.matchPercentage).withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getMatchColor(user.matchPercentage).withValues(alpha: 0.55),
                              width: 0.8,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: _getMatchColor(user.matchPercentage).withValues(alpha: 0.18),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Text(
                            '${user.matchPercentage}%',
                            style: TextStyle(
                              color: _getMatchColor(user.matchPercentage),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: NVSFonts.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getMatchColor(int percentage) {
    if (percentage >= 90) return NVSColors.ultraLightMint;
    if (percentage >= 80) return NVSColors.avocadoGreen;
    if (percentage >= 70) return NVSColors.turquoiseNeon;
    return NVSColors.electricPink;
  }

  void _handleUserTap(MockUser user) {
    // Show user profile modal
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => _buildUserProfileModal(user),
    );
  }

  void _handleUserLongPress(MockUser user) {
    // Add to favorites with haptic feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user.username} added to favorites'),
        backgroundColor: NVSColors.avocadoGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildUserProfileModal(MockUser user) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.45), width: 1.8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.ultraLightMint.withValues(alpha: 0.12),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: NVSColors.secondaryText,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Profile content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  // Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: NVSColors.ultraLightMint.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user.username[0].toUpperCase(),
                        style: const TextStyle(
                          color: NVSColors.ultraLightMint,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: NVSFonts.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    user.username,
                    style: const TextStyle(
                      color: NVSColors.ultraLightMint,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: NVSFonts.primary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    user.role,
                    style: const TextStyle(
                      color: NVSColors.secondaryText,
                      fontSize: 16,
                      fontFamily: NVSFonts.primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tags
                  Wrap(spacing: 8, runSpacing: 8, children: user.tags.map(_buildTag).toList()),

                  const SizedBox(height: 20),

                  // Match percentage
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: _getMatchColor(user.matchPercentage).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getMatchColor(user.matchPercentage).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '${user.matchPercentage}% MATCH',
                      style: TextStyle(
                        color: _getMatchColor(user.matchPercentage),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: NVSFonts.primary,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Action buttons
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _buildActionButton(
                          'MESSAGE',
                          NVSColors.ultraLightMint,
                          () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          'YO',
                          NVSColors.avocadoGreen,
                          () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NVSColors.ultraLightMint.withValues(alpha: 0.4), width: 1.2),
        boxShadow: <BoxShadow>[
          BoxShadow(color: NVSColors.ultraLightMint.withValues(alpha: 0.08), blurRadius: 10),
        ],
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: NVSColors.ultraLightMint,
          fontSize: 12,
          fontFamily: NVSFonts.secondary,
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.4),
        boxShadow: <BoxShadow>[
          BoxShadow(color: color.withValues(alpha: 0.16), blurRadius: 18, spreadRadius: 1),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: NVSFonts.primary,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MockUser {
  MockUser({
    required this.id,
    required this.username,
    required this.role,
    required this.tags,
    required this.matchPercentage,
  });
  final String id;
  final String username;
  final String role;
  final List<String> tags;
  final int matchPercentage;
}
