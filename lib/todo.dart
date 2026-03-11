import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:prod_app/taskexpanded.dart';
import 'package:prod_app/task_provider.dart';

// ignore: must_be_immutable
class ToDoTask extends StatelessWidget {
  final Task task; // to identify which task in provider
  const ToDoTask({super.key, required this.task});

  void _openTaskDetail(BuildContext context) {
    //final taskProvider = context.read<TaskModel>();
    //final task = taskProvider.tasks[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return TaskExpanded(task: task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => context.read<TaskModel>().deleteTask(task.id!),
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
                      onChanged: (_)=>{
                        context.read<TaskModel>().toggleComplete(task)
                      },
                          //above logic what it does is that it calls the database changing provider
                          //to update the task with same details but completion changed
                          //below logic is old logic, just a toggle locally
                          //context.read<TaskModel>().toggleComplete(index),
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
