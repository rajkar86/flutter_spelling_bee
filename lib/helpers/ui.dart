import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:spelling_bee/pages/found_words.dart';
import 'package:spelling_bee/pages/rules.dart';
import 'package:spelling_bee/widgets/word_list.dart';

AlertDialog buildMissedWordsDialog(GameBloc gb, BuildContext context) {
  return AlertDialog(
      title: Text("Missed Words"),
      content: StreamBuilder(
          stream: Provider.of(context).game.wordsRemaining,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? WordList(words: snapshot.data)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
      actions: <Widget>[
        RaisedButton(
          color: Colors.yellow,
          child: Text(
            'Proceed to new game',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            gb.eventSink.add(Event.LOAD);
            Navigator.pop(context);
          },
        ),
      ]);
}

Widget scaffold(Widget w, BuildContext context) {
  return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: Text("Spelling Bee"),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  tooltip: "New Game",
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            buildMissedWordsDialog(
                                Provider
                                    .of(context)
                                    .game, context));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.help),
                  tooltip: "Help",
                  onPressed: () {
                    Navigator.push(context, buildPageTransition(Rules()));
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(text: "Game", icon: Icon(Icons.edit)),
                  Tab(text: "Word List", icon: Icon(Icons.view_list)),
                ],
              )),
          body: TabBarView(
            children: [w, FoundWords()],
          )));
}

PageTransition buildPageTransition(Widget w) {
  return PageTransition(type: PageTransitionType.scale, child: w);
}

// Widget wrapWillPop(Widget w, BuildContext context) {
//   Future<bool> _onWillPop() {
//      dialog(
//             context,
//             'Save game?',
//             "Do you want to save the game and resume next time?",
//             () => {Navigator.of(context).pop(true)},
//             () => {
//                   Assets.removeGame(),
//                   // Assets.removeFoundWords(),
//                   Navigator.of(context).pop(true)
//                 }) ??
//         false;
//   }

//   return WillPopScope(onWillPop: _onWillPop, child: w);
// }

void dialog(BuildContext context, String title, String content,
    VoidCallback yes, VoidCallback no) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: no,
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: yes,
        ),
      ],
    ),
  );
}
