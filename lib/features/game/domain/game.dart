import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';

class Game {
  int? id;
  List<Player> players;
  final _rounds = <Round>[];
  String? _leaderName;

  Game({
    required this.players,
    this.id,
  });

  void addRound(Round round) {
    _rounds.add(round);
  }

  String? getLeaderName() {
    return _leaderName;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  void addPlayer(Player player) {
    if (player.id != null) {
      players.add(player);
    } else {
      throw Exception('Given player "$player" has no id. '
          'Has it not yet been persisted to db?');
    }
  }

  static Game fromMap(Map<dynamic, dynamic> map) {
    return Game(
      id: map['id'],
      players: map['players'],
    );
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Game{id: $id, players: $players}';
  }
}
