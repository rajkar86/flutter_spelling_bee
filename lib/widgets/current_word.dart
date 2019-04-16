import 'package:flutter/material.dart';

import 'dart:math';

class CurrentWord extends StatelessWidget {
  const CurrentWord({
    Key key,
    @required this.word,
    @required this.onBackspace,
    // @required Animation<double> animation,
    // }) : super(key: key, listenable: animation);
  }) : super(key: key);

  final String word;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    // var animation = listenable;
    // double d = animation.value;

    double sz = min(24, 36.0 - this.word.length);
      
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: sz*2),
        Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                this.word,
                style: TextStyle(fontSize: sz, letterSpacing: 0),
                //42 - 10 * (d-0.5).abs()
              ),
            ),
          ),
        ),
        IconButton(icon: Icon(Icons.backspace, size: sz,), onPressed: this.onBackspace)
      ],
    );
  }
}

