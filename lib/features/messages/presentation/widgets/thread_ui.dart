import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nvs/meatup_core.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/input_bar.dart';
import '../../domain/models/message_thread.dart';
import '../../data/message_repository.dart';
import '../../data/message_model.dart';

class ThreadUI extends ConsumerStatefulWidget {
  const ThreadUI({
    required this.threadId,
    required this.onToggle,
    required this.sectionToggles,
    super.key,
  });
  final String threadId;
  final Function(bool) onToggle;
  final Map<String, bool> sectionToggles;

  @override
  ConsumerState<ThreadUI> createState() => _ThreadUIState();
}

class _ThreadUIState extends ConsumerState<ThreadUI> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final MessageRepository _repository = MessageRepository();
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> _loadMoreMessages() async {
    if (!_isLoading && _hasMore) {
      setState(() => _isLoading = true);
      try {
        // Load more messages with your repository
        final messages = await _repository.loadMoreMessages(widget.threadId);
        if (messages.isEmpty) {
          _hasMore = false;
        }
      } catch (e) {
        // Handle error
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: NVSColors.pureBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: NVSColors.neonMint.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          _buildToggleSection(),
          Expanded(child: _buildMessageList()),
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: NVSColors.neonMint.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Messages',
            style: TextStyle(
              color: NVSColors.neonMint,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: NVSColors.neonMint),
            onPressed: () => widget.onToggle(false),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Active Sections',
            style: TextStyle(
              color: NVSColors.neonMint,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: widget.sectionToggles.entries.map((MapEntry<String, bool> entry) {
              return FilterChip(
                selected: entry.value,
                label: Text(entry.key),
                onSelected: (bool value) {
                  widget.onToggle(value);
                },
                selectedColor: NVSColors.neonMint,
                checkmarkColor: NVSColors.pureBlack,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<Message>>(
      stream: _repository.getMessages(widget.threadId),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading messages',
              style: TextStyle(color: NVSColors.neonMint),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(NVSColors.neonMint),
            ),
          );
        }

        final List<dynamic> messages = snapshot.data!;

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: messages.length + (_hasMore ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == messages.length) {
              return _buildLoadingIndicator();
            }

            return ChatBubble(
              message: messages[index],
              onLongPress: () => _showMessageOptions(messages[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(NVSColors.neonMint),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return InputBar(
      onSend: _handleMessageSend,
      onAttachmentSelected: _handleAttachment,
    );
  }

  Future<void> _handleMessageSend(String content) async {
    try {
      await _repository.sendMessage(
        threadId: widget.threadId,
        content: content,
        senderId: ref.read(authProvider).currentUser!.uid,
      );
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _handleAttachment() async {
    // Handle file attachments
  }

  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => MessageOptionsSheet(
        message: message,
        onDelete: () => _deleteMessage(message.id),
        onEdit: () => _editMessage(message),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
