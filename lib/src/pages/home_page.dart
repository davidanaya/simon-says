import 'package:flutter/material.dart';

// import 'package:simon_says/src/models/constants.dart';
import 'package:simon_says/src/widgets/simon_board.dart';
import 'package:simon_says/src/widgets/status_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SimonBoard()),
      // body: Center(child: SimonButton(GameColor.blue)),
      bottomNavigationBar: BottomAppBar(child: StatusBar()),
    );
  }
}
