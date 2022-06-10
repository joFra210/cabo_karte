import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/player/presentation/player_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GameWidget extends StatelessWidget {
  const GameWidget({
    Key? key,
    required this.currentGame,
  }) : super(key: key);

  final Game currentGame;

  String getFormattedDate(DateTime date) {
    return date.day.toString() +
        '. ' +
        date.month.toString() +
        '. ' +
        date.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game ' + currentGame.id.toString(),
          ),
          Text(
            'Date: ' + getFormattedDate(currentGame.date.toLocal()),
          ),
          const Text('Spieler:'),
          PlayerListWidget(
            listOnly: true,
            activePlayers: currentGame.players,
            onChanged: (player) {},
          ),
        ],
      ),
    );
  }
}
