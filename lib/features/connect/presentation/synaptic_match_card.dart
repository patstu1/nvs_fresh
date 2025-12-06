// lib/features/connect/presentation/synaptic_match_card.dart
// NVS Synaptic Match Card — neon, breathing, no placeholders.
// Requires only Flutter SDK. No assets. Feed your real URLs/data.

import 'dart:math' as math;
import 'package:flutter/material.dart';

class SynapticMatchCard extends StatefulWidget {
  const SynapticMatchCard({
    // Split-face circle
    required this.leftImageUrl,
    required this.rightImageUrl, // Core stats
    required this.matchPercent, // 0..100
    required this.sharedInterests, // label->0..1
    required this.onMessageNow,
    super.key,
    this.badges = const <String>['Chemistry', 'Consonance', 'Continuity', 'Consistency'],
    // Optional metadata row
    this.titleTop = 'MATCH DETAILS',
    this.primaryName,
    this.secondaryName,
    this.verified = false,
    this.height = 640,
  });

  final String leftImageUrl;
  final String rightImageUrl;

  final double matchPercent;
  final Map<String, double> sharedInterests;
  final List<String> badges;

  final VoidCallback onMessageNow;

  final String titleTop;
  final String? primaryName;
  final String? secondaryName;
  final bool verified;

  final double height;

  @override
  State<SynapticMatchCard> createState() => _SynapticMatchCardState();
}

class _SynapticMatchCardState extends State<SynapticMatchCard> with SingleTickerProviderStateMixin {
  late final AnimationController _breath;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController.unbounded(vsync: this)
      ..addListener(() => setState(() {}))
      ..repeat(
        min: 0,
        max: 2 * math.pi,
        period: const Duration(seconds: 6),
      );
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  double get breathValue => (math.sin(_breath.value) + 1) / 2; // 0..1 smooth “breath”

