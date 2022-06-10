import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class RoundsWidget extends StatefulWidget {
  const RoundsWidget({
    Key? key,
    required this.players,
  }) : super(key: key);

  final Set<Player> players;

  @override
  State<RoundsWidget> createState() => _RoundsWidgetState();
}

class _RoundsWidgetState extends State<RoundsWidget> {
  final _rounds = <Round>[];

  Player getPlayerById(int id) {
    for (Player player in widget.players) {
      if (player.id == id) {
        return player;
      }
    }
    throw Exception('No player with given id in game!');
  }

  List<Widget> generateRoundList() {
    List<ListTile> roundList = <ListTile>[];

    for (Round round in _rounds) {
      int? winnerId = round.getWinnerId();

      roundList.add(
        ListTile(
          leading: Text(
            round.number.toString(),
          ),
          title: Text(winnerId.toString()),
        ),
      );
    }

    final divided = ListTile.divideTiles(
      context: context,
      tiles: roundList,
    ).toList();

    return divided;
  }

  void addRound() {
    int roundNum = 1;
    if (_rounds.isNotEmpty) {
      roundNum = _rounds.last.number + 1;
    }

    Round round = Round(number: roundNum);

    setState(() {
      _rounds.add(round);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 3),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: ListView(
              children: generateRoundList(),
            ),
          ),
          const Text('add rounds here'),
          ElevatedButton(
            onPressed: () {
              addRound();
            },
            child: const Text('Runde anlegen'),
          ),
        ],
      ),
    );
  }
}
