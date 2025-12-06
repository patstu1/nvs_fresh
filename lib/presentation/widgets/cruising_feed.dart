import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';

class CruisingFeed extends StatefulWidget {
  const CruisingFeed({super.key});

  @override
  _CruisingFeedState createState() => _CruisingFeedState();
}

class _CruisingFeedState extends State<CruisingFeed> {
  final List<Map<String, String>> _updates = [
    {'time': '2m ago', 'message': 'Just got to the gym. Who else is here?'},
    {'time': '5m ago', 'message': 'Anyone up for a late-night adventure?'},
    {
      'time': '10m ago',
      'message': 'Feeling impulsive. Let\'s do something crazy.',
    },
    {
      'time': '12m ago',
      'message': 'Just finished a great workout. Feeling pumped.',
    },
    {'time': '15m ago', 'message': 'Anyone else love the rain?'},
  ];
  final TextEditingController _textController = TextEditingController();

  void _addUpdate() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _updates.insert(0, {
          'time': 'Just now',
          'message': _textController.text,
        });
        _textController.clear();
      });
    }
  }

  void _sendYo(int index) {
    final update = _updates[index];
    // Show YO sent confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('YO sent! 🚀'),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // Add a response update after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _updates.insert(0, {
            'time': 'Just now',
            'message': 'YO! 👋 Someone just sent you a signal',
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _updates.length,
              itemBuilder: (context, index) {
                final update = _updates[index];
                return ListTile(
                  title: Text(
                    update['message']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    update['time']!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.send, color: AppTheme.accentColor),
                    onPressed: () => _sendYo(index),
                  ),
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryColor.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Post an update...',
                hintStyle: TextStyle(
                  color: AppTheme.secondaryTextColor.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: AppTheme.primaryColor.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppTheme.accentColor),
                ),
              ),
              onSubmitted: (value) {
                _addUpdate();
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.send, color: AppTheme.accentColor),
            onPressed: _addUpdate,
          ),
        ],
      ),
    );
  }
}
