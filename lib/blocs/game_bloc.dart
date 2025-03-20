import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spelling_bee/blocs/settings_bloc.dart';
import 'package:spelling_bee/helpers/assets.dart';
import 'package:spelling_bee/helpers/logic.dart';
import 'package:spelling_bee/services/storage_service.dart';

enum Event { load, delete, check, shuffle, clear }

/// Represents a message to display to the user
class Message {
  final String message;
  final bool error;
  Message(this.message, [this.error = false]);
}

/// Types of messages that can be displayed to the user
enum MessageType { pangram, found, invalid, notCenter, short, duplicate }

/// Stores game state for saving/loading
class GameStore {
  final List<String> _val;

  GameStore() : _val = [];

  GameStore.fromCache(List<String> val) : _val = val;

  String? game() => (_val.isNotEmpty) ? _val[0] : null;

  List<String> foundWords() => (_val.length > 1) ? _val.sublist(1) : [];

  List<String> val() => _val;
}

/// Represents the state of the game
class GameState {
  final BehaviorSubject<String> game = BehaviorSubject<String>();
  final BehaviorSubject<String> word = BehaviorSubject<String>();

  final BehaviorSubject<SplayTreeSet<String>> words = BehaviorSubject<SplayTreeSet<String>>();

  final BehaviorSubject<SplayTreeSet<String>> wordsRemaining = BehaviorSubject<SplayTreeSet<String>>();

  final BehaviorSubject<Message> message = BehaviorSubject<Message>.seeded(Message(""));

  final BehaviorSubject<int> points = BehaviorSubject<int>();

  int maxWords = 0, maxPoints = 0;

  void reset(String game, List<String> answer, [List<String> wordList = const []]) {
    final wordsSet = SplayTreeSet<String>.from(wordList);
    final answerSet = SplayTreeSet<String>.from(answer);
    final wordsRemaining = SplayTreeSet<String>.from(answerSet.difference(wordsSet));
    
    this.game.add(game);
    this.wordsRemaining.add(wordsRemaining);
    word.add("");
    words.add(wordsSet);
    points.add(Logic.pointsForAns(wordList, game));
    maxWords = answer.length;
    maxPoints = Logic.pointsForAns(answer, game);
  }

  void _setWord(String w) => word.add(w);

  bool addLetter(String l) {
    if ((word.value).length > Logic.kMaxWordLength) {
      return false;
    }
    _setWord(word.value + l);
    return true;
  }

  void delete() {
    if (word.value.isNotEmpty) _setWord(word.value.substring(0, word.value.length - 1));
  }

  void clear() => _setWord("");

  void _setTempMessage(Message m) {
    message.add(m);
    // ?TODO Should this logic belong in the bloc?
    Timer(const Duration(milliseconds: 500), () => message.add(Message("")));
  }

