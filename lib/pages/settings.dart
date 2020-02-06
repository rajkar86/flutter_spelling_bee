import 'package:flutter/material.dart';
import 'package:spelling_bee/helpers/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  Widget _setting(context) {
    var game = Provider.of(context).game;
    return Card(
        child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
                child: Text(
              "Use large dictionary",
              style: TextStyle(fontSize: 20),
            )),
            StreamBuilder(
              stream: game.useEnableDict,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? Switch(
                        value: snapshot.data,
                        onChanged: (bool b) {
                          game.useEnableDictSink.add(b);
                        })
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text("If enabled, the dictionary used in popular games like Words With Friends will be used. " +
                  "Using this dictionary, which is larger than the default option, will result in the game accepting more words as valid, " +
                  "but will also require you to find a lot more words. "),
              Text(
                  "Note that changes take place when you start a new game or on full restart of the app."),
            ],
          ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _build(<Widget>[_setting(context)]);
  }

  Widget _build(List<Widget> w) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Expanded(child: ListView(children: w))]));
  }
}
