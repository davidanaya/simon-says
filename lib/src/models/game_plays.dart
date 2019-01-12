import 'dart:math';
import 'dart:collection';

import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/models/game_play.dart';

class GamePlays {
  List<GamePlay> _simonPlays = [];
  // we use -1 as we increase it always before checking the user play
  int _userPlayIndex = -1;

  UnmodifiableListView<GamePlay> get simonPlays =>
      UnmodifiableListView(_simonPlays);

  void clear() {
    _simonPlays.clear();
  }

  void newSimonPlay() {
    _userPlayIndex = -1;
    _addSimonPlay();
  }

  bool validateUserPlay(GameColor play) {
    _userPlayIndex++;
    return _isValidUserPlay(play);
  }

  bool isUserTurnFinished() {
    return _userPlayIndex == _simonPlays.length - 1;
  }

  GameColor getFailedPlay() {
    return _simonPlays[_userPlayIndex].play;
  }

  bool _isValidUserPlay(GameColor play) {
    return _simonPlays[_userPlayIndex].play == play;
  }

  void _addSimonPlay() {
    if (!_isEmpty()) {
      _simonPlays[_simonPlays.length - 1].setAsNotLastPlay();
    }
    _simonPlays.add(_generateRandomPlay());
  }

  bool _isEmpty() {
    return _simonPlays.length == 0;
  }

  GamePlay _generateRandomPlay() {
    var number = Random().nextInt(GameColor.values.length);
    return GamePlay(GameColor.values[number]);
  }
}
