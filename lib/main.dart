import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Randomizer',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 32.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Team Randomizer'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.access_time),),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Randomizer(),
              Settings(),
            ],
          ),
        ),
      ),
    );
  }
}

class Randomizer extends StatefulWidget {
  @override
  _RandomizerState createState() => _RandomizerState();
}

class _RandomizerState extends State<Randomizer> {
  final nameController = TextEditingController();
  List<String> government = [];
  List<String> opposition = [];
  List<String> judges = [];
  List<String> freeSpeakers = [];

  void _randomizeTeams() {
    List<String> allNames = nameController.text.split(RegExp(r'[\s,]+')).map((name) => name.trim()).toList();
    allNames.shuffle();

    government.clear();
    opposition.clear();
    judges.clear();
    freeSpeakers.clear();

      // Fill the "government" and "opposition" lists with up to three people each
    for (var person in allNames) {
      print(person);
      if (government.length < 3) {
        government.add(person);
    } else if (opposition.length < 3) {
        opposition.add(person);
    } else if (judges.length < 2) {
        judges.add(person);
    } else {
        freeSpeakers.add(person);
    }

    }

    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Enter names separated by spaces or commas',
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _randomizeTeams,
            child: Text('Randomize Teams'),
          ),
          SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                  // Widgets for the "government" team
                  Text('Government: '),
                  Text('${government.join(', ')}'),
                  Text('Judges:'),
                  Text('${judges.join(', ')}')
                  ],
              ),
          ),
            Expanded(
              child: Column(
                children: [
                // Widgets for the "opposition" team
                Text('Opposition:'),
                Text(' ${opposition.join(', ')}'),
                Text('Free Speakers: '),
                Text(' ${freeSpeakers.join(', ')}'),
                
                ],
            ),
          ),
          ],
          ),
      
    
        ],
      ),
    );
  }
}

// Build a timer that allows the user to set the number of minutes and seconds
// and start and stop the timer. The timer should count down from the number of
// minutes and seconds the user has set and stop when it reaches 0.
// The timer should also be able to be paused and resumed.
// The timer should also be able to be reset to the original number of minutes
// and seconds.


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _minutes = 7;
  int _seconds = 0;
  bool _isRunning = false;
  Timer? _timer;

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds == 0) {
          if (_minutes == 0) {
            _isRunning = false;
            _timer?.cancel();
          } else {
            _minutes--;
            _seconds = 59;
          }
        } else {
          _seconds--;
        }
      });
    });
  }

  void _stopTimer() {
    _isRunning = false;
    _timer?.cancel();
    // Update the UI
    setState(() {});
  }

  void _resetTimer() {
    _isRunning = false;
    _timer?.cancel();
    _minutes = 7;
    _seconds = 0;
    // Update the UI 
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Time Remaining: $_minutes:${_seconds.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodyMedium)),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? null : _startTimer,
                child: Text('Start'),
              ),
              ElevatedButton(
                onPressed: _isRunning ? _stopTimer : null,
                child: Text('Stop'),
              ),
              ElevatedButton(
                onPressed: _resetTimer,
                child: Text('Reset')),
              DropdownButton<int>(
                value: _minutes,
                onChanged: _isRunning ? null : (value) {
                  setState(() {
                    _minutes = value!;
                  });
                },
                items: List.generate(60, (index) => index + 1).map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text('$value minutes'),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}