import 'package:flutter/material.dart';

class ScheduleMenu extends StatefulWidget {
  final List<String> initialDays;
  final Function(List<String>) onSave;

  const ScheduleMenu({
    super.key,
    required this.initialDays,
    required this.onSave,
  });

  @override
  State<ScheduleMenu> createState() => _ScheduleMenuState();
}

class _ScheduleMenuState extends State<ScheduleMenu> {
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    // Create a copy so you can edit without mutating parent state
    _selectedDays = List<String>.from(widget.initialDays);
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Widget _dayButton(String day) {
    final bool isSelected = _selectedDays.contains(day);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _toggleDay(day),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHigh,
          foregroundColor: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
          shape: const CircleBorder(),
          minimumSize: const Size(40, 40),
          padding: EdgeInsets.zero,
        ),
        child: Text(day[0]), // first letter for now
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Set Reminder / Schedule",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Days of the week
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _dayButton('S'),
              _dayButton('M'),
              _dayButton('T'),
              _dayButton('W'),
              _dayButton('T2'),
              _dayButton('F'),
              _dayButton('S2'),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  widget.onSave(_selectedDays);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
