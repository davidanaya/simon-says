import 'package:flutter/material.dart';
import 'package:simon_says/src/bloc/bloc_provider.dart';
import 'package:simon_says/src/theme/fonts.dart';

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
                      : Container(),
            )));
  }

  Widget _buildRoundLabel(int round) {
    return Align(
      alignment: Alignment.center,
      child: Text('$round',
          style: TextStyle(
              color: Colors.white,
              fontSize: $fontSize['xxxlarge'],
              fontWeight: FontWeight.w700)),
    );
  }
}
