// lib/features/connect/presentation/widgets/nvs_match_card.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ---------- PALETTE ----------
class NvsPalette {
  static const Color bg = Color(0xFF05080A);
  static const Color gridLine = Color(0xFF0C1C1C);
  static const Color mint = Color(0xFFE4FFF0); // ultra-light neon mint
  static const Color cyan = Color(0xFF00F5FF); // neon cyan
  static const Color pink = Color(0xFFFF41D6); // neon pink
  static const Color lemon = Color(0xFFB8FF5C); // accent for charts (optional)
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF91A3A3);
}

/// ---------- TEXT STYLES ----------
class NvsText {
  // Use 'BellGothic' as defined in pubspec (rename here if your family name differs)
  static TextStyle title(BuildContext c) => const TextStyle(
        fontFamily: 'BellGothic',
        letterSpacing: 2.0,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: NvsPalette.mint,
      );

  static TextStyle labelMono(BuildContext c) => const TextStyle(
        fontFamily: 'MagdaCleanMono',
        letterSpacing: 1.1,
        fontSize: 12,
        color: NvsPalette.white,
      );

  static TextStyle smallMonoFaint(BuildContext c) => const TextStyle(
        fontFamily: 'MagdaCleanMono',
        letterSpacing: 1.0,
        fontSize: 10,
        color: Color(0xCCB7D7D7),
      );
}

/// ---------- DATA MODELS ----------
class NvsStat {
  const NvsStat({required this.icon, required this.label});
  final Widget icon; // pass an SVG/Icon already styled in neon
  final String label;
}

class NvsBarDatum { // 0..1
  const NvsBarDatum(this.key, this.value);
  final String key;
  final double value;
}

class NvsDonutSlice {
  const NvsDonutSlice(this.value, this.color);
  final double value; // raw; widget will normalize
  final Color color;
}

/// ---------- MAIN CARD ----------
class NvsMatchCard extends StatefulWidget {
  const NvsMatchCard({
    required this.leftImage, required this.rightImage, required this.compatibility, required this.stats, required this.bars, required this.donut, required this.onMessage, super.key,
    this.onPass,
  });

  final ImageProvider leftImage;
  final ImageProvider rightImage;
  final double compatibility; // 0..1 displayed as XX.X%
  final List<NvsStat> stats; // 4–5 items
  final List<NvsBarDatum> bars; // 5–7 items
  final List<NvsDonutSlice> donut; // 3–6 slices
  final VoidCallback onMessage;
  final VoidCallback? onPass;

  @override
  State<NvsMatchCard> createState() => _NvsMatchCardState();
}

class _NvsMatchCardState extends State<NvsMatchCard> with TickerProviderStateMixin {
  late final AnimationController _breath; // ring, glows
  late final AnimationController _stagger; // content reveal

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _stagger = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  }

  @override
  void dispose() {
    _breath.dispose();
    _stagger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String pctText = (widget.compatibility * 100).clamp(0, 100).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        color: NvsPalette.bg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(color: NvsPalette.cyan.withOpacity(.07), blurRadius: 30),
        ],
        border: Border.all(color: NvsPalette.gridLine),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // HEADER
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text('MATCH DETAILS', style: NvsText.title(context)),
          ],),
          const SizedBox(height: 10),
          // SPLIT PORTRAIT + PERCENT
          _SplitPortrait(
            left: widget.leftImage,
            right: widget.rightImage,
            breath: _breath,
            center: _NeonPercent(pct: pctText),
          ),
          const SizedBox(height: 18),

          // STAT PILLS ROW
          _StaggerIn(controller: _stagger, index: 0, child: _StatPillsRow(stats: widget.stats)),
          const SizedBox(height: 12),

          // SHARED INTERESTS / BAR CHART
          _StaggerIn(
            controller: _stagger,
            index: 1,
            child: Row(
              children: <Widget>[
                Expanded(flex: 11, child: _DonutGauge(slices: widget.donut)),
                const SizedBox(width: 12),
                Expanded(flex: 12, child: _NeonBarChart(bars: widget.bars)),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // CTA ROW
          _StaggerIn(
            controller: _stagger,
            index: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _NvsButton.outline(label: '✕ PASS', onTap: widget.onPass ?? () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NvsButton.filled(label: 'MESSAGE NOW', onTap: widget.onMessage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- SPLIT PORTRAIT WIDGET ----------
class _SplitPortrait extends StatelessWidget {
  const _SplitPortrait({required this.left, required this.right, required this.center, required this.breath});
  final ImageProvider left;
  final ImageProvider right;
  final Widget center;
  final AnimationController breath;

  @override
  Widget build(BuildContext context) {
    const double size = 240;
    return SizedBox(
      height: size + 26,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Glow ring painter
          AnimatedBuilder(
            animation: breath,
            builder: (_, __) => CustomPaint(size: const Size(size, size), painter: _NeonRingPainter(breathValue: breath.value)),
          ),
          // Clip left half
          SizedBox(
            width: size,
            height: size,
            child: ClipPath(
              clipper: _HalfCircleClipper(isLeft: true),
              child: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: left, fit: BoxFit.cover)),
              ),
            ),
          ),
          // Clip right half
          SizedBox(
            width: size,
            height: size,
            child: ClipPath(
              clipper: _HalfCircleClipper(isLeft: false),
              child: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: right, fit: BoxFit.cover)),
              ),
            ),
          ),
          // Center percent
          center,
        ],
      ),
    );
  }
}

