import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import 'yo_button_v2.dart';

class ChatCommandBar extends StatefulWidget {
  const ChatCommandBar({
    super.key,
    this.textController,
    this.onSendMessage,
    this.onAttachmentTap,
    this.hintText = 'Type a message...',
  });
  final TextEditingController? textController;
  final VoidCallback? onSendMessage;
  final VoidCallback? onAttachmentTap;
  final String hintText;

  @override
  State<ChatCommandBar> createState() => _ChatCommandBarState();
}

class _ChatCommandBarState extends State<ChatCommandBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.textController ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.textController == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleYoTap() {
    debugPrint('YO! Multi-sensory feedback triggered');
    // YoButton handles its own feedback
  }

  void _handleSendMessage() {
    if (_hasText) {
      widget.onSendMessage?.call();
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: NVSColors.cardBackground.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: NVSColors.dividerColor.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            // Attachment button
            IconButton(
              onPressed: widget.onAttachmentTap,
              icon: const Icon(
                Icons.attach_file,
                color: NVSColors.secondaryText,
                size: 24,
              ),
            ),

            const SizedBox(width: 8),

            // Text input field
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: NVSColors.pureBlack.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: NVSColors.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: NVSColors.secondaryText.withValues(alpha: 0.7),
                        ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // YoButton v2 or Send button
            if (_hasText)
              IconButton(
                onPressed: _handleSendMessage,
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: NVSColors.primaryNeonMint,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: NVSColors.primaryNeonMint.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.send,
                    color: NVSColors.pureBlack,
                    size: 20,
                  ),
                ),
              )
            else
              YoButtonV2(
                onTap: _handleYoTap,
                size: 50,
              ),
          ],
        ),
      ),
    );
  }
}
