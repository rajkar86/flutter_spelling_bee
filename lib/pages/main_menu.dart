import 'package:flutter/material.dart';
import 'dart:core';

import 'package:spelling_bee/blocs/game_bloc.dart';
import 'package:spelling_bee/helpers/consts.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/widgets/points_row.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  Widget _buildGamePreview(BuildContext context) {
    final gameBloc = Provider.of<GameBloc>(context);
    return StreamBuilder<String>(
        stream: gameBloc.game,
        builder: (context, snapshot) {
          return snapshot.hasData 
              ? const GamePreview() 
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildRandomGameButton(BuildContext context) {
    final gameBloc = Provider.of<GameBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          gameBloc.loadGameSink.add(false);
        },
        child: const Text("Reset and load new board"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameBloc = Provider.of<GameBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(gameTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help),
            tooltip: 'Rules',
            onPressed: () {
              Navigator.pushNamed(context, '/rules');
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          _buildGamePreview(context),
          StreamBuilder<bool>(
            stream: gameBloc.isGameSaved,
            builder: (context, snapshot) {
              final hasSavedGame = snapshot.data ?? false;
              return Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (hasSavedGame) {
                        gameBloc.loadGameSink.add(true);
                      }
                      Navigator.pushNamed(context, '/game');
                    },
                    child: Text(hasSavedGame ? "Resume game" : "Start new game"),
                  ),
                  if (hasSavedGame) _buildRandomGameButton(context),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class GamePreview extends StatelessWidget {
  const GamePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              "Current Game",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildPointsRow(context),
            const SizedBox(height: 10),
            buildProgressRow(context),
          ],
        ),
      ),
    );
  }
}

Widget buildProgressRow(BuildContext context) {
  final gameBloc = Provider.of<GameBloc>(context);
  return StreamBuilder<int>(
    stream: gameBloc.wordCount,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return Container();
      final wordsFound = snapshot.data ?? 0;
      final totalWords = gameBloc.maxWords;
      final percentComplete = wordsFound / totalWords * 100;
      
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Words found: $wordsFound / $totalWords"),
              Text("${percentComplete.toStringAsFixed(1)}%"),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: wordsFound / totalWords,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ],
      );
    },
  );
}
