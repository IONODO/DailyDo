import 'package:flutter/material.dart';
import 'package:prod_app/schedulemenu.dart';
import 'package:prod_app/task_provider.dart';
import 'package:prod_app/todo.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context){
    final taskProvider = context.watch<TaskModel>();
    final tasks = taskProvider.tasks;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTask(context),
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context,index){
          //final task = tasks[index];
          return ToDoTask(index: index);
        },
      ),
    );
  }

  void _openAddTask(BuildContext context){
    final TextEditingController titlecontrol = TextEditingController();
    final TextEditingController desccontrol = TextEditingController();
    List<String> selectedDays = [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Keep a mutable copy of the selected days here
        List<String> tempDays = List.from(selectedDays);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titlecontrol,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: desccontrol,
                  decoration: const InputDecoration(
                    hintText: 'Add description...',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 12),

                // Reminder / schedule selector
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return ScheduleMenu(
                            initialDays: tempDays,
                            onSave: (days) {
                              // Update state inside this bottom sheet
                              setModalState(() {
                                tempDays = List.from(days);
                              });
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.alarm),
                    label: Text(
                      tempDays.isEmpty
                          ? "Repeat/Schedule"
                          : "Repeats: ${tempDays.join(", ")}",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

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
                        final title = titlecontrol.text.trim();
                        final desc = desccontrol.text.trim();

                        if (title.isNotEmpty) {
                          final provider = context.read<TaskModel>();
                          provider.addTask(
                            Task(
                              title,
                              desc: desc.isNotEmpty ? desc : null,
                              weeklist: List.from(tempDays),
                            ),
                          );
                        }
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
      },
    );
  }
}
