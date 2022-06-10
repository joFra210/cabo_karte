import 'package:cabo_karte/features/app/data/database_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:sqflite/sqflite.dart';

class PlayerProvider {
  late Database _db;
  String tableName = 'players';

  // Make this a singleton class
  PlayerProvider._privateConstructor();

  static final PlayerProvider _instance = PlayerProvider._privateConstructor();

  factory PlayerProvider() => _instance;

  Future<PlayerProvider> get playerProvider async {
    PlayerProvider provider = await _instance.openDb();

    return provider;
  }

  Future<PlayerProvider> openDb() async {
    // Open the database and store the reference.
    _db = await DatabaseProvider().database;

    return this;
  }

  Future<Player> insertPlayer(Player player) async {
    player.id = await _db.insert(
      tableName,
      player.toMap(),
      // just skip duplicate players
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return player;
  }

  Future<Player> getPlayer(int id) async {
    List<Map> maps = await _db.query(
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
    final List<Map<String, dynamic>> maps = await _db.query('players');

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
    return await _db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Player player) async {
    return await _db.update(tableName, player.toMap(),
        where: 'id = ?', whereArgs: [player.id]);
  }

  Future<void> close() async => await _db.close();
}
