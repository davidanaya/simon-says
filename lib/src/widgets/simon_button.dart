import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:simon_says/src/bloc/bloc_provider.dart';

import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/models/game_play.dart';
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
  Animation<double> _animation;
  AnimationController _animationController;

  PublishSubject<Tap> _userTap$;

  StreamSubscription<GamePlay> _simonPlaySubs;
  StreamSubscription<Tap> _userTapSubs;

  @override
  void initState() {
    super.initState();

    // initialize animation controllers for the button
    _animationController = AnimationController(
        duration: Duration(
            milliseconds: gameSpeedTimes[GameSpeedTimeMs.buttonAnimation]),
        vsync: this);
    _animation = Tween(begin: 12.0, end: 24.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));

    // creates a new subject to deal with user taps
    _userTap$ = PublishSubject<Tap>();
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
        .doOnData((tap) => print('_userTap\$ ${tap}'))
        .withLatestFrom(
            bloc.state$.where((state) => state == GameState.userSays),
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
                color: _animation.value == 12.0
                    ? widget.simonColor.primary
                    : widget.simonColor.accent),
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
    _animationController.forward();
    playPressAnimationStart.add(widget.gameColor);
    Timer(
        Duration(milliseconds: gameSpeedTimes[GameSpeedTimeMs.buttonAnimation]),
        () {
      _animationController.reverse();
    });
  }

  void _handleTapDown(TapDownDetails tapDetails) {
    _userTap$.add(Tap.down);
  }

  void _handleTapUp(TapUpDetails tapDetails) {
    _userTap$.add(Tap.up);
  }
}
