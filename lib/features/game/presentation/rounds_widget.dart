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

  List<Widget> getPlayerEntriesAsListTiles(
      {required Set<Player> playerSet, required Round round}) {
    Player _caboPlayer = getPlayerById(round.caboCallerId!);
    final Iterable<ListTile> tiles = playerSet.map(
      (player) {
        return ListTile(
          trailing: Text(player.name),
          title: Text(
            round.playerScores[player.id]!.toString(),
          ),
          leading: Radio<Player>(
            value: player,
            groupValue: _caboPlayer,
            onChanged: (Player? value) {
              //do nothing
            },
          ),
        );
      },
    );
    if (tiles.isNotEmpty) {
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();
      return divided;
    }
    return [];
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
        bool isWinnerScore = player.id == round.winnerId;
        bool isLastPlayer = player.id == widget.game.players.last.id;

        cellList.add(
          DataCell(
            Text(
              isKamikazeScore ? 'KAMIKAZE' : score.toString(),
              style: TextStyle(
                color: isWinnerScore ? CaboColors.caboGreenLight : null,
                fontWeight: isWinnerScore ? FontWeight.bold : null,
              ),
            ),
            // preparation for edit round feature
            showEditIcon: !isFinished() && isLastPlayer && false,
            onTap: () async {
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  // return alert dialog with round data
                  return AlertDialog(
                    title: const Text('Runde'),
                    content: Column(
                      // insert round data for every player here
                      children: [
                        const ListTile(
                          leading: Text('Cabo'),
                          title: Text('Punkte'),
                          trailing: Text('Name'),
                        ),
                        ...getPlayerEntriesAsListTiles(
                          playerSet: widget.game.players,
                          round: round,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Zurück'),
                      ),
                      // TextButton(
                      //   onPressed: () => Navigator.of(context).pop(true),
                      //   child: const Text('Editieren'),
                      // ),
                    ],
                  );
                },
              );
              // prepare for edit round feature
              if (confirm == true) {
                // edit round
                // print('edit round');
              }
            },
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
    return Column(children: [
      Expanded(
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
          ],
        ),
      ),
      const SizedBox(
        height: 120,
      ),
    ]);
  }
}
