import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spelling_bee/helpers/provider.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var empty = Icon(Icons.star_border);
    var full = Icon(Icons.star);
    var game = Provider.of(context).game;

    return StreamBuilder(
        stream: game.points,
        initialData: 0,
        builder: (context, snapshot) {
          var ratio = snapshot.data / game.maxPoints;
          int stars = min(5, ((ratio - 0.06) / 0.11).ceil());

          var pointsToNextStar =
              ((0.06 + 0.11 * stars) * game.maxPoints).ceil();
          var text = "Level up at " + pointsToNextStar.toString() + " points";
          if (stars == 5) text = "Max level reached!";
          return Column(
            children: [
              Text(text),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    children: List.filled(stars, full) +
                        List.filled(5 - stars, empty)),
              ),
            ],
          );
        });
  }
}
