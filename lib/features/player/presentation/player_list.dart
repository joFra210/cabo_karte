import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/config/themes/themes_config.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({Key? key}) : super(key: key);

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  PlayerProvider playerProvider = PlayerProvider();

  Future<List<Player>> getplayerList() async {
    await playerProvider.openDb();
    List<Player> list = await playerProvider.getAllPlayers();
    return list;
  }

  @override
  void dispose() async {
    // Clean up the controller when the widget is disposed.
    super.dispose();
    await playerProvider.close();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angelegte Spieler'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bisherige Spieler:',
              style: TextStyle(
                fontSize: FontParams.fontSizeTitle,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: CaboColors.caboRedLight,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 2,
              ),
              child: FutureBuilder<List<Player>>(
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
                            color: Color(0xFFf0acab),
                            semanticLabel: 'Remove',
                          ),
                          onTap: () async {
                            await playerProvider.delete(player.id!);
                            setState(() {});
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
