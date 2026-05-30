
import 'package:flutter/material.dart';

class ScheduleMenu extends StatefulWidget {
  final List<String> initialDays;
  final Function(List<String>,DateTime?,Duration?) onSave;
  final DateTime? initialDue;
  final Duration? initialReminder;

  const ScheduleMenu({
    super.key,
    required this.initialDays,
    required this.onSave,
    this.initialDue,
    this.initialReminder,
  });

  @override
  State<ScheduleMenu> createState() => _ScheduleMenuState();
}

class _ScheduleMenuState extends State<ScheduleMenu> {

  late List<String> _selectedDays;

  DateTime? _selectedDueDate;
  TimeOfDay? _selectedTime;
  String? _selectedReminder;

  @override
  void initState() {
    super.initState();
    _selectedDays = List<String>.from(widget.initialDays);
    _selectedDueDate = widget.initialDue ?? DateTime.now();
    if (widget.initialDue != null) {
      _selectedDueDate = widget.initialDue;
      _selectedTime = TimeOfDay(
        hour: widget.initialDue!.hour,
        minute: widget.initialDue!.minute,
      );
    }

    if (widget.initialReminder != null) {
      _selectedReminder = widget.initialReminder!.inMinutes.toString();
    }
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
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHigh,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          shape: const CircleBorder(),
          minimumSize: const Size(40, 40),
          padding: EdgeInsets.zero,
        ),
        child: Text(day[0]),
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

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Set Reminder / Schedule",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// WEEKDAY SELECTOR
            Row(
              children: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map((d) => Expanded(child: Center(child: _dayButton(d)))).toList(),
            ),

            const SizedBox(height: 20),

            /// CALENDAR
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
              ),
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                onDateChanged: (date) {
                  setState(() {
                    _selectedDueDate = date;
                  });
                },
              ),
            ),

            const SizedBox(height: 12),

            /// TIME + REMINDER
            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _selectedTime == null
                          ? "Add Time"
                          : _selectedTime!.format(context),
                    ),
                    onPressed: () async {

                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (time != null) {
                        setState(() {
                          _selectedTime = time;
                        });
                      }

                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    hint: const Text("Reminder"),
                    initialValue: _selectedReminder,
                    items: const [
                      DropdownMenuItem(value: "10", child: Text("10 min")),
                      DropdownMenuItem(value: "30", child: Text("30 min")),
                      DropdownMenuItem(value: "60", child: Text("1 hour")),
                      DropdownMenuItem(value: "1440", child: Text("1 day")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedReminder = value;
                      });
                    },
                  ),
                ),

              ],
            ),

            const SizedBox(height: 24),

            /// SAVE BUTTONS
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
                    DateTime? finalDateTime;
                    if(_selectedDueDate != null){
                      finalDateTime = DateTime(
                        _selectedDueDate!.year,
                        _selectedDueDate!.month,
                        _selectedDueDate!.day,
                        _selectedTime?.hour ?? 0,
                        _selectedTime?.minute ?? 0,
                      );
                    }
                    

                    final reminder = _selectedReminder !=null ? Duration(minutes: int.parse(_selectedReminder!)) : null;
                    print("SCHEDULE SAVE:");
print(finalDateTime);
print(reminder);
                    widget.onSave(_selectedDays,finalDateTime,reminder);

                    Navigator.pop(context);

                  },
                  child: const Text('Save'),
                ),

              ],
            ),

            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}