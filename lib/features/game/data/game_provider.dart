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

  Future<bool> gameAvailable() async {
    try {
      final List<Map<String, dynamic>> gameMaps = await _db.query(tableName);

      if (gameMaps.isNotEmpty) {
        Map<String, dynamic> currentGameMap =
            Map<String, dynamic>.from(gameMaps.last);
        if (currentGameMap.isNotEmpty) {
          return true;
        }
      }
      return false;
    } catch (exception) {
      return false;
    }
  }

  /// Retrieves the current [Game] object from the database.
  ///
  /// The current [Game] is defined as the last [Game] object stored in the database.
  /// The [Game] object is populated with its associated [Player] objects using data
  /// from the `player_join` table.
  ///
  /// Returns the current [Game] object if it exists, or throws an [Exception] if no
  /// [Game] object is available.
  Future<Game> getCurrentGame() async {
    final List<Map<String, dynamic>> gameMaps = await _db.query(tableName);

    if (gameMaps.isNotEmpty) {
      Map<String, dynamic> currentGameMap =
          Map<String, dynamic>.from(gameMaps.last);
      if (currentGameMap.isNotEmpty) {
        Game currentGame = Game.fromMap(currentGameMap);

        // get players for current game
        List<Map<dynamic, dynamic>> playersGamesMaps = await _db.query(
          playerJoinTableName,
          where: 'game_id = ?',
          whereArgs: [currentGame.id],
        );

        // generate Set of Player objects
        Set<Player> playerSet = await playerSetFromJoinMaps(playersGamesMaps);

        // add players to currentGame
        currentGame.players = playerSet;

        return currentGame;
      }
    }

    throw Exception('No Game available');
  }

  /// Retrieves all [Game] objects from the database.
  /// The [Game] objects are populated with their associated [Player] objects using data
  /// from the `player_join` table.
  ///
  /// Returns a [List] of [Game] objects.
  ///
  /// If no [Game] objects are available, an empty [List] is returned.
  /// If an error occurs, an [Exception] is thrown.
  Future<List<Game>> getAllGames() async {
    final List<Map<String, dynamic>> gameMaps = await _db.query(tableName);

    if (gameMaps.isNotEmpty) {
      List<Game> games = [];

      for (Map<String, dynamic> gameMap in gameMaps) {
        Game game = Game.fromMap(gameMap);

        // get players for current game
        List<Map<dynamic, dynamic>> playersGamesMaps = await _db.query(
          playerJoinTableName,
          where: 'game_id = ?',
          whereArgs: [game.id],
        );

        // generate Set of Player objects
        Set<Player> playerSet = await playerSetFromJoinMaps(playersGamesMaps);

        // add players to currentGame
        game.players = playerSet;

        games.add(game);
      }

      // sort games from newest date to oldest date
      games.sort((a, b) => b.date.compareTo(a.date));

      return games;
    }

    throw Exception('No Game available');
  }

  /// Iterate over Games/Players JoinTable entries and generate Set of
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
