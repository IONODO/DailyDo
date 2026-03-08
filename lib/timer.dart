import 'package:flutter/material.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool isPomodoro = false; // false->Stopwatch, true->Pomodoro
  //stopwatch details
  String stopwatchmins = "00", stopwatchsecs="00";
  bool isStopwatchrunning = false;
  int swmin = 0, swsec=0;
  late Timer _swtimer;
  bool isReturnVisible = false;

  //pomodoro details
  int pomoFocusMin=25,pomoBreakMin=5;
  int pomosec=0;
  bool isPomorunning = false;
  bool onBreak=false; //must remember this is pomodoro's
  Timer? _pomotimer; 
  int remainingSeconds = 25 * 60; // always in seconds
  bool isPomoRunning = false;
  bool pomoResetShow = false;

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
      swsec++;
      if (swsec < 60) {
        stopwatchsecs = swsec.toString().padLeft(2, '0');
      } else {
        _swMinutes();
      }
    });
  }

  void _swMinutes(){
    setState(() {
      swsec=0;
      stopwatchsecs="00";
      swmin++;
      stopwatchmins = swmin.toString().padLeft(2, '0');
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
    setState(() {
      isPomoRunning = true;
    });
    _pomotimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        }else {
          timer.cancel();
          isPomoRunning = false;
          onBreak = !onBreak;
          if (onBreak) {
            // start break automatically, should be changable in settings
            remainingSeconds = pomoBreakMin * 60;
            startPomo();
          } else {
            // break finished, goes back to focus
            remainingSeconds = pomoFocusMin * 60;
          }
        }
      });
    });
  }

  void pausePomo(){
    _pomotimer?.cancel();
    setState(() {
      isPomoRunning = false;
      pomoResetShow = true;
    });
  }

  void endPomo(){
    //this will end the current pomo and start running the next break timer too, which should be skippable
    _pomotimer?.cancel();
      setState(() {
        isPomoRunning = false;
        pomoResetShow = false;
        onBreak = false;
        remainingSeconds = pomoFocusMin * 60;
      });
    }

    String _formatPomoTime(int totalSeconds) {
      final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
      final s = (totalSeconds % 60).toString().padLeft(2, '0');
      return "$m:$s";
    } //just to format the pomodoro times cause rn its a mess

  void _openPomodoroDialog() {
    final focusController = TextEditingController(text: pomoFocusMin.toString());
    final breakController = TextEditingController(text: pomoBreakMin.toString());
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Set Pomodoro & Break Duration",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: focusController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Focus (minutes)",
                  border: OutlineInputBorder(),
                  hintText: "1-120",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: breakController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Break (minutes)",
                  border: OutlineInputBorder(),
                  hintText: "1-120",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final int? focusMin = int.tryParse(focusController.text);
                final int? breakMin = int.tryParse(breakController.text);
  
                if (focusMin == null || breakMin == null || 
                    focusMin <= 0 || breakMin <= 0 || 
                    focusMin > 120 || breakMin > 120) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Enter valid durations between 1-120 minutes."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
  
                setState(() {
                  pomoFocusMin = focusMin;
                  pomoBreakMin = breakMin;
                  remainingSeconds = pomoFocusMin * 60; // reset timer
                });
  
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
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
                  style: TextButton.styleFrom(
                    backgroundColor: isPomodoro ? Colors.transparent : Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                  child: Text("Stopwatch")
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: (){setState(() {
                    isPomodoro=true;
                  });}, 
                  style: TextButton.styleFrom(
                    backgroundColor: isPomodoro ? Theme.of(context).colorScheme.surfaceContainerHigh : Colors.transparent,
                  ),
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
        GestureDetector(
          onTap: _openPomodoroDialog,
          child: Container(
            height: 200,
            width: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Text(
              _formatPomoTime(remainingSeconds),
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(isPomoRunning ? Icons.pause : Icons.play_arrow),
              onPressed: isPomoRunning ? pausePomo : startPomo,
              label: Text(isPomoRunning ? "Pause":"Start"),
            ),
            const SizedBox(width: 12),
            (pomoResetShow && !isPomoRunning) ? ElevatedButton.icon(
              icon: const Icon(Icons.replay),
              onPressed: (){
                endPomo();
              },
              label: Text("Reset"),
            ) : SizedBox(height: 30),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (isStopwatchrunning) _swtimer.cancel();
    if (isPomoRunning) _pomotimer?.cancel();
      super.dispose();
  }
}
