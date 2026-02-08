import 'package:flutter/material.dart';
import 'package:prod_app/topbar.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), child: TopBar()
      ),
      body: Text("Settings will be here"),
    );
  }
}