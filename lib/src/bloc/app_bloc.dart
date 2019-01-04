import 'package:simon_says/src/bloc/game_bloc.dart';

class AppBloc {
  final GameBloc _game;

  AppBloc() : _game = GameBloc();

  GameBloc get gameBloc => _game;
}
