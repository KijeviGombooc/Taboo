import 'package:flutter/material.dart';
import 'package:taboo/models/Game.dart';
import 'package:taboo/models/Formatter.dart';
import 'package:taboo/models/DBHelper.dart';

import 'TeamsScreen.dart';

class LoadGameScreen extends StatefulWidget {
  const LoadGameScreen();

  @override
  _LoadGameScreenState createState() => _LoadGameScreenState();
}

class _LoadGameScreenState extends State<LoadGameScreen> {
  List<Game>? games;

  @override
  void initState() {
    super.initState();

    _loadDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Game"),
        centerTitle: true,
      ),
      body: games == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: games?.length,
              itemBuilder: (ctx, i) {
                return Dismissible(
                  onDismissed: (_) => _onDismissed(i, games![i].id),
                  key: UniqueKey(),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => _loadGame(context, games![i].id),
                        child: Text(Formatter.date(
                            games![i].date, "yyyy MMM dd - hh:mm:ss")),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  _loadDatas() {
    DBHelper.getGames().then((value) {
      setState(() {
        games = value;
      });
    });
  }

  _onDismissed(int listIndex, int gameID) {
    setState(() {
      games?.removeAt(listIndex);
      DBHelper.deleteGame(gameID);
    });
  }

  _loadGame(BuildContext ctx, int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return TeamsScreen(gameID: id);
        },
      ),
    );
  }
}
