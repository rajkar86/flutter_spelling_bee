import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:spelling_bee/helpers/assets.dart';
import 'package:spelling_bee/helpers/logic.dart';

class _SavedGame {
  final List<String> _val;

  _SavedGame() : this._val = [];

  _SavedGame.fromCache(List<String> val) : this._val = val;

  String game() => (_val.length > 0) ? _val[0] : null;

  List<String> foundWords() => (_val.length > 1) ? _val.sublist(1) : [];

  List<String> val() => _val;
}

enum Event { DELETE, CHECK, SHUFFLE, CLEAR }

class Message {
  final String message;
  final bool error;
  Message(this.message, [this.error = false]);
}

class _Game {
  String game;
  List<String> answer;
  String word = "";
  SplayTreeSet<String> words = SplayTreeSet<String>();
  Sink<String> wordSink;
  Sink<List<String>> foundWordsSink;
  Sink<Message> messageSink;

  _Game(Map wordMap, this.wordSink, this.foundWordsSink, this.messageSink,
      String game,
      [List<String> foundWords = const []])
      : this.game = game,
        this.answer = Logic.answer(wordMap, game);

  int maxWords() => this.answer.length;
  int maxPoints() => Logic.pointsForAns(this.answer, this.game);

  setWord(String w) => {word = w, wordSink.add(w)};

  bool addLetter(String l) {
    if (word.length > Logic.MAX_WORD_LENGTH) {
      return false;
    }
    setWord(word + l);
    return true;
  }

  void delete() {
    if (word.length >= 1) {
      word = word.substring(0, word.length - 1);
      wordSink.add(word);
    }
  }

  void clear() => setWord("");

  void check(Map wordMap) {
    String status = Logic.check(word, game, words, wordMap);

    bool res = Logic.isCorrectProvider(status);
    if (res) {
      messageSink.add(Message(Logic.sampleSuccessMessage(), false));
      words.add(word);
      foundWordsSink.add(words.toList());
      wordSink.add("");
      // points += Logic.points(word, game);
    }
    messageSink.add(Message(status, true));
    setWord("");
  }

  void shuffle() {
    game = Logic.shuffleGame(game);
  }
}

class GameBloc {
  final Map wordMap;

  final _event = PublishSubject<Event>();
  Sink<Event> get eventSink => _event.sink;

  final _isGameSaved = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isGameSaved => _isGameSaved.stream;

  final _saveGame = PublishSubject<bool>();
  Sink<bool> get saveGameSink => _saveGame.sink;

  final _loadGame = PublishSubject<bool>();
  Sink<bool> get loadGameSink => _loadGame.sink;

  final _nextLetter = PublishSubject<String>();
  Sink<String> get nextLetterSink => _nextLetter.sink;

  final _foundWords = BehaviorSubject<List<String>>.seeded([]);
  Stream<List<String>> get foundWords => _foundWords.stream;
  // Sink<List<String>> get foundWordsSink => _foundWords.sink;

  final _word = BehaviorSubject<String>.seeded("");
  Stream<String> get word => _word.stream;
  Sink<String> get wordSink => _word.sink;

  final _game = BehaviorSubject<String>();
  Stream<String> get game => _game.stream;
  // Sink<String> get gameSink => _game.sink;

  final _message = BehaviorSubject<Message>();
  Stream<Message> get message => _message.stream;

  _SavedGame _savedGame;
  _Game _gameState;

  // Sink<String> get wordCheck => _wordCheck.sink;

  GameBloc(this.wordMap) {
    _load();
    _saveGame.stream.listen(_saveGameHandler);
    _loadGame.stream.listen(_loadGameHandler);
  }

  void _saveGameHandler(bool save) {
    save ? Assets.setGame(_savedGame.val()) : Assets.removeGame();
    _savedGame = save ? _savedGame : _SavedGame();
  }

  Future<void> _load() async {
    _savedGame = _SavedGame.fromCache(await Assets.getGame());
  }

  void _loadGameHandler(bool resume) {
    print("Loading");
    String game = resume ? _savedGame.game() : Logic.randomGame(wordMap);
    List<String> foundWords = resume ? _savedGame.foundWords() : List<String>();
    _gameState = _Game(
        wordMap, _word.sink, _foundWords.sink, _message.sink, game, foundWords);
    _game.sink.add(game);
    _nextLetter.stream.listen(_gameState.addLetter);
    _event.stream.listen(_eventHandler);
  }

  void _eventHandler(Event e) {
    switch (e) {
      case Event.CHECK:
        {
          _gameState.check(wordMap);
        }
        break;

      case Event.SHUFFLE:
        {
          _gameState.shuffle();
        }
        break;

      case Event.DELETE:
        {
          _gameState.delete();
        }
        break;
      case Event.CLEAR:
        {
          _gameState.clear();
        }
        break;
      default:
        {
          print("Unhandled event");
        }
        break;
    }
  }

  void close() {
    // _savedGame.close();
    _foundWords.close();
    _word.close();
    _saveGame.close();
    _loadGame.close();
    _isGameSaved.close();
    _nextLetter.close();
    _event.close();
    _game.close();
    _message.close();
    // _wordCheck.close();
  }
}
