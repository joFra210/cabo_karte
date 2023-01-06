import 'package:cabo_karte/config/routes/routes.dart';
import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/config/themes/themes_config.dart';
import 'package:cabo_karte/features/game/data/game_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/player/presentation/player_list_all.dart';
import 'package:flutter/material.dart';

import '../Utils/date_formatter.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Game> _allGames = [];

  @override
  void initState() {
    super.initState();
    _updateGames();
  }

  Future<void> _updateGames() async {
    GameProvider provider = await GameProvider().gameProvider;
    Future<List<Game>> allGames = provider.getAllGames();
    allGames.then((games) => setState(() {
          _allGames = games;
        }));
  }

  Future<Game> get currentGame async {
    GameProvider provider = await GameProvider().gameProvider;
    return provider.getCurrentGame();
  }

  Future<List<Game>> get games async {
    GameProvider provider = await GameProvider().gameProvider;
    return provider.getAllGames();
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  bottomNavigationBar: const TabBar(
                    padding: EdgeInsets.only(bottom: 10.0),
                    indicatorWeight: 4.0,
                    indicatorColor: CaboColors.caboGreenLight,
                    labelColor: CaboColors.caboGreenLight,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.home)),
                      Tab(icon: Icon(Icons.list)),
                      Tab(icon: Icon(Icons.person)),
                    ],
                  ),
                  body: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Willkommen bei deiner Cabo\u{00A0}Punkte\u{00A0}Karte',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: FontParams.fontSizeHeader,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Was möchtest du tun?',
                              style: TextStyle(
                                fontSize: FontParams.fontSizeTitle,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 50),
                            FutureBuilder<Game>(
                              future: currentGame,
                              builder: (context, AsyncSnapshot<Game> snapshot) {
                                if (snapshot.hasData &&
                                    !snapshot.data!.finished) {
                                  return ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: CaboColors.caboGreen,
                                      foregroundColor: CaboColors.white,
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 20,
                                          right: 20),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: FontParams.fontSizeSubtitle,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await Navigator.of(context).pushNamed(
                                        Routes.gameDetail,
                                        arguments: snapshot.data!,
                                      );
                                      setState(() {
                                        _updateGames();
                                      });
                                    },
                                    icon:
                                        const Icon(Icons.play_arrow, size: 25),
                                    label: const Text('Spiel fortsetzen'),
                                  );
                                } else {
                                  return const SizedBox(height: 0);
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            FloatingActionButton.extended(
                              backgroundColor: CaboColors.caboRed,
                              foregroundColor: CaboColors.white,
                              onPressed: () async {
                                await Navigator.of(context).pushNamed(
                                  Routes.newGame,
                                );
                                setState(() {
                                  _updateGames();
                                });
                              },
                              icon: const Icon(Icons.add, size: 30),
                              label: const Text(
                                'Neues Spiel',
                                style: TextStyle(
                                  fontSize: FontParams.fontSizeSubtitle,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: _allGames.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _allGames.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          'Spiel ' +
                                              _allGames[index].id.toString(),
                                          style: const TextStyle(
                                            fontSize: FontParams.fontSizeTitle,
                                            fontWeight: FontWeight.bold,
                                            height: 3,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Datum: ' +
                                              Dateformatter.getFormattedDate(
                                                  _allGames[index].date),
                                        ),
                                        // game screen on tap
                                        onTap: () async {
                                          await Navigator.of(context).pushNamed(
                                            Routes.gameDetail,
                                            arguments: _allGames[index],
                                          );
                                          setState(() {
                                            _updateGames();
                                          });
                                        },
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Text(
                                      'Noch keine Spiele vorhanden...',
                                      style: TextStyle(
                                        fontSize: FontParams.fontSizeSubtitle,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: PlayerListAll(),
                          ),
                          const SizedBox(height: 40),
                          FloatingActionButton.extended(
                            backgroundColor: CaboColors.caboGreen,
                            foregroundColor: CaboColors.white,
                            onPressed: () async {
                              await Navigator.of(context).pushNamed(
                                Routes.addPlayer,
                              );
                              setState(() {
                                _updateGames();
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Spieler:in anlegen'),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
