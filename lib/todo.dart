import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class ToDoTask extends StatelessWidget{
  int tasknum=0;
  final String taskName;
  final String? desc;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext) ? deleteFunction;
  final List weeklist;
  
  ToDoTask({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    this.desc,
    this.weeklist=const [],
  });

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
      ),
    );
  }
}