class _HalfCircleClipper extends CustomClipper<Path> {
  _HalfCircleClipper({required this.isLeft});
  final bool isLeft;

  @override
  Path getClip(Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Path path = Path()..addOval(rect);
    final Rect half = Rect.fromLTWH(isLeft ? 0 : size.width / 2, 0, size.width / 2, size.height);
    return Path.combine(PathOperation.intersect, path, Path()..addRect(half));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _NeonRingPainter extends CustomPainter {
  _NeonRingPainter({required this.breathValue});
  final double breathValue; // 0..1

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final double r = size.width / 2;
    final Offset center = Offset(r, r);

    // Base ring (thin)
    final Paint base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(.25);
    canvas.drawCircle(center, r - 1, base);

    // Glow strength breathing
    final double glow = 14.0 + 10.0 * math.sin(breathValue * math.pi);

    // Left arc (pink)
    final Paint pink = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7
      ..color = NvsPalette.pink.withOpacity(.95)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glow);
    canvas.drawArc(rect.deflate(5), -math.pi / 2, math.pi, false, pink);

    // Right arc (cyan)
    final Paint cyan = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7
      ..color = NvsPalette.cyan.withOpacity(.95)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glow);
    canvas.drawArc(rect.deflate(5), math.pi / 2, math.pi, false, cyan);
  }

  @override
  bool shouldRepaint(covariant _NeonRingPainter old) => old.breathValue != breathValue;
}

class _NeonPercent extends StatelessWidget {
  const _NeonPercent({required this.pct});
  final String pct;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ShaderMask(
          shaderCallback: (Rect rect) => const LinearGradient(colors: <Color>[NvsPalette.mint, NvsPalette.cyan]).createShader(rect),
          child: Text(
            '$pct%',
            style: const TextStyle(
              fontFamily: 'BellGothic',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white, // masked
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text('COMPATIBILITY', style: NvsText.smallMonoFaint(context)),
      ],
    );
  }
}

/// ---------- STAT PILLS ----------
class _StatPillsRow extends StatelessWidget {
  const _StatPillsRow({required this.stats});
  final List<NvsStat> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: stats.map((NvsStat s) => _NeonPill(icon: s.icon, label: s.label)).toList(),
    );
  }
}

class _NeonPill extends StatelessWidget {
  const _NeonPill({required this.icon, required this.label});
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF061014),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NvsPalette.gridLine),
        boxShadow: <BoxShadow>[
          BoxShadow(color: NvsPalette.cyan.withOpacity(.18), blurRadius: 18, spreadRadius: -4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        icon,
        const SizedBox(width: 6),
        Text(label.toUpperCase(), style: NvsText.labelMono(context)),
      ],),
    );
  }
}

/// ---------- BAR CHART ----------
class _NeonBarChart extends StatefulWidget {
  const _NeonBarChart({required this.bars});
  final List<NvsBarDatum> bars;

  @override
  State<_NeonBarChart> createState() => _NeonBarChartState();
}

class _NeonBarChartState extends State<_NeonBarChart> with SingleTickerProviderStateMixin {
  late final AnimationController _a;

