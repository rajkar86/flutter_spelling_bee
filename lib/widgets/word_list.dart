import 'dart:collection';

import 'package:flutter/material.dart';

class WordList extends StatelessWidget {
  final SplayTreeSet<String> words;

  const WordList({Key? key, required this.words}) : super(key: key);

  Widget _word(String w) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        w,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _wordList() {
    return Scrollbar(
        child: ListView(children: words.map((w) => _word(w)).toList()));
  }

  Widget _emptyState() {
    return const Column(
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
    return SizedBox(
        width: double.maxFinite,
        child: words.isEmpty ? _emptyState() : _wordList());
  }
}
