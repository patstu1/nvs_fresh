import 'package:flutter/material.dart';
import 'dart:math';
import 'package:nvs/features/connect/presentation/synaptic_match_card.dart';
import 'package:nvs/features/messenger/presentation/universal_messaging_sheet.dart';

class ConnectMatchDetailPage extends StatelessWidget {
  const ConnectMatchDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Subtle grid overlay
          Positioned.fill(child: _CyberpunkGrid()),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 12),
                    // Synaptic neon match card with unified CTA
                    SynapticMatchCard(
                      leftImageUrl: 'assets/images/IMG_2217 2.jpg',
                      rightImageUrl: 'assets/images/IMG_2223 2.jpg',
                      matchPercent: 87,
                      sharedInterests: const <String, double>{
                        'values': 0.82,
                        'music': 0.66,
                        'nightlife': 0.58,
                        'style': 0.74,
                      },
                      badges: const <String>['chemistry', 'signal', 'trust', 'kink'],
                      onMessageNow: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext ctx) {
                            return const UniversalMessagingSheet(
                              section: MessagingSection.connect,
                              targetUserId: 'connect_user_1',
                              displayName: 'alex',
                            );
                          },
                        );
                      },
                      titleTop: 'match details',
                      primaryName: 'alex',
                      secondaryName: 'jordan',
                      verified: true,
                    ),
                    const SizedBox(height: 28),
                    // Comparison Metrics
                    _ComparisonMetrics(),
                    const SizedBox(height: 28),
                    // AI Diagnostic Box
                    _AIDiagnosticBox(),
                    const SizedBox(height: 28),
                    // Shared Interests & Data
                    _SharedInterestsSection(),
                    const SizedBox(height: 32),
                    // AI Companion
                    _AICompanion(),
                    const SizedBox(height: 32),
                    // Interaction Buttons (kept for additional actions)
                    _InteractionButtons(),
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

// --- Cyberpunk Grid Overlay ---
class _CyberpunkGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const double gridSpacing = 36.0;
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- Split Match Display ---
class _SplitMatchDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // Glowing split rings
        SizedBox(
          width: 180,
          height: 180,
          child: CustomPaint(
            painter: _SplitRingPainter(),
          ),
        ),
        // Avatars
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _AvatarCircle(
              image: 'https://randomuser.me/api/portraits/men/32.jpg',
              glowColor: Colors.cyanAccent,
              username: 'ALEX',
              age: 29,
              left: true,
            ),
            _AvatarCircle(
              image: 'https://randomuser.me/api/portraits/men/45.jpg',
              glowColor: Colors.pinkAccent,
              username: 'JORDAN',
              age: 31,
              left: false,
            ),
          ],
        ),
        // Top badge overlay
        const Positioned(
          top: 0,
          child: _CompatibilityBadge(
            percent: 87,
            aiRank: 'HIGH',
            color: Colors.greenAccent,
          ),
        ),
      ],
    );
  }
}

class _SplitRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Paint paintLeft = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final Paint paintRight = Paint()
      ..color = Colors.pinkAccent.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 80),
      pi / 2,
      pi,
      false,
      paintLeft,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 80),
      -pi / 2,
      pi,
      false,
      paintRight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.image,
    required this.glowColor,
    required this.username,
    required this.age,
    required this.left,
  });
  final String image;
  final Color glowColor;
  final String username;
  final int age;
  final bool left;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: left ? 0 : 12, right: left ? 12 : 0),
      child: Column(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.7),
                  blurRadius: 32,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 44,
              backgroundImage: NetworkImage(image),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$username, $age',
            style: TextStyle(
              color: glowColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompatibilityBadge extends StatelessWidget {
  const _CompatibilityBadge({required this.percent, required this.aiRank, required this.color});
  final int percent;
  final String aiRank;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$percent%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Potential: $aiRank',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Comparison Metrics ---
class _ComparisonMetrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const _MetricBar(
          label: 'Communication',
          left: 'Direct',
          right: 'Passive',
          value: 0.7,
          color: Colors.cyanAccent,
        ),
        const _MetricBar(
          label: 'Attachment',
          left: 'Secure',
          right: 'Anxious',
          value: 0.5,
          color: Colors.pinkAccent,
        ),
        const _MetricBar(
          label: 'Sexual Compatibility',
          left: 'High',
          right: 'Low',
          value: 0.85,
          color: Colors.amberAccent,
        ),
        const _MetricBar(
          label: 'Emotional Sync',
          left: 'High',
          right: 'Low',
          value: 0.62,
          color: Colors.purpleAccent,
        ),
        const _MetricBar(
          label: 'Lifestyle Rhythm',
          left: 'Night',
          right: 'Day',
          value: 0.3,
          color: Colors.greenAccent,
        ),
        const _MetricBar(
          label: 'Zodiac',
          left: '♎',
          right: '♈',
          value: 0.9,
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 18),
        _MiniBarChart(),
      ],
    );
  }
}

