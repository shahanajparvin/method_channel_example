import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import your ConnectivityService

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channel Communication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Method Channel'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:50),
            ElevatedButton(
              onPressed: () {
                ConnectivityService.turnOnWiFi();
              },
              child: Text('Turn On WiFi'),
            ),
            ElevatedButton(
              onPressed: () {
                ConnectivityService.turnOffWiFi();
              },
              child: Text('Turn Off WiFi'),
            ),
            ElevatedButton(
              onPressed: () {
                ConnectivityService.turnOnMobileData();
              },
              child: Text('Turn On Mobile Data'),
            ),

            ElevatedButton(
              onPressed: () {
                ConnectivityService.turnOffMobileData();
              },
              child: Text('Turn Off Mobile Data'),
            ),

            SizedBox(height:50),

            SizedBox(
                height:200,
                child: TimerEventChannel(title: 'Event Channel',))

          ],
        ),
      );
  }
}



class ConnectivityService {
  static const MethodChannel _channel =
  MethodChannel('your_channel_id'); // Change this to your channel ID

  static Future<void> turnOnWiFi() async {
    try {
      await _channel.invokeMethod('turnOnWiFi');
    } on PlatformException catch (e) {
      print("Failed to turn on WiFi: '${e.message}'.");
    }
  }

  static Future<void> turnOffWiFi() async {
    try {
      await _channel.invokeMethod('turnOffWiFi');
    } on PlatformException catch (e) {
      print("Failed to turn off WiFi: '${e.message}'.");
    }
  }

  static Future<void> turnOnMobileData() async {
    try {
      await _channel.invokeMethod('turnOnMobileData');
    } on PlatformException catch (e) {
      print("Failed to turn on mobile data: '${e.message}'.");
    }
  }

  static Future<void> turnOffMobileData() async {
    try {
      await _channel.invokeMethod('turnOffMobileData');
    } on PlatformException catch (e) {
      print("Failed to turn off mobile data: '${e.message}'.");
    }
  }
}

class TimerEventChannel extends StatefulWidget {
  const TimerEventChannel({super.key, required this.title});

  final String title;

  @override
  State<TimerEventChannel> createState() => _TimerEventChannelState();
}

class _TimerEventChannelState extends State<TimerEventChannel> {
  Stream<String> streamTimeFromNative() {
    const eventChannel = EventChannel('timeHandlerEvent');
    return eventChannel
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height:30),
            const Text(
              'Timer :',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            StreamBuilder<String>(
              stream: streamTimeFromNative(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

