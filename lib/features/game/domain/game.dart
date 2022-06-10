import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';

class Game {
  int? id;
  DateTime date;
  Set<Player> players;
  final _rounds = <Round>[];
  String? _leaderName;
  bool finished;

  Game({
    required this.date,
    required this.players,
    this.id,
    this.finished = false,
  });

  void addRound(Round round) {
    _rounds.add(round);
  }

  String? getLeaderName() {
    return _leaderName;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'date': date.toIso8601String(),
      'finished': finished == true ? 1 : 0, // transform bool value to int
    };
    if (id != null) {
      // let database set int value don't include on your own
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
      date: DateTime.parse(map['date']),
      players: map['players'],
      finished: map['finished'] == 1, // transform int value to bool
    );
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Game{id: $id, date: $date, players: $players, finished: $finished}';
  }
}