  @override
  Widget build(BuildContext context) {
    final _Palette p = _palette;
    const double radius = 116.0;

    return Container(
      height: widget.height,
      margin: const EdgeInsets.all(14),
      decoration: _neonCardDecoration(p, breathValue),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                p.surface.withOpacity(0.92),
                p.surface.withOpacity(0.86),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints cst) {
              final bool shouldScroll = cst.maxHeight < 520;
              final Widget content = Column(
                mainAxisSize: shouldScroll ? MainAxisSize.min : MainAxisSize.max,
                children: <Widget>[
                  // Top title
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 6),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.titleTop.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'BellGothic',
                              letterSpacing: 1.6,
                              fontSize: 14,
                              color: p.mint,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Split-face + neon rings + % donut overlay
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        // Aura ring behind
                        SizedBox(
                          width: radius * 2 + 36,
                          height: radius * 2 + 36,
                          child: CustomPaint(
                            painter: _NeonAuraRingPainter(
                              breath: breathValue,
                              palette: p,
                            ),
                          ),
                        ),
                        // Split face disc with thin divider
                        _SplitFaceDisc(
                          left: widget.leftImageUrl,
                          right: widget.rightImageUrl,
                          radius: radius,
                          palette: p,
                        ),
                        // Donut percent overlay
                        SizedBox(
                          width: radius * 2 + 22,
                          height: radius * 2 + 22,
                          child: CustomPaint(
                            painter: _DonutPercentPainter(
                              percent: (widget.matchPercent.clamp(0, 100)) / 100.0,
                              palette: p,
                              breath: breathValue,
                            ),
                          ),
                        ),
                        // Center % label
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              '${widget.matchPercent.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontFamily: 'BellGothic',
                                fontSize: 24,
                                letterSpacing: 1.2,
                                color: p.mint,
                                shadows: <Shadow>[
                                  Shadow(
                                    color: p.mint.withOpacity(.55),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'COMPATIBILITY',
                              style: TextStyle(
                                fontFamily: 'BellGothic',
                                fontSize: 10.5,
                                letterSpacing: 1.8,
                                color: p.cyan.withOpacity(.85),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Names + verified
                  if (widget.primaryName != null || widget.secondaryName != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (widget.primaryName != null) _nameTag(widget.primaryName!, true, p),
                          if (widget.secondaryName != null) ...<Widget>[
                            const SizedBox(width: 10),
                            _nameTag(widget.secondaryName!, false, p),
                          ],
                          if (widget.verified) ...<Widget>[
                            const SizedBox(width: 8),
                            Icon(Icons.verified, size: 16, color: p.mint),
                          ],
                        ],
                      ),
                    ),

                  // Badge row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: widget.badges
                          .take(4)
                          .map((String b) => _NeonChip(text: b, palette: p, breath: breathValue))
                          .toList(),
                    ),
                  ),

                  // Shared interests (left: icons, right: neon bar chart)
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 12, bottom: 12),
                    child: SizedBox(
                      height: 130,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 48,
                            child: _SharedInterestsList(
                              items: widget.sharedInterests,
                              palette: p,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (shouldScroll) ...<Widget>[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: p.panel.withOpacity(.35),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: p.mint.withOpacity(.22)),
                              ),
                              child: CustomPaint(
                                painter: _NeonBarChartPainter(
                                  values: widget.sharedInterests.values.toList(),
                                  labels: widget.sharedInterests.keys.toList(growable: false),
                                  palette: p,
                                  breath: breathValue,
                                ),
                              ),
                            ),
                          ] else ...<Widget>[
                            Expanded(
                              flex: 52,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: p.panel.withOpacity(.35),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: p.mint.withOpacity(.22)),
                                ),
                                child: CustomPaint(
                                  painter: _NeonBarChartPainter(
                                    values: widget.sharedInterests.values.toList(),
                                    labels: widget.sharedInterests.keys.toList(growable: false),
                                    palette: p,
                                    breath: breathValue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  if (!shouldScroll) const Spacer(),

                  // CTA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: 14),
                    child: _NeonButton(
                      label: 'MESSAGE NOW',
                      onTap: widget.onMessageNow,
                      palette: p,
                      breath: breathValue,
                    ),
                  ),
                ],
              );
              return shouldScroll ? SingleChildScrollView(child: content) : content;
            },
          ),
        ),
      ),
    );
  }

  Widget _nameTag(String name, bool primary, _Palette p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (primary ? p.mint : p.magenta).withOpacity(.5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: (primary ? p.mint : p.magenta).withOpacity(.25),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
        gradient: LinearGradient(
          colors: <Color>[
            p.panel.withOpacity(.45),
            p.panel.withOpacity(.25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontFamily: 'BellGothic',
          fontSize: 12.5,
          letterSpacing: 1.2,
          color: (primary ? p.mint : p.magenta),
        ),
      ),
    );
  }
}

// ---------- Visual Building Blocks ----------

class _SplitFaceDisc extends StatelessWidget {
  const _SplitFaceDisc({
    required this.left,
    required this.right,
    required this.radius,
    required this.palette,
  });

  final String left;
  final String right;
  final double radius;
  final _Palette palette;

  @override
  Widget build(BuildContext context) {
    final double size = radius * 2;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.mint.withOpacity(.35),
            blurRadius: 36,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Left half
          ClipPath(
            clipper: _HalfCircleClipper(isLeft: true),
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: left.startsWith('assets/')
                      ? AssetImage(left)
                      : NetworkImage(left) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Right half
          ClipPath(
            clipper: _HalfCircleClipper(isLeft: false),
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: right.startsWith('assets/')
                      ? AssetImage(right)
                      : NetworkImage(right) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Center divider
          Align(
            child: Container(
              width: 2,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[palette.magenta, palette.cyan],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: palette.magenta.withOpacity(.7), blurRadius: 8),
                  BoxShadow(color: palette.cyan.withOpacity(.7), blurRadius: 8),
                ],
              ),
            ),
          ),
          // Subtle circular overlay to unify tones
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  Colors.transparent,
                  palette.surface.withOpacity(.06),
                ],
              ),
            ),
          ),
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
    final Path path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Path half = Path();
    if (isLeft) {
      half.addRect(Rect.fromLTWH(0, 0, size.width / 2, size.height));
    } else {
      half.addRect(Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height));
    }
    return Path.combine(PathOperation.intersect, path, half);
  }

  @override
  bool shouldReclip(covariant _HalfCircleClipper oldClipper) => false;
}

