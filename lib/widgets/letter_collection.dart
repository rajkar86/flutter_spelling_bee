import 'package:flutter/material.dart';

class LetterCollection extends StatelessWidget {
  LetterCollection({Key key, @required this.letters, @required this.onPressed})
      : super(key: key);

  final ValueChanged<String> onPressed;
  final String letters;

  @override
  Widget build(BuildContext context) {
    Widget _button(String c, [bool center = false]) {
      double sz = 50;

      var s = TextStyle(
          color: (center ? Colors.yellow : Colors.black), fontSize: 24);

      //  = Theme.of(context).textTheme.title;
      // if (center)
      //   s.color = Colors.yellow;
      return Center(
        child: Padding(
          padding: EdgeInsets.all(sz/2),
          child: ButtonTheme(
            height: sz,
            child: RaisedButton(
              onPressed: () {
                this.onPressed(c);
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
            Positioned(top: 015, child: _button(this.letters[1])),
            Positioned(
                top: 047, child: _buttonRow(this.letters[2] + this.letters[3])),
            Positioned(top: 080, child: _button(this.letters[0], true)),
            Positioned(
                top: 113, child: _buttonRow(this.letters[4] + this.letters[5])),
            Positioned(top: 145, child: _button(this.letters[6]))
          ]),
    );
  }
}
