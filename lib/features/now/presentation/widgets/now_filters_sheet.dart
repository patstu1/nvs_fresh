import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class NowFilters {
  NowFilters({required this.onlineOnly, required this.ages, required this.tags});
  final bool onlineOnly;
  final RangeValues ages;
  final Set<String> tags;

  NowFilters copyWith({bool? onlineOnly, RangeValues? ages, Set<String>? tags}) => NowFilters(
        onlineOnly: onlineOnly ?? this.onlineOnly,
        ages: ages ?? this.ages,
        tags: tags ?? this.tags,
      );
}

Future<NowFilters?> showFiltersSheet(
  BuildContext context, {
  required NowFilters value,
}) {
  NowFilters v = value;
  final TextTheme t = Theme.of(context).textTheme;
  return showModalBottomSheet<NowFilters>(
    context: context,
    backgroundColor: NvsColors.panel,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    builder: (BuildContext ctx) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NvsCaps('FILTERS', style: t.titleLarge),
            const SizedBox(height: 14),
            SwitchListTile(
              value: v.onlineOnly,
              onChanged: (bool b) => v = v.copyWith(onlineOnly: b),
              title: const NvsCaps('ONLINE ONLY'),
              activeTrackColor: NvsColors.mint,
              activeThumbColor: NvsColors.bg,
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const NvsCaps('AGE RANGE'),
                const Spacer(),
                NvsCaps('${v.ages.start.round()}–${v.ages.end.round()}'),
              ],
            ),
            RangeSlider(
              min: 18,
              max: 80,
              divisions: 62,
              values: v.ages,
              onChanged: (RangeValues r) => v = v.copyWith(ages: r),
              labels: RangeLabels('${v.ages.start.round()}', '${v.ages.end.round()}'),
              activeColor: NvsColors.mint,
              inactiveColor: NvsColors.mint.withOpacity(.25),
            ),
            const SizedBox(height: 8),
            _TagRow(
              all: const <String>['DISCREET', 'JOCK', 'LEATHER', 'GYM', 'ART', 'TECH'],
              selected: v.tags,
              onChange: (Set<String> set) => v = v.copyWith(tags: set),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: NvsColors.mint,
                  foregroundColor: NvsColors.bg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(ctx, v),
                child: const NvsCaps('APPLY'),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      );
    },
  );
}

class _TagRow extends StatefulWidget {
  const _TagRow({required this.all, required this.selected, required this.onChange});
  final List<String> all;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChange;
  @override
  State<_TagRow> createState() => _TagRowState();
}

class _TagRowState extends State<_TagRow> {
  late Set<String> sel = <String>{...widget.selected};
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.all.map((String t) {
        final bool on = sel.contains(t);
        return GestureDetector(
          onTap: () {
            setState(() {
              on ? sel.remove(t) : sel.add(t);
            });
            widget.onChange(sel);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NvsColors.mint.withOpacity(on ? .65 : .25)),
              color: on ? NvsColors.mint.withOpacity(.10) : NvsColors.panel,
            ),
            child: NvsCaps(t, style: Theme.of(context).textTheme.labelMedium),
          ),
        );
      }).toList(),
    );
  }
}








