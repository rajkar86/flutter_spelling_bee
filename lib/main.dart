import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/blocs/settings_bloc.dart';
import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/pages/game.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:spelling_bee/pages/rules.dart';
import 'package:spelling_bee/pages/settings.dart';
import 'package:native_state/native_state.dart';

// import 'package:flutter/rendering.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var settingsBloc = SettingsBloc();
  await settingsBloc.init();

  var gameBloc = GameBloc(settingsBloc: settingsBloc);
  await gameBloc.init();

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

PageTransition buildPageTransition(Widget w) {
  return PageTransition(type: PageTransitionType.rightToLeftWithFade, child: w);
}

class MyApp extends StatelessWidget {
  final GameBloc gameBloc;
  // final Map wordMap;
  // final Map statsMap;
  MyApp({Key key, this.gameBloc}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var title = 'Not That Spelling Bee';
    var savedState = SavedState.of(context);

    var lightTheme = ThemeData(
      primarySwatch: Colors.yellow,
      brightness: Brightness.light,
    );

    var darkTheme = ThemeData.dark();

    return Provider(
      game: this.gameBloc,
      child: StreamBuilder(
        stream: this.gameBloc.useEnableDict,
        builder: (context, snapshot) {
          return MaterialApp(
            title: title,
            theme: snapshot.data ? darkTheme : lightTheme,
            darkTheme: darkTheme,
            navigatorKey: GlobalKey(),
            navigatorObservers: [SavedStateRouteObserver(savedState: savedState)],
            initialRoute: SavedStateRouteObserver.restoreRoute(savedState) ?? "/",
            routes: {
              '/': (context) => GameScreen(),
              '/settings': (context) => Settings(),
              '/rules': (context) => Rules(),
            },
          );
        }
      ),
    );
  }
}
