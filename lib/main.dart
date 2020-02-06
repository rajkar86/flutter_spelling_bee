import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/pages/game.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:spelling_bee/pages/rules.dart';
import 'package:spelling_bee/pages/settings.dart';
import 'package:native_state/native_state.dart';

// import 'package:flutter/rendering.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var gameBloc = GameBloc();
  await gameBloc.init();
  // Map wordMap = await Assets.loadMap('assets/words.json');
  // debugPaintSizeEnabled = true;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(SavedState(child: MyApp(gameBloc: gameBloc)));
  });
}

class GameScreen extends StatelessWidget {
  const GameScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return StreamBuilder<Object>(
          stream: Provider.of(context).game.game,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? scaffold(Game(), context)
                : Center(child: CircularProgressIndicator());
          });
    });
  }
}

class MyApp extends StatelessWidget {
  final GameBloc gameBloc;
  // final Map wordMap;
  // final Map statsMap;
  MyApp({Key key, this.gameBloc}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var title = '7 Letter Pangrams';
    var savedState = SavedState.of(context);
    return Provider(
      game: this.gameBloc,
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          brightness: Brightness.light,
        ),
        navigatorKey: GlobalKey(),
        navigatorObservers: [SavedStateRouteObserver(savedState: savedState)],
        initialRoute: SavedStateRouteObserver.restoreRoute(savedState) ?? "/",
        routes: {
          '/': (context) => GameScreen(),
          '/settings': (context) => Settings(),
          '/rules': (context) => Rules(),
        },
        
        // home: GameScreen(),
        // onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}


