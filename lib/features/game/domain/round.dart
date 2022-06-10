import 'package:cabo_karte/features/score/domain/score.dart';

class Round {
  int? _id;
  int number;
  Map<String, Score>? playerScores;

  Round({
    required this.number,
    this.playerScores,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'Round{id: $_id, number: $number, playerScores: $playerScores}';
  }
}
