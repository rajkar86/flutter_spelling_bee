import 'package:flutter/material.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

import 'dart:core';
import 'dart:collection';
import 'dart:async';

import 'package:spelling_bee/pages/found_words.dart';

import 'package:spelling_bee/widgets/actions.dart';
import 'package:spelling_bee/states/provider.dart';
import 'package:spelling_bee/widgets/current_word.dart';
import 'package:spelling_bee/widgets/letter_collection.dart';
import 'package:spelling_bee/widgets/tally.dart';

// import 'package:spelling_bee/helpers/assets.dart';
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
  // String _game;
  // String _word = "";
  // int _points = 0;
  // int _maxPoints = 0;
  // int _maxWords = 0;
  // String _message = "";
  // Color _messageStyle = Colors.black;

  // SplayTreeSet<String> _words = SplayTreeSet<String>();

  // void _setTempMessage(m) {
  //   _message = m;
  //   Timer(Duration(milliseconds: 500), () => setState(() => _message = ""));
  // }

  // void _nextLetterHandler(String l) {
  //   setState(() {
  //     if (_word.length > Logic.MAX_WORD_LENGTH) {
  //       _setTempMessage("Too long");
  //       return;
  //     }
  //     _message = "";
  //     _word = _word + l;
  //   });
  // }

  // void _clear() {
  //   setState(() => {_word = "", _message = ""});
  // }

  // void _saveGame() {
  //   var l = [_game];
  //   l.addAll(_words);
  //   // Provider.of(context).game.foundWordsSink.add(_words.toList());
  //   // Provider.of(context).game.saveGameSink.add(true);
  //   // Assets.setGame(l);
  // }

  // void _refresh() {
  //   setState(() => _game = Logic.shuffleGame(_game));
  // }

  // void _check() {
  //   setState(() {
  //     String status =
  //         Logic.check(_word, _game, _words, Provider.of(context).game.wordMap);
  //     bool res = Logic.isCorrectProvider(status);

  //     _setTempMessage(res ? Logic.sampleSuccessMessage() : status);
  //     _messageStyle = res ? Colors.green : Colors.red;

  //     if (res) {
  //       _words.add(_word);
  //       // _points += Logic.points(_word, _game);
  //       _saveGame();
  //     }
  //     _word = "";
  //     // _saveGame();
  //   });
  // }

  // void _delete() {
  //   setState(() {
  //     if (_word.length >= 1) _word = _word.substring(0, _word.length - 1);
  //     _message = "";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return PageView(children: <Widget>[_buildGamePage(), FoundWords()]);
  }

  Widget _buildGamePage() {
    // setState(() {
    // var wordMap = Provider.of(context).game.wordMap;
    // if (_game == null) {
    //   if (game == null || game.length == 0) {
    //     _game = Logic.randomGame(wordMap);
    //     _words = SplayTreeSet<String>();
    //     _points = 0;
    //   } else {
    //     _game = game[0];
    //     _words =
    //         SplayTreeSet<String>.from((game.length > 1) ? game.sublist(1) : []);
    //     _points = 0;
    //     if (_words.length > 0) {
    //       _points =
    //           _words.map((w) => Logic.points(w, _game)).reduce((a, b) => a + b);
    //     }
    //   }
    // }

    // var answer = Logic.answer(wordMap, _game);
    // _maxWords = answer.length;
    // _maxPoints = Logic.pointsForAns(answer, _game);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            child: buildSwipeMessage("Swipe left to see your found words.")),
        Expanded(
          child: Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
            // _buildPointsRow(),
            _buildKeyPad(),
             Actions()
          ])),
        ),
      ],
    );
  }

  // Widget _buildPointsRow() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: <Widget>[
  //       Tally(points: _words.length, max: _maxWords, text: "word(s)"),
  //       Tally(points: _points, max: _maxPoints, text: "point(s)"),
  //     ],
  //   );
  // }

  Widget _buildKeyPad() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new MessageWidget(),
          CurrentWord(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LetterCollection(),
          ),
          // LetterCollection(letters: , onPressed: _nextLetterHandler),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   print("Dispose called");
  //   _saveGame();
  //   super.dispose();
  // }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of(context).game.message,
      initialData: Message(""),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return _build(context, snapshot.data);
      },
    );
  }

  Widget _build(BuildContext context, Message m) {
    return Text(m.message, style: TextStyle(color: m.error ? Colors.red : Colors.red, fontSize: 16));
  }
}
