import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String games = "/games";
  static String gameDetail = "/games/detail";
  static String newRound = "/games/current/rounds/new-round";
  static String currentRounds = "/games/current/rounds";
  static String newGame = "/games/new-game";
  static String rounds = "/games/:game-id/rounds";
  static String players = "/players";
  static String addPlayer = "/players/add-player";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        throw ErrorDescription("ROUTE WAS NOT FOUND !!!");
      },
    );
    router.define(root, handler: homeHandler);
    router.define(addPlayer, handler: addPlayerHandler);
    router.define(players, handler: playerHandler);
    router.define(newGame, handler: newGameHandler);
    router.define(gameDetail, handler: gameDetailHandler);
    router.define(newRound, handler: newRoundHandler);
    router.define(currentRounds, handler: currentRoundsHandler);
  }
}
