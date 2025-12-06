// lib/features/messenger/presentation/universal_messenger_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import 'package:go_router/go_router.dart';

import '../../messages/domain/models/message_thread.dart';
// ignore_for_file: unused_import
import '../../messages/domain/models/message.dart' show ChatContextType;
import '../../messages/state/chat_thread_provider.dart';
import '../domain/section_type.dart';
import 'widgets/messenger_tab_bar.dart';
import 'widgets/message_thread_tile.dart';

class UniversalMessengerView extends ConsumerStatefulWidget {
  const UniversalMessengerView({super.key});

  @override
  ConsumerState<UniversalMessengerView> createState() => _UniversalMessengerViewState();
}

class _UniversalMessengerViewState extends ConsumerState<UniversalMessengerView>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final List<SectionType> _sections;

  @override
  void initState() {
    super.initState();
    _sections = <SectionType>[
      SectionType.live,
      SectionType.grid,
      SectionType.now,
      SectionType.connect,
    ];
    _pageController = PageController(initialPage: 3);
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'MESSENGER',
                      style: TextStyle(
                        fontFamily: 'BellGothic',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: NVSColors.ultraLightMint,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: MessengerTabBar(controller: _pageController, sections: _sections),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: _sections.length,
                itemBuilder: (BuildContext context, int index) {
                  final SectionType section = _sections[index];
                  final List<MessageThread> threads =
                      ref.watch(contextThreadsProvider(section.context));
                  return _ThreadsList(
                    threads: threads,
                    onOpen: (MessageThread t) async {
                      final bool pinLocked = (t.metadata['pinLocked'] as bool?) ?? false;
                      if (pinLocked) {
                        final String? pin = await showDialog<String>(
                          context: context,
                          builder: (BuildContext ctx) => _PinDialog(),
                        );
                        if (pin == null || pin.isEmpty) return;
                        // TODO: verify PIN against secure storage or backend
                      }
                      context.push('/chat/${t.id}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThreadsList extends StatelessWidget {
  const _ThreadsList({required this.threads, required this.onOpen});
  final List<MessageThread> threads;
  final void Function(MessageThread) onOpen;

  @override
  Widget build(BuildContext context) {
    if (threads.isEmpty) {
      return const Center(
        child: Text(
          'no threads yet',
          style: TextStyle(fontFamily: 'MagdaCleanMono', color: NVSColors.secondaryText),
        ),
      );
    }
    return ListView.builder(
      itemCount: threads.length,
      itemBuilder: (BuildContext context, int i) {
        final MessageThread t = threads[i];
        return MessageThreadTile(
          thread: t,
          onTap: () => onOpen(t),
        );
      },
    );
  }
}

class _PinDialog extends StatefulWidget {
  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: NVSColors.pureBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Enter PIN',
        style: TextStyle(fontFamily: 'BellGothic', color: NVSColors.ultraLightMint),
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        obscureText: true,
        style: const TextStyle(fontFamily: 'MagdaCleanMono', color: NVSColors.ultraLightMint),
        decoration: const InputDecoration(
          hintText: '••••',
          hintStyle: TextStyle(fontFamily: 'MagdaCleanMono', color: NVSColors.secondaryText),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: NVSColors.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: NVSColors.primaryNeonMint),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop<String>(),
          child: const Text('cancel',
              style: TextStyle(fontFamily: 'MagdaCleanMono', color: NVSColors.secondaryText),),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop<String>(_controller.text.trim()),
          style: ElevatedButton.styleFrom(
              backgroundColor: NVSColors.ultraLightMint, foregroundColor: NVSColors.pureBlack,),
          child: const Text('unlock', style: TextStyle(fontFamily: 'MagdaCleanMono')),
        ),
      ],
    );
  }
}
