import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:prod_app/task_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const double itemWidth = 70.0;
  static const int range = 3650;
  static const int todayIndex = range;
  static const int totalItems = range * 2 + 1;

  late DateTime today;
  late DateTime selectedDate;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    selectedDate = today;
    scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;
        final screenWidth = MediaQuery.of(context).size.width;
        final offset = (todayIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2); //maths baby
        scrollController.jumpTo(offset);
      });
    }
  }

  bool isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // Mirror of tasksForToday but for any date
  List<Task> _tasksForDate(List<Task> allTasks, DateTime date) {
    final weekday = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][date.weekday - 1];
    return allTasks.where((task) {
      final createdOnDate = task.created != null && isSameDate(task.created!, date);
      final dueOnDate = task.dueDateTime != null && isSameDate(task.dueDateTime!, date);
      final recurringOnDate = task.weeklist.contains(weekday);
      return createdOnDate || dueOnDate || recurringOnDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = context.watch<TaskModel>().tasks;
    final tasksForSelected = _tasksForDate(allTasks, selectedDate);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          DateFormat.yMMMM().format(selectedDate),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Date 
          SizedBox(
            height: 90,
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: totalItems,
              itemExtent: itemWidth,
              itemBuilder: (context, index) {
                final date = today.add(Duration(days: index - todayIndex));
                final isSelected = isSameDate(selectedDate, date);
                final isToday = isSameDate(today, date);

                return GestureDetector(
                  onTap: () => setState(() => selectedDate = date),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: isToday && !isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('MMM').format(date),
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('d').format(date),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // below code for showing tasks for selected day
          Expanded(
            child: tasksForSelected.isEmpty  //tasksForSelected is doing what tasksForToday does in task_provider.dart but for a selected date only not just today, lil more general purpose ig
                ? Center(
                    child: Text(
                      'No tasks for ${DateFormat.MMMd().format(selectedDate)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: tasksForSelected.length,
                    itemBuilder: (context, index) {
                      final task = tasksForSelected[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: task.completed
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              if (task.desc != null && task.desc!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  task.desc!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  //suggested to dispose of the calendar scroll after switch from calendar to timer/tasks
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}