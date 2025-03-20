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
    final gameBloc = Provider.of<GameBloc>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate star size based on available width
        final availableWidth = constraints.maxWidth;
        final starSize = (availableWidth / 8).clamp(16.0, 24.0);
        final fontSize = (starSize * 0.7).clamp(10.0, 14.0);
        
        // Create responsive star icons
        final empty = Icon(Icons.star_border, size: starSize);
        final full = Icon(Icons.star, size: starSize);

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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: EdgeInsets.all(starSize * 0.2),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: starSize * 0.2,
                    children: [
                      ...List.filled(stars, full),
                      ...List.filled(5 - stars, empty),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }
    );
  }
}
