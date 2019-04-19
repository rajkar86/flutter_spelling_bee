import 'package:flutter/material.dart';
import 'package:spelling_bee/helpers/provider.dart';

class LetterCollection extends StatelessWidget {
  // LetterCollection({Key key}) : super(key: key);

  // final ValueChanged<String> onPressed;
  // final String letters;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of(context).game.game,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData ? _build(context, snapshot.data) : Container();
      },
    );
  }

  Widget _build(BuildContext context, String letters) {
    Widget _button(String c, [bool center = false]) {
      double sz = 50;

      var s = TextStyle(
          color: (center ? Colors.yellow : Colors.black), fontSize: 24);

      //  = Theme.of(context).textTheme.title;
      // if (center)
      //   s.color = Colors.yellow;
      return Center(
        child: Padding(
          padding: EdgeInsets.all(sz / 2),
          child: ButtonTheme(
            height: sz,
            child: RaisedButton(
              onPressed: () {
                Provider.of(context).game.nextLetterSink.add(c);
              },
              color: (center ? Colors.black : Colors.yellow),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(sz / 2),
              ),
              child: Text(c, style: s),
            ),
          ),
        ),
      );
    }

    Widget _buttonRow(String chars) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: chars.split("").map((c) => _button(c)).toList());
    }

    // print (MediaQuery.of(context).size.width);
    // print (MediaQuery.of(context).size.height);
    return Container(
      height: 240,
      child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          alignment: const Alignment(0, 0),
          fit: StackFit.loose,
          children: <Widget>[
            Positioned(top: 015, child: _button(letters[1])),
            Positioned(top: 047, child: _buttonRow(letters[2] + letters[3])),
            Positioned(top: 080, child: _button(letters[0], true)),
            Positioned(top: 113, child: _buttonRow(letters[4] + letters[5])),
            Positioned(top: 145, child: _button(letters[6]))
          ]),
    );
  }
}
