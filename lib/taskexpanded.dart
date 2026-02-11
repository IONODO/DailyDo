import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prod_app/task_provider.dart';

class TaskExpanded extends StatefulWidget {
  final int index; // so we know which task to edit

  const TaskExpanded({super.key, required this.index});

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
    final task = context.read<TaskModel>().tasks[widget.index];
    _titleController = TextEditingController(text: task.title);
    _descController = TextEditingController(text: task.desc ?? "");
    _selectedDays = List.from(task.weeklist);
    _completed = task.completed;
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
              decoration: const InputDecoration(border: InputBorder.none),
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
              children: ['S','M','T','W','T2','F','S2']
                  .map((d) => ChoiceChip(
                        label: Text(d[0]),
                        selected: _selectedDays.contains(d),
                        onSelected: (_) => _toggleDay(d),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _completed,
                  shape: const CircleBorder(),
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
                    final provider = context.read<TaskModel>();
                    provider.updateTask(
                      widget.index,
                      Task(
                        _titleController.text.trim(),
                        desc: _descController.text.trim().isNotEmpty
                            ? _descController.text.trim()
                            : null,
                        completed: _completed ?? false,
                        weeklist: List<String>.from(_selectedDays),
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
