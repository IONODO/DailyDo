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
          ListTile(
            title: const Text("Test notification"),
            onTap: () async {
              await NotificationService.instance.showNotifications(
                id: 1000,
                title: "Test",
                body: "Notification system works",
              );
            },
          ),
          ListTile(
            title: const Text("Scheduled notification test"),
            onTap: () async{
              await NotificationService.instance.scheduleNotification(
                id: 999, 
                title: "Scheduled timer works", 
                body: "YAY",
                scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
              );
            }
          ),
          Center(child: Text("More coming soon..."))
        ],
      ),
    );
  }
}