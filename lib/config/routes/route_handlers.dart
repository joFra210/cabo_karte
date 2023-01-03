import 'package:cabo_karte/features/game/presentation/current_game_screen.dart';
import 'package:cabo_karte/features/game/presentation/game_detail_screen.dart';
import 'package:cabo_karte/features/game/presentation/new_game_screen.dart';
import 'package:cabo_karte/features/game/presentation/new_round_screen.dart';
import 'package:cabo_karte/features/game/presentation/rounds_screen.dart';
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

/// Extract the arguments using [BuildContext.settings.arguments] or [BuildContext.arguments] for short
var newRoundHandler = Handler(
  handlerFunc: (context, params) {
    final args = context!.arguments as List<dynamic>;

    return NewRoundScreen(
      players: args[0],
      roundNumber: args[1],
    );
  },
);

/// Extract the arguments using [BuildContext.settings.arguments] or [BuildContext.arguments] for short
var currentRoundsHandler = Handler(
  handlerFunc: (context, params) {
    final args = context!.arguments as List<dynamic>;

    return RoundsScreen(
      game: args[0],
      onChanged: args[1],
    );
  },
);

/// Extract the arguments using [BuildContext.settings.arguments] or [BuildContext.arguments] for short
var gameDetailHandler = Handler(
  handlerFunc: (context, params) {
    final args = context!.arguments as List<dynamic>;

    return GameDetailScreen(
      game: args[0],
    );
  },
);
