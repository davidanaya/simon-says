import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/models/game_play.dart';
import 'package:simon_says/src/models/game_plays.dart';
import 'package:simon_says/src/services/sound_player.dart';

class GameBloc {
  // sound player
  final SoundPlayer _soundPlayer;

  // plays
  final _gamePlays = GamePlays();

  final _simonPlay$ = PublishSubject<GamePlay>();
  final _userPlayController = StreamController<GameColor>();

  final _playPressAnimationStart = StreamController<GameColor>();

  Stream<GamePlay> get simonPlay$ =>
      _simonPlay$.stream.concatMap((play) => Observable.timer(
          play,
          Duration(
              milliseconds: gameSpeedTimes[GameSpeedTimeMs.simonPlayDelay])));

  Sink<GameColor> get userPlay => _userPlayController.sink;

  // play sound when key is pressed
  Sink<void> get playPressAnimationStart => _playPressAnimationStart.sink;

  // state
  final BehaviorSubject<GameState> _state$ =
      BehaviorSubject<GameState>(seedValue: GameState.intro);
  Stream<GameState> get state$ => _state$.stream.distinct();

  // round
  int _round = 0;
  BehaviorSubject<int> _round$ = BehaviorSubject<int>(seedValue: 0);
  Stream<int> get round$ => _round$;

  GameBloc(this._soundPlayer) {
    _soundPlayer.state$.listen((s) => print('audioPlayerState $s'));

    state$.listen(_stateHandler);

    Observable(simonPlay$)
        .doOnData((play) => print('SIMON PLAY --> ${play.play}'))
        .where((play) => play.isLastPlay)
        .delay(Duration(
            milliseconds: gameSpeedTimes[GameSpeedTimeMs.lastPlayDelay]))
        .listen(_lastSimonPlayHandler);

    _userPlayController.stream.listen(_userPlayHandler);

    _playPressAnimationStart.stream.listen(_playSound);
  }

  void _stateHandler(GameState state) {
    print('STATE --> $state');
    if (state == GameState.simonSays) {
      _simonSaysHandler();
    }
  }

  _simonSaysHandler() {
    _setRound(_round + 1);
    _gamePlays.newSimonPlay();
    print(_gamePlays.simonPlays.map((play) => '${play.play}'));
    _gamePlays.simonPlays.forEach(_simonPlay$.add);
  }

  void _userPlayHandler(GameColor play) {
    print('USER PLAY --> $play');
    if (_gamePlays.validateUserPlay(play)) {
      if (_gamePlays.isUserTurnFinished()) {
        Timer(
            Duration(
                milliseconds: gameSpeedTimes[GameSpeedTimeMs.lastPlayDelay]),
            () => _state$.add(GameState.simonSays));
      }
    } else {
      _state$.add(GameState.gameOver);
      _setRound(0);
    }
  }

  void _lastSimonPlayHandler(GamePlay play) {
    _state$.add(GameState.userSays);
  }

  void startGame() {
    _setRound(0);
    _gamePlays.clear();
    _state$.add(GameState.simonSays);
  }

  void dispose() {
    _userPlayController.close();
    _playPressAnimationStart.close();
    _playPressAnimationEnd.close();
    _state$.close();
    _simonPlay$.close();
  }

  void _setRound(int round) {
    _round = round;
    _round$.add(_round);
  }

  void _playSound(GameColor play) async {
    await _soundPlayer.stop();

    _soundPlayer.play(play);
  }
}
