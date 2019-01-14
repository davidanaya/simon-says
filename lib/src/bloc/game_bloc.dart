import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/models/game_play.dart';
import 'package:simon_says/src/models/game_plays.dart';
import 'package:simon_says/src/models/game_state.dart';
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
              milliseconds: play.isFailedPlay
                  ? failedPlayRepeatDelayMs
                  : simonPlayDelayMs)));

  Sink<GameColor> get userPlay => _userPlayController.sink;

  // play sound when key is pressed
  Sink<void> get playPressAnimationStart => _playPressAnimationStart.sink;

  // state
  final BehaviorSubject<GameState> _state$ = BehaviorSubject<GameState>(
      seedValue: GameState(GameState.Intro, Duration(milliseconds: 0), 0));
  Stream<GameState> get state$ => _state$.stream.distinct();

  // round
  int _round = 0;
  BehaviorSubject<int> _round$ = BehaviorSubject<int>(seedValue: 0);
  Stream<int> get round$ => _round$;

  // score
  // we could use Stopwatch
  // https://api.dartlang.org/stable/2.1.0/dart-core/Stopwatch-class.html
  DateTime _gameTimeStart;

  GameBloc(this._soundPlayer) {
    _soundPlayer.state$.listen((s) => print('audioPlayerState $s'));

    state$.listen(_stateHandler);

    Observable(simonPlay$)
        .doOnData((play) => print('SIMON PLAY --> ${play.play}'))
        .where((play) => play.isLastPlay)
        .delay(Duration(milliseconds: lastPlayDelayMs))
        .listen(_lastSimonPlayHandler);

    _userPlayController.stream.listen(_userPlayHandler);

    _playPressAnimationStart.stream.listen(_playSound);
  }

  void startGame() {
    _setRound(0);
    _gamePlays.clear();
    _gameTimeStart = DateTime.now();
    _state$.add(_newGameState(GameState.SimonSays));
  }

  void dispose() {
    _userPlayController.close();
    _playPressAnimationStart.close();
    _state$.close();
    _simonPlay$.close();
  }

  void _stateHandler(GameState state) {
    print('STATE --> $state');
    if (state.state == GameState.SimonSays) {
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
        Timer(Duration(milliseconds: lastPlayDelayMs),
            () => _state$.add(_newGameState(GameState.SimonSays)));
      }
    } else {
      _state$.add(_newGameState(GameState.GameOver));
      _sentFailPlayBatch();
      _setRound(0);
    }
  }

  void _lastSimonPlayHandler(GamePlay play) {
    _state$.add(_newGameState(GameState.UserSays));
  }

  void _setRound(int round) {
    _round = round;
    _round$.add(_round);
  }

  void _sentFailPlayBatch() {
    var failedPlay = GamePlay(_gamePlays.getFailedPlay(),
        isLastPlay: false, isFailedPlay: true);
    RepeatStream((count) => Observable.just(failedPlay), failedPlayRepeatTimes)
        .listen(_simonPlay$.add);
  }

  Duration get _gameDuration => DateTime.now().difference(_gameTimeStart);

  GameState _newGameState(String state) {
    return GameState(state, _gameDuration, _round);
  }

  void _playSound(GameColor play) async {
    await _soundPlayer.stop();
    _soundPlayer.play(play);
  }
}
