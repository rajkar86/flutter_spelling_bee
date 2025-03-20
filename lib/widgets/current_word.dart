import 'package:flutter/material.dart';

import 'dart:math';

import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

class CurrentWord extends StatelessWidget {
  const CurrentWord({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: Provider.of<GameBloc>(context).word,
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        return _build(context, snapshot.data ?? "");
      },
    );
  }

  Widget _build(BuildContext context, String word) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate font size based on available width and word length
        final availableWidth = constraints.maxWidth;
        final baseFontSize = availableWidth * 0.06;
        final fontSize = min(24.0, max(14.0, baseFontSize - (word.length * 0.5)));
        final iconSize = fontSize;
        
        void onPressed() {
          Provider.of<GameBloc>(context, listen: false).eventSink.add(Event.delete);
        }
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Flexible spacer that takes up available space
            const Spacer(flex: 1),
            // Word display with flexible constraints
            Expanded(
              flex: 6,
              child: Center(
                child: Text(
                  word,
                  style: TextStyle(fontSize: fontSize, letterSpacing: 0),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Backspace button
            IconButton(
              icon: Icon(Icons.backspace, size: iconSize), 
              onPressed: onPressed,
              padding: EdgeInsets.all(fontSize * 0.2),
              constraints: const BoxConstraints(),
            ),
            const Spacer(flex: 1),
          ],
        );
      }
    );
  }
}

