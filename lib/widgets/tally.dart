import 'package:flutter/material.dart';

class Tally extends ImplicitlyAnimatedWidget {
  final int points;
  final int max;
  final String text;
  // static const Duration(seconds: 1);

  Tally(
      {Key key,
      @required this.points,
      @required this.max,
      @required this.text,
      Duration duration = const Duration(milliseconds: 450),
      Curve curve = Curves.linear})
      : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<Tally> {
  IntTween _points;

  @override
  Widget build(BuildContext context) {
    var points = _points.evaluate(animation);
    var width = 3;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(points.toString().padLeft(width, " ") + " " + widget.text,
              // widget.max.toString(),
              style: TextStyle(color: Colors.black, fontSize: 21)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("0",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ),
            Container(
              width: 50,
              height: 10,
              decoration: BoxDecoration(border: Border.all(width: 2.0)),
              child: LinearProgressIndicator(
                backgroundColor: Colors.yellow,
                value: points / widget.max,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(widget.max.toString() + "",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            )
          ],
        ),
      ],
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _points = visitor(
        _points, widget.points, (dynamic value) => new IntTween(begin: value));
  }
}
