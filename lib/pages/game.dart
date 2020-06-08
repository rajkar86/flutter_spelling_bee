import 'package:flutter/material.dart';
import 'dart:core';

import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/provider.dart';

import 'package:spelling_bee/widgets/game_actions.dart';
import 'package:spelling_bee/widgets/current_word.dart';
import 'package:spelling_bee/widgets/letter_collection.dart';
import 'package:spelling_bee/widgets/star_rating.dart';

import 'package:spelling_bee/widgets/tally.dart';

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
            _buildPointsRow(context),
            _buildKeyPad(context),
            _buildActions()
          ])),
        ),
      ],
    );
  }

  Widget _buildPointsRow(BuildContext context) {
    var g = Provider.of(context).game;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildPointDisplay(context, g.wordCount, g.maxWords, "word(s)"),
        StarRating(),
        _buildPointDisplay(context, g.points, g.maxPoints, "point(s)"),
      ],
    );
  }

  StreamBuilder<int> _buildPointDisplay(
      BuildContext context, Stream<int> curr, int max, String text) {
    return StreamBuilder<int>(
        stream: curr,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Tally(points: snapshot.data, max: max, text: text)
              : Container();
        });
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
          // LetterCollection(letters: , onPressed: _nextLetterHandler),
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