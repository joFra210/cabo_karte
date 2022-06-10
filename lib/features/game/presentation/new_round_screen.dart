import 'package:cabo_karte/features/game/presentation/new_game_form.dart';
import 'package:cabo_karte/features/game/presentation/new_round_form.dart';
import 'package:flutter/material.dart';

class NewRoundScreen extends StatefulWidget {
  const NewRoundScreen({Key? key}) : super(key: key);

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
      body: const Center(
        child: RoundForm(),
      ),
    );
  }
}
