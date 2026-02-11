import 'package:flutter/material.dart';

class Task{
  String title;
  String? desc;
  bool completed;
  List<String> weeklist = [];

  Task(this.title,{this.desc,this.completed=false,this.weeklist=const []});
}

class TaskModel extends ChangeNotifier{
  final List<Task> _tasks = [
    Task("Add a new task with +",desc:"Add descriptions too!!"),
  ];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task){
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(int index){
    _tasks.removeAt(index);
    notifyListeners();
  }

  void updateTask(int index,Task newTask){
    _tasks[index] = newTask;
    notifyListeners();
  }

  void toggleComplete(int index){
    _tasks[index].completed = !_tasks[index].completed;
    notifyListeners();
  }
}