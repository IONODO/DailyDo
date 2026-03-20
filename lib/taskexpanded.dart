import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prod_app/task_provider.dart';

class TaskExpanded extends StatefulWidget {
  final Task task;

  const TaskExpanded({super.key, required this.task});

  @override
  State<TaskExpanded> createState() => _TaskExpandedState();
}

class _TaskExpandedState extends State<TaskExpanded> {

  late TextEditingController _titleController;
  late TextEditingController _descController;

  late List<String> _selectedDays;
  bool? _completed;

  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String? _reminder;

  @override
  void initState() {
    super.initState();

    final task = widget.task;

    _titleController = TextEditingController(text: task.title);
    _descController = TextEditingController(text: task.desc ?? "");

    _selectedDays = List.from(task.weeklist);
    _completed = task.completed;

    if (task.dueDateTime != null) {
      _dueDate = task.dueDateTime;
      _dueTime = TimeOfDay(
      hour: task.dueDateTime!.hour,
      minute: task.dueDateTime!.minute,
    );
  }

if (task.remindersForDue != null) {
  _reminder = task.remindersForDue!.inMinutes.toString();
}
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
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
    final selected = _selectedDays.contains(day);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _toggleDay(day),
        style: ElevatedButton.styleFrom(
          backgroundColor: selected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHigh,
          foregroundColor: selected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          shape: const CircleBorder(),
          minimumSize: const Size(40, 40),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            /// TITLE
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
            ),

            /// DESCRIPTION
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: InputBorder.none,
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 12),

            /// WEEKDAYS (NEW BUTTON STYLE)
            Row(
              children: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map((d) => Expanded(child: Center(child: _dayButton(d)))).toList(),
            ),

            const SizedBox(height: 16),

            /// CALENDAR
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
              ),
              child: CalendarDatePicker(
                initialDate: _dueDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                onDateChanged: (date) {
                  setState(() {
                    _dueDate = date;
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
                      _dueTime == null
                          ? "Add Time"
                          : _dueTime!.format(context),
                    ),
                    onPressed: () async {

                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (time != null) {
                        setState(() {
                          _dueTime = time;
                        });
                      }

                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    hint: const Text("Reminder"),
                    initialValue: _reminder,
                    items: const [
                      DropdownMenuItem(value: "10", child: Text("10 min")),
                      DropdownMenuItem(value: "30", child: Text("30 min")),
                      DropdownMenuItem(value: "60", child: Text("1 hour")),
                      DropdownMenuItem(value: "1440", child: Text("1 day")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _reminder = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// COMPLETION
            Row(
              children: [
                Checkbox(
                  value: _completed,
                  shape: const CircleBorder(),
                  onChanged: (val) {
                    setState(() {
                      _completed = val;
                    });
                  },
                ),
                const Text("Mark as completed"),
              ],
            ),

            const SizedBox(height: 12),

            /// SAVE
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: () {

                    final provider = context.read<TaskModel>();
                    DateTime? finalDueDateTime;
                    if(_dueDate!=null){
                      finalDueDateTime = DateTime(
                        _dueDate!.year,
                        _dueDate!.month,
                        _dueDate!.day,
                        _dueTime?.hour ?? 0,
                        _dueTime?.minute ?? 0
                      );
                    }

                    provider.updateTask(
                      Task(
                        _titleController.text.trim(),
                        id: widget.task.id,
                        desc: _descController.text.trim().isNotEmpty
                            ? _descController.text.trim()
                            : null,
                        completed: _completed ?? false,
                        weeklist: List<String>.from(_selectedDays),
                        dueDateTime: finalDueDateTime,
                        remindersForDue: _reminder != null ? Duration(minutes: int.parse(_reminder!)): null,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text("Save Changes"),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
