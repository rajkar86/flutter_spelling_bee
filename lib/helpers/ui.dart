import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// import 'package:spelling_bee/helpers/assets.dart';

// import 'package:spelling_bee/pages/game.dart';

Widget scaffold(Widget w) {
  return Scaffold(
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
