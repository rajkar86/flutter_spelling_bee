import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:core';

import 'package:spelling_bee/helpers/consts.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/widgets/letter_collection.dart';
import 'package:spelling_bee/widgets/points_row.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key key}) : super(key: key);

  Widget _buildGamePreview(context) {
    var gameState = Provider.of(context).game.state;
    return StreamBuilder(
        stream: gameState.game.stream,
        builder: (context, snapshot) {
          return snapshot.hasData ? GamePreview() : WAIT_WIDGET;
        });
  }

  Widget _buildRandomGameButton(context) {
    var game = Provider.of(context).game;
    return pad(raisedButton(context, "Reset and load new board", () {
      game.loadGameSink.add(false);
    }));
  }

  Widget _largeDictionaryInfoDialog(context) {
    return AlertDialog(
        title: text("Use large dictionary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Note that English vocabulary lists of a reasonable size are necessarily subjective.\n"),
            Text("Selecting the large dictionary will result in more words being accepted, " +
                "but will also require you to find more words that you might consider obscure.\n"),
            Text(
                "Using the smaller dictionary will require fewer words to be found, " +
                    "but result in some common words not being accepted.\n"),
            Text("The larger dictionary is the Enable2k wordlist used in popular games like Words With Friends." +
                "The smaller dictionary is the one named 2of12inf in the 12dicts collection by Alan Beale.\n"),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var game = Provider.of(context).game;

    return Scaffold(
        appBar: AppBar(title: Text(GAME_TITLE), actions: [
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: "Settings",
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
              //Navigator.push(context, buildPageTransition(Settings()));
            },
          ),
          IconButton(
            icon: Icon(Icons.help),
            tooltip: "Help",
            onPressed: () {
              Navigator.pushNamed(context, '/rules');
              // Navigator.push(context, buildPageTransition(Rules()));
            },
          ),
        ]),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildGamePreview(context),

            clickableCard(
                "Use large dictionary?",
                "Tap to see more info about this option",
                switchControl(game.useEnableDict), () {
              showDialog(context: context, builder: _largeDictionaryInfoDialog);
            }),

            _buildRandomGameButton(context),
            // _buildCustomGameButton(context), TODO ??
            // TODO: settings, rules, tips, support?
            // TODO: dark mode could be better
          ],
        ));
  }
}

StreamBuilder<bool> switchControl(BehaviorSubject<bool> sub) {
  return StreamBuilder(
    stream: sub.stream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      return snapshot.hasData
          ? Switch(
              value: snapshot.data,
              onChanged: (bool b) {
                sub.sink.add(b);
              })
          : WAIT_WIDGET;
    },
  );
}

class GamePreview extends StatelessWidget {
  const GamePreview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gameState = Provider.of(context).game.state;

    return Column(
      children: [
        InkWell(
            child: AbsorbPointer(
                absorbing: true,
                child: Card(
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: gameState.points.stream,
                          initialData: 0,
                          builder: (context, snapshot) {
                            var verb = snapshot.data > 0 ? "resume" : "start";
                            return pad(text(
                                "Tap here to " + verb + " playing this game"));
                          }),
                      buildPointsRow(context),
                      LetterCollection(),
                    ],
                  ),
                )),
            onTap: () {
              Navigator.pushNamed(context, '/game');
            }),
      ],
    );
  }
}

Padding pad(Widget w) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: w,
  );
}

Text text(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 22),
  );
}

RaisedButton raisedButton(
    BuildContext context, String title, Function onPressed) {
  // bool isDark = Theme.of(context).brightness == Brightness.dark;

  return RaisedButton(
      // color: Colors.yellow,
      child: text(title),
      onPressed: onPressed);
}
