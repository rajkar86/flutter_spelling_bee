import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

class GameActions extends StatelessWidget {
  const GameActions({Key? key}) : super(key: key);

  // final VoidCallback clear;
  // final VoidCallback refresh;
  // final VoidCallback submit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate icon size based on available width
        final availableWidth = constraints.maxWidth;
        final iconSize = (availableWidth / 10).clamp(24.0, 36.0);
        final fontSize = (iconSize / 3).clamp(10.0, 14.0);
        
        Widget buildActionIcon(IconData iconData, String label, Event event) {
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(iconSize * 0.2),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        iconData, 
                        size: iconSize,
                        color: Theme.of(context).iconTheme.color
                      ),
                      SizedBox(height: fontSize / 2),
                      Text(
                        label, 
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: fontSize,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  onPressed: () => Provider.of<GameBloc>(context, listen: false)
                    .eventSink.add(event),
                ),
              ],
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: availableWidth * 0.02,
            vertical: 8
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildActionIcon(Icons.clear, "Clear", Event.clear),
              buildActionIcon(Icons.refresh, "Shuffle", Event.shuffle),
              buildActionIcon(Icons.check, "Check", Event.check),
            ],
          ),
        );
      }
    );
  }
}
