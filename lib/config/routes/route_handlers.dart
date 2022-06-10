import 'package:cabo_karte/features/player/presentation/new_player_widget.dart';
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
