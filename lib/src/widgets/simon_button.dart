import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simon_says/src/services/simon_game_service.dart';

import 'package:simon_says/src/widgets/simon_board.dart' show SimonColor;

final double buttonPadding = 12.0;
final double buttonPressedPadding = 24.0;

class SimonButton extends StatefulWidget {
  final SimonColor color;
  final Function onPressed;
  final SimonGameService _service;

  final int timerMs = 200;

  SimonButton(this._service, {@required this.color, @required this.onPressed});

  @override
  _SimonButtonState createState() => _SimonButtonState();
}

class _SimonButtonState extends State<SimonButton> {
  double _padding = buttonPadding;
  bool _isPressed = false;
  GameState _state;

  @override
  Widget build(BuildContext context) {
    widget._service.currentPlay$.listen(_handlePlay);
    widget._service.state$.listen((state) => _state = state);

    return Container(
      margin: EdgeInsets.all(_padding),
      child: GestureDetector(
        onTapDown: _onTapDown,
        child: Container(
            decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (_state == GameState.userSays) {
      widget.onPressed(widget.color);
    }
    _updateState(buttonPressedPadding, true);
    Timer(Duration(milliseconds: widget.timerMs),
        () => _updateState(buttonPadding, false));
  }

  void _updateState(double padding, bool isPressed) {
    setState(() {
      _padding = padding;
      _isPressed = isPressed;
    });
  }

  void _handlePlay(SimonColor color) {
    if (color == widget.color) {
      _onTapDown(null);
    }
  }

  Color get _color {
    switch (widget.color) {
      case SimonColor.green:
        return _isPressed ? Colors.green[300] : Colors.green;
      case SimonColor.red:
        return _isPressed ? Colors.red[300] : Colors.red;
      case SimonColor.yellow:
        return _isPressed ? Colors.yellow[300] : Colors.yellow;
      case SimonColor.blue:
        return _isPressed ? Colors.blue[300] : Colors.blue;
    }
    return null;
  }
}
