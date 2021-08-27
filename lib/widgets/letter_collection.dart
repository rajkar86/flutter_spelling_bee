import 'package:flutter/material.dart';
import 'package:spelling_bee/helpers/provider.dart';
import 'package:polygon_clipper/polygon_border.dart';

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
    double sz = 80;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    var color1 = isDark ? Colors.grey : Colors.black;
    var color2 = isDark ? Colors.blueGrey : Colors.yellow;

    Widget _button(String c, [bool center = false]) {
      var s = TextStyle(color: isDark ? Colors.black : (center ? color2 : color1), fontSize: 24);

      return Center(
        child: Padding(
          padding: EdgeInsets.only(left: sz * 0.4, right: sz * 0.4),
          child: ButtonTheme(
            height: sz,
            minWidth: sz,
            child: RaisedButton(
              onPressed: () {
                Provider.of(context).game.nextLetterSink.add(c);
              },
              color: (center ? color1 : color2),
              shape: PolygonBorder(
                sides: 6,
                borderRadius: 0.0, // Default 0.0 degrees
                rotate: 90.0, // Default 0.0 degrees
                border: BorderSide.none, // Default BorderSide.none
              ),
              // BeveledRectangleBorder(
              //   borderRadius: BorderRadius.circular(sz/2),
              // ),
              child: Text(c, style: s),
            ),
          ),
        ),
      );
    }

    Widget _buttonRow(String chars) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, children: chars.split("").map((c) => _button(c)).toList());
    }

    // print (MediaQuery.of(context).size.width);
    // print (MediaQuery.of(context).size.height);
    var dist = sz * 0.5;

    return Container(
      height: sz * 3,
      child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          alignment: const Alignment(0, 0),
          fit: StackFit.loose,
          children: <Widget>[
            Positioned(top: 0 * dist, child: _button(letters[1])),
            Positioned(top: 1 * dist, child: _buttonRow(letters[2] + letters[3])),
            Positioned(top: 2 * dist, child: _button(letters[0], true)),
            Positioned(top: 3 * dist, child: _buttonRow(letters[4] + letters[5])),
            Positioned(top: 4 * dist, child: _button(letters[6]))
          ]),
    );
  }
}
