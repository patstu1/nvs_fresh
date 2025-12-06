/// NVS CRUISING EVENT MODAL — DARK, SEXY INVITE UI
/// One file includes: Event model, mock data, event creation modal UI
library;

/// ---------------------------
/// FILE: lib/features/now/presentation/widgets/cruising_event_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cruising Event Model
class CruisingEvent {
  CruisingEvent({
    required this.type,
    required this.title,
    required this.location,
    required this.time,
    required this.invitees,
  });
  final String type; // orgy, pump-and-dump, chill, etc.
  final String title;
  final String location;
  final String time;
  final List<String> invitees;
}

/// Mock Provider (to store/preview event)
final StateProvider<CruisingEvent?> createdEventProvider =
    StateProvider<CruisingEvent?>((StateProviderRef<CruisingEvent?> ref) => null);

/// Cruising Event Modal UI
class CruisingEventModal extends ConsumerStatefulWidget {
  const CruisingEventModal({super.key});

  @override
  ConsumerState<CruisingEventModal> createState() => _CruisingEventModalState();
}

class _CruisingEventModalState extends ConsumerState<CruisingEventModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String _selectedType = 'Orgy';

  List<String> types = <String>['Orgy', 'Pump & Dump', 'Chill', 'Public Meet'];

  void _createEvent() {
    final CruisingEvent event = CruisingEvent(
      type: _selectedType,
      title: _titleController.text,
      location: _locationController.text,
      time: _timeController.text,
      invitees: <String>[],
    );
    ref.read(createdEventProvider.notifier).state = event;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Host Cruising Event',
            style: TextStyle(
              color: Color(0xFFA7FFE0),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          /// Event Type Selector
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            dropdownColor: Colors.black,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Type',
              labelStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1B1B1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: types.map((String type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (String? value) => setState(() => _selectedType = value!),
          ),

          const SizedBox(height: 16),

          /// Title
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Title or Description',
              labelStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1B1B1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Location
          TextField(
            controller: _locationController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Location / Area',
              labelStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1B1B1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Time
          TextField(
            controller: _timeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Time',
              labelStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF1B1B1B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: _createEvent,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFA7FFE0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Create Event',
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