class _NeonAuraRingPainter extends CustomPainter {
  _NeonAuraRingPainter({required this.breath, required this.palette});

  final double breath;
  final _Palette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final double r = math.min(size.width, size.height) / 2.2;

    // Outer glow
    final Paint glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18 + 6 * breath
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24)
      ..color = Color.lerp(palette.magenta, palette.cyan, breath)!.withOpacity(.75);
    canvas.drawCircle(c, r, glow);

    // Thin neon ring
    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..shader = SweepGradient(
        colors: <Color>[palette.magenta, palette.cyan, palette.mint, palette.magenta],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r, ring);
  }

  @override
  bool shouldRepaint(covariant _NeonAuraRingPainter oldDelegate) => oldDelegate.breath != breath;
}

class _DonutPercentPainter extends CustomPainter {
  _DonutPercentPainter({
    required this.percent,
    required this.palette,
    required this.breath,
  });

  final double percent; // 0..1
  final _Palette palette;
  final double breath;

  @override
  void paint(Canvas canvas, Size size) {
    const double stroke = 9.0;
    final Rect rect = Offset.zero & size;
    final Offset c = rect.center;
    final double r = math.min(size.width, size.height) / 2 - stroke;

    final Paint bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = palette.panel.withOpacity(.45);
    canvas.drawCircle(c, r, bg);

    final double sweep = 2 * math.pi * percent.clamp(0, 1);
    final Paint arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + sweep,
        colors: <Color>[
          palette.cyan,
          palette.mint,
          palette.magenta,
        ],
      ).createShader(Rect.fromCircle(center: c, radius: r));

    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      sweep,
      false,
      arc,
    );

    // Glow along the head
    final Paint glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke + 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
      ..color = palette.mint.withOpacity(.35 + .3 * breath);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      sweep,
      false,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPercentPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.breath != breath;
}

class _NeonChip extends StatelessWidget {
  const _NeonChip({required this.text, required this.palette, required this.breath});
  final String text;
  final _Palette palette;
  final double breath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.mint.withOpacity(.4 + .25 * breath)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.mint.withOpacity(.2 + .25 * breath),
            blurRadius: 16,
            spreadRadius: .6,
          ),
        ],
        gradient: LinearGradient(
          colors: <Color>[palette.panel.withOpacity(.55), palette.panel.withOpacity(.28)],
        ),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: 'BellGothic',
          fontSize: 11,
          letterSpacing: 1.5,
          color: palette.mint,
        ),
      ),
    );
  }
}

class _SharedInterestsList extends StatelessWidget {
  const _SharedInterestsList({required this.items, required this.palette});

