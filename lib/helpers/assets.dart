import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:spelling_bee/services/storage_service.dart';

/// Helper class for loading assets and handling persistence
class Assets {
  /// Loads a string asset from the bundle
  static Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  /// Loads a JSON map from an asset file
  static Future<Map<String, dynamic>> loadMap(String path) async {
    String jsonString = await loadAsset(path);
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Saves the current game state
  static Future<void> setGame(List<String> list) async {
    final Map<String, dynamic> gameData = {
      'game': list,
    };
    await StorageService.saveGame(gameData);
  }

  /// Gets the saved game state
  static Future<List<String>> getGame() async {
    final gameData = await StorageService.loadGame();
    if (gameData == null || !gameData.containsKey('game')) {
      return [];
    }
    
    final gameList = gameData['game'];
    if (gameList is List) {
      return gameList.cast<String>();
    }
    
    return [];
  }

  /// Removes the saved game
  static Future<void> removeGame() async {
    await StorageService.removeGame();
  }

  /// Loads the word map for the current dictionary
  static Future<Map<String, dynamic>> getWordMap(bool useEnableDict) async {
    // Try to load from storage first
    final cachedWordMap = await StorageService.loadWordMap(useEnableDict);
    if (cachedWordMap != null) {
      return cachedWordMap;
    }
    
    // If not in storage, load from assets
    final assetPath = useEnableDict ? 'assets/words_large.json' : 'assets/words.json';
    final wordMap = await loadMap(assetPath);
    
    // Cache for future use
    await StorageService.saveWordMap(useEnableDict, wordMap);
    
    return wordMap;
  }
}
