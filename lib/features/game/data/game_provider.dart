import 'package:cabo_karte/features/app/data/database_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:sqflite/sqlite_api.dart';

class GameProvider {
  late Database _db;
  String tableName = DatabaseProvider.tableNameGames;
  String playerJoinTableName = DatabaseProvider.tableNameGamesPlayers;

  // Make this a singleton class
  GameProvider._privateConstructor();

  static final GameProvider _instance = GameProvider._privateConstructor();

  factory GameProvider() => _instance;

  Future<GameProvider> get gameProvider async {
    GameProvider provider = await _instance.openDb();

    return provider;
  }

  Future<GameProvider> openDb() async {
    // Open the database and store the reference.
    _db = await DatabaseProvider().database;

    return this;
  }

  Future<Game> persistGame(Game game) async {
    game.id = await _db.insert(
      tableName,
      game.toMap(),
      // just replace duplicate games
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (Player player in game.players) {
      await _db.insert(
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
    final List<Map<String, dynamic>> gameMaps = await _db.query(tableName);
    Map<String, dynamic> currentGameMap =
        Map<String, dynamic>.from(gameMaps.last);
    if (currentGameMap.isNotEmpty) {
      int gameId = currentGameMap['id'];

      final List<Map<String, dynamic>> playerGamesJoinMaps = await _db.query(
          playerJoinTableName,
          where: 'game_id = ?',
          whereArgs: [gameId]);

      currentGameMap['players'] =
          await playerSetFromJoinMaps(playerGamesJoinMaps);

      return Game.fromMap(currentGameMap);
    }

    throw Exception('No current game available...');
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
