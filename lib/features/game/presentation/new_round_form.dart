import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/features/game/domain/round.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

class RoundForm extends StatefulWidget {
  const RoundForm({Key? key, required this.players, required this.roundNumber})
      : super(key: key);

  final Set<Player> players;
  final int roundNumber;

  @override
  State<RoundForm> createState() => _RoundFormState();
}

class _RoundFormState extends State<RoundForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final Round _round = Round(number: 0);
  Player? _caboPlayer;

  @override
  void initState() {
    initRoundNumber();
    super.initState();
  }

  void initRoundNumber() {
    _round.number = widget.roundNumber;
  }

  bool isValidCaboScore(int intVal) {
    return intVal <= 50 && intVal >= 0;
  }

  /// Returns a list of [ListTile] widgets representing the [Player] objects in
  /// a given [playerSet].
  ///
  /// Each [ListTile] widget contains a [Radio] button for selecting the [Player]
  /// object as the cabo caller, and a [TextFormField] for entering the player's score.
  /// The [TextFormField] has a validator that ensures the entered score is a number
  /// between 0 and 50, and an `onChanged` callback that updates the score for the
  /// corresponding [Player] in the [_round] object.
  List<Widget> getPlayerEntriesAsListTiles(Set<Player> playerSet) {
    final Iterable<ListTile> tiles = playerSet.map(
      (player) {
        return ListTile(
          trailing: Text(player.name),
          title: TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              try {
                int intVal = int.parse(value!);
                return isValidCaboScore(intVal)
                    ? null
                    : 'Bitte nutze Zahlen zwischen 0 und 50';
              } on Exception {
                return 'Bitte nur Zahlen eingeben';
              }
            },
            onChanged: (value) {
              try {
                int intVal = int.parse(value);
                if (isValidCaboScore(intVal)) {
                  _round.addPlayerScore(player.id!, intVal);
                }
              } on FormatException {
                // ignore
              }
            },
          ),
          leading: Radio<Player>(
            value: player,
            groupValue: _caboPlayer,
            onChanged: (Player? value) {
              setState(() {
                _caboPlayer = value;
                _round.caboCallerId = _caboPlayer!.id;
              });
            },
          ),
        );
      },
    );
    if (tiles.isNotEmpty) {
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();
      return divided;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            color: CaboColors.caboGreen,
            child: const ListTile(
              leading: Text('Cabo'),
              title: Text('Punkte'),
              trailing: Text('Name'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: getPlayerEntriesAsListTiles(widget.players).length,
              itemBuilder: (context, index) {
                return getPlayerEntriesAsListTiles(widget.players)[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FloatingActionButton.extended(
              backgroundColor: CaboColors.caboGreen,
              foregroundColor: CaboColors.white,
              onPressed: () {
                // check if a cabo caller was selected
                if (_caboPlayer == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: CaboColors.caboRedLight,
                      content: Text('Bitte wähle aus, wer Cabo gesagt hat 🤔'),
                    ),
                  );
                  return;
                }

                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a Snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ok cool 😎')),
                  );
                  // close the dialog and return the round object
                  Navigator.of(context).pop(_round);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: CaboColors.caboRedLight,
                        content: Text('mmmh, da passt was nicht 🤔')),
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Runde eintragen'),
            ),
          ),
        ],
      ),
    );
  }
}
