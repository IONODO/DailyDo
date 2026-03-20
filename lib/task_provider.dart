import 'package:flutter/material.dart';
import 'backend/database_service.dart';

class Task{
  int? id;
  String title;
  String? desc;
  bool completed;
  List<String> weeklist = [];
  DateTime ? created;
  DateTime ? dueDateTime;
  Duration? remindersForDue;

  Task(this.title,{this.id,this.desc,this.completed=false,this.weeklist=const [],this.created,this.dueDateTime,this.remindersForDue});
}

class TaskModel extends ChangeNotifier{
  final DatabaseService _databaseService = DatabaseService.instance;
  final List<Task> _tasks = [];
  List<Task> tasksForToday(){
    final today = DateTime.now();
    final weekday = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][today.weekday-1];
    bool sameDay(DateTime a, DateTime b){
      return a.year==b.year && a.month==b.month && a.day==b.day;
    }
    return _tasks.where((task){
      final createdToday = task.created != null && sameDay(task.created!, today);
      final dueToday = task.dueDateTime != null && sameDay(task.dueDateTime!, today);
      final recurringToday = task.weeklist.contains(weekday);
      final result =  createdToday || dueToday || recurringToday;
      return result;
    }).toList();
  }  
  TaskModel(){
    loadTasks();
  }

  Future<void> addTask(Task task) async{
    await _databaseService.addTask(task.title, task.desc, task.weeklist.join(","),task.created,task.dueDateTime,task.remindersForDue?.inMinutes);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async{
    await _databaseService.deleteTask(id);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(
      task.id!,
      task.title,
      task.desc,
      task.weeklist.join(','),
      task.completed ? 1 : 0,
      task.dueDateTime,
      task.remindersForDue?.inMinutes,
    );
    await loadTasks();
  }

  Future<void> toggleComplete(Task task) async {
    await _databaseService.updateTask(
      task.id!,
      task.title,
      task.desc,
      task.weeklist.join(','),
      task.completed ? 0 : 1,
      task.dueDateTime,
      task.remindersForDue?.inMinutes,
    );
    await loadTasks();
  }

  Future<void> loadTasks() async {
    await _databaseService.cleanupCompleted();
    final data = await _databaseService.getTasks();
    _tasks.clear();
    for (var row in data) {     
      _tasks.add(
        Task(
          row['title'],
          id : row['id'],
          desc: row['desc'],
          completed: row['status'] == 1,
          weeklist: row['days'] == null ? [] : (row['days'] as String).split(','),
          created: row['created'] != null ? DateTime.parse(row['created']).toLocal() : null,
          dueDateTime: row['due'] != null ? DateTime.parse(row['due']).toLocal() : null,
          remindersForDue: row['reminders'] != null ? Duration(minutes: row['reminders']) : null
        ),
      );
    }
    notifyListeners();
  }
}