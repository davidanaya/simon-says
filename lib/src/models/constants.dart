import 'package:flutter/material.dart';
import 'package:simon_says/src/models/game_state.dart';

import 'package:simon_says/src/models/simon_color.dart';

// enum GameState { intro, simonSays, userSays, gameOver }

enum GameColor { green, red, yellow, blue }

final int buttonAnimationMs = 200;
final int simonPlayDelayMs = 500;
final int lastPlayDelayMs = 1000;
final int failedPlayRepeatTimes = 3;
final int failedPlayRepeatDelayMs = 300;
final int failedPlayButtonAnimationMs = 100;
final int overlayNoGameInfoAnimationMs = 3000;

final Map<GameColor, SimonColor> gameColors = {
  GameColor.green: SimonColor(Colors.green,
      accent: Colors.green[300], soundFileName: 'green'),
  GameColor.red:
      SimonColor(Colors.red, accent: Colors.red[300], soundFileName: 'red'),
  GameColor.yellow: SimonColor(Colors.yellow,
      accent: Colors.yellow[300], soundFileName: 'yellow'),
  GameColor.blue:
      SimonColor(Colors.blue, accent: Colors.blue[300], soundFileName: 'blue')
};

final SimonColor failColor = SimonColor(Colors.grey, accent: Colors.grey[300]);

final String gameTitle = 'simon says';

final Map<String, String> statusMessages = {
  GameState.Intro: 'Ready to play?',
  GameState.SimonSays: 'Simon\'s turn, pay attention...',
  GameState.UserSays: 'Your turn...',
  GameState.GameOver: 'G A M E  O V E R'
};
