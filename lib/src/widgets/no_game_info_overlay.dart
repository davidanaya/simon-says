import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simon_says/src/bloc/bloc_provider.dart';
import 'package:simon_says/src/models/constants.dart';

class NoGameInfoOverlay extends StatefulWidget {
  final GameState state;

  NoGameInfoOverlay(this.state);

  @override
  _NoGameInfoOverlayState createState() => _NoGameInfoOverlayState();
}

class _NoGameInfoOverlayState extends State<NoGameInfoOverlay> {
  final double opacityWhenBuilt = 0.85;

  double _opacityLevel;

  @override
  void initState() {
    super.initState();
    _opacityLevel = widget.state == GameState.intro ? opacityWhenBuilt : 0.0;
    // execute after widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
  }

  void _startAnimation() {
    if (widget.state != GameState.intro) {
      if (this.mounted) setState(() => _opacityLevel = opacityWhenBuilt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: AnimatedOpacity(
            duration: Duration(milliseconds: overlayNoGameInfoAnimationMs),
            opacity: _opacityLevel,
            child: Container(
                color: Colors.black, child: _buildOverlayElements(context)),
          ))
        ]);
  }

  Widget _buildOverlayElements(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildStateLabel(),
        _buildPlay(context),
      ],
    );
  }

  Widget _buildStateLabel() {
    return Text(
      widget.state == GameState.gameOver
          ? statusMessages[GameState.gameOver]
          : gameTitle,
      style: TextStyle(fontSize: 32.0, color: Colors.white),
    );
  }

  Widget _buildPlay(BuildContext context) {
    final bloc = BlocProvider.of(context).gameBloc;

    return Column(
      children: <Widget>[_buildPlayLabel(), _buildPlayButton(bloc.startGame)],
    );
  }

  Widget _buildPlayLabel() {
    return Text(
      statusMessages[GameState.intro],
      style: TextStyle(fontSize: 16.0, color: Colors.white),
    );
  }

  Widget _buildPlayButton(Function onStartFn) {
    return IconButton(
        icon: Icon(Icons.play_arrow, size: 42.0, color: Colors.white),
        onPressed: onStartFn);
  }
}
