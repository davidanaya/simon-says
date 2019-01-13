import 'package:flutter/material.dart';
import 'package:simon_says/src/bloc/bloc_provider.dart';
import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/widgets/no_game_info_overlay.dart';
import 'package:simon_says/src/widgets/round_score.dart';
import 'package:simon_says/src/widgets/simon_button.dart';

class SimonBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context).gameBloc;

    return StreamBuilder(
        stream: bloc.state$,
        builder: (context, snapshot) {
          var children = [_buildButtons(), RoundScore()];
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data == GameState.intro ||
              snapshot.data == GameState.gameOver) {
            children.add(NoGameInfoOverlay(snapshot.data as GameState));
          }
          return Stack(children: children);
        });
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
