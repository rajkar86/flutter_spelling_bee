import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/provider.dart';
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

class SBDrawer extends StatelessWidget {
  const SBDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var gb = Provider.of(context).game;
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text(
              "Spelling Bee",
              style: TextStyle(fontSize: 27),
            ),
            decoration: BoxDecoration(
              color: Colors.yellow,
            ),
          ),
          ListTile(
            title: Text(
              "Abandon game",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) => buildMissedWordsDialog(gb, context));
            },
          ),
          ListTile(
            title: Text(
              "Rules",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, buildPageTransition(scaffold(Rules(), context, false)));
              // showDialog(
              //     context: context,
              //     builder: (context) => Rules());
            },
          )
        ],
      ),
    );
  }
}

Widget scaffold(Widget w, BuildContext context, drawer) {
  return Scaffold(
    drawer: drawer ? SBDrawer() : null,
    appBar: AppBar(
      title: Text("Spelling Bee"),
    ),
    body: w,
  );
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

Widget buildSwipeMessage(String m) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(m, style: TextStyle(color: Colors.grey, fontSize: 20)),
    ),
  );
}
