import 'package:simon_says/src/bloc/game_bloc.dart';

import 'package:simon_says/src/services/sound_player.dart';

class AppBloc {
  final GameBloc _game;

  AppBloc(SoundPlayer player) : _game = GameBloc(player);

  GameBloc get gameBloc => _game;
}
