import 'dart:convert';

import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';

class Game {
  int? id;
  DateTime date;
  Set<Player> players;
  List<Round> _rounds = <Round>[];
  Map<int, int> _playerScores = <int, int>{};
  String? _leaderName;
  bool _finished = false;

  Game({
    required this.date,
    required this.players,
    this.id,
  });

  set rounds(List<Round> newRounds) {
    _rounds = newRounds;
    _playerScores = playerScores;
  }

  List<Round> get rounds {
    return _rounds;
  }

  void addRound(Round round) {
    rounds.add(round);
  }

  int getNextRoundNumber() {
    return rounds.length + 1;
  }

  String? getLeaderName() {
    return _leaderName;
  }

  get playerScores {
    Map<int, int> playerScores = <int, int>{};
    for (Player player in players) {
      for (Round round in rounds) {
        // if scores already contains key add to it, else put round score in it
        if (playerScores.containsKey(player.id!)) {
          playerScores[player.id!] =
              playerScores[player.id!]! + round.playerScores[player.id!]!;
        } else {
          playerScores[player.id!] = round.playerScores[player.id!]!;
        }
      }
    }
    return playerScores;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'date': date.toIso8601String(),
      'finished': finished == true ? 1 : 0, // transform bool value to int
      'rounds': jsonEncode(
        rounds,
        toEncodable: (Object? round) => round is Round
            ? Round.toJson(round)
            : throw Exception('object is no round!?'),
      ),
    };
    if (id != null) {
      // let database set int value don't include on your own
      map['id'] = id;
    }
    return map;
  }

  bool get finished {
    for (MapEntry<int, int> scoreEntry in playerScores.entries) {
      if (scoreEntry.value > 100) {
        int playerId = scoreEntry.key;
        int loserScore = scoreEntry.value;
        int roundLength = rounds.length;

        Player loser = players.firstWhere((element) => element.id == playerId);
        String playerName = loser.name;

        _finished = true;
        print(
            'player: $playerName has $loserScore points after $roundLength rounds!');
        return _finished;
      }
    }
    print('PlayerScores: $playerScores');
    return _finished;
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
    Game game = Game(
      id: map['id'],
      date: DateTime.parse(map['date']),
      players: map['players'], // transform int value to bool
    );
    if (map['rounds'] != null) {
      List<dynamic> roundsListDynamic = jsonDecode(
        map['rounds'],
      );
      List<Round> roundsList = roundsListDynamic
          .map((e) => Round.fromJson(e as Map<String, dynamic>))
          .toList();

      print('Game from Map Roundslist: ' + roundsList.toString());

      game.rounds = roundsList;
    }

    return game;
  }

  // Implement toString to make it easier to see information about
  // each player when using the print statement.
  @override
  String toString() {
    return 'Game{id: $id, date: $date, players: $players, finished: $finished, rounds:$rounds}';
  }
}
