import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/widgets/star_rating.dart';
import 'package:spelling_bee/widgets/tally.dart';

Widget buildPointsRow(BuildContext context) {
  final gameBloc = Provider.of<GameBloc>(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      _buildPointDisplay(context, gameBloc.wordCount, gameBloc.maxWords, "word(s)"),
      const StarRating(),
      _buildPointDisplay(context, gameBloc.points, gameBloc.maxPoints, "point(s)"),
    ],
  );
}

StreamBuilder<int> _buildPointDisplay(
    BuildContext context, Stream<int> curr, int max, String text) {
  return StreamBuilder<int>(
      stream: curr,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Tally(points: snapshot.data ?? 0, max: max, text: text)
            : const SizedBox();
      });
}