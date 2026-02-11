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
      builder: (_)=> ScheduleMenu(
        initialDays: selectedDays,
        onSave: (days){
          final taskProvider = context.read<TaskModel>();
          taskProvider.addTask(
            Task(
              titlecontrol.text.trim(),
              desc: desccontrol.text.trim(),
              weeklist: days,
            )
          );
        }
      ),
    );
  }
}

// class _TaskPageState extends State<TaskPage> {
//   final TextEditingController _controller = TextEditingController();
//   final TextEditingController _desccontroller = TextEditingController();
//   List<String> _selectDay = [];
//   //list of all the tasks
//   List toDoList = [
//     ["Add a new task using +",false,"description goes here",[]]
//   ];

//   //method to change the checkbox, cause flutter isn't doing it by default? idk bruh
//   void checkBoxChanged(bool? value,int index){
//     setState(() {
//       toDoList[index][1] = !toDoList[index][1];
//     });
//   }

//   void _openAddTask(){
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       //backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom, // move with keyboard
//             left: 16,
//             right: 16,
//             top: 24,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField( //titel of task
//                 controller: _controller,
//                 autofocus: true, // keyboard pops up automatically
//                 decoration: const InputDecoration(
//                   hintText: 'Add a new task...',
//                   border: OutlineInputBorder(),
//                 ),
//                 onSubmitted: (value) => _saveTask(), // press enter to save
//               ),
//               TextField(  //description
//                 controller: _desccontroller,
//                 autofocus: false,
//                 decoration: const InputDecoration(
//                   hintText: 'Add desription...',
//                   border: InputBorder.none,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // New Schedule/Reminder button
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: ElevatedButton.icon(
//                   onPressed: (){
//                     showModalBottomSheet(
//                       context: context, 
//                       isScrollControlled: true,
//                       //backgroundColor: Colors.white,
//                       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//                       builder: (context){
//                         return ScheduleMenu(
//                           initialDays: _selectDay, 
//                           onSave: (selectedDays){
//                             setState(() {
//                               _selectDay = List<String>.from(selectedDays);
//                             });
//                           }
//                         );
//                       },
//                     );
//                   },
//                   label: const Icon(Icons.alarm),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                     foregroundColor: Theme.of(context).colorScheme.onPrimary,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Existing save/cancel buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Cancel'),
//                   ),
//                   const SizedBox(width: 8),
//                   ElevatedButton(
//                     onPressed: _saveTask,
//                     child: const Text('Save'),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   } 
  
//   void _saveTask(){
//     final text = _controller.text.trim();
//     final desctext = _desccontroller.text;
//     if (text.isNotEmpty) {
//       setState(() {
//       toDoList.add([
//         text,
//         false,
//         desctext.isNotEmpty ? desctext : null,
//         List<String>.from(_selectDay), // copy current selections
//       ]);
//     });
//     }
//     _selectDay.clear();
//     _desccontroller.clear();
//     _controller.clear();
//     Navigator.pop(context); // close the bottom sheet
//   }

//   void _deleteTask(int index){
//     setState(() {
//       toDoList.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: _openAddTask,shape: const CircleBorder(),child: Icon(Icons.add),),
//       body: ListView.builder(
//         itemCount: toDoList.length,
//         itemBuilder: (context,index){
//           return ToDoTask(
//             taskName: toDoList[index][0], 
//             taskCompleted: toDoList[index][1], 
//             desc: toDoList[index][2],
//             weeklist: toDoList[index].length > 3 ? List.from(toDoList[index][3]) : <String>[],
//             onChanged: (value) => checkBoxChanged(value,index),
//             deleteFunction: (context) => _deleteTask(index),
//             onSave: (title, desc, completed, weeklist){
//               setState(() {
//                 toDoList[index][0] = title;
//                 toDoList[index][1] = completed;
//                 toDoList[index][2] = desc.isNotEmpty ? desc : null;
//                 // make sure you store a copy
//                 toDoList[index] = [
//                   toDoList[index][0],
//                   toDoList[index][1],
//                   toDoList[index][2],
//                   List.from(weeklist)
//                 ];
//               });
//             },
//           );
//         },
//       ),     
//     );
//   }
// }