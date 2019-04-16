import 'package:flutter/material.dart';

import 'package:spelling_bee/helpers/ui.dart';

class FoundWords extends StatelessWidget {
  const FoundWords({Key key, @required this.words}) : super(key: key);

  final List<String> words;

  Widget _word(w) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          w,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildSwipeMessage("Swipe right to go back to the game."),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.grey,
            child: Center(
              child: Text("Words found so far",
                  style: TextStyle(color: Colors.yellow, fontSize: 18)),
            ),
          ),
        ),
        Expanded(
            child:
                ListView(children: this.words.map((w) => _word(w)).toList())),
      ],
    );
  }
}

