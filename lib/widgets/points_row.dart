
import 'package:flutter/material.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:spelling_bee/widgets/star_rating.dart';
import 'package:spelling_bee/widgets/tally.dart';

Widget buildPointsRow(BuildContext context) {
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