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

  int? getWinnerId() {
    MapEntry<int, int> lowestScore;

    if (playerScores.isNotEmpty) {
      lowestScore = playerScores.entries.reduce(
        (value, element) => value.value < element.value ? value : element,
      );
      return lowestScore.key;
    }

    return null;
  }

  @override
  String toString() {
    return 'Round{id: $_id, number: $number, playerScores: $playerScores}';
  }
}
