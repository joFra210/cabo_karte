import 'package:cabo_karte/features/game/presentation/new_game_form.dart';
import 'package:flutter/material.dart';

class CurrentGameScreen extends StatefulWidget {
  const CurrentGameScreen({Key? key}) : super(key: key);

  @override
  State<CurrentGameScreen> createState() => _CurrentGameScreenState();
}

class _CurrentGameScreenState extends State<CurrentGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktuelles Spiel:'),
      ),
      body: const Center(
        child: const Text('hier spiel einfügen'),
      ),
    );
  }
}
