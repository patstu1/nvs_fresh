/// NVS CRUISING EVENT MODAL — DARK, SEXY INVITE UI
/// One file includes: Event model, mock data, event creation modal UI
library;

/// ---------------------------
/// FILE: lib/features/now/presentation/widgets/cruising_event_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cruising Event Model
class CruisingEvent {
  final String type; // orgy, pump-and-dump, chill, etc.
  final String title;
  final String location;
  final String time;
  final List<String> invitees;

  CruisingEvent({
    required this.type,
    required this.title,
    required this.location,
    required this.time,
    required this.invitees,
  });
}

/// Mock Provider (to store/preview event)
final createdEventProvider = StateProvider<CruisingEvent?>((ref) => null);

/// Cruising Event Modal UI
class CruisingEventModal extends ConsumerStatefulWidget {
  const CruisingEventModal({super.key});

  @override
  ConsumerState<CruisingEventModal> createState() => _CruisingEventModalState();
}

class _CruisingEventModalState extends ConsumerState<CruisingEventModal> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _timeController = TextEditingController();
  String _selectedType = 'Orgy';

  List<String> types = ['Orgy', 'Pump & Dump', 'Chill', 'Public Meet'];

  void _createEvent() {
    final event = CruisingEvent(
      type: _selectedType,
      title: _titleController.text,
      location: _locationController.text,
      time: _timeController.text,
      invitees: [],
    );
    ref.read(createdEventProvider.notifier).state = event;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Host Cruising Event",
            style: TextStyle(
              color: Color(0xFFA7FFE0),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),

          /// Event Type Selector
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            dropdownColor: Colors.black,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Type',
              labelStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Color(0xFF1B1B1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: types.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) => setState(() => _selectedType = value!),
          ),

          SizedBox(height: 16),

          /// Title
          TextField(
            controller: _titleController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Title or Description',
              labelStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Color(0xFF1B1B1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          SizedBox(height: 16),

          /// Location
          TextField(
            controller: _locationController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Location / Area',
              labelStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Color(0xFF1B1B1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          SizedBox(height: 16),

          /// Time
          TextField(
            controller: _timeController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Time',
              labelStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Color(0xFF1B1B1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          Spacer(),

          GestureDetector(
            onTap: _createEvent,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFA7FFE0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Create Event",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// USAGE:
/// showModalBottomSheet(
///   context: context,
///   backgroundColor: Colors.transparent,
///   builder: (context) => CruisingEventModal(),
/// );
