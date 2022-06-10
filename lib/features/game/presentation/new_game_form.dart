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
  Game? _newGame = null;
  final _gameProvider = GameProvider();

  void _handlePlayersChanged(Set<Player> players) {
    setState(() {
      _currentPlayers = players;
    });
  }

  void _persistGame() async {
    _newGame = Game(
      date: DateTime.now(),
      players: _currentPlayers,
    );
    _newGame = await _gameProvider.persistGame(_newGame!);
  }

  @override
  Widget build(BuildContext context) {
    final tiles = _currentPlayers.map(
      (Player player) {
        return ListTile(
          title: Text(player.name),
        );
      },
    );
    final divided = tiles.isNotEmpty
        ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
        : <Widget>[];

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
          ElevatedButton(
            onPressed: () async {
              _persistGame();

              print('spiel sollte jetzt in db liegen: $_newGame');

              await _gameProvider.printGames();
            },
            child: const Text('Spiel anlegen'),
          ),
        ],
      ),
    );
  }
}
