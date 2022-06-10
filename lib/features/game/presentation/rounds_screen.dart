import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/game/presentation/rounds_widget.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class RoundsScreen extends StatefulWidget {
  const RoundsScreen({
    Key? key,
    required this.game,
    required this.onChanged,
  }) : super(key: key);

  final Game game;
  final ValueChanged<List<Round>> onChanged;

  @override
  State<RoundsScreen> createState() => _RoundsScreenState();
}

class _RoundsScreenState extends State<RoundsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Runden in diesem Spiel:'),
      ),
      body: RoundsWidget(
        game: widget.game,
        onChanged: widget.onChanged,
      ),
    );
  }
}
