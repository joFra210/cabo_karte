import 'package:cabo_karte/config/application.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String tableNamePlayers = 'players';
  static const String tableNameGames = 'games';
  static const String tableNameRounds = 'rounds';
  static const String tableNameScores = 'scores';
  static const String tableNameGamesPlayers =
      tableNameGames + '_' + tableNamePlayers;
  static const String tableNameGamesRounds =
      tableNameGames + '_' + tableNameRounds;
  static const String tableNameRoundsScores =
      tableNameRounds + '_' + tableNameScores;
  static const String tableNameScoresPlayers =
      tableNameScores + '_' + tableNamePlayers;

  // Single reference to the db
  static late Database _db;

  // Make this a singleton class
  DatabaseProvider._privateConstructor();

  static final DatabaseProvider _instance =
      DatabaseProvider._privateConstructor();

  factory DatabaseProvider() => _instance;

  Future<Database> get database async {
    _db = await _instance.getDatabase();
    return _db;
  }

  Future<Database> getDatabase() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    Database db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), Application.dbName),
      onConfigure: (db) {
        return db.execute(
          'PRAGMA foreign_keys = ON;',
        );
      },
      // When the database is first created, create a table to store stuff.
      onCreate: (db, version) {
        // Run the CREATE TABLE statements on the database.
        db.execute(
          'CREATE TABLE $tableNamePlayers('
          'id INTEGER PRIMARY KEY, '
          'name TEXT KEY UNIQUE, '
          'overallScore INTEGER);',
        );
        db.execute(
          'CREATE TABLE $tableNameGames('
          'id INTEGER PRIMARY KEY, '
          'leaderName TEXT, '
          'date TEXT, '
          'rounds TEXT, '
          'finished INTEGER);',
        );
        db.execute(
          'CREATE TABLE $tableNameGamesPlayers('
          'player_id INTEGER, game_id INTEGER, '
          'FOREIGN KEY(player_id) REFERENCES $tableNamePlayers(id) ON DELETE CASCADE, '
          'FOREIGN KEY(game_id) REFERENCES $tableNameGames(id) ON DELETE CASCADE);',
        );
        db.execute(
          'CREATE INDEX player_index ON $tableNameGamesPlayers(player_id);',
        );
        db.execute(
          'CREATE INDEX game_index ON $tableNameGamesPlayers(game_id);',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return db;
  }

  void printTables() async {
    Database db = await database;

    print(await db.rawQuery('PRAGMA foreign_keys'));
    print(await db.rawQuery('PRAGMA table_list'));
  }
}
