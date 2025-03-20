import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

String themeString(ThemeMode t) {
  var s = t.toString().split(".").last;
  return s[0].toUpperCase() + s.substring(1);
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: <Widget>[
          _buildThemeSettings(context),
        ],
      ),
    );
  }

  Widget _buildThemeSettings(BuildContext context) {
    final gameBloc = Provider.of<GameBloc>(context);
    final settings = gameBloc.settings;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Theme Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<int>(
              stream: settings.theme,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return Column(
                  children: [
                    ListTile(
                      title: const Text("Current theme"),
                      subtitle: Text(themeString(ThemeMode.values[snapshot.data!])),
                      trailing: const Icon(Icons.palette),
                      onTap: () {
                        _showThemeDialog(context, settings.theme);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, BehaviorSubject<int> themeSubject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Theme"),
        content: SingleChildScrollView(
          child: StreamBuilder<int>(
            stream: themeSubject,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: ThemeMode.values.map((themeMode) {
                  return RadioListTile<int>(
                    title: Text(themeString(themeMode)),
                    value: themeMode.index,
                    groupValue: snapshot.data,
                    onChanged: (value) {
                      if (value != null) {
                        themeSubject.add(value);
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
