import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const empty = Icon(Icons.star_border);
    const full = Icon(Icons.star);
    final gameBloc = Provider.of<GameBloc>(context);

    return StreamBuilder<int>(
        stream: gameBloc.points,
        initialData: 0,
        builder: (context, snapshot) {
          final points = snapshot.data ?? 0;
          final ratio = points / gameBloc.maxPoints;
          int stars = min(5, ((ratio - 0.06) / 0.11).ceil());

          var pointsToNextStar =
              ((0.06 + 0.11 * stars) * gameBloc.maxPoints).ceil();
          var text = "Level up at $pointsToNextStar points";
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
