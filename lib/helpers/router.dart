import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:spelling_bee/helpers/ui.dart';
import 'package:spelling_bee/pages/game.dart';
import 'package:spelling_bee/pages/rules.dart';
import 'package:spelling_bee/pages/settings.dart';

PageTransition buildPageTransition(Widget w) {
  return PageTransition(type: PageTransitionType.scale, child: w);
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

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return buildPageTransition(GameScreen());
      case '/settings':
        return buildPageTransition(Settings());
      case '/rules':
        return buildPageTransition(Rules());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
