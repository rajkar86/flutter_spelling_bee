import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/widgets/star_rating.dart';
import 'package:spelling_bee/widgets/tally.dart';

Widget buildPointsRow(BuildContext context, {bool isVertical = false}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final gameBloc = Provider.of<GameBloc>(context);
      
      // If we're in vertical layout or on a very small screen, use a column layout
      if (isVertical || constraints.maxWidth < 320) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildPointDisplay(context, gameBloc.wordCount, gameBloc.maxWords, "word(s)"),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: StarRating(),
            ),
            _buildPointDisplay(context, gameBloc.points, gameBloc.maxPoints, "point(s)"),
          ],
        );
      }
      
      // For normal screens, use a responsive row layout
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: _buildPointDisplay(context, gameBloc.wordCount, gameBloc.maxWords, "word(s)"),
          ),
          const Flexible(
            flex: 2,
            child: StarRating(),
          ),
          Flexible(
            flex: 3,
            child: _buildPointDisplay(context, gameBloc.points, gameBloc.maxPoints, "point(s)"),
          ),
        ],
      );
    }
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