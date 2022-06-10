import 'package:cabo_karte/features/game/data/game_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/game/presentation/game_widget.dart';
import 'package:flutter/material.dart';

class CurrentGameScreen extends StatefulWidget {
  const CurrentGameScreen({Key? key}) : super(key: key);

  @override
  State<CurrentGameScreen> createState() => _CurrentGameScreenState();
}

class _CurrentGameScreenState extends State<CurrentGameScreen> {
  Future<Game> getCurrentGame() async {
    GameProvider provider = await GameProvider().gameProvider;
    return provider.getCurrentGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aktuelles Spiel:'),
        ),
        body: FutureBuilder(
          future: getCurrentGame(),
          builder: (context, AsyncSnapshot<Game> snapshot) {
            if (snapshot.hasData) {
              return GameWidget(currentGame: snapshot.data!);
            } else if (snapshot.hasError) {
              return AlertDialog(
                content: Text(snapshot.error.toString()),
              );
            }
            return const Text(
                'spiel hier anzeigen aber is wohl grad keins da...');
          },
        ));
  }
}
