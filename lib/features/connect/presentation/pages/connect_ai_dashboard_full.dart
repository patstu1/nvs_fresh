// NVS Connect AI Dashboard (Prompt 1)
// Main AI command center with NVS hologram, stats, and match recommendations
// Colors: #000000 matte black background, #E4FFF0 mint only
// NO FILLS - only outline glows behind buttons and boxes

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectAIDashboardFull extends StatefulWidget {
  const ConnectAIDashboardFull({super.key});

  @override
  State<ConnectAIDashboardFull> createState() => _ConnectAIDashboardFullState();
}

class _ConnectAIDashboardFullState extends State<ConnectAIDashboardFull>
    with TickerProviderStateMixin {
  // Global NVS colors - mint and black only, no fills
  static const Color _mint = Color(0xFFE4FFF0);
  static const Color _black = Color(0xFF000000);
  
  // Helper for opacity variations
  Color _mintOpacity(double o) => _mint.withOpacity(o);

  late AnimationController _hologramController;
  late AnimationController _pulseController;
  late AnimationController _glowController;

  // Mock stats
  final int _totalMatches = 47;
  final int _pendingMatches = 12;
  final int _weeklyViews = 156;
  final int _compatibilityAvg = 78;

  @override
  void initState() {
    super.initState();
    _hologramController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _hologramController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildNVSHologramSection(),
              const SizedBox(height: 24),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildTopMatchesSection(),
              const SizedBox(height: 24),
              _buildAIInsightsSection(),
              const SizedBox(height: 24),
              _buildDeepProfileProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: _mint),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CONNECT AI',
                style: TextStyle(
                  color: _mint,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'Your AI-powered matchmaker',
                style: TextStyle(color: _mint.withOpacity(0.5), fontSize: 12),
              ),
            ],
          ),
        ),
        _buildGlowOutlineButton(
          child: const Icon(Icons.settings, color: _mint, size: 20),
          onTap: () {},
        ),
      ],
    );
  }

  // ============ NVS HOLOGRAM SECTION ============
  Widget _buildNVSHologramSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([_hologramController, _glowController]),
      builder: (context, child) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _mint.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: _mint.withOpacity(0.15 * _glowController.value),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background grid
                CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: _HologramBackgroundPainter(
                    animation: _hologramController.value,
                    color: _mint,
                  ),
                ),
                // NVS Hologram orb
                _buildHologramOrb(),
                // Greeting text
                Positioned(
                  bottom: 20,
                  child: Column(
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          color: _mint.withOpacity(0.9),
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap me to talk',
                        style: TextStyle(color: _mint.withOpacity(0.4), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHologramOrb() {
    return GestureDetector(
      onTap: _openNVSChat,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: 80 + (10 * _pulseController.value),
            height: 80 + (10 * _pulseController.value),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _mint.withOpacity(0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: _mint.withOpacity(0.3 * _pulseController.value + 0.1),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.auto_awesome,
                color: _mint,
                size: 32,
              ),
            ),
          );
        },
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '"Good morning. Ready to find your match?"';
    if (hour < 17) return '"Afternoon check-in. Any prospects today?"';
    if (hour < 21) return '"Evening vibes. Let\'s see who\'s out there."';
    return '"Late night mode. The best connections happen now."';
  }

  // ============ STATS GRID ============
  Widget _buildStatsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('YOUR STATS'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('Matches', '$_totalMatches', Icons.favorite)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Pending', '$_pendingMatches', Icons.hourglass_empty)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('Views', '$_weeklyViews', Icons.visibility)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Avg Match', '$_compatibilityAvg%', Icons.psychology)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _mint.withOpacity(0.05 * _glowController.value),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: _mint.withOpacity(0.7), size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: _mint,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(color: _mint.withOpacity(0.5), fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ============ QUICK ACTIONS ============
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('QUICK ACTIONS'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildActionButton('View Matches', Icons.people, () {})),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton('Deep Profile', Icons.psychology, () {})),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildActionButton('My ALTER', Icons.auto_awesome, () {})),
            const SizedBox(width: 12),
            Expanded(child: _buildActionButton('Preferences', Icons.tune, () {})),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _mint.withOpacity(0.08 * _glowController.value),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: _mint, size: 28),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: _mint,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============ TOP MATCHES SECTION ============
  Widget _buildTopMatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('TOP MATCHES'),
            GestureDetector(
              onTap: () {},
              child: Text('See all', style: TextStyle(color: _mint.withOpacity(0.6), fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => _buildMatchCard(index),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchCard(int index) {
    final scores = [94, 89, 87, 82, 78];
    final names = ['Alex', 'Jordan', 'Casey', 'Sam', 'Riley'];
    
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _mint.withOpacity(0.06 * _glowController.value),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile pic placeholder
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _mint.withOpacity(0.4), width: 2),
                ),
                child: Icon(Icons.person, color: _mint.withOpacity(0.3), size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                names[index],
                style: const TextStyle(color: _mint, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: _mint.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: _mint.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  '${scores[index]}%',
                  style: TextStyle(
                    color: _mint,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============ AI INSIGHTS SECTION ============
  Widget _buildAIInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('NVS INSIGHTS'),
        const SizedBox(height: 12),
        _buildInsightCard(
          Icons.trending_up,
          'Your profile is performing well',
          '+23% more views this week',
        ),
        const SizedBox(height: 8),
        _buildInsightCard(
          Icons.lightbulb,
          'Tip: Add more about your interests',
          'Profiles with 5+ interests get 40% more matches',
        ),
        const SizedBox(height: 8),
        _buildInsightCard(
          Icons.auto_awesome,
          'Chaos Match Available',
          'Someone outside your type might surprise you',
        ),
      ],
    );
  }

  Widget _buildInsightCard(IconData icon, String title, String subtitle) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: _mint.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _mint.withOpacity(0.05 * _glowController.value),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: _mint.withOpacity(0.7), size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: _mint, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: _mint.withOpacity(0.5), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: _mint.withOpacity(0.4), size: 14),
            ],
          ),
        );
      },
    );
  }

  // ============ DEEP PROFILE PROGRESS ============
  Widget _buildDeepProfileProgress() {
    const progress = 0.75;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('DEEP PROFILE'),
            Text('${(progress * 100).toInt()}% complete', style: TextStyle(color: _mint.withOpacity(0.6), fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: _mint.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _mint.withOpacity(0.08 * _glowController.value),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Progress bar - outline only
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _mint.withOpacity(0.3)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: _mint, width: 0.5),
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: _mint.withOpacity(0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Complete to unlock better matches',
                        style: TextStyle(color: _mint.withOpacity(0.7), fontSize: 13),
                      ),
                      _buildGlowOutlineButton(
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: _mint,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _mint.withOpacity(0.5),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildGlowOutlineButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, _) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: _mint.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _mint.withOpacity(0.15 * _glowController.value),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _openNVSChat() {
    HapticFeedback.mediumImpact();
    // TODO: Open NVS chat
  }
}

// ============ HOLOGRAM BACKGROUND PAINTER ============
class _HologramBackgroundPainter extends CustomPainter {
  final double animation;
  final Color color;

  _HologramBackgroundPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Animated grid
    const spacing = 30.0;
    final offset = animation * spacing;
    
    // Vertical lines
    for (double x = offset % spacing; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Horizontal lines
    for (double y = offset % spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HologramBackgroundPainter oldDelegate) =>
      animation != oldDelegate.animation;
}
