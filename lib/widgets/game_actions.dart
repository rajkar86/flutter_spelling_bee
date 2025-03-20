import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

class GameActions extends StatelessWidget {
  const GameActions({Key? key}) : super(key: key);

  // final VoidCallback clear;
  // final VoidCallback refresh;
  // final VoidCallback submit;

  static const double kIconSize = 36;

  @override
  Widget build(BuildContext context) {
    //bool isDark = MediaQuery.of(context).platformBrightness == Brightness.light; //TODO change

    Widget buildActionIcon(IconData iconData, String label, Event event) {
      return Column(
        children: <Widget>[
          TextButton(
            // iconSize: SIZE,
            child: Column(
              children: <Widget>[
                Icon(iconData, size: kIconSize, color: Theme.of(context).iconTheme.color),
                Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color))
              ],
            ),
            // color: Colors.transparent,
            // splashColor: Colors.grey,
            onPressed: () => Provider.of<GameBloc>(context, listen: false).eventSink.add(event),
          ),
        ],
      );
    }

    return Ink(
      // padding: const EdgeInsets.only(bottom: SIZE*1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildActionIcon(Icons.clear, "Clear", Event.clear),
          buildActionIcon(Icons.refresh, "Shuffle", Event.shuffle),
          buildActionIcon(Icons.check, "Check", Event.check),
        ],
      ),
    );
  }
}
