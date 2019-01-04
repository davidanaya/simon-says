import 'dart:math';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';

import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/models/game_play.dart';

class Game {
  BehaviorSubject<GameState> _state$ =
      BehaviorSubject<GameState>(seedValue: GameState.intro);

  int _round = 0;
  BehaviorSubject<int> _round$ = BehaviorSubject<int>(seedValue: 0);

  List<GamePlay> _simonSequence = [];
  int _userPlayIndex = 0;

  Stream<GameState> get state$ => _state$.stream;
  Stream<int> get round$ => _round$.stream;

  UnmodifiableListView<GamePlay> get simonSequence =>
      UnmodifiableListView(_simonSequence);

  void restartGame() {
    _setRound(0);
    _simonSequence.clear();
    _state$.add(GameState.simonSays);
  }

  void newRound() {
    _setRound(_round + 1);
    _userPlayIndex = 0;
    _addSimonPlay();
  }

  void setState(GameState state) {
    if (state != null) {
      _state$.add(state);
    }
  }

  void endGame() {
    _setRound(0);
  }

  bool validateUserPlay(SimonColor play) {
    if (!_isValidUserPlay(play)) {
      return false;
    }
    _userPlayIndex++;
    return true;
  }

  bool isUserTurnFinished() {
    return _userPlayIndex == _simonSequence.length;
  }

  bool _isValidUserPlay(SimonColor play) {
    return _simonSequence[_userPlayIndex].play == play;
  }

  void _addSimonPlay() {
    if (_simonSequence.length > 0) {
      _simonSequence[_simonSequence.length - 1].setAsNotLastPlay();
    }
    _simonSequence.add(_generateRandomPlay());
  }

  GamePlay _generateRandomPlay() {
    var number = Random().nextInt(SimonColor.values.length);
    return GamePlay(SimonColor.values[number]);
  }

  void _setRound(int round) {
    _round = round;
    _round$.add(_round);
  }
}
