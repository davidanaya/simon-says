import 'package:flutter/material.dart';
import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/widgets/simon_button.dart';
import 'package:simon_says/src/widgets/round_score.dart';

class SimonBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[_buildButtons(), RoundScore()]);
  }

  Widget _buildButtons() {
    return Container(
        padding: EdgeInsets.all(12.0),
        color: Colors.black,
        child: Column(children: <Widget>[_buildTopRow(), _buildBottomRow()]));
  }

  Widget _buildTopRow() {
    return _buildRow(GameColor.green, GameColor.red);
  }

  Widget _buildBottomRow() {
    return _buildRow(GameColor.yellow, GameColor.blue);
  }

  Widget _buildRow(GameColor color1, GameColor color2) {
    return Expanded(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildButton(color1),
            _buildButton(color2),
          ]),
    );
  }

  Widget _buildButton(GameColor color) {
    return Expanded(child: SimonButton(color));
  }
}
