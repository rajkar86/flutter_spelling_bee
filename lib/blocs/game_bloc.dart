import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spelling_bee/blocs/settings_bloc.dart';
import 'package:spelling_bee/helpers/assets.dart';
import 'package:spelling_bee/helpers/logic.dart';

enum Event { LOAD, DELETE, CHECK, SHUFFLE, CLEAR }

class Message {
  final String message;
  final bool error;
  Message(this.message, [this.error = false]);
}

class _GameStore {
  final List<String> _val;

  _GameStore() : this._val = [];

  _GameStore.fromCache(List<String> val) : this._val = val;

  String game() => (_val.length > 0) ? _val[0] : null;

  List<String> foundWords() => (_val.length > 1) ? _val.sublist(1) : [];

  List<String> val() => _val;
}

class _Game {
  BehaviorSubject<String> game = BehaviorSubject<String>();
  BehaviorSubject<String> word = BehaviorSubject<String>();

  BehaviorSubject<SplayTreeSet<String>> words =
      BehaviorSubject<SplayTreeSet<String>>();

  BehaviorSubject<SplayTreeSet<String>> wordsRemaining =
      BehaviorSubject<SplayTreeSet<String>>();

  BehaviorSubject<Message> message =
      BehaviorSubject<Message>.seeded(Message(""));

  BehaviorSubject<int> points = BehaviorSubject<int>();

  int maxWords = 0, maxPoints = 0;

  // Sink<Message> messageSink;
  //Logic.answer(wordMap, game)

  void reset(String game, List<String> answer,
      [List<String> wordList = const []]) {
    var words = SplayTreeSet<String>.from(wordList);
    var wordsRemaining = SplayTreeSet<String>.from(answer).difference(words);
    this.game.add(game);
    this.wordsRemaining.add(wordsRemaining);
    this.word.add("");
    this.words.add(words);
    // this.message.add(Message(""));
    this.points.add(Logic.pointsForAns(wordList, game));
    maxWords = answer.length;
    maxPoints = Logic.pointsForAns(answer, game);
  }

  _setWord(String w) => {word.add(w)};

  bool addLetter(String l) {
    if (word.value.length > Logic.MAX_WORD_LENGTH) {
      return false;
    }
    _setWord(word.value + l);
    return true;
  }

  void delete() {
    if (word.value.length >= 1)
      _setWord(word.value.substring(0, word.value.length - 1));
  }

  void clear() => _setWord("");

  void _setTempMessage(m) {
    message.add(m);
    // ?TODO Should this logic belong in the bloc?
    Timer(Duration(milliseconds: 500), () => message.add(Message("")));
  }

  bool check(Map wordMap) {
    String status = Logic.check(word.value, game.value, words.value, wordMap);
    bool res = Logic.isCorrectProvider(status);
    if (res) {
      var l = words.value;
      l.add(word.value);
      words.add(l);
      l = wordsRemaining.value;
      l.remove(word.value);
      wordsRemaining.add(l);
      points.sink.add(points.value + Logic.points(word.value, game.value));
    }
    _setTempMessage(Message(res ? Logic.sampleSuccessMessage() : status, !res));
    _setWord("");
    return res;
  }

  void shuffle() {
    game.add(Logic.shuffleGame(game.value));
  }

  _GameStore getGameStore() {
    var l = words.value.toList();
    l.insert(0, game.value);
    return _GameStore.fromCache(l);
  }

  void dispose() {
    game.close();
    word.close();
    points.close();
    wordsRemaining.close();
    words.close();
    message.close();
  }
}

class GameBloc {
  
  GameBloc();
  
  var settings = SettingsBloc();
  var state = _Game();
  var _loadEnableDict;

  BehaviorSubject<bool> useEnableDict = BehaviorSubject<bool>();

  BehaviorSubject<Map> _wordMap = BehaviorSubject<Map>();

  // STREAMS
  Stream<SplayTreeSet<String>> get foundWords => state.words.stream;

  Stream<String> get word => state.word.stream;
  Stream<String> get game => state.game.stream;
  Stream<Message> get message => state.message.stream;
  // Stream<List<String>> get answer => _gameState.answer.stream;

  Stream<int> get points => state.points.stream;
  Stream<int> get wordCount => state.words.map((x) => x.length);

  SplayTreeSet<String> get wordsRemaining =>
      state.wordsRemaining.stream.value;
  int get maxPoints => state.maxPoints;
  int get maxWords => state.maxWords;

  final _isGameSaved = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isGameSaved => _isGameSaved.stream;

  // SINKS
  final _event = PublishSubject<Event>();
  Sink<Event> get eventSink => _event.sink;

  final _loadGame = PublishSubject<bool>();
  Sink<bool> get loadGameSink => _loadGame.sink;

  final _nextLetter = PublishSubject<String>();
  Sink<String> get nextLetterSink => _nextLetter.sink;

  _GameStore _savedGame;

  Future<void> init() async {
    await settings.init(); // Do this first

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    useEnableDict.add(prefs.getBool("useEnable") ?? true);   
    

    await loadWordMap();
    
    _savedGame = _GameStore.fromCache(await Assets.getGame());
    var isGameSaved = _savedGame.val().length > 0;
    _isGameSaved.add(isGameSaved);
    // _loadGameHandler(isGameSaved);

    useEnableDict.listen((bool use){
      prefs.setBool("useEnable", use);
      _loadGameHandler(true);
    });     
    _loadGame.listen(_loadGameHandler);
    _nextLetter.listen(state.addLetter);
    _event.listen(_eventHandler);

    
  }

  Future<void> loadWordMap() async {
    if (_loadEnableDict == useEnableDict.stream.value) return;
    _loadEnableDict = useEnableDict.stream.value;
    var wordMap = await Assets.getWordMap(_loadEnableDict);
    this._wordMap.add(wordMap);
  }

  void _saveGame(bool save) {
    _savedGame = save ? state.getGameStore() : null;
    save ? Assets.setGame(_savedGame.val()) : Assets.removeGame();
    _isGameSaved.add(save);
  }

  Future<void> _loadGameHandler(bool resume) async {
    await loadWordMap();
    var wordMap = this._wordMap.stream.value;
   
    String game = _savedGame != null ? _savedGame.game() : Logic.randomGame(wordMap);

    game = (resume && Logic.isGameValid(wordMap, game))
        ? game
        : Logic.randomGame(wordMap);
    var answer = Logic.answer(wordMap, game);

    List<String> foundWords = List<String>();
    if (resume) {
      foundWords = SplayTreeSet<String>.from(_savedGame.foundWords())
          .intersection(SplayTreeSet<String>.from(answer))
          .toList();
    }

    state.reset(game, answer, foundWords);
    if (!resume) _saveGame(true);
  }

  void _eventHandler(Event e) {
    var wordMap = this._wordMap.stream.value;
    switch (e) {
      case Event.LOAD:
        {
          _loadGameHandler(false);
        }
        break;
      case Event.CHECK:
        {
          if (state.check(wordMap)) _saveGame(true);
        }
        break;

      case Event.SHUFFLE:
        {
          state.shuffle();
        }
        break;

      case Event.DELETE:
        {
          state.delete();
        }
        break;
      case Event.CLEAR:
        {
          state.clear();
        }
        break;
      default:
        {
          // print("Unhandled event");
        }
        break;
    }
  }

  void dispose() {
    state.dispose();
    _isGameSaved.close();
    _loadGame.close();
    _nextLetter.close();
    _event.close();
    _wordMap.close();
  }
}
