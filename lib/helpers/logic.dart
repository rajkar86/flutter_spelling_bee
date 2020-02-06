import 'dart:collection';
import 'dart:math';

import "package:trotter/trotter.dart";

class Logic {
  static const int MAX_WORD_LENGTH = 17;

  static String sortWord(String word) {
    var list = word.split("");
    list.sort();
    return Set<String>.from(list).join();
  }

  static String check(
      String word, String game, SplayTreeSet<String> foundWords, Map wordMap) {
    if (foundWords.contains(word)) return "Word already found";
    if (word.length == 0) return "Enter a word first!";
    if (word.length < 4) return "Word too short!";
    if (!(word.contains(game[0]))) return "Does not contain center letter!";
    var key = sortWord(word);
    return (wordMap.keys.contains(key) && wordMap[key].contains(word))
        ? ""
        : "Not a word";
  }

  static bool isValidProvider(String word, String letters) {
    return (word.length >= 4) && (word.contains(letters[0]));
  }

  static bool isCorrectProvider(String checkStatus) {
    return checkStatus == "";
  }

  static String sampleSuccessMessage() {
    var m = [
      "Nice!",
      "Good job!",
      "Excellent!",
      "Way to go!",
      "Terrific!",
      "Brilliant!"
    ];
    var r = new Random();
    return m[r.nextInt(m.length)];
  }

  static String randomGame(Map wordMap) {
    // return "TAENHIR";
    var games = wordMap.keys.where((x) => x.length == 7).toList();
    final _random = new Random();
    var game = games[_random.nextInt(games.length)].toString();
    var pos = _random.nextInt(7);
    return game.substring(pos, pos + 1) +
        game.substring(0, max(0, pos)) +
        game.substring(pos + 1, 7);
  }

  static bool isGameValid(Map wordMap, String game) {
    var key = game.split('');
    key.sort();
    return wordMap.containsKey(key.join(''));
  }

  static String shuffleWord(String word) {
    List l = word.split("");
    l.shuffle();
    return l.join();
  }

  static String shuffleGame(String game) {
    return game[0] + shuffleWord(game.substring(1));
  }

  // Assuming word is already valid for the game
  static bool isPangram(String word, String game) {
    return Set<String>.from(game.split(""))
            .difference(Set<String>.from(word.split("")))
            .length ==
        0;
  }

  // Assuming word is already valid for the game
  static int points(String word, String game) {
    if (word.length == 4) return 1;
    return word.length + (isPangram(word, game) ? 7 : 0);
  }

  static List<String> answer(Map wordMap, String game) {
    if (game == null) return [];

    var sub = Subsets(game.substring(1).split(""))();

    var ans = [];

    void solveSubGame(List g) {
      g.add(game[0]);
      var key = sortWord(g.join());
      var val = wordMap[key];
      if (val != null) ans.addAll(val);
    }

    sub.forEach((g) => {solveSubGame(g)});

    return List<String>.from(ans);
  }

  static int pointsForAns(List ans, String game) {
    var total = 0;
    ans.forEach((w) => {total += points(w, game)});
    return total;
  }

  // static List statsForGame(String game, Map statsMap) {
  //   if (!statsMap.keys.contains(game)) return []; //ERROR
  //   return statsMap[game];
  // }
}