  bool check(Map<String, dynamic> wordMap) {
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

  GameStore getGameStore() {
    var l = words.value.toList();
    l.insert(0, game.value);
    return GameStore.fromCache(l);
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

/// Main game BLoC that manages game state and logic
class GameBloc {
  GameBloc();

  final SettingsBloc settings = SettingsBloc();
  final GameState state = GameState();

  // Settings
  final BehaviorSubject<bool> useEnableDict = BehaviorSubject<bool>();
  bool? _loadEnableDict;

  // State
  final BehaviorSubject<String> _game = BehaviorSubject<String>();
  Stream<String> get game => _game.stream;

  final BehaviorSubject<Map<String, dynamic>> _wordMap = BehaviorSubject<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get wordMap => _wordMap.stream;

  final BehaviorSubject<bool> _isGameSaved = BehaviorSubject<bool>();
  Stream<bool> get isGameSaved => _isGameSaved.stream;

  // Game state streams
  Stream<SplayTreeSet<String>> get foundWords => state.words.stream;
  Stream<String> get word => state.word.stream;
  Stream<Message> get message => state.message.stream;
  Stream<int> get points => state.points.stream;
  Stream<int> get wordCount => state.words.map((x) => x.length);

  // Game state getters
  SplayTreeSet<String> get wordsRemaining => state.wordsRemaining.value;
  int get maxPoints => state.maxPoints;
  int get maxWords => state.maxWords;

  // Event handlers
  final PublishSubject<Event> _event = PublishSubject<Event>();
  Sink<Event> get eventSink => _event.sink;

  final _loadGame = PublishSubject<bool>();
  Sink<bool> get loadGameSink => _loadGame.sink;

  final _nextLetter = PublishSubject<String>();
  Sink<String> get nextLetterSink => _nextLetter.sink;

  GameStore? _savedGame;

  Future<void> init() async {
    try {
      await settings.init(); // Do this first

      // Get dictionary preference
      final useEnable = await StorageService.getUseEnableDict();
      useEnableDict.add(useEnable);

      await loadWordMap();

      // Load saved game if it exists
      final savedGameData = await Assets.getGame();
      _savedGame = GameStore.fromCache(savedGameData);
      final isGameSaved = _savedGame != null && _savedGame!.val().isNotEmpty;
      _isGameSaved.add(isGameSaved);

      // Listen for dictionary preference changes
      useEnableDict.listen((bool use) async {
        await StorageService.setUseEnableDict(use);
        _loadGameHandler(true);
      });
      
      _loadGame.listen(_loadGameHandler);
      _nextLetter.listen(state.addLetter);
      _event.listen(_eventHandler);
      
      // Force initial game load if there's no saved game
      if (!isGameSaved) {
        await _loadGameHandler(false);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing GameBloc: $e');
      }
      // Add a default empty game to prevent loading forever
      _isGameSaved.add(false);
      state.reset('abcdefg', [''], []);
    }
  }

  Future<void> loadWordMap() async {
    if (_loadEnableDict == useEnableDict.value) return;
    _loadEnableDict = useEnableDict.value;
    final wordMap = await Assets.getWordMap(_loadEnableDict ?? true);
    _wordMap.add(wordMap);
  }

  void _saveGame(bool save) {
    _savedGame = save ? state.getGameStore() : null;
    if (save && _savedGame != null) {
      Assets.setGame(_savedGame!.val());
    } else {
      Assets.removeGame();
    }
    _isGameSaved.add(save);
  }

  Future<void> _loadGameHandler(bool resume) async {
    await loadWordMap();
    final wordMap = _wordMap.value;

    String? gameStr = _savedGame != null ? _savedGame!.game() : Logic.randomGame(wordMap);
    String game = (resume && (gameStr != null) && Logic.isGameValid(wordMap, gameStr)) 
        ? gameStr 
        : Logic.randomGame(wordMap);
    
    final answer = Logic.answer(wordMap, game);

    List<String> foundWords = <String>[];
    if (resume && _savedGame != null) {
      foundWords = SplayTreeSet<String>.from(_savedGame!.foundWords())
          .intersection(SplayTreeSet<String>.from(answer))
          .toList();
    }

    state.reset(game, answer, foundWords);
    if (!resume) _saveGame(true);
  }

  void _eventHandler(Event e) {
    final wordMap = _wordMap.value;
    switch (e) {
      case Event.load:
        _loadGameHandler(false);
        break;
      case Event.check:
        if (state.check(wordMap)) _saveGame(true);
        break;
      case Event.shuffle:
        state.shuffle();
        break;
      case Event.delete:
        state.delete();
        break;
      case Event.clear:
        state.clear();
        break;
      default:
        if (kDebugMode) {
          //print("Unhandled event");
        }
        break;
    }
  }

  void dispose() {
    state.dispose();
    useEnableDict.close();
    _wordMap.close();
    _isGameSaved.close();
    _event.close();
    _loadGame.close();
    _nextLetter.close();
    settings.dispose();
  }
}
