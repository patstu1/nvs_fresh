import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../domain/section_type.dart';

class MessengerTabBar extends StatelessWidget {
  const MessengerTabBar({
    required this.controller,
    required this.sections,
    super.key,
  });

  final PageController controller;
  final List<SectionType> sections;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: List<Widget>.generate(sections.length, (int index) {
          final SectionType section = sections[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeInOutCubic,
              ),
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget? child) {
                  final bool isActive =
                      (controller.hasClients ? controller.page?.round() : controller.initialPage) ==
                          index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive
                          ? NVSColors.primaryNeonMint.withValues(alpha: 0.14)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isActive
                            ? NVSColors.primaryNeonMint
                            : NVSColors.primaryNeonMint.withValues(alpha: 0.28),
                      ),
                      boxShadow: isActive
                          ? <BoxShadow>[
                              BoxShadow(
                                color: NVSColors.primaryNeonMint.withValues(alpha: 0.25),
                                blurRadius: 18,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        section.label,
                        style: TextStyle(
                          fontFamily: 'MagdaCleanMono',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: isActive ? NVSColors.primaryNeonMint : NVSColors.secondaryText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
