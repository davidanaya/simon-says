import 'package:flutter/material.dart';
import 'package:simon_says/src/bloc/bloc_provider.dart';
import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/models/game_state.dart';
import 'package:simon_says/src/theme/fonts.dart';

class StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context).gameBloc;
    return StreamBuilder(
        stream: bloc.state$,
        builder: (context, snapshot) =>
            snapshot.hasData ? _buildMessage(snapshot.data) : Container());
  }

  Widget _buildMessage(GameState gameState) {
    var text = gameState.isPlayState ? statusMessages[gameState.state] : '';
    return Container(
        color: Colors.black,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: $fontSize['xxlarge']),
          textAlign: TextAlign.center,
        ));
  }
}
