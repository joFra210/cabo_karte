import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class PlayerListWidget extends StatefulWidget {
  const PlayerListWidget({
    Key? key,
    bool? deleteButton,
    required this.activePlayers,
    required this.onChanged,
  }) : super(key: key);

  final Set<Player> activePlayers;
  final ValueChanged<Set<Player>> onChanged;

  @override
  State<PlayerListWidget> createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  final Set<Player> _playersList = <Player>{};
  final PlayerProvider _playerProvider = PlayerProvider();

  Future<List<Player>> getAllPlayers() async {
    await _playerProvider.openDb();
    List<Player> list = await _playerProvider.getAllPlayers();
    return list;
  }

  void _handleListTileTap(Player player) {
    setState(() {
      bool alreadyInGame = _playersList.contains(player);
      if (alreadyInGame) {
        _playersList.remove(player);
      } else {
        _playersList.add(player);
      }
    });

    widget.onChanged(_playersList);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Player>>(
      future: getAllPlayers(),
      builder: (context, snap) {
        if (snap.hasData) {
          final tiles = snap.data!.map(
            (player) {
              bool alreadyInGame = _playersList.contains(player);
              return ListTile(
                title: Text(
                  player.name,
                ),
                trailing: Icon(
                  alreadyInGame ? Icons.remove : Icons.add,
                  color: alreadyInGame
                      ? CaboColors.caboRedLight
                      : CaboColors.caboGreenLight,
                  semanticLabel: 'Zu Spiel hinzufügen',
                ),
                onTap: () {
                  _handleListTileTap(player);
                },
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return ListView.builder(
            shrinkWrap: true,
            itemCount: divided.length,
            itemBuilder: (context, index) {
              return divided[index];
            },
          );
        } else if (snap.hasError) {
          return AlertDialog(
            content: Text(snap.error.toString()),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
