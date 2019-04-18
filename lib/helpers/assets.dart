import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class Assets {
  static Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  static Future<Map> loadMap(String path) async {
    String jsonString = await loadAsset(path);
    return json.decode(jsonString);
  }

  static Future<bool> setGame(List<String> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList("game", list);
  }

  static Future<List<String>> getGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("game") ?? [];
  }

  static Future<bool> removeGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("game");
  }
}
