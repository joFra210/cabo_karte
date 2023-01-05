import 'package:cabo_karte/config/themes/cabo_colors.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/material.dart';

// Define a custom Form widget.
class PlayerForm extends StatefulWidget {
  const PlayerForm({Key? key}) : super(key: key);

  @override
  PlayerFormState createState() {
    return PlayerFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class PlayerFormState extends State<PlayerForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String formInput = '';
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final playerFormController = TextEditingController();

  Future<Player> insertNewPlayer(Player newPlayer) async {
    PlayerProvider playerProvider = await PlayerProvider().playerProvider;
    Player player = await playerProvider.insertPlayer(newPlayer);
    // Clear the text field
    playerFormController.clear();
    return player;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    playerFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte gib einen Namen ein';
                }
                return null;
              },
              controller: playerFormController,
            ),
            const SizedBox(height: 20),
            FloatingActionButton.extended(
              foregroundColor: CaboColors.white,
              backgroundColor: CaboColors.caboGreen,
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Spieler:in wird angelegt... 😇')),
                  );
                  Player newPlayer = Player(name: playerFormController.text);
                  Future<Player> futurePlayer = insertNewPlayer(newPlayer);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return FutureBuilder<Player>(
                        future: futurePlayer,
                        builder: (context, snap) {
                          String text = '';
                          if (snap.hasData) {
                            text = 'Neue Spieler:in "' +
                                snap.data!.name +
                                '" wurde angelegt.';
                            return AlertDialog(
                              // Retrieve the Player that has been created and
                              // inserted into the database.
                              content: Text(text),
                            );
                          } else if (snap.hasError) {
                            text = snap.error.toString();
                            return AlertDialog(
                              // Display error
                              content: Text(text),
                            );
                          }
                          // By default, show a loading spinner.
                          return const AlertDialog(
                            content: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text(
                'Anlegen',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
