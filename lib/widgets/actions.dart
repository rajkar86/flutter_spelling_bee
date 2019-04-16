import 'package:flutter/material.dart';

class Actions extends StatelessWidget {
  const Actions({Key key, this.clear, this.refresh, this.submit})
      : super(key: key);

  final VoidCallback clear;
  final VoidCallback refresh;
  final VoidCallback submit;

  static const double SIZE=36;

  @override
  Widget build(BuildContext context) {
    return Ink(
      // padding: const EdgeInsets.only(bottom: SIZE*1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _icon(Icons.clear, "Clear", this.clear),
          _icon(Icons.refresh, "Shuffle", this.refresh),
          _icon(Icons.check, "Check", this.submit),
          //button("Clear", this.clear),
          // button("Submit", this.submit),
        ],
      ),
    );
  }

  Widget _icon(IconData i, String t, VoidCallback c) {
    return Column(
      children: <Widget>[
        IconButton(
          iconSize: SIZE,
          icon: Icon(i, color: Colors.black, size: SIZE),
          tooltip: t,
          // color: Colors.yellow,
          splashColor: Colors.yellow,
          onPressed: c,
          disabledColor: Colors.blueGrey,
        ),
        Text(t)
      ],
    );
  }

  // Widget button(String s, VoidCallback c) {
  //   return Padding(
  //     padding: const EdgeInsets.all(27.0),
  //     child: ButtonTheme(
  //       child: RaisedButton(
  //         color: Colors.black,
  //         highlightColor: Colors.green,
  //         onPressed: c,
  //         shape: BeveledRectangleBorder(
  //           borderRadius: BorderRadius.circular(5.0),
  //         ),
  //         child: Text(s, style: TextStyle(color: Colors.white, fontSize: 20)),
  //       ),
  //     ),
  //   );
  // }
}
