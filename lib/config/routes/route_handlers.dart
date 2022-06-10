import 'package:cabo_karte/features/player/presentation/new_player_widget.dart';
import 'package:cabo_karte/widgets/form.dart';
import 'package:cabo_karte/widgets/root.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var rootHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const Root(title: 'Cabotastisch');
  },
);

var addPlayerHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const NewPlayerScreen();
  },
);
