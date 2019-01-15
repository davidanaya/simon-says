class GameState {
  static const Intro = 'Intro';
  static const GameOver = 'GameOver';
  static const SimonSays = 'SimonSays';
  static const UserSays = 'UserSays';

  final String state;
  final Duration time;
  final int round;

  final isBestScore;

  GameState(this.state, this.time, this.round, {isBestScore})
      : this.isBestScore = isBestScore ?? false;

  int get score => round;

  bool get isPlayState =>
      state == GameState.UserSays || state == GameState.SimonSays;

  int get duration => time.inSeconds;
}
