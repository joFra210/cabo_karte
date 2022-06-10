import 'dart:convert';

class Round {
  int number;
  Map<int, int> playerScores = <int, int>{};

  Round({
    required this.number,
  });

  void addPlayerScore(int playerId, int value) {
    playerScores[playerId] = value;
  }

  MapEntry<int, int>? getLowestScore() {
    MapEntry<int, int> lowestScore;

    if (playerScores.isNotEmpty) {
      lowestScore =
          playerScores.entries.reduce((returnValue, iterationalElement) {
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
      });
      return lowestScore;
    }

    return null;
  }

  @override
  String toString() {
    return 'Round{number: $number, playerScores: $playerScores}';
  }

  static Round fromJson(Map<String, dynamic> json) {
    Round round = Round(
      number: json['number'],
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
        },
      ),
    };
  }
}
