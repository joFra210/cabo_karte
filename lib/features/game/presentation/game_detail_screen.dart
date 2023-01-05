import 'package:cabo_karte/config/routes/routes.dart';
import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/features/game/data/game_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/game/presentation/game_widget.dart';
import 'package:flutter/material.dart';

class GameDetailScreen extends StatefulWidget {
  const GameDetailScreen({
    Key? key,
    required this.game,
  }) : super(key: key);

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
  }

  bool isFinished() {
    return widget.game.finished;
  }

  /// Navigates to a screen where the user can create a new [Round] object for the
  /// current [Game].
  ///
  /// The [context] argument is used to build the appropriate [MaterialPageRoute] for
  /// the [Round] creation screen.
  ///
  /// If the user creates a new [Round] object, it is added to the
  /// [widget.game.rounds] list and [widget.onGameChanged] is called with the
  /// updated [widget.game] object.
  Future<void> _navigateAndGetCreatedRound(BuildContext context) async {
    final Round? createdRound = await Navigator.pushNamed(
      context,
      Routes.newRound,
      arguments: [
        widget.game.players,
        widget.game.rounds.length + 1,
      ],
    ) as Round?;

    if (createdRound != null) {
      setState(() {
        widget.game.rounds.add(createdRound);
        saveGame(widget.game);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spiel: ' + widget.game.id.toString()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CaboColors.caboGreen,
        foregroundColor: CaboColors.white,
        icon: const Icon(Icons.add),
        label: Text(!isFinished() ? 'Neue Runde anlegen' : 'SPIEL IST AUS'),
        onPressed: () {
          if (!isFinished()) {
            _navigateAndGetCreatedRound(context);
          }
        },
      ),
      body: GameWidget(
        currentGame: widget.game,
        onGameChanged: saveGame,
      ),
    );
  }
}
