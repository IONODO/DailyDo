import 'package:flutter/material.dart';
import 'package:prod_app/calendar.dart';
import 'package:prod_app/task.dart';
import 'package:prod_app/settings.dart';
import 'package:prod_app/timer.dart';
import 'package:prod_app/topbar.dart';

class Body extends StatefulWidget{
  const Body({super.key});
  
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body>{
  int currentPageIndex=0;
  final List<Widget> _pages = const [
    TaskPage(),
    TimerPage(),
    CalendarPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: TopBar(),
      ),
      body: _pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        // indicatorColor: Colors.amber,
        onDestinationSelected: (int index) {
          if(index==3){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsPage())
            );
          } else {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.check), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.timer),label: 'Timer',),
          NavigationDestination(icon: Icon(Icons.calendar_month_rounded), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}