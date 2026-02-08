import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:prod_app/taskexpanded.dart';

// ignore: must_be_immutable
class ToDoTask extends StatelessWidget{
  int tasknum=0;
  final String taskName;
  final String? desc;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext) ? deleteFunction;
  final List weeklist;
  final Function(String title, String desc, bool completed, List weeklist)? onSave;

  
  ToDoTask({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    this.desc,
    this.weeklist=const [],
    this.onSave
  });

  void _openTaskDetail(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context){
        return TaskExpanded(
          taskName: taskName, 
          desc: desc ?? "", 
          completed: taskCompleted, 
          onChanged: onChanged,
          weeklist: weeklist,
          onSave: onSave,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10.0, top: 5.0, bottom: 5.0),
      child: Slidable(
        endActionPane: ActionPane(
            extentRatio: 0.2,
          motion: StretchMotion(), 
          children:[
              SlidableAction(
                onPressed: deleteFunction, 
              icon: Icons.delete,
              backgroundColor: Colors.redAccent,
              //borderRadius: BorderRadius.circular(12),
            )
          ]
      ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openTaskDetail(context),
          child: Container(       
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: taskCompleted, 
                      onChanged: onChanged, 
                      activeColor: Theme.of(context).colorScheme.primary,
                      shape: CircleBorder(),
                    ),
                  Text(taskName, style: TextStyle(decoration: taskCompleted ? TextDecoration.lineThrough : TextDecoration.none),)
                  ],
                ),
                Row(
                  children: [
                    if (desc != null) Text(desc!)
                  ],
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}