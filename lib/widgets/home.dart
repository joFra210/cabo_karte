import 'package:cabo_karte/config/routes/routes.dart';
import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/config/themes/themes_config.dart';
import 'package:cabo_karte/features/app/data/db_connection_test.dart';
import 'package:cabo_karte/features/game/data/game_provider.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:flutter/material.dart';

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
  Future<Game> get currentGame async {
    GameProvider provider = await GameProvider().gameProvider;
    return provider.getCurrentGame();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: currentGame,
              builder: (context, AsyncSnapshot<Game> snapshot) {
                if (snapshot.hasData) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        Routes.currentGame,
                      );
                    },
                    child: const Text('Spiel fortsetzen'),
                  );
                } else {
                  return const Text('');
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.addPlayer,
                );
              },
              child: const Text('Neue Spieler anlegen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.players,
                );
              },
              child: const Text('Spielerliste anzeigen'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  CaboColors.caboRed,
                ),
                foregroundColor: MaterialStateProperty.all(
                  CaboColors.white,
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: FontParams.fontSizeHeader,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.newGame,
                );
              },
              child: const Text('Neues Spiel!'),
            ),
            ElevatedButton(
              onPressed: () {
                dbConnectionTest();
              },
              child: const Text('print playerdb test'),
            ),
          ],
        ),
      ),
    );
  }
}
