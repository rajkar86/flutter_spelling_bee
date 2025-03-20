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
    // Check if we're in landscape mode
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    if (isLandscape) {
      // Landscape layout - optimized for horizontal space
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Game controls on the left
          Expanded(
            flex: 6,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildKeyPad(context),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          ),
          // Points and stats on the right
          Expanded(
            flex: 4,
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: buildPointsRow(context, isVertical: true),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // Portrait layout - original vertical layout
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Center(
              child: ListView(
                shrinkWrap: true, 
                children: <Widget>[
                  buildPointsRow(context),
                  _buildKeyPad(context),
                  _buildActions()
                ],
              ),
            ),
          ),
        ],
      );
    }
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
