import 'package:cabo_karte/features/game/presentation/current_game_screen.dart';
import 'package:cabo_karte/features/game/presentation/new_game_screen.dart';
import 'package:cabo_karte/features/game/presentation/new_round_screen.dart';
import 'package:cabo_karte/features/player/presentation/new_player_screen.dart';
import 'package:cabo_karte/features/player/presentation/player_list_screen.dart';
import 'package:cabo_karte/widgets/home.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var homeHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const Home(title: 'Cabotastisch');
  },
);

var addPlayerHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const NewPlayerScreen();
  },
);

var playerHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const PlayerListScreen();
  },
);

var newGameHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const NewGameScreen();
  },
);

var currentGameHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const CurrentGameScreen();
  },
);

var newRoundHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const NewRoundScreen();
  },
);
