import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logging/logging.dart';

import 'package:simon_says/src/bloc/app_bloc.dart';
import 'package:simon_says/src/bloc/bloc_provider.dart';
import 'package:simon_says/src/pages/home_page.dart';
import 'package:simon_says/src/services/sound_player.dart';

void main() {
  SoundPlayer soundPlayer = SoundPlayer();

  // hide status bar
  SystemChrome.setEnabledSystemUIOverlays([]);

  // configure logger
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName}(${rec.level.name}): ${rec.time}: ${rec.message}');
  });

  final appBloc = AppBloc(soundPlayer);

  runApp(MyApp(appBloc, soundPlayer));
}

class MyApp extends StatelessWidget {
  final AppBloc bloc;
  final SoundPlayer _player;

  MyApp(this.bloc, this._player);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _player.loadSounds(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _buildApp()
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildApp() {
    return BlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: 'Simon Says',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Lalezar',
        ),
        home: HomePage(),
      ),
    );
  }
}
