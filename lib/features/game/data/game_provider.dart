import 'package:cabo_karte/features/app/data/database_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
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

  Future<Game> persistGame(Game game) async {
    game.id = await db.insert(
      tableName,
      game.toMap(),
      // just replace duplicate games
      conflictAlgorithm: ConflictAlgorithm.replace,
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

  Future<void> printCurrentGame() async {
    Game currentGame = await getCurrentGame();

    print('CURRENT GAME: $currentGame');
  }

  Future<Game> getCurrentGame() async {
    final List<Map<String, dynamic>> gameMaps = await db.query(tableName);
    Map<String, dynamic> currentGameMap =
        Map<String, dynamic>.from(gameMaps.last);
    int gameId = currentGameMap['id'];

    final List<Map<String, dynamic>> playerGamesJoinMaps = await db
        .query(playerJoinTableName, where: 'game_id = ?', whereArgs: [gameId]);

    currentGameMap['players'] =
        await playerSetFromJoinMaps(playerGamesJoinMaps);

    return Game.fromMap(currentGameMap);
  }

  /// Iterate over over Games/Players JoinTable entries and generate Set of
  /// Player objects
  static Future<Set<Player>> playerSetFromJoinMaps(
    List<Map<dynamic, dynamic>> playersGamesMaps,
  ) async {
    PlayerProvider playerProvider = await PlayerProvider().playerProvider;
    Set<Player> playerSet = {};

    // iterate over Games/Players JoinTable entries and generate Player objects
    for (Map<dynamic, dynamic> joinTableMap in playersGamesMaps) {
      int playerId = joinTableMap['player_id'];

      // use playerProvider to get Playerobjects from db
      Player player = await playerProvider.getPlayer(playerId);
      // populate playerSet with generated Objects
      playerSet.add(player);
    }

    return playerSet;
  }
}
