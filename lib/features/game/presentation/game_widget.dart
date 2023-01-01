import 'package:cabo_karte/config/routes/routes.dart';
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

  String getFormattedDate(DateTime date) {
    return date.day.toString() +
        '. ' +
        date.month.toString() +
        '. ' +
        date.year.toString();
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

  /// Navigates to a screen where the user can create a new [Round] object for the
  /// current [Game].
  ///
  /// The [context] argument is used to build the appropriate [MaterialPageRoute] for
  /// the [Round] creation screen.
  ///
  /// If the user creates a new [Round] object, it is added to the
  /// [widget.currentGame.rounds] list and [widget.onGameChanged] is called with the
  /// updated [widget.currentGame] object.
  Future<void> _navigateAndGetCreatedRound(BuildContext context) async {
    final Round? createdRound = await Navigator.pushNamed(
      context,
      Routes.newRound,
      arguments: [
        widget.currentGame.players,
        widget.currentGame.rounds.length + 1,
      ],
    ) as Round?;

    if (createdRound != null) {
      setState(() {
        widget.currentGame.rounds.add(createdRound);
        widget.onGameChanged(widget.currentGame);
      });
    }
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
                              getFormattedDate(
                                widget.currentGame.date.toLocal(),
                              ),
                        ),
                      ],
                    ),
                  ),
                  PlayerListGameWidget(
                    game: widget.currentGame,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isFinished()) {
                          _navigateAndGetCreatedRound(context);
                        }
                      },
                      child: Text(!isFinished()
                          ? 'Neue Runde anlegen'
                          : 'SPIEL IST AUS'),
                    ),
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
