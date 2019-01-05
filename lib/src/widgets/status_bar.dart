import 'package:flutter/material.dart';

import 'package:simon_says/src/bloc/bloc_provider.dart';
import 'package:simon_says/src/models/constants.dart';

class StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context).gameBloc;
    return StreamBuilder(
        stream: bloc.state$,
        builder: (context, snapshot) =>
            snapshot.hasData ? _buildMessage(snapshot.data) : Container());
  }

  Widget _buildMessage(GameState state) {
    var text = statusMessages[state];
    return Container(
        color: Colors.black,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ));
  }
}
