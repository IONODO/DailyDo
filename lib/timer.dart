import 'package:flutter/material.dart';

class TimerPage extends StatelessWidget{
  const TimerPage ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer', style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Text("Timer will be here"),
    );
  }
}