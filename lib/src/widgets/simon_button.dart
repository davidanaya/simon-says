import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:simon_says/src/bloc/bloc_provider.dart';

import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/models/game_play.dart';
import 'package:simon_says/src/models/game_state.dart';
import 'package:simon_says/src/models/simon_color.dart';

enum Tap { up, down }

class SimonButton extends StatefulWidget {
  final GameColor gameColor;
  final SimonColor simonColor;

  SimonButton(this.gameColor) : simonColor = gameColors[gameColor];

  @override
  _SimonButtonState createState() => _SimonButtonState();
}

class _SimonButtonState extends State<SimonButton>
    with TickerProviderStateMixin {
  final buttonPadding = 12.0;
  final buttonPaddingAccent = 24.0;

  Animation<double> _animation;
  AnimationController _animationController;

  PublishSubject<Tap> _userTap$;

  StreamSubscription<GamePlay> _simonPlaySubs;
  StreamSubscription<Tap> _userTapSubs;

  bool _isFailedPlay = false;

  @override
  void initState() {
    super.initState();

    // initialize animation controllers for the button
    _animationController = AnimationController(
        duration: Duration(milliseconds: buttonAnimationMs), vsync: this);
    _animation = Tween(begin: buttonPadding, end: buttonPaddingAccent).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));

    // creates a new subject to deal with user taps
    _userTap$ = PublishSubject<Tap>();

    // after the reverse set the color back to normal in case it was changed in a failed play
    _animation.addStatusListener((status) {
      if (_isFailedPlay && status == AnimationStatus.dismissed) {
        _isFailedPlay = false;
      }
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    // get bloc reference through the context
    var bloc = BlocProvider.of(this.context).gameBloc;

    // subscribe to simon plays and animate button
    _simonPlaySubs = Observable(bloc.simonPlay$)
        .doOnData((play) => print('simonPlay\$ ${play.play}'))
        .where((gamePlay) => gamePlay.play == widget.gameColor)
        .listen((play) => _handleSimonPlay(play, bloc.playPressAnimationStart));

    // subscribe to user plays and animate only if it's the user turn
    _userTapSubs = _userTap$
        .doOnData((tap) => print('_userTap\$ $tap'))
        .withLatestFrom(
            bloc.state$
                .where((gameState) => gameState.state == GameState.UserSays),
            (tap, state) => tap)
        .listen((tap) =>
            _handleUserTap(tap, bloc.userPlay, bloc.playPressAnimationStart));
  }

  @override
  void dispose() {
    super.dispose();
    _simonPlaySubs.cancel();
    _userTapSubs.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            child: _buildButton(
                color: _animation.value == buttonPadding
                    ? _getPrimaryColor()
                    : _getAccentColor()),
            color: Colors.black,
            padding: EdgeInsets.all(_animation.value),
          );
        });
  }

  Widget _buildButton({Color color}) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10.0)))),
    );
  }

  void _handleUserTap(Tap tap, Sink<GameColor> userPlay,
      Sink<GameColor> playPressAnimationStart) {
    if (tap == Tap.down) {
      _animationController.forward();
      playPressAnimationStart.add(widget.gameColor);
    } else {
      userPlay.add(widget.gameColor);
      _animationController.reverse();
    }
  }

  void _handleSimonPlay(
      GamePlay play, Sink<GameColor> playPressAnimationStart) {
    _isFailedPlay = play.isFailedPlay;
    _animationController.forward();
    playPressAnimationStart.add(widget.gameColor);
    Timer(
        Duration(
            milliseconds: play.isFailedPlay
                ? failedPlayButtonAnimationMs
                : buttonAnimationMs), () {
      _animationController.reverse();
    });
  }

  void _handleTapDown(TapDownDetails tapDetails) {
    _userTap$.add(Tap.down);
  }

  void _handleTapUp(TapUpDetails tapDetails) {
    _userTap$.add(Tap.up);
  }

  Color _getPrimaryColor() {
    return _isFailedPlay ? failColor.primary : widget.simonColor.primary;
  }

  Color _getAccentColor() {
    return _isFailedPlay ? failColor.accent : widget.simonColor.accent;
  }
}
