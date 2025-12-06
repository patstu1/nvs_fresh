import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:nvs/theme/nvs_theme.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    required this.name, required this.age, required this.score, required this.metrics, super.key,
    this.avatarUrl,
    this.onTap,
    this.onMessage,
    this.onPin,
  });

  final String name; // e.g. "JAX"
  final int age; // e.g. 29
  final double score; // 0..1 -> 92% etc.
  final List<MetricBar> metrics; // stacked gradient bars
  final String? avatarUrl; // optional network avatar
  final VoidCallback? onTap;
  final VoidCallback? onMessage;
  final VoidCallback? onPin;

  @override
  Widget build(BuildContext context) {
    final int pct = (score * 100).clamp(0, 100).round();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: NvsColors.panel.withOpacity(.78),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: NvsColors.mint.withOpacity(.28)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: NvsColors.mint.withOpacity(.08),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            // Breathing mint outer glow
            const _BreathingGlow(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: <Widget>[
                  _AvatarRing(url: avatarUrl, selected: false),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // NAME • AGE + SCORE RIGHT
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: NvsText.caps(
                                '$name • $age',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: NvsColors.mint,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.3,
                                ),
                              ),
                            ),
                            _ScorePill(pct: pct),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // METRIC BARS (stacked)
                        _MetricBars(metrics: metrics),
                        const SizedBox(height: 12),
                        // ACTION ROW
                        Row(
                          children: <Widget>[
                            _ActionChip(
                              icon: Icons.chat_bubble_outline_rounded,
                              label: 'MESSAGE',
                              onTap: onMessage,
                            ),
                            const SizedBox(width: 10),
                            _ActionChip(
                              icon: Icons.push_pin_outlined,
                              label: 'PIN',
                              onTap: onPin,
                            ),
                            const Spacer(),
                            // tiny labels right
                            NvsText.caps('LIVE',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelTiny
                                    .copyWith(color: NvsColors.cyan.withOpacity(.9)),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ——— Avatar with neon-mint ring ————————————————————————————————
class _AvatarRing extends StatelessWidget {
  const _AvatarRing({required this.url, required this.selected});
  final String? url;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    const double size = 64.0;
    return CustomPaint(
      painter: _GlowRingPainter(selected: selected),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF0E151A)),
        clipBehavior: Clip.antiAlias,
        child: url == null
            ? const _Initials()
            : Image.network(url!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const _Initials()),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: NvsText.caps('NV',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: NvsColors.mint, fontWeight: FontWeight.w700),),
    );
  }
}

class _GlowRingPainter extends CustomPainter {
  _GlowRingPainter({required this.selected});
  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final double r = size.width / 2;

    final Paint glow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16)
      ..color = NvsColors.mint.withOpacity(selected ? .95 : .65);
    canvas.drawCircle(c, r * .92, glow);

    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 3 : 2
      ..shader = ui.Gradient.sweep(c, <Color>[NvsColors.mint, NvsColors.mintSoft, NvsColors.mint], <double>[0, .5, 1]);
    canvas.drawCircle(c, r * .82, ring);
  }

  @override
  bool shouldRepaint(covariant _GlowRingPainter old) => old.selected != selected;
}

// ——— Score Pill ————————————————————————————————————————————————
class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.pct});
  final int pct;
  @override
  Widget build(BuildContext context) {
    final TextTheme t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: NvsColors.bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: NvsColors.mint.withOpacity(.45)),
        boxShadow: <BoxShadow>[BoxShadow(color: NvsColors.mint.withOpacity(.12), blurRadius: 12)],
      ),
      child: NvsText.caps('$pct% MATCH', style: t.labelTight.copyWith(color: NvsColors.mint)),
    );
  }
}

// ——— Stacked Metric Bars (exact cyber gradient) ————————————————
class MetricBar {
  MetricBar({required this.label, required this.value, required this.gradient});
  final String label; // e.g. "INTENSITY"
  final double value; // 0..1
  final List<Color> gradient; // left->right
}

class _MetricBars extends StatelessWidget {
  const _MetricBars({required this.metrics});
  final List<MetricBar> metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: metrics.map((MetricBar m) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 90,
                child: NvsText.caps(
                  m.label,
                  style: Theme.of(context).textTheme.labelTiny.copyWith(color: NvsColors.mint.withOpacity(.85)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 10,
                    child: Stack(
                      children: <Widget>[
                        Container(color: Colors.white.withOpacity(.06)),
                        FractionallySizedBox(
                          widthFactor: m.value.clamp(0, 1),
                          child: DecoratedBox(
                            decoration: BoxDecoration(gradient: LinearGradient(colors: m.gradient)),
                          ),
                        ),
                        // thin mint outline
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: NvsColors.mint.withOpacity(.25)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ——— Subtle breathing glow background ————————————————
class _BreathingGlow extends StatefulWidget {
  const _BreathingGlow();
  @override
  State<_BreathingGlow> createState() => _BreathingGlowState();
}

class _BreathingGlowState extends State<_BreathingGlow> with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ac,
      builder: (_, __) {
        final double o = ui.lerpDouble(.03, .10, _ac.value)!;
        return Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(color: NvsColors.mint.withOpacity(o), blurRadius: 28, spreadRadius: 2),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }
}

