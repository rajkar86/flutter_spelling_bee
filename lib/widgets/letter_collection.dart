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
    // Use LayoutBuilder to get available width and adapt to it
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate optimal button size based on available width
        // Leave some margin to prevent overflow
        final availableWidth = constraints.maxWidth;
        final buttonSize = (availableWidth / 4).clamp(50.0, 80.0);
        final padding = (buttonSize * 0.15).clamp(5.0, 15.0);
        
        bool isDark = Theme.of(context).brightness == Brightness.dark;
        var color1 = isDark ? Colors.grey : Colors.black;
        var color2 = isDark ? Colors.blueGrey : Colors.yellow;

        Widget button(String c, [bool center = false]) {
          var s = TextStyle(
            color: isDark ? Colors.black : (center ? color2 : color1), 
            fontSize: (buttonSize / 3.5).clamp(16.0, 24.0), // Responsive font size
          );

          return Center(
            child: Padding(
              padding: EdgeInsets.only(left: padding, right: padding),
              child: SizedBox(
                height: buttonSize,
                width: buttonSize,
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
              padding: EdgeInsets.only(bottom: buttonSize * 0.25),
              child: button(center, true),
            ),
            // Use Wrap widget to handle overflow gracefully for the bottom two rows
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 0,
              runSpacing: buttonSize * 0.25,
              children: <Widget>[
                button(chars[0]),
                button(chars[1]),
                button(chars[2]),
              ],
            ),
            SizedBox(height: buttonSize * 0.25),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 0,
              runSpacing: buttonSize * 0.25,
              children: <Widget>[
                button(chars[3]),
                button(chars[4]),
                button(chars[5]),
              ],
            ),
          ],
        );
      }
    );
  }
}
