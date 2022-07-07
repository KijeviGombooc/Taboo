import 'package:flutter/material.dart';
import 'package:akon/models/db_helper.dart';
import 'package:akon/models/settings.dart';
import 'package:akon/screens/load_game_screen.dart';
import 'package:akon/screens/settings_screen.dart';
import 'package:akon/screens/teams_screen.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Akon"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: ElevatedButton(
                onPressed: () => _startnewGamePressed(context),
                child: Text("New Game"),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () => _onLoadGamePressed(context),
                child: Text("Load Game"),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () => _onSettingsPressed(context),
                child: Text("Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onLoadGamePressed(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return LoadGameScreen();
        },
      ),
    );
  }

  _startnewGamePressed(ctx) {
    DBHelper.newGame(Settings.teamCount).then(
      (gameID) {
        Navigator.of(ctx).push(
          MaterialPageRoute(
            builder: (ctx) {
              return TeamsScreen(gameID: gameID);
            },
          ),
        );
      },
    );
  }

  _onSettingsPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return SettingsScreen();
        },
      ),
    );
  }
}
