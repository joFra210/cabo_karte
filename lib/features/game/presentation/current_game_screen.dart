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
  Future<Game> get currentGame async {
    GameProvider provider = await GameProvider().gameProvider;
    return provider.getCurrentGame();
  }

  void saveGame(Game game) async {
    GameProvider provider = await GameProvider().gameProvider;
    provider.persistGame(game);
    print('GAME SAVED');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktuelles Spiel:'),
      ),
      body: FutureBuilder(
        future: currentGame,
        builder: (context, AsyncSnapshot<Game> snapshot) {
          if (snapshot.hasData) {
            return GameWidget(
              currentGame: snapshot.data!,
              onGameChanged: saveGame,
            );
          } else if (snapshot.hasError) {
            return AlertDialog(
              content: Text(snapshot.error.toString()),
            );
          }
          return const Text(
            'spiel hier anzeigen aber is wohl grad keins da...',
          );
        },
      ),
    );
  }
}
