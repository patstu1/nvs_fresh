import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

// Placeholder model for an event
class NvsEvent {

  NvsEvent({
    required this.title,
    required this.hostName,
    required this.participantCount,
    this.isPrivate = false,
  });
  final String title;
  final String hostName;
  final int participantCount;
  final bool isPrivate;
}

class EventsNodeView extends StatelessWidget {
  const EventsNodeView({super.key});

  // Mock data for the event list
  static final List<NvsEvent> _events = <NvsEvent>[
    NvsEvent(
      title: 'Sunday Funday Party',
      hostName: 'RYKER',
      participantCount: 53,
    ),
    NvsEvent(
      title: 'Warehouse Afters',
      hostName: 'KAINE',
      participantCount: 112,
      isPrivate: true,
    ),
    NvsEvent(
      title: 'First Timers Only',
      hostName: 'ZEPHYR',
      participantCount: 22,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Let the Nexus background show through
      // A floating action button is the perfect, modern UI for creation
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          /* TODO: Show Create Event Dialog */
          debugPrint('Create Event tapped');
        },
        backgroundColor: NVSColors.primaryNeonMint,
        foregroundColor: NVSColors.pureBlack,
        icon: const Icon(Icons.add),
        label: Text(
          'CREATE EVENT',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 14,
                letterSpacing: 1,
              ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'EVENTS',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: NVSColors.primaryNeonMint,
                      fontSize: 20,
                    ),
              ),
              centerTitle: true,
              background: Container(
                color: Colors.transparent,
              ), // No background image needed
            ),
          ),
          // The list of event cards
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => _buildEventCard(_events[index], context),
              childCount: _events.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(NvsEvent event, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NVSColors.pureBlack.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NVSColors.dividerColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: event.isPrivate
                ? Colors.red.withValues(alpha: 0.3)
                : NVSColors.primaryNeonMint.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (event.isPrivate)
            Text(
              'PRIVATE SIGNAL',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.red,
                    fontSize: 10,
                  ),
            ),
          Text(
            event.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'HOSTED BY ${event.hostName}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Icon(Icons.group, color: NVSColors.secondaryText, size: 16),
              const SizedBox(width: 8),
              Text(
                '${event.participantCount} online',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
