import 'package:simon_says/src/models/game_state.dart';
import 'package:simon_says/src/models/simon_color.dart';
import 'package:simon_says/src/theme/colors.dart';

enum GameColor { green, red, yellow, blue }

final int buttonAnimationMs = 200;
final int simonPlayDelayMs = 500;
final int lastPlayDelayMs = 1000;
final int failedPlayRepeatTimes = 3;
final int failedPlayRepeatDelayMs = 300;
final int failedPlayButtonAnimationMs = 100;
final int overlayNoGameInfoAnimationMs = 3000;

final Map<GameColor, SimonColor> gameColors = {
  GameColor.green: SimonColor($colors['green'],
      accent: $colors['greenAccent'], soundFileName: 'green'),
  GameColor.red: SimonColor($colors['red'],
      accent: $colors['redAccent'], soundFileName: 'red'),
  GameColor.yellow: SimonColor($colors['yellow'],
      accent: $colors['yellowAccent'], soundFileName: 'yellow'),
  GameColor.blue: SimonColor($colors['blue'],
      accent: $colors['blueAccent'], soundFileName: 'blue')
};

final SimonColor failColor =
    SimonColor($colors['green'], accent: $colors['greyAccent']);

final String gameTitle = 'simon says';

final Map<String, String> statusMessages = {
  GameState.Intro: 'Ready to play?',
  GameState.SimonSays: 'Simon\'s turn, pay attention',
  GameState.UserSays: 'Your turn',
  GameState.GameOver: 'G A M E  O V E R'
};
