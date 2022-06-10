import 'package:cabo_karte/config/routes/routes.dart';
import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class RoundsWidget extends StatefulWidget {
  const RoundsWidget({
    Key? key,
    required this.players,
    required this.roundNumber,
    required this.onChanged,
    required this.finished,
  }) : super(key: key);

  final Set<Player> players;
  final int roundNumber;
  final bool finished;
  final ValueChanged<List<Round>> onChanged;

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

  int getRoundNumber() {
    if (widget.roundNumber > _rounds.length) {
      return widget.roundNumber;
    }
    return _rounds.length + 1;
  }

  bool isFinished() {
    print('Rounds WIdget finished:' + widget.finished.toString());
    return widget.finished;
  }

  List<Widget> generateRoundList() {
    List<ListTile> roundList = <ListTile>[];

    for (Round round in _rounds) {
      MapEntry<int, int>? winnerScore = round.getLowestScore();

      bool isKamikazeScore = winnerScore?.value == 50;

      roundList.add(
        ListTile(
          leading: Text(
            round.number.toString(),
          ),
          title: Text(
            winnerScore?.key.toString() ?? 'Null',
          ),
          trailing: Text(
            isKamikazeScore
                ? 'KAMIKAZE'
                : winnerScore?.value.toString() ?? 'Null',
          ),
        ),
      );
    }

    final divided = ListTile.divideTiles(
      context: context,
      tiles: roundList,
    ).toList();

    return divided;
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop.
  Future<void> _navigateAndGetCreatedRound(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.of(context).pushNamed(
      Routes.newRound,
      arguments: [
        widget.players,
        getRoundNumber(),
      ],
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Round came back as: $result')));

    if (result is Round) {
      setState(() {
        _rounds.add(result);
      });
      widget.onChanged(_rounds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
      child: Column(
        children: [
          Container(
            color: CaboColors.caboGreenDark,
            child: const ListTile(
              leading: Text('#'),
              title: Text('Gewinner'),
              trailing: Text('Punkte'),
            ),
          ),
          Expanded(
            child: ListView(
              children: generateRoundList(),
            ),
          ),
          const Text('add rounds here'),
          ElevatedButton(
            onPressed: () {
              if (!isFinished()) {
                _navigateAndGetCreatedRound(context);
              }
            },
            child: Text(!isFinished() ? 'Runde anlegen' : 'RUNDE IST AUS'),
          ),
        ],
      ),
    );
  }
}
