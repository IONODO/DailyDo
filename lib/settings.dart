import 'package:flutter/material.dart';
import 'package:prod_app/settings_pages/theme_settings.dart';
import 'package:prod_app/backend/notification_service.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //theme tile
          ListTile(
            title: const Text("Theme"),
            //trailing: const Icon(Icons.arrow_forward),
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const ThemeSettingsPage()),
              );
            },
          ),
          Center(child: Text("More coming soon..."))
        ],
      ),
    );
  }
}