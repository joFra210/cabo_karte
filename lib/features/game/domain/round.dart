import 'package:cabo_karte/features/player/domain/player.dart';

class Round {
  int? _id;
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
    return 'Round{id: $_id, number: $number, playerScores: $playerScores}';
  }
}
