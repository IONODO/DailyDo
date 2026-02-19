import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget{
  const CalendarPage ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('month goes here', style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Text("Calender will be here"),
    );
  }
}