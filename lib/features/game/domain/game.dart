import 'dart:convert';

import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';

class Game {
  int? id;
  DateTime date;
  Set<Player> players;
  List<Round> _rounds = <Round>[];
  String? _leaderName;
  bool _finished = false;

  Game({
    required this.date,
    required this.players,
    this.id,
  });

  set rounds(List<Round> newRounds) {
    _rounds = newRounds;
  }

  List<Round> get rounds {
    return _rounds;
  }

  void addRound(Round round) {
    rounds.add(round);
  }

  Round getRoundByNumber(int number) {
    for (Round round in rounds) {
      if (round.number == number) {
        return round;
      }
    }
    throw Exception('no matching round for number: $number');
  }

  void replaceRound(Round round) {
    Round existingRound = getRoundByNumber(round.number);
    rounds.remove(existingRound);
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
    for (Round round in rounds) {
      bool isKamikaze = false;
      if (round.playerScores.containsValue(50)) {
        isKamikaze = true;
      }
      for (Player player in players) {
        if (isKamikaze) {
          if (round.playerScores[player.id!] == 50) {
            print('player with id: ' +
                player.id.toString() +
                ' hat kamikaze in runde: ' +
                round.number.toString());
          } else {
            // create entry with score for player if not exists and add points,
            // else add points to existing entry, add 50 cause Kamikaze
            playerScores = addToPlayerScore(playerScores, player.id!, 50);
          }
        } else if (player.id == round.winnerId) {
          print('player with id: ' +
              player.id.toString() +
              ' hat gewonnen in runde: ' +
              round.number.toString());
        } else {
          // add points to existing entry if it exists,
          // else create entry with score for player
          playerScores = addToPlayerScore(
            playerScores,
            player.id!,
            round.playerScores[player.id!]!,
          );
        }
        // if player said cabo, but hasn't got the lowest score,
        // add 5 penalty points
        if (player.id == round.caboCallerId &&
            !round.hasIdLowestScore(player.id!)) {
          print('player ' +
              player.id.toString() +
              ' said cabo incorrectly in runde ' +
              round.number.toString() +
              ', 5 strafpunkte');
          playerScores = addToPlayerScore(playerScores, player.id!, 5);
        }

        // if player hits 100 points exactly, reduce score to 50
        if (playerScores[player.id!] == 100) {
          playerScores[player.id!] = 50;
        }
      }
    }
    return playerScores;
  }

  /// add points to existing entry if it exists,
  /// else create entry with score for player
  /// return map when done
  Map<int, int> addToPlayerScore(
    Map<int, int> playerScores,
    int playerId,
    int scoreToAdd,
  ) {
    if (playerScores.containsKey(playerId)) {
      playerScores[playerId] = playerScores[playerId]! + scoreToAdd;
    } else {
      playerScores[playerId] = scoreToAdd;
    }

    return playerScores;
  }

  int getScoreForPlayer(int id) {
    return playerScores[id] ?? 0;
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
      players: map['players'] ?? <Player>{}, // use empty set if null
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
