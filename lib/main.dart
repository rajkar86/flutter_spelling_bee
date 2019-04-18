import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/assets.dart';
import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/pages/main_menu.dart';
// import 'package:spelling_bee/pages/game.dart';
import 'package:spelling_bee/states/provider.dart';

// import 'package:flutter/rendering.dart';


void main() async {
  Map wordMap = await Assets.loadMap('assets/words.json');
  // Map statsMap = await Assets.loadMap('assets/stats.json');
  // debugPaintSizeEnabled = true;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp(wordMap: wordMap));
  });
}

class MyApp extends StatelessWidget {
  final Map wordMap;
  // final Map statsMap;
  MyApp({Key key, this.wordMap}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var title = 'Spelling Bee';
    return Provider(
      game: GameBloc(this.wordMap),
      // statsMap: this.statsMap,
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          brightness: Brightness.light,
        ),
        home: Builder(builder: (context) => scaffold(MainMenu())),
      ),
    );
  }
}
