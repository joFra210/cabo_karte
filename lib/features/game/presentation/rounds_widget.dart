import 'package:cabo_karte/config/routes/routes.dart';
import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class RoundsWidget extends StatefulWidget {
  const RoundsWidget({
    Key? key,
    required this.game,
    required this.onChanged,
  }) : super(key: key);

  final Game game;
  final ValueChanged<List<Round>> onChanged;

  @override
  State<RoundsWidget> createState() => _RoundsWidgetState();
}

class _RoundsWidgetState extends State<RoundsWidget> {
  List<Round> get _rounds {
    return widget.game.rounds;
  }

  Player getPlayerById(int id) {
    for (Player player in widget.game.players) {
      if (player.id == id) {
        return player;
      }
    }
    throw Exception('No player with given id in game!');
  }

  int getRoundNumber() {
    if (widget.game.getNextRoundNumber() > _rounds.length) {
      return widget.game.getNextRoundNumber();
    }
    return _rounds.length + 1;
  }

  bool isFinished() {
    return widget.game.finished;
  }

  List<Widget> generateRoundList() {
    List<ListTile> roundList = <ListTile>[];

    for (Round round in _rounds) {
      MapEntry<int, int>? winnerScore = round.winnerScore;

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

  List<DataRow> generateRoundDataRowList() {
    List<DataRow> roundList = <DataRow>[];

    for (Round round in _rounds) {
      List<DataCell> cellList = [
        DataCell(
          Text(
            round.number.toString(),
          ),
        ),
      ];

      for (Player player in widget.game.players) {
        int score = round.playerScores[player.id]!;
        bool isKamikazeScore = score == 50;

        cellList.add(
          DataCell(
            Text(
              isKamikazeScore ? 'KAMIKAZE' : score.toString(),
            ),
          ),
        );
      }

      roundList.add(
        DataRow(
          cells: cellList,
        ),
      );
    }

    return roundList;
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop.
  Future<void> _navigateAndGetCreatedRound(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.of(context).pushNamed(
      Routes.newRound,
      arguments: [
        widget.game.players,
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
        widget.game.addRound(result);
      });
      widget.onChanged(_rounds);
    }
  }

  List<DataColumn> get tableCols {
    List<DataColumn> cols = [
      const DataColumn(label: Text('#')),
    ];

    for (Player player in widget.game.players) {
      cols.add(
        DataColumn(
          label: Text(player.name),
        ),
      );
    }

    return cols;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        restorationId: 'some_table',
        padding: const EdgeInsets.all(16),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: tableCols,
              rows: generateRoundDataRowList(),
            ),
          ),
          const Text('add rounds here'),
          ElevatedButton(
            onPressed: () {
              if (!isFinished()) {
                _navigateAndGetCreatedRound(context);
              }
            },
            child: Text(!isFinished() ? 'Runde anlegen' : 'SPIEL IST AUS'),
          ),
        ],
      ),
    );
  }
}
