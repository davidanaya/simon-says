import 'dart:async';
import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'package:simon_says/src/widgets/simon_board.dart' show SimonColor;

enum GameState { intro, simonSays, userSays, gameOver }

class SimonGameService {
  int _round = 0;
  final _round$ = BehaviorSubject<int>(seedValue: 0);

  int _userPlayIndex = 0;
  final _userPlayController = StreamController<SimonColor>();

  List<SimonColor> _sequence = [];
  final _state$ = BehaviorSubject<GameState>(seedValue: GameState.intro);
  final _currentPlay$ = PublishSubject<SimonColor>();

  Stream<int> get round$ => _round$.stream;
  Stream<GameState> get state$ => _state$.stream;

  // current color being played by Simon
  Stream<SimonColor> get currentPlay$ => _currentPlay$.stream
      .concatMap((i) => Observable.timer(i, Duration(milliseconds: 500)));

  // used to handle user play
  Sink<SimonColor> get play => _userPlayController.sink;

  SimonGameService() {
    _state$.listen(_stateHandler);
    _userPlayController.stream.listen(_handleUserPlay);
  }

  void startGame() {
    _round = 0;
    _userPlayIndex = 0;
    _sequence.clear();
    _state$.add(GameState.simonSays);
  }

  void _handleUserPlay(SimonColor play) {
    print('user play --> $play');
    if (_sequence[_userPlayIndex] == play) {
      _userPlayIndex++;
    } else {
      _state$.add(GameState.gameOver);
    }
    if (_userPlayIndex == _sequence.length) {
      _state$.add(GameState.simonSays);
    }
  }

  void _stateHandler(GameState state) {
    print('STATE --> $state');
    switch (state) {
      case GameState.simonSays:
        return _handleSimonSays();
      case GameState.gameOver:
        return _handleGameOver();
      default:
    }
  }

  _handleSimonSays() {
    _round$.add(++_round);
    _userPlayIndex = 0;
    _sequence.add(_generateRandomPlay());
    print(_sequence);
    _sequence.forEach(_currentPlay$.add);
    // TODO review this, it's not reactive and very dangerous
    Timer(Duration(milliseconds: 1000 * _sequence.length),
        () => _state$.add(GameState.userSays));
  }

  _handleGameOver() {
    print('G A M E O V E R');
    _round$.add(++_round);
  }

  SimonColor _generateRandomPlay() {
    var number = Random().nextInt(SimonColor.values.length);
    return SimonColor.values[number];
  }

  void dispose() {
    _userPlayController.close();
    _currentPlay$.close();
    _round$.close();
  }
}
