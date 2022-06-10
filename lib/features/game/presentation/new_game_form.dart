import 'package:cabo_karte/config/routes/routes.dart';
import 'package:cabo_karte/features/game/data/game_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:cabo_karte/features/player/presentation/player_list.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports

class NewGameForm extends StatefulWidget {
  const NewGameForm({Key? key}) : super(key: key);

  @override
  State<NewGameForm> createState() => _NewGameFormState();
}

class _NewGameFormState extends State<NewGameForm> {
  final _formKey = GlobalKey<FormState>();
  Set<Player> _currentPlayers = <Player>{};
  Game? _newGame;
  bool enoughPlayers = false;

  void _handlePlayersChanged(Set<Player> players) {
    setState(() {
      _currentPlayers = players;
      enoughPlayers = _currentPlayers.length >= 2;
    });
  }

  Future<void> _persistGame() async {
    GameProvider gameProvider = await GameProvider().gameProvider;
    _newGame = Game(
      date: DateTime.now(),
      players: _currentPlayers,
    );
    _newGame = await gameProvider.persistGame(_newGame!);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 3 * 2,
            ),
            child: PlayerListWidget(
              activePlayers: _currentPlayers,
              onChanged: _handlePlayersChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: enoughPlayers
                ? ElevatedButton(
                    onPressed: () async {
                      GameProvider gameProvider =
                          await GameProvider().gameProvider;
                      await _persistGame();

                      print('spiel sollte jetzt in db liegen: $_newGame');

                      await gameProvider.printCurrentGame();
                      Navigator.of(context).pushNamed(
                        Routes.currentGame,
                      );
                    },
                    child: const Text('Spiel anlegen'),
                  )
                : const Text('Nicht genug Spieler zum Spiel hinzugefügt.'),
          ),
        ],
      ),
    );
  }
}
