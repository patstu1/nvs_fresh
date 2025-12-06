import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class EventsNodeView extends StatelessWidget {
  const EventsNodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NVSColors.primaryNeonMint.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: NVSColors.primaryNeonMint.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Node Title
            const Text(
              'EVENTS',
              style: TextStyle(
                color: NVSColors.primaryNeonMint,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'SYNCHRONICITY GRID',
              style: TextStyle(
                color: NVSColors.secondaryText.withValues(alpha: 0.7),
                fontSize: 12,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 30),

            // Event Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildEventStat('LIVE', '12', NVSColors.primaryNeonMint),
                Container(
                  width: 1,
                  height: 40,
                  color: NVSColors.dividerColor,
                ),
                _buildEventStat('NEARBY', '8', Colors.orange),
                Container(
                  width: 1,
                  height: 40,
                  color: NVSColors.dividerColor,
                ),
                _buildEventStat('INVITED', '3', Colors.purple),
              ],
            ),
            const SizedBox(height: 30),

            // Quick Actions
            Row(
              children: <Widget>[
                Expanded(
                  child: _buildActionButton(
                    'BROWSE',
                    Icons.explore,
                    () {
                      // TODO: Navigate to events browser
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'CREATE',
                    Icons.add_circle_outline,
                    () {
                      // TODO: Navigate to event creation
                    },
                    isPrimary: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Featured Event Preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NVSColors.dividerColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: NVSColors.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: NVSColors.primaryNeonMint,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: NVSColors.primaryNeonMint.withValues(alpha: 0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'LIVE NOW',
                        style: TextStyle(
                          color: NVSColors.primaryNeonMint,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'MIDNIGHT SYNTHESIS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Electronic music gathering • 2.3km away',
                    style: TextStyle(
                      color: NVSColors.secondaryText.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      ...List.generate(3, (int index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: NVSColors.primaryNeonMint,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 12,
                            color: NVSColors.primaryNeonMint,
                          ),
                        );
                      }),
                      Text(
                        '+47 others',
                        style: TextStyle(
                          color: NVSColors.secondaryText.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventStat(String label, String count, Color color) {
    return Column(
      children: <Widget>[
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: NVSColors.secondaryText.withValues(alpha: 0.6),
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isPrimary
            ? NVSColors.primaryNeonMint.withValues(alpha: 0.1)
            : Colors.transparent,
        border: Border.all(
          color: isPrimary ? NVSColors.primaryNeonMint : NVSColors.dividerColor,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: isPrimary
                    ? NVSColors.primaryNeonMint
                    : NVSColors.secondaryText,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary
                      ? NVSColors.primaryNeonMint
                      : NVSColors.secondaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
