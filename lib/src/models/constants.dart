import 'package:flutter/material.dart';

import 'package:simon_says/src/models/simon_color.dart';

enum GameState { intro, simonSays, userSays, gameOver }

enum GameColor { green, red, yellow, blue }

enum GameSpeedTimeMs { buttonAnimation, simonPlayDelay, lastPlayDelay }

final Map<GameSpeedTimeMs, int> gameSpeedTimes = {
  GameSpeedTimeMs.buttonAnimation: 200,
  GameSpeedTimeMs.simonPlayDelay: 500,
  GameSpeedTimeMs.lastPlayDelay: 1000,
};

final Map<GameColor, SimonColor> gameColors = {
  GameColor.green: SimonColor(Colors.green, Colors.green[300]),
  GameColor.red: SimonColor(Colors.red, Colors.red[300]),
  GameColor.yellow: SimonColor(Colors.yellow, Colors.yellow[300]),
  GameColor.blue: SimonColor(Colors.blue, Colors.blue[300])
};

final Map<GameState, String> statusMessages = {
  GameState.intro: 'Ready to play? Tap the center',
  GameState.simonSays: 'Simon\'s turn, pay attention...',
  GameState.userSays: 'Your turn...',
  GameState.gameOver: 'G A M E  O V E R'
};
