import 'package:flutter/material.dart';
import '../pages/live_page.dart';

class LiveViewWidget extends StatelessWidget {
  const LiveViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const LivePage();
  }
}

// Keep the old name for compatibility
class LiveView extends StatelessWidget {
  const LiveView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LivePage();
  }
}
