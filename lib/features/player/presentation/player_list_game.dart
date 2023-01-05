import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class PlayerListGameWidget extends StatefulWidget {
  const PlayerListGameWidget({
    Key? key,
    required this.game,
  }) : super(key: key);

  final Game game;

  @override
  State<PlayerListGameWidget> createState() => _PlayerListGameWidgetState();
}

class _PlayerListGameWidgetState extends State<PlayerListGameWidget> {
  final PlayerProvider _playerProvider = PlayerProvider();

  Future<List<Player>> getAllPlayers() async {
    await _playerProvider.openDb();
    List<Player> list = await _playerProvider.getAllPlayers();
    return list;
  }

  Set<Player> get playersList {
    return widget.game.players;
  }

  // TBD: maybe show players rounds on tap
  void _handleListTileTap(Player player) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: CaboColors.caboGreen,
          child: const ListTile(
            title: Text('Spieler'),
            trailing: Text('Punkte'),
          ),
        ),
        Builder(
          builder: (context) {
            final tiles = playersList.map(
              (player) {
                return ListTile(
                  title: Text(
                    player.name,
                  ),
                  trailing: Text(
                    widget.game.getScoreForPlayer(player.id!).toString(),
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
                  children: const [
                    Text('Keine Spieler mehr für dieses Spiel vorhanden 😕'),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
