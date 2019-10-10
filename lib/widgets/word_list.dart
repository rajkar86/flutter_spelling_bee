import 'dart:collection';

import 'package:flutter/material.dart';

class WordList extends StatelessWidget {
  final SplayTreeSet<String> words;

  const WordList({this.words});

  Widget _word(w) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        w,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _wordList() {
    return Scrollbar(
        child: ListView(children: this.words.map((w) => _word(w)).toList()));
  }

  Widget _emptyState() {
    return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.edit, size: 100),
              Padding(
                padding: EdgeInsets.all(8),
              child: Text("No words found", style: TextStyle(fontSize: 24))),
              Text("Spell some words and they will show up here.")
            ],
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        child: this.words.length == 0 ? _emptyState() : _wordList());
  }
}
