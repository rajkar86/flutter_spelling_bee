import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/consts.dart';
import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/pages/game.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:spelling_bee/pages/main_menu.dart';
import 'package:spelling_bee/pages/rules.dart';
import 'package:spelling_bee/pages/settings.dart';
import 'package:native_state/native_state.dart';

// import 'package:flutter/rendering.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var gameBloc = GameBloc();
  await gameBloc.init();

  // debugPaintSizeEnabled = true;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
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
            return snapshot.hasData ? scaffold(Game(), context) : WAIT_WIDGET;
          });
    });
  }
}

// PageTransition buildPageTransition(Widget w) {
//   return PageTransition(type: PageTransitionType.rightToLeftWithFade, child: w);
// }

class MyApp extends StatelessWidget {
  final GameBloc gameBloc;
  // final Map wordMap;
  // final Map statsMap;
  MyApp({Key key, this.gameBloc}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var lightTheme = ThemeData(
      primarySwatch: Colors.yellow,
      brightness: Brightness.light,
      indicatorColor: Colors.black,
    );

    var darkTheme = ThemeData(
        // primaryColor: Colors.black,
        // buttonColor: Colors.blueGrey,
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.grey), bodyText2: TextStyle(color: Colors.grey)),
        // colorScheme: ColorScheme(secondary: Colors.black),
        iconTheme: IconThemeData(color: Colors.blueGrey),
        buttonTheme: ButtonThemeData(buttonColor: Colors.blueGrey, textTheme: ButtonTextTheme.accent),
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
        // backgroundColor: Colors.black ,
        toggleableActiveColor: Colors.blueGrey,
        canvasColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        cardTheme: CardTheme(color: Colors.black, shadowColor: Colors.blueGrey, elevation: 9),
        brightness: Brightness.dark);

    var navigatorKey = GlobalKey<NavigatorState>();
    var savedState = SavedState.of(context);
    var routeObserver = SavedStateRouteObserver(savedState: savedState);

    return Provider(
      game: this.gameBloc,
      child: StreamBuilder(
          stream: this.gameBloc.settings.theme,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return WAIT_WIDGET;
            return MaterialApp(
              title: GAME_TITLE,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.values[snapshot.data],
              navigatorKey: navigatorKey,
              navigatorObservers: [routeObserver],
              initialRoute: SavedStateRouteObserver.restoreRoute(savedState) ?? "/",
              routes: {
                '/': (context) => MainMenu(),
                '/game': (context) => GameScreen(),
                '/settings': (context) => Settings(),
                '/rules': (context) => Rules(),
              },
            );
          }),
    );
  }
}
