enum GameState { intro, simonSays, userSays, gameOver }

enum SimonColor { green, red, yellow, blue }

final Map<GameState, String> statusMessages = {
  GameState.intro: 'Ready to play? Tap the center',
  GameState.simonSays: 'Simon\'s turn, pay attention...',
  GameState.userSays: 'Your turn...',
  GameState.gameOver: 'G A M E  O V E R'
};
