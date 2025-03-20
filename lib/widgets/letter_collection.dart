import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

class LetterCollection extends StatelessWidget {
  const LetterCollection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: Provider.of<GameBloc>(context).game,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return snapshot.hasData ? _build(context, snapshot.data ?? '') : Container();
      },
    );
  }

  Widget _build(BuildContext context, String letters) {
    double sz = 80;

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    var color1 = isDark ? Colors.grey : Colors.black;
    var color2 = isDark ? Colors.blueGrey : Colors.yellow;

    Widget button(String c, [bool center = false]) {
      var s = TextStyle(color: isDark ? Colors.black : (center ? color2 : color1), fontSize: 24);

      return Center(
        child: Padding(
          padding: EdgeInsets.only(left: sz * 0.4, right: sz * 0.4),
          child: SizedBox(
            height: sz,
            width: sz,
            child: ElevatedButton(
              onPressed: () {
                Provider.of<GameBloc>(context, listen: false).nextLetterSink.add(c);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: (center ? color1 : color2),
                shape: const PolygonBorder(
                  sides: 6,
                  borderRadius: 0.0,
                  rotate: 90.0,
                ),
                padding: EdgeInsets.zero,
              ),
              child: Text(c, style: s),
            ),
          ),
        ),
      );
    }

    var chars = letters.split('');
    var center = chars[0];
    chars = chars.sublist(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: button(center, true),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            button(chars[0]),
            button(chars[1]),
            button(chars[2]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            button(chars[3]),
            button(chars[4]),
            button(chars[5]),
          ],
        ),
      ],
    );
  }
}
