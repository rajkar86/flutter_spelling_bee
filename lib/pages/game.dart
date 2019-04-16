import 'package:flutter/material.dart';

import 'dart:core';
import 'dart:collection';
import 'dart:async';

import 'package:spelling_bee/pages/found_words.dart';

import 'package:spelling_bee/widgets/actions.dart';
import 'package:spelling_bee/states/answer.dart';
import 'package:spelling_bee/widgets/current_word.dart';
import 'package:spelling_bee/widgets/letter_collection.dart';
import 'package:spelling_bee/widgets/tally.dart';

import 'package:spelling_bee/helpers/assets.dart';
import 'package:spelling_bee/helpers/logic.dart';
import 'package:spelling_bee/helpers/ui.dart';

class Game extends StatefulWidget {
  // final List<String> game;
  final bool resume;
  const Game({Key key, this.resume}) : super(key: key);
  // final String game;

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  // Future<List<String>> _gameFuture;
  String _game;
  String _word = "";
  int _points = 0;
  int _maxPoints = 0;
  int _maxWords = 0;
  String _message = "";
  Color _messageStyle = Colors.black;

  SplayTreeSet<String> _words = SplayTreeSet<String>();

  void _setTempMessage(m) {
    _message = m;
    Timer(Duration(milliseconds: 500), () => setState(() => _message = ""));
  }

  void _nextLetterHandler(String l) {
    setState(() {
      if (_word.length > Logic.MAX_WORD_LENGTH) {
        _setTempMessage("Too long");
        return;
      }
      _message = "";
      _word = _word + l;
    });
  }

  void _clear() {
    setState(() => {_word = "", _message = ""});
  }

  void _saveGame() {
    var l = [_game];
    l.addAll(_words);
    Assets.setGame(l);
  }

  void _refresh() {
    setState(() => _game = Logic.shuffleGame(_game));
  }

  void _check() {
    setState(() {
      String status =
          Logic.check(_word, _game, _words, Answer.of(context).wordMap);
      bool res = Logic.isCorrectAnswer(status);

      _setTempMessage(res ? Logic.sampleSuccessMessage() : status);
      _messageStyle = res ? Colors.green : Colors.red;

      if (res) {
        _words.add(_word);
        _points += Logic.points(_word, _game);
      }
      _word = "";
      // _saveGame();
    });
  }

  void _delete() {
    setState(() {
      if (_word.length >= 1) _word = _word.substring(0, _word.length - 1);
      _message = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.resume) return _build(context, []);

    return FutureBuilder(
        future: Assets.getGame(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) =>
            snapshot.hasData ? _build(context, snapshot.data) : CircularProgressIndicator());
  }

  Widget _build(BuildContext context, List<String> game) {
    return PageView(children: <Widget>[
      _buildGamePage(game),
      FoundWords(words: _words.toList())
    ]);
  }

  Widget _buildGamePage(List<String> game) {
    // setState(() {
    var wordMap = Answer.of(context).wordMap;
    if (_game == null) {
      if (game == null || game.length == 0) {
        _game = Logic.randomGame(wordMap);
        _words = SplayTreeSet<String>();
        _points = 0;
      } else {
        _game = game[0];
        _words =
            SplayTreeSet<String>.from((game.length > 1) ? game.sublist(1) : []);
        _points = 0;
        if (_words.length > 0) {
          _points =
              _words.map((w) => Logic.points(w, _game)).reduce((a, b) => a + b);
        }
      }
    }

    var answer = Logic.answer(wordMap, _game);
    _maxWords = answer.length;
    _maxPoints = Logic.pointsForAns(answer, _game);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            child: buildSwipeMessage("Swipe left to see your found words.")),
        Expanded(
          child: Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
            _buildPointsRow(),
            _buildKeyPad(),
            _buildControlRow()
          ])),
        ),
      ],
    );
  }

  Widget _buildControlRow() =>
      Actions(clear: _clear, refresh: _refresh, submit: _check);

  Widget _buildPointsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Tally(points: _words.length, max: _maxWords, text: "word(s)"),
        Tally(points: _points, max: _maxPoints, text: "point(s)"),
      ],
    );
  }

  Widget _buildKeyPad() {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_message, style: TextStyle(color: _messageStyle, fontSize: 16)),
          CurrentWord(word: _word, onBackspace: _delete),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child:
                LetterCollection(letters: _game, onPressed: _nextLetterHandler),
          ),
          // LetterCollection(letters: , onPressed: _nextLetterHandler),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print("Dispose called");
    _saveGame();
    super.dispose();
  }
}
