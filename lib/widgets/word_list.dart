import 'dart:collection';

import 'package:flutter/material.dart';

class WordList extends StatelessWidget {
  final SplayTreeSet<String> words;

  const WordList({this.words});

  Widget _word(w) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
              w,
              style: TextStyle(fontSize: 18),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      width: double.maxFinite,
      child: Scrollbar(
          child: ListView(children: this.words.map((w) => _word(w)).toList())),
    );
  }
}
