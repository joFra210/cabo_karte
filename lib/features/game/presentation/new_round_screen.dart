import 'package:cabo_karte/features/game/presentation/new_game_form.dart';
import 'package:cabo_karte/features/game/presentation/new_round_form.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class NewRoundScreen extends StatefulWidget {
  const NewRoundScreen(
      {Key? key, required this.players, required this.roundNumber})
      : super(key: key);
  final Set<Player> players;
  final int roundNumber;

  @override
  State<NewRoundScreen> createState() => _NewRoundScreenState();
}

class _NewRoundScreenState extends State<NewRoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Runde eingeben:'),
      ),
      body: Center(
        child: RoundForm(
          players: widget.players,
          roundNumber: widget.roundNumber,
        ),
      ),
    );
  }
}
