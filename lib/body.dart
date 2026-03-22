import 'package:flutter/material.dart';
import 'package:prod_app/calendar.dart';
import 'package:prod_app/task.dart';
import 'package:prod_app/settings.dart';
import 'package:prod_app/timer.dart';

class Body extends StatefulWidget{
  const Body({super.key});
  
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body>{
  int currentPageIndex=0;
  bool isTimerRunning = false;
  late final List<Widget> _pages;

  @override
  void initState(){
    super.initState();
    _pages = [
      TaskPage(),
      TimerPage(onTimerStarted: (running){    
        setState((){
          isTimerRunning=running;
        }); 
      }),
      CalendarPage(),
      SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
      bottomNavigationBar: isTimerRunning
    ? null
    : NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          if (index == 3) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          } else {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.check), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Timer'),
          NavigationDestination(icon: Icon(Icons.calendar_month_rounded), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}