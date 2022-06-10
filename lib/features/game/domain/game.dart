import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';

class Game {
  List<Player> players;
  final _rounds = <Round>[];
  String? _leaderName;

  Game({
    required this.players,
  });

  void addRound(Round round) {
    _rounds.add(round);
  }

  String? getLeaderName() {
    return _leaderName;
  }
}
