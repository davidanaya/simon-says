import 'package:flutter/material.dart';

import 'package:simon_says/src/services/simon_game_service.dart';
import 'package:simon_says/src/services/simon_sounds_player.dart';
import 'package:simon_says/src/widgets/simon_board.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simon Says',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // sounds player does not work well at the moment, that's why it's not being used
  final SimonSoundsPlayer player = SimonSoundsPlayer();
  final SimonGameService service = SimonGameService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Simon Says'),
        ),
        body: Center(
            child: FutureBuilder(
                future: player.loadSounds(context),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState == ConnectionState.done
                      ? SimonBoard(service)
                      : CircularProgressIndicator();
                })));
  }
}
