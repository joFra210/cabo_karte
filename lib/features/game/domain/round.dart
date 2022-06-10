import 'dart:convert';

class Round {
  int number;
  Map<int, int> playerScores = <int, int>{};
  int? caboCallerId;

  Round({
    required this.number,
    this.caboCallerId,
  });

  void addPlayerScore(int playerId, int value) {
    playerScores[playerId] = value;
  }

  int get winnerId {
    return winnerScore!.key;
  }

  bool get isKamikaze {
    return playerScores.containsValue(50);
  }

  /// get lowest score or return Kamikaze score if it happened
  MapEntry<int, int>? get winnerScore {
    MapEntry<int, int> lowestScore;

    if (playerScores.isNotEmpty) {
      lowestScore = playerScores.entries.reduce(
        (returnValue, iterationalElement) {
          // if player has cabo return this value
          if (iterationalElement.value == 50) {
            return iterationalElement;
          }
          // if previous player had cabo always return that value
          if (returnValue.value == 50) {
            return returnValue;
          }
          // else return the smallest value
          return returnValue.value < iterationalElement.value
              ? returnValue
              : iterationalElement;
        },
      );

      return lowestScore;
    }

    return null;
  }

  @override
  String toString() {
    return 'Round{number: $number, playerScores: $playerScores, caboCallerId: $caboCallerId}';
  }

  static Round fromJson(Map<String, dynamic> json) {
    Round round = Round(
      number: json['number'],
      caboCallerId: json['caboCallerId'],
    );
    // maybe change dynamic to int here
    Map<String, dynamic> playerScoresDynamic = jsonDecode(
      json['playerScores'],
    );
    Map<int, int> playerScoresMapped = playerScoresDynamic.map(
      (key, value) => MapEntry(int.parse(key), value),
    );

    round.playerScores = playerScoresMapped;

    return round;
  }

  static Map<String, dynamic> toJson(Round round) {
    return {
      'number': round.number,
      'caboCallerId': round.caboCallerId,
      'playerScores': jsonEncode(
        round.playerScores,
        toEncodable: (nonEncodable) {
          if (nonEncodable is Map<int, int>) {
            return nonEncodable.map(
              (key, value) {
                return MapEntry(key.toString(), value);
              },
            );
          }
          return null;
        },
      ),
    };
  }
}
