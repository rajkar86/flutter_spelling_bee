import 'package:flutter/material.dart';
import 'dart:core';

import 'package:spelling_bee/widgets/game_actions.dart';
import 'package:spelling_bee/widgets/current_word.dart';
import 'package:spelling_bee/widgets/letter_collection.dart';
import 'package:spelling_bee/widgets/points_row.dart';

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

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
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: CurrentWord(),
        ),
        LetterCollection(),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: const GameActions(),
    );
  }
}
