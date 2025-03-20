import 'package:flutter/material.dart';

import 'dart:math';

import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

class CurrentWord extends StatelessWidget {
  const CurrentWord({
    Key? key,
    // @required this.word,
    // @required this.onBackspace,
    // @required Animation<double> animation,
    // }) : super(key: key, listenable: animation);
  }) : super(key: key);

  // final String word;
  // final VoidCallback onBackspace;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: Provider.of<GameBloc>(context).word,
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        return _build(context, snapshot.data ?? "");
      },
    );
  }

  Widget _build(BuildContext context, String word) {
    // var animation = listenable;
    // double d = animation.value;

    void onPressed() {
      Provider.of<GameBloc>(context, listen: false).eventSink.add(Event.delete);
    }

    double sz = min(24, 36.0 - word.length);
      
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: sz*2),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Text(
              word,
              style: TextStyle(fontSize: sz, letterSpacing: 0),
              //42 - 10 * (d-0.5).abs()
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.backspace, size: sz), 
          onPressed: onPressed
        )
      ],
    );
  }
}

