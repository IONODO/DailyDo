import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:prod_app/taskexpanded.dart';
import 'package:prod_app/task_provider.dart';

// ignore: must_be_immutable
class ToDoTask extends StatelessWidget {
  final int index; // to identify which task in provider
  const ToDoTask({super.key, required this.index});

  void _openTaskDetail(BuildContext context) {
    final taskProvider = context.read<TaskModel>();
    final task = taskProvider.tasks[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return TaskExpanded(
          taskName: task.title,
          desc: task.desc ?? "",
          completed: task.completed,
          weeklist: List.from(task.weeklist),
          onSave: (title, desc, completed, weeklist) {
            taskProvider.updateTask(
              index,
              Task(
                title,
                desc: desc.isNotEmpty ? desc : null,
                completed: completed,
                weeklist: weeklist,
              ),
            );
          },
          onChanged: (_) => taskProvider.toggleComplete(index),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TaskModel>().tasks[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => context.read<TaskModel>().deleteTask(index),
              icon: Icons.delete,
              backgroundColor: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openTaskDetail(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: task.completed,
                      onChanged: (_) =>
                          context.read<TaskModel>().toggleComplete(index),
                      activeColor: Theme.of(context).colorScheme.primary,
                      shape: const CircleBorder(),
                    ),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                if (task.desc != null && task.desc!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0),
                    child: Text(
                      task.desc!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
