import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import '../../data/user_grid_provider.dart';

class GridViewWidget extends ConsumerWidget {
  const GridViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: NVSColors.pureBlack,
      child: SafeArea(
        child: Column(
          children: [
            // Centered NVS Logo
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 12),
              child: Align(
                alignment: Alignment.topCenter,
                child: NvsLogo(size: 28, letterSpacing: 10),
              ),
            ),
            // MEATUP label
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'MEATUP',
                style: TextStyle(
                  fontFamily: 'MagdaCleanMono',
                  fontSize: 12,
                  letterSpacing: 3,
                  color: NVSColors.primaryLightMint,
                  shadows: const [Shadow(color: NVSColors.primaryLightMint, blurRadius: 6)],
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Filter bar
            const _GridFilterBar(),
            const SizedBox(height: 8),
            // Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ref
                    .watch(userGridListProvider)
                    .when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text('Error: $e')),
                      data: (users) {
                        final bool favOnly = ref.watch(favoritesOnlyProvider);
                        final Set<String> favIds =
                            ref.watch(favoriteIdsProvider).valueOrNull ?? <String>{};
                        final filtered = favOnly
                            ? users.where((u) => favIds.contains(u.id)).toList()
                            : users;
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return GridUserCard(user: filtered[index]);
                          },
                        );
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridFilterBar extends ConsumerWidget {
  const _GridFilterBar();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool favOnly = ref.watch(favoritesOnlyProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              _IconPill(icon: Icons.sports_mma, label: 'Role'),
              SizedBox(width: 8),
              _IconPill(icon: Icons.fiber_new, label: 'New'),
            ],
          ),
          _TogglePill(
            active: favOnly,
            activeLabel: '💚 Favorites',
            inactiveLabel: '🔥 Nearby',
            onChanged: (bool v) => ref.read(favoritesOnlyProvider.notifier).state = v,
          ),
        ],
      ),
    );
  }
}

class _IconPill extends StatefulWidget {
  const _IconPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  State<_IconPill> createState() => _IconPillState();
}

class _IconPillState extends State<_IconPill> with SingleTickerProviderStateMixin {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: NVSColors.primaryLightMint.withOpacity(0.5), width: 1),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: NVSColors.primaryLightMint.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: NVSColors.primaryLightMint, size: 14),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: const TextStyle(
                fontFamily: 'MagdaCleanMono',
                fontSize: 10,
                color: NVSColors.primaryLightMint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TogglePill extends StatelessWidget {
  const _TogglePill({
    required this.active,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.onChanged,
  });
  final bool active;
  final String activeLabel;
  final String inactiveLabel;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!active),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? NVSColors.avocadoGreen : NVSColors.primaryLightMint,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: (active ? NVSColors.avocadoGreen : NVSColors.primaryLightMint).withOpacity(
                0.4,
              ),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          active ? activeLabel : inactiveLabel,
          style: TextStyle(
            fontFamily: 'MagdaCleanMono',
            fontSize: 10,
            color: active ? NVSColors.avocadoGreen : NVSColors.primaryLightMint,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
