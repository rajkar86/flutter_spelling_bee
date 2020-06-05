import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Themes { SYSTEM, LIGHT, DARK }

class SettingsBloc {

  // Public, but only use stream and sink
  BehaviorSubject<bool> useEnableDict = BehaviorSubject<bool>();
  BehaviorSubject<int> theme = BehaviorSubject<int>();

  SettingsBloc();

  Future<void> init() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  
    useEnableDict.add(prefs.getBool("useEnable") ?? true);   
    useEnableDict.listen((bool use){
      prefs.setBool("useEnable", use);
      // _reloadWordMap = true;
    });     

    theme.add(prefs.getInt("theme") ?? Themes.SYSTEM);
    theme.listen((int theme){
      prefs.setInt("theme", theme);
    });

  }

  void dispose() {
    useEnableDict.close();
    theme.close();
  }
}