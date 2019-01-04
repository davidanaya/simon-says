import 'package:flutter/material.dart';

import 'package:simon_says/src/bloc/app_bloc.dart';
import 'package:simon_says/src/bloc/bloc_provider.dart';

import 'package:simon_says/src/pages/home_page.dart';

void main() {
  final appBloc = AppBloc();

  runApp(MyApp(appBloc));
}

class MyApp extends StatelessWidget {
  final AppBloc bloc;

  MyApp(this.bloc);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: 'Simon Says',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
