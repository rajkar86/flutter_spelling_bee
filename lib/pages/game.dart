import 'package:flutter/material.dart';
import 'dart:core';

import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/provider.dart';

import 'package:spelling_bee/widgets/game_actions.dart';
import 'package:spelling_bee/widgets/current_word.dart';
import 'package:spelling_bee/widgets/letter_collection.dart';
import 'package:spelling_bee/widgets/points_row.dart';

class Game extends StatelessWidget {
  const Game({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
            buildPointsRow(context),
            _buildKeyPad(context),
            _buildActions()
          ])),
        ),
      ],
    );
  }

  Widget _buildKeyPad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildMessage(context),
          CurrentWord(),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: LetterCollection(),
          ),
        ],
      ),
    );
  }

  _buildMessage(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of(context).game.message,
      initialData: Message(""),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(snapshot.data.message,
            style: TextStyle(
                color: snapshot.data.error ? Colors.red : Colors.green,
                fontSize: 16));
      },
    );
  }

  GameActions _buildActions() => GameActions();
}
