import 'package:cabo_karte/features/app/data/database_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:sqflite/sqlite_api.dart';

class GameProvider {
  late Database db;
  String tableName = DatabaseProvider.tableNameGames;
  String playerJoinTableName = DatabaseProvider.tableNameGamesPlayers;

  GameProvider() {
    openDb();
  }

  Future<void> openDb() async {
    // Open the database and store the reference.
    db = await DatabaseProvider().database;
  }

  Future<Game> addGame(Game game) async {
    game.id = await db.insert(
      tableName,
      game.toMap(),
      // just skip duplicate players
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    for (Player player in game.players) {
      await db.insert(
        playerJoinTableName,
        {
          'player_id': player.id,
          'game_id': game.id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return game;
  }
}