  @override
  void initState() {
    super.initState();
    _a = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  }

  @override
  void dispose() {
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedBuilder(
        animation: _a,
        builder: (_, __) {
          final List<NvsBarDatum> bars = widget.bars;
          return CustomPaint(painter: _BarPainter(bars: bars, t: Curves.easeOut.transform(_a.value)));
        },
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter({required this.bars, required this.t});
  final List<NvsBarDatum> bars;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final int n = bars.length.clamp(1, 12);
    const double gap = 8.0;
    final double w = (size.width - gap * (n - 1)) / n;

    final Paint paint = Paint()..style = PaintingStyle.fill..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    for (int i = 0; i < n; i++) {
      final double v = bars[i].value.clamp(0.0, 1.0) * t;
      final double h = (size.height - 8) * v;
      final double x = i * (w + gap);
      final Rect rect = Rect.fromLTWH(x, size.height - h, w, h);

      // gradient cyan->pink to match reference
      paint.shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: <Color>[NvsPalette.cyan, NvsPalette.pink],
      ).createShader(rect);

      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) => old.t != t || old.bars != bars;
}

/// ---------- DONUT GAUGE ----------
class _DonutGauge extends StatefulWidget {
  const _DonutGauge({required this.slices});
  final List<NvsDonutSlice> slices;

  @override
  State<_DonutGauge> createState() => _DonutGaugeState();
}

class _DonutGaugeState extends State<_DonutGauge> with SingleTickerProviderStateMixin {
  late final AnimationController _a;

  @override
  void initState() {
    super.initState();
    _a = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  }

  @override
  void dispose() {
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: AnimatedBuilder(
        animation: _a,
        builder: (_, __) => CustomPaint(painter: _DonutPainter(widget.slices, Curves.easeOutBack.transform(_a.value))),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.slices, this.t);
  final List<NvsDonutSlice> slices;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final double total = slices.fold<double>(0, (double p, NvsDonutSlice e) => p + e.value).clamp(0.0001, 1e9);
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Offset center = rect.center;
    final double r = size.shortestSide / 2;

    // background ring
    final Paint bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..color = const Color(0x2236E2E2);
    canvas.drawCircle(center, r - 10, bg);

    // slices
    double start = -math.pi / 2;
    for (final NvsDonutSlice s in slices) {
      final double sweep = (s.value / total) * 2 * math.pi * t;
      final Paint p = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 16
        ..color = s.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(rect.deflate(10), start, sweep, false, p);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => old.t != t || old.slices != slices;
}

/// ---------- CTA BUTTONS ----------
class _NvsButton extends StatelessWidget {

  factory _NvsButton.filled({required String label, required VoidCallback onTap}) => _NvsButton._(label, onTap, true);
  factory _NvsButton.outline({required String label, required VoidCallback onTap}) => _NvsButton._(label, onTap, false);
  const _NvsButton._(this.label, this.onTap, this.filled);
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final Widget child = Center(
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'MagdaCleanMono',
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: Colors.black,
        ),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        decoration: BoxDecoration(
          color: filled ? NvsPalette.mint : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: filled ? NvsPalette.mint : NvsPalette.cyan, width: 2),
          boxShadow: filled
              ? <BoxShadow>[
                  BoxShadow(color: NvsPalette.mint.withOpacity(.6), blurRadius: 28, spreadRadius: -8),
                ]
              : <BoxShadow>[
                  BoxShadow(color: NvsPalette.cyan.withOpacity(.25), blurRadius: 18, spreadRadius: -6),
                ],
        ),
        child: filled
            ? child
            : Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'MagdaCleanMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: NvsPalette.cyan,
                  ),
                ),
              ),
      ),
    );
  }
}

/// ---------- STAGGER WRAPPER ----------
class _StaggerIn extends StatelessWidget {
  const _StaggerIn({required this.controller, required this.index, required this.child});
  final AnimationController controller;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double intervalStart = (index * 0.15).clamp(0.0, 1.0);
    final Animation<double> anim = CurvedAnimation(parent: controller, curve: Interval(intervalStart, 1.0, curve: Curves.easeOut));
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final double t = anim.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, (1 - t) * 14), child: child),
        );
      },
    );
  }
}

