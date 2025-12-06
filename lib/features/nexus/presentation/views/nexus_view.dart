import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'dart:math'; // For the 3D transform
import '../nodes/self_node_view.dart';
import '../nodes/filter_node_view.dart';
import '../nodes/events_node_view.dart';
import '../../../../shared/widgets/nvs_logo.dart';

// Enum to represent our orbiting nodes
enum NexusNode { self, filter, events, settings }

class NexusView extends StatefulWidget {
  const NexusView({super.key});

  @override
  State<NexusView> createState() => _NexusViewState();
}

class _NexusViewState extends State<NexusView> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.6, // Makes adjacent nodes visible
    )..addListener(() {
        setState(() {
          _currentPage = _pageController.page!;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      // We add a close button to escape The Nexus
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const NvsLogo(),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close, color: NVSColors.secondaryText),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Center(
        child: PageView.builder(
          controller: _pageController,
          itemCount: NexusNode.values.length,
          itemBuilder: (BuildContext context, int index) {
            // This calculates the 3D perspective effect
            final double difference = index - _currentPage;
            final double rotationY = difference * -pi / 4; // Rotate in 3D space
            final double scale = 1 - (difference.abs() * 0.2);

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Add perspective
                ..rotateY(rotationY)
                ..scale(scale),
              child: _buildNexusNode(NexusNode.values[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNexusNode(NexusNode node) {
    switch (node) {
      case NexusNode.self:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: NVSColors.pureBlack.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NVSColors.ultraLightMint.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.ultraLightMint.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const SelfNodeView(),
        );

      case NexusNode.filter:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: NVSColors.pureBlack.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NVSColors.primaryNeonMint.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.primaryNeonMint.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const FilterNodeView(),
        );

      case NexusNode.events:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: NVSColors.pureBlack.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: NVSColors.avocadoGreen.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: NVSColors.avocadoGreen.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const EventsNodeView(),
        );

      default:
        // Placeholder for other nodes
        return Card(
          color: NVSColors.dividerColor.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              node.name.toUpperCase(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: NVSColors.primaryNeonMint,
                    fontSize: 24,
                  ),
            ),
          ),
        );
    }
  }
}
