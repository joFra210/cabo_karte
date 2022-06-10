import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/game/presentation/rounds_widget.dart';
import 'package:cabo_karte/features/player/presentation/player_list.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({
    Key? key,
    required this.currentGame,
  }) : super(key: key);

  final Game currentGame;

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  String getFormattedDate(DateTime date) {
    return date.day.toString() +
        '. ' +
        date.month.toString() +
        '. ' +
        date.year.toString();
  }

  bool isFinished() {
    return widget.currentGame.finished;
  }

  void _handleRoundsChanged(List<Round> rounds) {
    widget.currentGame.rounds = rounds;
    print('finished: ' + widget.currentGame.finished.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game ' + widget.currentGame.id.toString(),
          ),
          Text(
            'Date: ' + getFormattedDate(widget.currentGame.date.toLocal()),
          ),
          const Text('Spieler:'),
          PlayerListWidget(
            listOnly: true,
            activePlayers: widget.currentGame.players,
            onChanged: (player) {},
          ),
          RoundsWidget(
            players: widget.currentGame.players,
            roundNumber: widget.currentGame.getNextRoundNumber(),
            finished: isFinished(),
            onChanged: _handleRoundsChanged,
          ),
        ],
      ),
    );
  }
}
