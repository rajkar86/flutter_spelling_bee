import 'package:flutter/material.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/states/provider.dart';

class Actions extends StatelessWidget {
  const Actions({Key key})
      : super(key: key);

  // final VoidCallback clear;
  // final VoidCallback refresh;
  // final VoidCallback submit;

  static const double SIZE=36;

  @override
  Widget build(BuildContext context) {
    Widget _icon(IconData i, String t, Event e) {
    return Column(
      children: <Widget>[
        IconButton(
          iconSize: SIZE,
          icon: Icon(i, color: Colors.black, size: SIZE),
          tooltip: t,
          // color: Colors.yellow,
          splashColor: Colors.yellow,
          onPressed: () => Provider.of(context).game.eventSink.add(e),
          disabledColor: Colors.blueGrey,
        ),
        Text(t)
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

  

  // Widget button(String s, VoidCallback c) {
  //   return Padding(
  //     padding: const EdgeInsets.all(27.0),
  //     child: ButtonTheme(
  //       child: RaisedButton(
  //         color: Colors.black,
  //         highlightColor: Colors.green,
  //         onPressed: c,
  //         shape: BeveledRectangleBorder(
  //           borderRadius: BorderRadius.circular(5.0),
  //         ),
  //         child: Text(s, style: TextStyle(color: Colors.white, fontSize: 20)),
  //       ),
  //     ),
  //   );
  // }
}
