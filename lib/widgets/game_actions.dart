import 'package:flutter/material.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/provider.dart';

class GameActions extends StatelessWidget {
  const GameActions({Key key})
      : super(key: key);

  // final VoidCallback clear;
  // final VoidCallback refresh;
  // final VoidCallback submit;

  static const double SIZE=36;

  @override
  Widget build(BuildContext context) {
    
    //bool isDark = MediaQuery.of(context).platformBrightness == Brightness.light; //TODO change

    Widget _icon(IconData i, String t, Event e) {
    return Column(
      children: <Widget>[
        FlatButton(
          // iconSize: SIZE,
          child: Column(
            children: <Widget>[Icon(i, size: SIZE),Text(t)],
          ),
          color: Colors.transparent,
          // splashColor: Colors.grey,
          onPressed: () => Provider.of(context).game.eventSink.add(e),
        ),
      ],
    );
  }
    return Ink(
      // padding: const EdgeInsets.only(bottom: SIZE*1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _icon(Icons.clear, "Clear", Event.CLEAR),
          _icon(Icons.refresh, "Shuffle", Event.SHUFFLE),
          _icon(Icons.check, "Check", Event.CHECK),
        ],
      ),
    );
  }
}
