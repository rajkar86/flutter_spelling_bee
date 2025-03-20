import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/consts.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/pages/found_words.dart';
import 'package:spelling_bee/widgets/word_list.dart';

AlertDialog buildMissedWordsDialog(BuildContext context) {
  final gameBloc = Provider.of<GameBloc>(context, listen: false);
  final words = gameBloc.wordsRemaining;

  bool isDark = Theme.of(context).brightness == Brightness.dark;

  return AlertDialog(
      title: const Text("Missed Words"),
      content: WordList(words: SplayTreeSet<String>.from(words)),
      actions: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.grey : Colors.yellow,
              ),
              child: const Text(
                'Proceed to new game',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                gameBloc.eventSink.add(Event.load);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ]);
}

Widget scaffold(Widget w, BuildContext context) {
  return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: const Text(gameTitle, style: TextStyle(fontSize: 18)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: "New Game",
                  onPressed: () {
                    showDialog(context: context, builder: (context) => buildMissedWordsDialog(context));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: "Settings",
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                    //Navigator.push(context, buildPageTransition(Settings()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.help),
                  tooltip: "Rules",
                  onPressed: () {
                    Navigator.pushNamed(context, '/rules');
                    //Navigator.push(context, buildPageTransition(Rules()));
                  },
                ),
              ],
              bottom: TabBar(
                  indicatorColor: Theme.of(context).indicatorColor,
                  tabs: [const Tab(text: "GAME"), Tab(text: "FOUND (${Provider.of<GameBloc>(context).wordsRemaining.length})")])
              ),
          body: TabBarView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: w,
                ),
              ],
            ),
            const FoundWords()
          ])));
}

class TextFieldDialog extends StatefulWidget {
  final String title;
  final String label;
  final String confirmText;
  final Function(String) onConfirm;
  final Function? onCancel;
  final String text;
  final bool obscureText;

  const TextFieldDialog(
      {Key? key,
      required this.title,
      required this.label,
      required this.confirmText,
      required this.onConfirm,
      this.onCancel,
      this.text = "",
      this.obscureText = false})
      : super(key: key);

  @override
  State<TextFieldDialog> createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          labelText: widget.label,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
            if (widget.onCancel != null) {
              widget.onCancel!();
            }
          },
        ),
        TextButton(
          child: Text(widget.confirmText),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onConfirm(controller.text);
          },
        ),
      ],
    );
  }
}

PageTransition buildPageTransition(Widget w) {
  return PageTransition(type: PageTransitionType.scale, child: w);
}

Card clickableCard(String title, String subtitle, Widget control, Function() onTap) {
  var inkWell = InkWell(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18),
                ),
              )),
              control,
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ));
  return Card(child: inkWell);
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

void dialog(BuildContext context, String title, String content, VoidCallback yes, VoidCallback no) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: no,
          child: const Text('No'),
        ),
        TextButton(
          onPressed: yes,
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
