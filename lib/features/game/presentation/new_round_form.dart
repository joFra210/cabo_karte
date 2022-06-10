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

  List<Widget> getPlayerEntries() {
    final Iterable<ListTile> tiles = widget.players.map(
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
                print('do not use letters here');
              }
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
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: getPlayerEntries().length,
              itemBuilder: (context, index) {
                return getPlayerEntries()[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.

                  print(_round);
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ok cool 😎')),
                  );
                  Navigator.of(context).pop(_round);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: CaboColors.caboRedLight,
                        content: Text('mmmh, da passt was nicht 🤔')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
