import 'dart:collection';

import 'package:flutter/material.dart';

//import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:spelling_bee/widgets/word_list.dart';

class FoundWords extends StatelessWidget {
  const FoundWords({Key key}) : super(key: key);

  // final List<String> words;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SplayTreeSet<String>>(
      stream: Provider.of(context).game.foundWords,
      initialData: SplayTreeSet<String>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          child: _build(context, snapshot.data),
        );
      },
    );
  }

  Widget _build(BuildContext context, SplayTreeSet<String> words) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Expanded(child: Scrollbar(child: WordList(words: words))),
      ],
    );
  }
}
