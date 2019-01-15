import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simon_says/src/models/best_score.dart';
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
  Stream<int> get round$ => _round$.distinct();

  // preferences
  SharedPreferences _prefs;
  int _maxRound;
  int _bestTime;

  final _bestScore$ = PublishSubject<BestScore>();
  Stream<BestScore> get bestScore$ => _bestScore$.stream;

  // score
  // we could use Stopwatch
  // https://api.dartlang.org/stable/2.1.0/dart-core/Stopwatch-class.html
  DateTime _gameTimeStart;

  GameBloc(this._soundPlayer) {
    _soundPlayer.state$.listen((s) => print('audioPlayerState $s'));

    _bestScore$.listen((s) => print('bestscore ${s.round}-${s.time}'));

    state$.listen(_stateHandler);

    Observable(simonPlay$)
        .doOnData((play) => print('SIMON PLAY --> ${play.play}'))
        .where((play) => play.isLastPlay)
        .delay(Duration(milliseconds: lastPlayDelayMs))
        .listen(_lastSimonPlayHandler);

    _userPlayController.stream.listen(_userPlayHandler);

    _playPressAnimationStart.stream.listen(_playSound);

    _loadPreferences();
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
    _bestScore$.close();
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

  void _userPlayHandler(GameColor play) async {
    print('USER PLAY --> $play');
    if (_gamePlays.validateUserPlay(play)) {
      if (_gamePlays.isUserTurnFinished()) {
        Timer(Duration(milliseconds: lastPlayDelayMs),
            () => _state$.add(_newGameState(GameState.SimonSays)));
      }
    } else {
      var isBestScore = false;
      if (_isBestScore()) {
        // at some point we might need to separate this
        await _savePreferences();
        isBestScore = true;
        _bestScore$.add(BestScore(_maxRound, _bestTime));
      }
      final gameState = GameState(GameState.GameOver, _gameDuration, _round,
          isBestScore: isBestScore);
      _state$.add(gameState);
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

  void _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _maxRound = _prefs.getInt('simonsays.max_round') ?? 0;
    _bestTime = _prefs.getInt('simonsays.best_time') ?? 0;
    _bestScore$.add(BestScore(_maxRound, _bestTime));
  }

  Future<List<bool>> _savePreferences() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return Future.wait([
      _prefs.setInt('simonsays.max_round', _round),
      _prefs.setInt('simonsays.best_time', _gameDuration.inSeconds)
    ]);
  }

  bool _isBestScore() {
    return _round > _maxRound
        ? true
        : _round == _maxRound ? _gameDuration.inSeconds < _bestTime : false;
  }
}
