import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/widgets/word_list.dart';

//import 'package:spelling_bee/helpers/ui.dart';

class FoundWords extends StatelessWidget {
  const FoundWords({Key? key}) : super(key: key);

  // final List<String> words;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SplayTreeSet<String>>(
      stream: Provider.of<GameBloc>(context).foundWords,
      initialData: SplayTreeSet<String>(),
      builder: (BuildContext context, AsyncSnapshot<SplayTreeSet<String>> snapshot) {
        return _build(context, snapshot.data ?? SplayTreeSet<String>());
      },
    );
  }

  Widget _build(BuildContext context, SplayTreeSet<String> words) {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Expanded(child: Scrollbar(child: WordList(words: words))),
      ],
    );
  }
}
