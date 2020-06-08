import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spelling_bee/helpers/provider.dart';

String themeString(ThemeMode t) {
  var s = t.toString().split(".").last;
  return s[0].toUpperCase() + s.substring(1);
}

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  Widget _settings(context) {
    var settings = Provider.of(context).game.settings;

    return Column(
      children: [
        _setting(
            "Theme",
            themeString(ThemeMode.values[settings.theme.stream.value]),
            Container(), () {
          showDialog(
              context: context,
              builder: (context) => _optionsDialog(context, settings.theme));
        }),
        _setting(
            "Use large dictionary",
            "If enabled, the dictionary used in popular games like Words With Friends will be used. " +
                "Using this dictionary, which is larger than the default option, will result in the game accepting more words as valid, " +
                "but will also require you to find a lot more words." +
                "Note that changes take place when you start a new game or on full restart of the app.",
            switchControl(settings.useEnableDict), () {
          settings.useEnableDict.sink.add(!settings.useEnableDict.stream.value);
        })
      ],
    );
  }

  Card _setting(
      String title, String subtitle, Widget control, Function() onTap) {
    var inkWell = InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18),
                  ),
                )),
                control,
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(subtitle, style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        onTap: onTap);
    return Card(child: inkWell);
  }

  StreamBuilder<bool> switchControl(BehaviorSubject<bool> sub) {
    return StreamBuilder(
      stream: sub.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Switch(
                value: snapshot.data,
                onChanged: (bool b) {
                  sub.sink.add(b);
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  // TODO make this generic,
  // Maybe a collection Widgets that respond to to BehaviorSubject-s
  Widget _optionsDialog(BuildContext context, BehaviorSubject<int> choice) {
    return SimpleDialog(title: Text("Theme"), children: [
      StreamBuilder(
          stream: choice.stream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ThemeMode.values
                        .map((v) => RadioListTile(
                            title: Text(themeString(v)),
                            groupValue: choice.stream.value,
                            value: v.index,
                            onChanged: (val) {
                              choice.sink.add(v.index);
                              Navigator.pop(context);
                            }))
                        .toList(),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          })
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return _build(<Widget>[_settings(context)]);
  }

  Widget _build(List<Widget> w) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Expanded(child: ListView(children: w))]));
  }
}
