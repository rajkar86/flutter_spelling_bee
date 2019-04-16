import 'package:flutter/material.dart';

class Answer extends InheritedWidget {
  Answer({Key key, this.wordMap, this.statsMap, this.child}) : super(key: key, child: child);

  final Widget child;
  final Map wordMap;
  final Map statsMap;

  static Answer of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Answer)as Answer);
  }

  @override
  bool updateShouldNotify( Answer oldWidget) {
    return true;
  }
}