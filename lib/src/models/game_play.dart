import 'package:simon_says/src/models/constants.dart';

class GamePlay {
  final GameColor play;
  bool _isLastPlay = true;
  bool _isFailedPlay = false;

  bool get isLastPlay => _isLastPlay;

  bool get isFailedPlay => _isFailedPlay;

  GamePlay(this.play, {bool isLastPlay, bool isFailedPlay})
      : _isLastPlay = isLastPlay ?? true,
        _isFailedPlay = isFailedPlay ?? false;

  void setAsNotLastPlay() {
    _isLastPlay = false;
  }
}
