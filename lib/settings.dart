import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(20) 
      ),
    );
  }
}