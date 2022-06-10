import 'package:cabo_karte/config/application.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PlayerProvider {
  late Database db;
  String tableName = 'players';

  Future<void> openDb() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    db = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), Application.dbName),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE, overallScore INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<Player> insertPlayer(Player player) async {
    player.id = await db.insert(
      tableName,
      player.toMap(),
      // just skip duplicate players
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return player;
  }

  Future<Player> getPlayer(int id) async {
    List<Map> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Player.fromMap(maps.first);
    }
    throw Exception('Player with id: $id not found');
  }

  // A method that retrieves all the dawgs from the players table.
  Future<List<Player>> getAllPlayers() async {
    // Query the table for all the Players.
    final List<Map<String, dynamic>> maps = await db.query('players');

    // Convert the List<Map<String, dynamic> into a List<Player>.
    return List.generate(
      maps.length,
      (i) {
        return Player(
          id: maps[i]['id'],
          name: maps[i]['name'],
          overallScore: maps[i]['overallScore'],
        );
      },
    );
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Player player) async {
    return await db.update(tableName, player.toMap(),
        where: 'id = ?', whereArgs: [player.id]);
  }

  Future<void> close() async => await db.close();
}
