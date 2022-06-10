import 'package:cabo_karte/features/game/round.dart';
import 'package:cabo_karte/features/player/player.dart';

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
