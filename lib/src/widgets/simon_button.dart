import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:simon_says/src/bloc/bloc_provider.dart';

import 'package:simon_says/src/models/constants.dart';

final double buttonPadding = 12.0;
final double buttonPressedPadding = 24.0;

final int timerMs = 200;

enum SimonButtonState { pressed, normal }

class SimonButton extends StatelessWidget {
  final SimonColor color;

  // an event here will mean either that the button has been tapped down or that is released
  // we can handle this better later on with animations
  final PublishSubject<bool> _isTapDown$ = PublishSubject<bool>();

  SimonButton(this.color);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context).gameBloc;

    // transform simon play into a tap down button event if the play involves this button
    final Stream<bool> simonPlay$ = bloc.simonPlay$
        .where((gamePlay) => gamePlay.play == color)
        .map((_) => true);

    // generate event from the button only if this is the users turn
    final Stream<bool> _isValidTapDown$ =
        _isTapDown$.withLatestFrom(bloc.state$, (isTapDown, state) {
      if (state == GameState.userSays && isTapDown) {
        bloc.play.add(color);
        return isTapDown;
      }
    });

    return StreamBuilder(
        stream: Observable.merge([simonPlay$, _isValidTapDown$]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildButton(
                context,
                snapshot.data
                    ? SimonButtonState.pressed
                    : SimonButtonState.normal);
          }
          return _buildButton(context, SimonButtonState.normal);
        });
  }

  Widget _buildButton(BuildContext context, SimonButtonState state) {
    var padding =
        state == SimonButtonState.normal ? buttonPadding : buttonPressedPadding;
    var bColor = _getColor(state == SimonButtonState.pressed);

    if (state == SimonButtonState.pressed) {
      // we could handle this with the observables as well, for each true emit a false after timerMs
      Timer(Duration(milliseconds: timerMs), () => _isTapDown$.add(false));
    }

    return Container(
      margin: EdgeInsets.all(padding),
      child: GestureDetector(
        onTapDown: (details) => _isTapDown$.add(true),
        child: Container(
            decoration: BoxDecoration(
                color: bColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
      ),
    );
  }

  Color _getColor(bool isPressed) {
    switch (color) {
      case SimonColor.green:
        return isPressed ? Colors.green[300] : Colors.green;
      case SimonColor.red:
        return isPressed ? Colors.red[300] : Colors.red;
      case SimonColor.yellow:
        return isPressed ? Colors.yellow[300] : Colors.yellow;
      case SimonColor.blue:
        return isPressed ? Colors.blue[300] : Colors.blue;
      default:
        return null;
    }
  }
}
