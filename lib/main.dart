import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Soundchat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static AudioCache player = AudioCache();

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  @override
  void initState() {
    pusher.init(
        apiKey: "secret",
        cluster: "mt1",
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        authEndpoint: "https://marcel-auth.herokuapp.com/pusher/auth",
        onAuthorizer: onAuthorizer);

    pusher.connect();
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
    return {
      "auth": "foo:bar",
      "channel_data": '{"user_id": 1}',
      "shared_secret": "foobar"
    };
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState (from $previousState)");

    if (previousState == "CONNECTING" && currentState == "CONNECTED") {
      print("subscribing...");
      pusher.subscribe(channelName: "private-soundchat-channel-1");
    }
  }

  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    print("onEvent2 : $event");

    print("gonna compare");
    if (event.eventName == "client-play") {
      print("oh mama");
      print(event.data);
      print("oh mama 2");
      print(event.data.runtimeType);
      print("oh mama 3");
      final parsedData = jsonDecode(event.data);
      final instrument = parsedData["instrument"];
      print("gonna play $instrument because I got a client-play event");

      play(instrument);
    } else {
      print("confused");
      print("wat ${event.eventName}");
    }

    print("-------exiting onEvent");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("onSubscriptionSucceeded: $channelName data: $data");
    // final me = pusher.getChannel(channelName)?.me;
    // print("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    print("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    print("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print("onMemberRemoved: $channelName user: $member");
  }

  void pub(String instrument) async {
    String data = "{\"instrument\": \"$instrument\"}";
    PusherEvent e = PusherEvent(
      channelName: "private-soundchat-channel-1",
      eventName: "client-play",
      data: data,
    );
    pusher.trigger(e);
    print(
        "triggering eventName=${e.eventName} on channel=${e.channelName} with data=${e.data}");
  }

  void play(String instrument) {
    player.play('$instrument.mp3');
  }

  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                print("piano");
                play('piano');
                pub("piano");
              },
              child: const Text(
                "🎵 piano",
              ), //label text
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent //elevated button background color
                  ),
            ),
            ElevatedButton(
              onPressed: () {
                print("drums");
                play('drums');
                pub("drums");
              },
              child: const Text(
                "🥁 drums",
              ), //label text
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent //elevated button background color
                  ),
            ),
            ElevatedButton(
              onPressed: () {
                print("trumpet");
                play('trumpet');
                pub("trumpet");
              },
              child: const Text(
                "🎺 trumpet",
              ), //label text
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent //elevated button background color
                  ),
            ),
            ElevatedButton(
              onPressed: () {
                print("clap");
                play('clap');
                pub("clap");
              },
              child: const Text(
                "👏🏽 clap",
              ), //label text
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent //elevated button background color
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
