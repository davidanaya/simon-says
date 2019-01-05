import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/models/game.dart';
import 'package:simon_says/src/models/game_play.dart';

class GameBloc {
  final _game = Game();

  final _simonPlay$ = PublishSubject<GamePlay>();

  final _userPlayController = StreamController<SimonColor>();

  Stream<GameState> get state$ => _game.state$.distinct();
  Stream<int> get round$ => _game.round$;

  Stream<GamePlay> get simonPlay$ => _simonPlay$.stream
      .concatMap((play) => Observable.timer(play, Duration(milliseconds: 500)));

  Sink<SimonColor> get play => _userPlayController.sink;

  GameBloc() {
    state$.listen(_stateHandler);

    Observable(simonPlay$)
        .doOnData((play) => print('SIMON PLAY --> ${play.play}'))
        .where((play) => play.isLastPlay)
        .delay(Duration(seconds: 1))
        .listen(_lastSimonPlayHandler);

    _userPlayController.stream.listen(_userPlayHandler);
  }

  void _stateHandler(GameState state) {
    print('STATE --> $state');
    if (state == GameState.simonSays) {
      _simonSaysHandler();
    }
  }

  _simonSaysHandler() {
    _game.newRound();
    print(
        _game.simonSequence.map((play) => '(${play.play},${play.isLastPlay})'));
    _game.simonSequence.forEach(_simonPlay$.add);
  }

  void _userPlayHandler(SimonColor play) {
    print('USER PLAY --> $play');
    if (_game.validateUserPlay(play)) {
      if (_game.isUserTurnFinished()) {
        Timer(Duration(milliseconds: 1000),
            () => _game.setState(GameState.simonSays));
      }
    } else {
      _game.setState(GameState.gameOver);
      _game.endGame();
    }
  }

  void _lastSimonPlayHandler(GamePlay play) {
    _game.setState(GameState.userSays);
  }

  void startGame() {
    _game.restartGame();
  }

  void dispose() {
    _userPlayController.close();
    _simonPlay$.close();
  }
}
