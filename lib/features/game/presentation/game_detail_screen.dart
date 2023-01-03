import 'package:cabo_karte/features/game/data/game_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/game/presentation/game_widget.dart';
import 'package:flutter/material.dart';

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({Key? key, required this.game}) : super(key: key);

  final Game game;

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
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
        title: Text('Spiel: ' + widget.game.id.toString()),
      ),
      body: GameWidget(
        currentGame: widget.game,
        onGameChanged: saveGame,
      ),
    );
  }
}
