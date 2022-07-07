import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:akon/models/formatter.dart';
import 'package:akon/models/word.dart';

import 'game.dart';
import 'team.dart';

class DBHelper {
  static late Database _db;
  static const dbName = "akon.db";

  static Future<void> init() async {
    if (kIsWeb) return;
    var path = join(await getDatabasesPath(), dbName);

    // Check if the database exists
    bool exists = await databaseExists(path);
    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
  }

  static Future<void> openDB() async {
    if (kIsWeb) return;
    _db = await openDatabase(join(await getDatabasesPath(), dbName),
        readOnly: false);
  }

  static Future<int> getWordCount() async {
    if (kIsWeb) return 1;
    List<Map> map = await _db.rawQuery("SELECT COUNT(*) AS n FROM words;");
    return map[0].entries.first.value;
  }

  static Future<List<Team>> getTeamsData(int gameID) async {
    List<Map> resultMaps = await _db.query(
      "teams",
      columns: ["team_id", "score", "name"],
      where: "game_id = ?",
      whereArgs: [gameID],
      orderBy: "team_id",
    );

    return List<Team>.generate(resultMaps.length, (i) {
      return Team(
        id: resultMaps[i]["team_id"] as int,
        score: resultMaps[i]["score"] as int,
        name: resultMaps[i]["name"],
      );
    });
  }

  static Future<void> setTeamName(int gameID, int teamID, String name) async {
    await _db.update(
      "teams",
      {"name": name},
      where: "game_id = ? AND team_id = ?",
      whereArgs: [gameID, teamID],
    );
  }

  static Future<void> updateScore(int gameID, int teamID, int score) async {
    List<Map> resultMaps = await _db.query(
      "teams",
      columns: ["score"],
      where: "game_id = ? AND team_id = ?",
      whereArgs: [gameID, teamID],
    );
    int oldScore = resultMaps[0]["score"];
    await _db.update(
      "teams",
      {"score": score + oldScore},
      where: "game_id = ? AND team_id = ?",
      whereArgs: [gameID, teamID],
    );
  }

  static Future<int> newGame(int teamCount) async {
    String gameDateTime = Formatter.date(DateTime.now(), "yyyyMMddhhmmsseee");
    int gameID = await _db.insert("games", {
      "game_datetime": gameDateTime,
    });
    for (var i = 0; i < teamCount; i++) {
      await _db.insert("teams", {
        "game_id": gameID,
        "team_id": i,
        "score": 0,
      });
    }
    return gameID;
  }

  static Future<void> setNextTeam(int gameID) async {
    await _db.rawUpdate("""
      UPDATE games
      SET current_team = (
                  SELECT MAX(team_id) FROM
                  (
                    SELECT team_id FROM teams
                    WHERE teams.game_id = games.game_id
                    AND
                    (
                      team_id > current_team	
                      OR
                      team_id = (SELECT min(team_id) FROM teams WHERE teams.game_id = games.game_id)
                    )
                    ORDER BY team_id LIMIT 2
                  )
                )
      WHERE game_id = '$gameID'
      ;
    """);
  }

  static Future<int> getCurrentTeam(int gameID) async {
    List<Map> resultMaps = await _db.rawQuery("""
      SELECT current_team FROM games WHERE game_id = '$gameID';
    """);
    if (resultMaps[0]["current_team"] == null) {
      setNextTeam(gameID);
    }
    resultMaps = await _db.rawQuery("""
      SELECT current_team FROM games WHERE game_id = '$gameID';
    """);
    return resultMaps[0]["current_team"] as int;
  }

  static Future<List<Game>> getGames() async {
    final List<Map> resultMaps = await _db.query(
      "games",
      columns: [
        "game_id",
        "game_datetime",
      ],
      orderBy: "game_datetime DESC",
    );

    return List<Game>.generate(resultMaps.length, (i) {
      return Game(
        id: resultMaps[i]["game_id"],
        date: Formatter.parseDate(resultMaps[i]["game_datetime"]),
      );
    });
  }

  static Future<void> deleteGame(int gameID) async {
    await _db.delete(
      "games",
      where: "game_id = ?",
      whereArgs: [gameID],
    );
  }

  static Future<Word> getWord(int id) async {
    if (kIsWeb)
      return Word(word: "DUMMY_WORD", taboos: [
        "DUMMY_TABOO1",
        "DUMMY_TABOO2",
        "DUMMY_TABOO3",
        "DUMMY_TABOO4",
        "DUMMY_TABOO5",
      ]);
    List<Map> wordMaps = await _db.query(
      "words",
      columns: ["word"],
      where: "word_id = ?",
      whereArgs: [id],
    );

    List<Map> taboosMaps = await _db.query(
      "taboos",
      columns: ["taboo"],
      where: "word_id = ?",
      whereArgs: [id],
    );
    List<String> taboos = List.generate(taboosMaps.length, (i) {
      return taboosMaps[i]["taboo"];
    });
    taboos.shuffle();
    Word word = Word(
      word: wordMaps[0]["word"],
      taboos: taboos,
    );
    return word;
  }
}
