import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/config/themes/themes_config.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class PlayerListAll extends StatefulWidget {
  const PlayerListAll({Key? key}) : super(key: key);

  @override
  State<PlayerListAll> createState() => _PlayerListAllState();
}

class _PlayerListAllState extends State<PlayerListAll> {
  Future<List<Player>> getplayerList() async {
    PlayerProvider playerProvider = await PlayerProvider().playerProvider;

    List<Player> list = await playerProvider.getAllPlayers();
    return list;
  }

  Future<void> _handlePlayerTap(int id) async {
    PlayerProvider playerProvider = await PlayerProvider().playerProvider;

    await playerProvider.delete(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 20),
          child: Text(
            'Bisherige Spieler',
            style: TextStyle(
              fontSize: FontParams.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FutureBuilder<List<Player>>(
          future: getplayerList(),
          builder: (context, snap) {
            if (snap.hasData) {
              final tiles = snap.data!.map(
                (player) {
                  return ListTile(
                    title: Text(
                      player.name,
                    ),
                    trailing: const Icon(
                      Icons.delete,
                      color: CaboColors.caboRedLight,
                      semanticLabel: 'Remove',
                    ),
                    onTap: () async {
                      final bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Spielernamen löschen?'),
                            content: const Text(
                                'Soll der Spieler wirklich gelöscht werden? Dies kann nicht rückgängig gemacht werden.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Abbrechen'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Löschen'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirm == true) {
                        await _handlePlayerTap(player.id!);
                      }
                    },
                  );
                },
              );
              if (tiles.isNotEmpty) {
                final divided = tiles.isNotEmpty
                    ? ListTile.divideTiles(
                        context: context,
                        tiles: tiles,
                      ).toList()
                    : <Widget>[];

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: divided.length,
                    itemBuilder: (context, index) {
                      return divided[index];
                    },
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 25, bottom: 25),
                        child: Text('Noch keine Spieler angelegt!'),
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
        ),
      ],
    );
  }
}