  final Map<String, double> items;
  final _Palette palette;

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, double>> entries = items.entries.toList()
      ..sort(
        (MapEntry<String, double> a, MapEntry<String, double> b) => b.value.compareTo(a.value),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'SHARED  INTERESTS',
          style: TextStyle(
            fontFamily: 'BellGothic',
            letterSpacing: 1.6,
            fontSize: 11.5,
            color: palette.cyan,
          ),
        ),
        const SizedBox(height: 8),
        ...entries.take(4).map((MapEntry<String, double> e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                Icon(Icons.bolt, size: 14, color: palette.magenta),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.key,
                    style: TextStyle(
                      fontFamily: 'BellGothic',
                      fontSize: 12,
                      letterSpacing: .6,
                      color: palette.mint,
                    ),
                  ),
                ),
                Text(
                  '${(e.value * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: 'BellGothic',
                    fontSize: 12,
                    color: palette.mint.withOpacity(.9),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _NeonBarChartPainter extends CustomPainter {
  _NeonBarChartPainter({
    required this.values,
    required this.labels,
    required this.palette,
    required this.breath,
  });

  final List<double> values; // 0..1
  final List<String> labels;
  final _Palette palette;
  final double breath;

  @override
  void paint(Canvas canvas, Size size) {
    final int barCount = values.length.clamp(0, 6);
    if (barCount == 0) return;

    final double w = size.width;
    final double h = size.height;
    const double gap = 8.0;
    final double barW = (w - (gap * (barCount + 1))) / barCount;

    // Grid
    final Paint grid = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = palette.mint.withOpacity(.18);
    for (int i = 0; i < 4; i++) {
      final double y = h - 8 - (i + 1) * (h - 24) / 4;
      canvas.drawLine(Offset(8, y), Offset(w - 8, y), grid);
    }

    for (int i = 0; i < barCount; i++) {
      final num v = values[i].clamp(0, 1);
      final double x = gap + i * (barW + gap);
      final double barH = (h - 26) * v;
      final RRect rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, h - 10 - barH, barW, barH),
        const Radius.circular(6),
      );

      // Glow
      final Paint glow = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
        ..color = palette.mint.withOpacity(.25 + .25 * breath);
      canvas.drawRRect(rect, glow);

      // Fill
      final Paint fill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            palette.magenta,
            palette.cyan,
            palette.mint,
          ],
          stops: const <double>[0.0, 0.55, 1.0],
        ).createShader(rect.outerRect);
      canvas.drawRRect(rect, fill);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonBarChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.breath != breath;
}

class _NeonButton extends StatefulWidget {
  const _NeonButton({
    required this.label,
    required this.onTap,
    required this.palette,
    required this.breath,
  });

  final String label;
  final VoidCallback onTap;
  final _Palette palette;
  final double breath;

  @override
  State<_NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<_NeonButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final _Palette p = widget.palette;
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: p.mint.withOpacity(.75), width: 1.4),
            gradient: LinearGradient(
              colors: <Color>[
                p.mint.withOpacity(_down ? .18 : .28),
                p.panel.withOpacity(.2),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: p.mint.withOpacity(.45 + .25 * widget.breath),
                blurRadius: 22,
                spreadRadius: 1.2,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'BellGothic',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 1.6,
              color: p.surfaceDark,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Palette & Card decoration ----------

class _Palette {
  // Primary request: ultra-light neon mint #E4FFF0
  final Color mint = const Color(0xFFE4FFF0);

  // Supporting neon tones
  final Color cyan = const Color(0xFF18E1FF);
  final Color magenta = const Color(0xFFFF3FD7);
  final Color lemon = const Color(0xFFFFE86A);

  // Surfaces
  final Color surface = const Color(0xFF0A0E11);
  final Color surfaceDark = const Color(0xFF071014);
  final Color panel = const Color(0xFF0F161B);
}

final _Palette _palette = _Palette();

BoxDecoration _neonCardDecoration(_Palette p, double breath) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: p.mint.withOpacity(.35)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: p.cyan.withOpacity(.18 + .1 * breath),
        blurRadius: 24 + 10 * breath,
        spreadRadius: 0.8,
      ),
      BoxShadow(
        color: p.magenta.withOpacity(.12 + .1 * breath),
        blurRadius: 26 + 10 * breath,
        spreadRadius: 0.8,
        offset: const Offset(0, 2),
      ),
    ],
    gradient: LinearGradient(
      colors: <Color>[p.surface.withOpacity(.96), p.surface.withOpacity(.9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
