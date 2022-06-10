import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String games = "/games";
  static String currentGame = "/games/current";
  static String newGame = "/games/new-game";
  static String rounds = "/games/:game-id/rounds";
  static String players = "/players";
  static String addPlayer = "/players/add-player";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        // print('ROUTE WAS NOT FOUND !!!');
        // return;
        throw ErrorDescription("ROUTE WAS NOT FOUND !!!");
      },
    );
    router.define(root, handler: homeHandler);
    router.define(addPlayer, handler: addPlayerHandler);
    router.define(players, handler: playerHandler);
    router.define(newGame, handler: newGameHandler);
    router.define(currentGame, handler: currentGameHandler);
  }
}
