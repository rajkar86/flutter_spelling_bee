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

  Widget _buildRandomButton(context) {
    var game = Provider.of(context).game;
    return pad(raisedButton(context, "Reset to another random game", () {
      game.loadGameSink.add(false);
    }));
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            _buildGamePreview(context),

            clickableCard("Use large dictionary?", "Tap to see more info about this option",
                switchControl(game.useEnableDict), () {
              //TODO
            }),

            _buildRandomButton(context),

            // TODO: settings, rules, tips, support?
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
    return Column(
      children: [
        InkWell(
            child: AbsorbPointer(
                absorbing: true,
                child: Card(
                  child: Column(
                    children: [
                      pad(text("Tap to start playing this game")),
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
    style: TextStyle(fontSize: 24),
  );
}

RaisedButton raisedButton(
    BuildContext context, String title, Function onPressed) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  return RaisedButton(
      color: isDark ? Colors.grey : Colors.yellow,
      child: text(title),
      onPressed: onPressed);
}
