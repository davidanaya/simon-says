import 'package:flutter/material.dart';
import 'package:simon_says/src/services/simon_game_service.dart';

class RoundScore extends StatelessWidget {
  final SimonGameService _service;
  final Function _onStartFn;

  RoundScore(this._service, this._onStartFn);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          alignment: Alignment.center,
          child: StreamBuilder(
              stream: _service.round$,
              builder: (context, snapshot) =>
                  snapshot.hasData && snapshot.data != 0
                      ? _buildRoundLabel(snapshot.data)
                      : _buildPlayButton()),
        ));
  }

  Widget _buildRoundLabel(int round) {
    return Text('$round',
        style: TextStyle(
            color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.w700));
  }

  Widget _buildPlayButton() {
    return IconButton(
        icon: Icon(Icons.play_arrow, color: Colors.white),
        onPressed: _onStartFn);
  }
}
