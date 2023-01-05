import 'package:cabo_karte/Utils/date_formatter.dart';
import 'package:cabo_karte/config/themes/themes_config.dart';
import 'package:cabo_karte/features/game/domain/game.dart';
import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/game/presentation/rounds_screen.dart';
import 'package:cabo_karte/features/player/presentation/player_list_game.dart';
import 'package:flutter/material.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({
    Key? key,
    required this.currentGame,
    required this.onGameChanged,
  }) : super(key: key);

  final Game currentGame;
  final ValueChanged<Game> onGameChanged;

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isFinished() {
    return widget.currentGame.finished;
  }

  void _handleRoundsChanged(List<Round> rounds) {
    setState(() {
      widget.currentGame.rounds = rounds;
      widget.onGameChanged(widget.currentGame);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Übersicht'),
            Tab(text: 'Runden'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spiel ' + widget.currentGame.id.toString(),
                          style: const TextStyle(
                            fontSize: FontParams.fontSizeTitle,
                            fontWeight: FontWeight.bold,
                            height: 3,
                          ),
                        ),
                        Text(
                          'Datum: ' +
                              Dateformatter.getFormattedDate(
                                widget.currentGame.date.toLocal(),
                              ),
                        ),
                      ],
                    ),
                  ),
                  PlayerListGameWidget(
                    game: widget.currentGame,
                  ),
                ],
              ),
              RoundsScreen(
                game: widget.currentGame,
                onChanged: _handleRoundsChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
