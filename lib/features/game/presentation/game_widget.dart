import 'package:cabo_karte/config/routes/routes.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/presentation/player_list.dart';
import 'package:cabo_karte/features/player/presentation/player_list_game.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({
    Key? key,
    required this.currentGame,
    required this.onGameChanged,
  }) : super(key: key);

  final Game currentGame;
  final ValueChanged<Game> onGameChanged;

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
    setState(() {
      widget.currentGame.rounds = rounds;
      widget.onGameChanged(widget.currentGame);
    });
    print('finished: ' + widget.currentGame.finished.toString());
  }

  void _handleRoundsButton() {
    Navigator.of(context).pushNamed(
      Routes.currentRounds,
      arguments: [
        widget.currentGame,
        _handleRoundsChanged,
      ],
    );
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
          PlayerListGameWidget(
            game: widget.currentGame,
          ),
          ElevatedButton(
            onPressed: _handleRoundsButton,
            child: const Text('Rounds'),
          ),
        ],
      ),
    );
  }
}
