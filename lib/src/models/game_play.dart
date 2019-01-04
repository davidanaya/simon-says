import 'package:simon_says/src/models/constants.dart';

class GamePlay {
  final SimonColor play;
  bool _isLastPlay = true;

  bool get isLastPlay => _isLastPlay;

  GamePlay(this.play, {bool isLastPlay}) : _isLastPlay = isLastPlay ?? true;

  void setAsNotLastPlay() {
    _isLastPlay = false;
  }
}
