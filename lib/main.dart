import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/consts.dart';
import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/pages/game.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/pages/main_menu.dart';
import 'package:spelling_bee/pages/rules.dart';
import 'package:spelling_bee/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter/rendering.dart';

/// App entry point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GameBloc
  final gameBloc = GameBloc();
  await gameBloc.init();

  // Set preferred orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Load last route if saved
  final prefs = await SharedPreferences.getInstance();
  final lastRoute = prefs.getString('last_route') ?? '/';
  
  // Run the app
  runApp(MyApp(gameBloc: gameBloc, initialRoute: lastRoute));
}

/// Game screen that shows the actual game
class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final gameBloc = Provider.of<GameBloc>(context);
      return StreamBuilder<String>(
          stream: gameBloc.game,
          builder: (context, snapshot) {
            return snapshot.hasData 
                ? scaffold(const Game(), context) 
                : const Center(child: CircularProgressIndicator());
          });
    });
  }
}

// PageTransition buildPageTransition(Widget w) {
//   return PageTransition(type: PageTransitionType.rightToLeftWithFade, child: w);
// }

/// Main app widget that sets up theming and routes
class MyApp extends StatelessWidget {
  final GameBloc gameBloc;
  final String initialRoute;
  
  const MyApp({
    Key? key, 
    required this.gameBloc,
    required this.initialRoute,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      primarySwatch: Colors.yellow,
      brightness: Brightness.light,
      indicatorColor: Colors.black,
      useMaterial3: true,
    );

    final darkTheme = ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.grey), 
          bodyMedium: TextStyle(color: Colors.grey),
        ),
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
          ),
        ),
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
        canvasColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        cardTheme: const CardTheme(color: Colors.black, shadowColor: Colors.blueGrey, elevation: 9),
        brightness: Brightness.dark,
        useMaterial3: true);

    final navigatorKey = GlobalKey<NavigatorState>();

    return Provider<GameBloc>.value(
      value: gameBloc,
      child: StreamBuilder<int>(
          stream: gameBloc.settings.theme,
          initialData: 0,
          builder: (context, snapshot) {
            final themeMode = snapshot.hasData ? ThemeMode.values[snapshot.data!] : ThemeMode.system;
            
            return MaterialApp(
              title: gameTitle,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              navigatorKey: navigatorKey,
              initialRoute: initialRoute,
              routes: {
                '/': (context) => const MainMenu(),
                '/game': (context) => const GameScreen(),
                '/settings': (context) => const Settings(),
                '/rules': (context) => const Rules(),
              },
              navigatorObservers: [
                _RouteObserver(
                  onRouteChanged: (String route) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('last_route', route);
                  },
                ),
              ],
            );
          }),
    );
  }
}

/// Custom route observer to track navigation for state persistence
class _RouteObserver extends NavigatorObserver {
  final void Function(String) onRouteChanged;
  
  _RouteObserver({required this.onRouteChanged});
  
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      onRouteChanged(route.settings.name!);
    }
    super.didPush(route, previousRoute);
  }
  
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute?.settings.name != null) {
      onRouteChanged(newRoute!.settings.name!);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
