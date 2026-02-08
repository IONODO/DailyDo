import 'package:flutter/material.dart';

class TopBar extends StatelessWidget{
  const TopBar ({super.key});

  @override
  Widget build(BuildContext context){
    return AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'Today',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      );
  }
}
