import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
//import 'package:spelling_bee/helpers/assets.dart';
import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/pages/game.dart';
import 'package:spelling_bee/helpers/provider.dart';

// import 'package:flutter/rendering.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var gameBloc = GameBloc();
  await gameBloc.init();
  // Map wordMap = await Assets.loadMap('assets/words.json');
  // debugPaintSizeEnabled = true;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp(gameBloc: gameBloc));
  });
}

class MyApp extends StatelessWidget {
  final GameBloc gameBloc;
  // final Map wordMap;
  // final Map statsMap;
  MyApp({Key key, this.gameBloc}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var title = 'Spelling Bee';
    return Provider(
      game: this.gameBloc,
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          brightness: Brightness.light,
        ),
        home: Builder(builder: (context) {
          return StreamBuilder<Object>(
              stream: gameBloc.game,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? scaffold(Game(), context)
                    : Center(child: CircularProgressIndicator());
              });
        }),
      ),
    );
  }
}
