import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A service class to handle app state persistence using SharedPreferences
class StorageService {
  static const String _gameKey = 'savedGame';
  static const String _wordMapKey = 'wordMap';
  static const String _statsKey = 'stats';
  //static const String _settingsKey = 'settings';
  static const String _enableDictKey = 'useEnable';
  static const String _themeKey = 'theme';
  static const String _routeKey = 'last_route';

  /// Saves the game state
  static Future<void> saveGame(Map<String, dynamic> gameData) async {
    final prefs = await SharedPreferences.getInstance();
    if (gameData.isEmpty) {
      await prefs.remove(_gameKey);
    } else {
      await prefs.setString(_gameKey, jsonEncode(gameData));
    }
  }

  /// Loads the saved game state
  static Future<Map<String, dynamic>?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final gameString = prefs.getString(_gameKey);
    if (gameString == null || gameString.isEmpty) {
      return null;
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(gameString));
    } catch (e) {
      //print('Error loading game: $e');
      return null;
    }
  }

  /// Removes the saved game
  static Future<void> removeGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_gameKey);
  }

  /// Saves the word map
  static Future<void> saveWordMap(bool useEnable, Map<String, dynamic> wordMap) async {
    final prefs = await SharedPreferences.getInstance();
    final key = useEnable ? '${_wordMapKey}_enable' : _wordMapKey;
    await prefs.setString(key, jsonEncode(wordMap));
    await prefs.setBool(_enableDictKey, useEnable);
  }

  /// Loads the word map
  static Future<Map<String, dynamic>?> loadWordMap(bool useEnable) async {
    final prefs = await SharedPreferences.getInstance();
    final key = useEnable ? '${_wordMapKey}_enable' : _wordMapKey;
    final wordMapString = prefs.getString(key);
    if (wordMapString == null || wordMapString.isEmpty) {
      return null;
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(wordMapString));
    } catch (e) {
      //print('Error loading word map: $e');
      return null;
    }
  }

  /// Gets the dictionary preference
  static Future<bool> getUseEnableDict() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enableDictKey) ?? true;
  }

  /// Sets the dictionary preference
  static Future<void> setUseEnableDict(bool useEnable) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enableDictKey, useEnable);
  }

  /// Saves the theme setting
  static Future<void> saveTheme(int themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode);
  }

  /// Loads the theme setting
  static Future<int> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_themeKey) ?? 0; // Default to system theme
  }

  /// Saves stats data
  static Future<void> saveStats(Map<String, dynamic> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats));
  }

  /// Loads stats data
  static Future<Map<String, dynamic>?> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsString = prefs.getString(_statsKey);
    if (statsString == null || statsString.isEmpty) {
      return null;
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(statsString));
    } catch (e) {
      //print('Error loading stats: $e');
      return null;
    }
  }

  /// Saves the last route for navigation persistence
  static Future<void> saveRoute(String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_routeKey, route);
  }

  /// Loads the last route
  static Future<String> loadRoute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_routeKey) ?? '/';
  }
} 