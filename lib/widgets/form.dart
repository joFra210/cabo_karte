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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(35),
            child: Text('Last Input: ' + formInput),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                formInput.toString();
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
