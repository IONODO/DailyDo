import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';


class CalendarPage extends StatefulWidget{
  const CalendarPage ({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.now();
  final baseDate = DateTime.now();
  late ScrollController scrollController;
  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      initialScrollOffset: 10000 * 70,
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextButton(
          onPressed: (){}, 
          child: Text(DateFormat.MMMM().format(selectedDate),style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10,left:10),
            child: DatePicker(
              DateTime.now(),
              width: 60,
              height: 100,
              initialSelectedDate: DateTime.now(),
              selectionColor: Theme.of(context).colorScheme.primary,
              selectedTextColor: Colors.white,
              onDateChange: (date){
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 20000,
              itemBuilder: (context,index){
                DateTime date = baseDate.add(Duration(days: index -10000 ));
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedDate=date;
                    });
                  },
                  child: SizedBox(
                    width: 70,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                      color: isSameDate(selectedDate, date)? Theme.of(context).colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat('MMM').format(date),style: isSameDate(selectedDate, date)? TextStyle(color: Colors.white) : TextStyle(color: Colors.black)),
                          Text(DateFormat('d').format(date),style: isSameDate(selectedDate, date)? TextStyle(color: Colors.white) : TextStyle(color: Colors.black)),
                          Text(DateFormat('E').format(date),style: isSameDate(selectedDate, date)? TextStyle(color: Colors.white) : TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}