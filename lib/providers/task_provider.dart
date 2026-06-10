import 'package:flutter/material.dart';
import 'package:prod_app/backend/notification_service.dart';
import '../backend/database_service.dart';

class Task{
  int? id;
  String title;
  String? desc;
  bool completed;
  List<String> weeklist = [];
  DateTime ? created;
  DateTime ? dueDateTime;
  Duration? remindersForDue;
  int focusSeconds;
  DateTime? timerStartedAt;

  Task(this.title,{this.id,this.desc,this.completed=false,this.weeklist=const [],this.created,this.dueDateTime,this.remindersForDue,this.focusSeconds=0,this.timerStartedAt});
}

class TaskModel extends ChangeNotifier{
  final DatabaseService _databaseService = DatabaseService.instance;
  final List<Task> _tasks = [];
  List<Task> get tasks =>List.unmodifiable(_tasks); //this shi is for the date-specific task in calendar.dart
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
    await _databaseService.addTask(task.title, task.desc, task.weeklist.join(","),task.created,task.dueDateTime,task.remindersForDue?.inMinutes, task.focusSeconds, task.timerStartedAt);
    if(task.dueDateTime!=null && task.remindersForDue!=null){
      final notificationTime = task.dueDateTime?.subtract(task.remindersForDue!);
      print("ADDING TASK: ${task.title}");
      await NotificationService.instance.scheduleNotification(
        id: task.id!, 
        title: task.title, 
        body: "Reminder: Task due soon!", 
        scheduledDate: notificationTime!,
      );
    }

    await loadTasks();
  }

  Future<void> deleteTask(int id) async{
    await NotificationService.instance.cancelNotification(id);
    await _databaseService.deleteTask(id);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await NotificationService.instance.cancelNotification(task.id!);
    await _databaseService.updateTask(
      task.id!,
      task.title,
      task.desc,
      task.weeklist.join(','),
      task.completed ? 1 : 0,
      task.dueDateTime,
      task.remindersForDue?.inMinutes,
    );
    if(task.dueDateTime!=null && task.remindersForDue!=null){
      final notificationTime = task.dueDateTime?.subtract(task.remindersForDue!);
      await NotificationService.instance.scheduleNotification(
        id: task.id!, 
        title: task.title, 
        body: "Reminder: Task due soon!", 
        scheduledDate: notificationTime!,
      );
    }
    await loadTasks();
  }

  Future<void> startTimer(Task task) async {
    task.timerStartedAt = DateTime.now();
    await _databaseService.updateTimer(
      task.id!,
      task.focusSeconds,
      task.timerStartedAt,
    );
    notifyListeners();
  }

  Future<void> stopTimer(Task task) async {
    if(task.timerStartedAt == null) return;
    final elapsed = DateTime.now().difference(task.timerStartedAt!).inSeconds;
    task.focusSeconds += elapsed;
    task.timerStartedAt = null;
    await _databaseService.updateTimer(
      task.id!,
      task.focusSeconds,
      null,
    );
    notifyListeners();
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
          remindersForDue: row['reminders'] != null ? Duration(minutes: row['reminders']) : null,
          focusSeconds: row['focusSeconds'] ?? 0,
          timerStartedAt: row['timerStarted'] != null ? DateTime.parse(row['timerStarted']) : null,
        ),
      );
    }
    notifyListeners();
  }
}