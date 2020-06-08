import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc {

  // Don't use BehaviorSubjects directly in clients
  // BehaviorSubject<bool> useEnableDict = BehaviorSubject<bool>();
  BehaviorSubject<int> theme = BehaviorSubject<int>();

  SettingsBloc();

  Future<void> init() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  
    // useEnableDict.add(prefs.getBool("useEnable") ?? true);   
    // useEnableDict.listen((bool use){
    //   prefs.setBool("useEnable", use);
    //   // _reloadWordMap = true;
    // });     

    theme.add(prefs.getInt("theme") ?? ThemeMode.light.index);
    theme.listen((int theme){
      prefs.setInt("theme", theme);
    });

  }

  void dispose() {
    // useEnableDict.close();
    theme.close();
  }
}