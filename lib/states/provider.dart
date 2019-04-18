import 'package:flutter/material.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

class Provider extends InheritedWidget {
  Provider({Key key, this.game, this.child})
      : super(key: key, child: child);

  final Widget child;
  // final Map wordMap;
  // final Map statsMap;
  final GameBloc game;

  static Provider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Provider) as Provider;

  @override
  bool updateShouldNotify(Provider oldWidget) => true;
}
