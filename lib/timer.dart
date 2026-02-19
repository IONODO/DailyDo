import 'package:flutter/material.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool isPomodoro = false; // false → Stopwatch, true → Pomodoro
  //stopwatch details
  String stopwatchmins = "00", stopwatchsecs="00";
  bool isStopwatchrunning = false;
  int swmin = 0, swsec=0;
  late Timer _swtimer;
  bool isReturnVisible = false;

  void startStopwatch(){
    setState(() {
      isStopwatchrunning = true;
    });
    _swtimer = Timer.periodic(Duration(seconds: 1), (timer){
      _swSecond();
    });
  }

  void _swSecond(){
    setState(() {
      swsec ++;
      stopwatchsecs = swsec.toString();
      if(stopwatchsecs.length == 1){
        stopwatchsecs = "0$stopwatchsecs";
      } else{
        _swMinutes();
      }
    });
  }

  void _swMinutes(){
    setState(() {
      swsec=0;
      stopwatchsecs="00";
      swmin++;
      stopwatchmins = swmin.toString();
      if(stopwatchmins.length == 1){
        stopwatchmins = "0$stopwatchmins";
      }
    });
  }

  void stopStopwatch(){
    _swtimer.cancel();
    setState(() {
      isStopwatchrunning=false;
    });
    isReturnVisible = checkVals();
  }

  void resetStopwatch(){
    _swtimer.cancel();
    setState(() {
      swsec=0;
      swmin=0;
      stopwatchmins="00";
      stopwatchsecs="00";
      isReturnVisible = false;
    });
  }

  bool checkVals(){
    if(swsec!=0 || swmin!=0){
      return true;
    } else{
      return false;
    }
  }

  void startPomo(){

  }

  void pausePomo(){

  }

  void endPomo(){
    //this will end the current pomo and start running the next break timer too, which should be skippable

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Toggle buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: (){setState(() {
                    isPomodoro=false;
                  });}, 
                  child: Text("Stopwatch")
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: (){setState(() {
                    isPomodoro=true;
                  });}, 
                  child: Text("Pomodoro")
                ),
              ],
            ),
            const SizedBox(height: 30),

            // AnimatedSwitcher smoothly transitions between both UIs
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: isPomodoro
                    ? _buildPomodoroUI(context)
                    : _buildStopwatchUI(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Stopwatch Layout ---
  Widget _buildStopwatchUI(BuildContext context) {
    return Column(
      key: const ValueKey("stopwatch"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(70),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Text(
            "$stopwatchmins:$stopwatchsecs",
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon((isStopwatchrunning ? Icons.pause : Icons.play_arrow)),
              onPressed: (){
                if(isStopwatchrunning){
                  stopStopwatch();
                } else{
                  startStopwatch();
                }
              },
              label: Text(isStopwatchrunning ? "Pause" : "Play"),
            ),
            SizedBox(height: 30)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            (isReturnVisible && !isStopwatchrunning) ? ElevatedButton.icon(
              icon: const Icon(Icons.replay),
              onPressed: (){
                resetStopwatch();
              },
              label: Text("Reset"),
            ) : SizedBox(height: 30),
          ],
        )
      ],
    );
  }

  // --- Pomodoro Layout ---
  Widget _buildPomodoroUI(BuildContext context) {
    return Column(
      key: const ValueKey("pomodoro"),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: const Text(
            "25:00",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {},
              label: const Text("Start"),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.pause),
              onPressed: () {},
              label: const Text("Pause"),
            ),
          ],
        ),
      ],
    );
  }
}
