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
  final Game? _newGame = null;

  void _handlePlayersChanged(Set<Player> players) {
    setState(() {
      _currentPlayers = players;
    });
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
            onPressed: () {
              print(
                  'spiel sollte jetzt angelegt werden, is aber noch nicht weil die implementierung fehlt...');
            },
            child: const Text('Spiel anlegen'),
          ),
        ],
      ),
    );
  }
}
