import 'package:flutter/material.dart';

class TaskExpanded extends StatefulWidget {
  final String taskName;
  final String desc;
  final bool completed;
  final Function(bool?)? onChanged;
  final List weeklist;
  final Function(String title, String desc, bool completed, List weeklist)? onSave;

  const TaskExpanded({
    super.key,
    required this.taskName,
    required this.desc,
    required this.completed,
    required this.onChanged,
    required this.weeklist,
    this.onSave,
  });

  @override
  State<TaskExpanded> createState() => _TaskExpandedState();
}

class _TaskExpandedState extends State<TaskExpanded> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late List<String> _selectedDays;
  bool? _completed;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskName);
    _descController = TextEditingController(text: widget.desc);
    _selectedDays = List.from(widget.weeklist);
    _completed = widget.completed;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Widget _dayChip(String dayLabel) {
    final selected = _selectedDays.contains(dayLabel);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(dayLabel[0]),
        selected: selected,
        onSelected: (val) {
          setState(() {
            if (val) {
              _selectedDays.add(dayLabel);
            } else {
              _selectedDays.remove(dayLabel);
            }
          });
        },
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
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
                border: InputBorder.none,
              ),
              maxLines: 3,
            ),
            Wrap(
              spacing: 6,
              children: [
                _dayChip('S'),
                _dayChip('M'),
                _dayChip('T'),
                _dayChip('W'),
                _dayChip('T2'),
                _dayChip('F'),
                _dayChip('S2'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _completed,
                  shape: CircleBorder(),
                  onChanged: (val) => setState(() => _completed = val),
                ),
                const Text("Mark as completed"),
              ],
            ),
            const SizedBox(height: 12),
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
                    // Here you’d update your toDoList in TaskPage later
                    widget.onSave?.call(
                      _titleController.text.trim(),
                      _descController.text.trim(),
                      _completed ?? false,
                      List.from(_selectedDays),
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