class _MetricBar extends StatelessWidget {
  const _MetricBar({
    required this.label,
    required this.left,
    required this.right,
    required this.value,
    required this.color,
  });
  final String label;
  final String left;
  final String right;
  final double value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(left, style: TextStyle(color: color, fontSize: 12)),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(right, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: <Widget>[
              Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color.withValues(alpha: 0.18),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                height: 12,
                width: MediaQuery.of(context).size.width * 0.8 * value,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: <Color>[color, Colors.white.withValues(alpha: 0.2)],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<double> bars = <double>[0.7, 0.5, 0.9];
    final List<String> labels = <String>['Values', 'Music', 'Nightlife'];
    final List<MaterialAccentColor> colors = <MaterialAccentColor>[
      Colors.cyanAccent,
      Colors.pinkAccent,
      Colors.amberAccent,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(bars.length, (int i) {
        return Column(
          children: <Widget>[
            Container(
              width: 18,
              height: 54,
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                height: 54 * bars[i],
                width: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: <Color>[colors[i], Colors.white.withValues(alpha: 0.2)],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colors[i].withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(labels[i], style: TextStyle(color: colors[i], fontSize: 11)),
          ],
        );
      }),
    );
  }
}

// --- AI Diagnostic Box ---
class _AIDiagnosticBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amberAccent, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.amberAccent.withValues(alpha: 0.18),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.amberAccent,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'AI Insight',
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'This user’s emotional pattern mirrors yours closely. Suggested approach: flirty, but low-pressure. Estimated relationship sync: 84%.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
            child: const Text('Expand Compatibility Report'),
          ),
        ],
      ),
    );
  }
}

// --- Shared Interests & Data ---
class _SharedInterestsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _DonutChart(percent: 0.82),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _CategoryChip(label: 'Vibes', color: Colors.cyanAccent),
                _CategoryChip(label: 'Kinks', color: Colors.pinkAccent),
                _CategoryChip(label: 'Mood', color: Colors.amberAccent),
                _CategoryChip(label: 'Style', color: Colors.greenAccent),
                _CategoryChip(label: 'Travel', color: Colors.purpleAccent),
                _CategoryChip(label: 'Astrology', color: Colors.blueAccent),
              ],
            ),
          ],
        ),
        SizedBox(height: 18),
        Text(
          'Aesthetic alignment with their Instagram is 92%',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _CompatIcon(
              icon: Icons.science,
              label: 'DNA Match',
              color: Colors.cyanAccent,
            ),
            _CompatIcon(
              icon: Icons.flash_on,
              label: 'Mood Sync',
              color: Colors.amberAccent,
            ),
            _CompatIcon(
              icon: Icons.balance,
              label: 'Star Sign',
              color: Colors.purpleAccent,
            ),
            _CompatIcon(
              icon: Icons.psychology,
              label: 'Comm. Freq',
              color: Colors.greenAccent,
            ),
          ],
        ),
      ],
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.percent});
  final double percent;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ShaderMask(
            shaderCallback: (Rect rect) => const SweepGradient(
              colors: <Color>[
                Colors.cyanAccent,
                Colors.pinkAccent,
                Colors.amberAccent,
                Colors.greenAccent,
                Colors.cyanAccent,
              ],
              stops: <double>[0.0, 0.3, 0.6, 0.85, 1.0],
            ).createShader(rect),
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 12,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Text(
            '${(percent * 100).toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _CompatIcon extends StatelessWidget {
  const _CompatIcon({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}

// --- AI Companion ---
class _AICompanion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.cyanAccent, width: 1.5),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.cyanAccent.withValues(alpha: 0.18),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Row(
            children: <Widget>[
              Icon(Icons.android, color: Colors.cyanAccent, size: 32),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'NEON',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Would you like to learn what makes this match so rare?',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Interaction Buttons ---
class _InteractionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _ActionButton(
          label: 'Message Now',
          icon: Icons.chat_bubble_outline,
          color: Colors.cyanAccent,
        ),
        _ActionButton(
          label: 'Analyze Again',
          icon: Icons.psychology,
          color: Colors.amberAccent,
        ),
        _ActionButton(
          label: 'Save Match',
          icon: Icons.bookmark_outline,
          color: Colors.greenAccent,
        ),
        _ActionButton(
          label: 'Next',
          icon: Icons.refresh,
          color: Colors.pinkAccent,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        elevation: 8,
        shadowColor: color.withValues(alpha: 0.4),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}
