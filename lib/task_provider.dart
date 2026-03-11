import 'package:flutter/material.dart';
import 'backend/database_service.dart';

class Task{
  int? id;
  String title;
  String? desc;
  bool completed;
  List<String> weeklist = [];

  Task(this.title,{this.id,this.desc,this.completed=false,this.weeklist=const []});
}

class TaskModel extends ChangeNotifier{
  final DatabaseService _databaseService = DatabaseService.instance;
  final List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);
  TaskModel(){
    loadTasks();
  }

  Future<void> addTask(Task task) async{
    await _databaseService.addTask(task.title, task.desc, task.weeklist.join(","),);
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
    );
    await loadTasks();
  }

  Future<void> loadTasks() async {
    final data = await _databaseService.getTasks();
    _tasks.clear();
    for (var row in data) {
      _tasks.add(
        Task(
          row['title'],
          id : row['id'],
          desc: row['desc'],
          completed: row['status'] == 1,
          weeklist: row['days'] == null
            ? []
            : (row['days'] as String).split(','),
        ),
      );
    }
    notifyListeners();
  }
}