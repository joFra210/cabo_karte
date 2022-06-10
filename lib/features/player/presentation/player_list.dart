import 'package:cabo_karte/config/routes/routes.dart';
import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class PlayerListWidget extends StatefulWidget {
  const PlayerListWidget({
    Key? key,
    this.deleteButton = false,
    required this.activePlayers,
    required this.onChanged,
    this.listOnly = false,
  }) : super(key: key);

  final Set<Player> activePlayers;
  final ValueChanged<Set<Player>> onChanged;
  final bool listOnly;
  final bool deleteButton;

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

  void _handlePlayerDelete(Player player) {
    setState(() {
      _playersList.remove(player);
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
              if (widget.listOnly) {
                return ListTile(
                  title: Text(
                    player.name,
                  ),
                );
              }
              if (widget.deleteButton) {
                return ListTile(
                  title: Text(
                    player.name,
                  ),
                  trailing: const Icon(
                    Icons.delete,
                    color: CaboColors.caboRedLight,
                    semanticLabel: 'Spieler löschen',
                  ),
                  onTap: () {
                    _handlePlayerDelete(player);
                  },
                );
              }
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
          if (tiles.isNotEmpty) {
            final divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: divided.length,
              itemBuilder: (context, index) {
                return divided[index];
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Noch keine Spieler angelegt:'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        Routes.addPlayer,
                      );
                    },
                    child: const Text('Neue Spieler anlegen'),
                  ),
                ],
              ),
            );
          }
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
