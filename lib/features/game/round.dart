import 'package:cabo_karte/features/score/score.dart';

class Round {
  int number;
  Map<String, Score>? playerScores;

  Round({
    required this.number,
    this.playerScores,
  });
}
