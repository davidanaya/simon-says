import 'package:flutter/material.dart';

import 'package:simon_says/src/bloc/bloc_provider.dart';

final double roundSize = 60.0;

class RoundScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context).gameBloc;
    return Align(
        alignment: Alignment.center,
        child: Container(
            height: roundSize,
            width: roundSize,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(roundSize / 2))),
            child: StreamBuilder(
              stream: bloc.round$,
              builder: (context, snapshot) =>
                  snapshot.hasData && snapshot.data != 0
                      ? _buildRoundLabel(snapshot.data)
                      : _buildPlayButton(bloc.startGame),
            )));
  }

  Widget _buildRoundLabel(int round) {
    return Align(
      alignment: Alignment.center,
      child: Text('$round',
          style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildPlayButton(Function onStartFn) {
    return IconButton(
        icon: Icon(Icons.play_arrow, size: 42.0, color: Colors.white),
        onPressed: onStartFn);
  }
}
