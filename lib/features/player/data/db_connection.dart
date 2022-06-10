import 'package:cabo_karte/features/player/domain/player.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void dbConnection() async {
  // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'player_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE players(id INTEGER PRIMARY KEY, name TEXT, overallScore INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertPlayer(Player player) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'players',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Create a Dog and add it to the dogs table
  var fido = Player(
    id: 0,
    name: 'Fido',
    overallScore: 35,
  );

  await insertPlayer(fido);

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Player>> players() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('players');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(
      maps.length,
      (i) {
        return Player(
          id: maps[i]['id'],
          name: maps[i]['name'],
          overallScore: maps[i]['overallScore'],
        );
      },
    );
  }

  // Now, use the method above to retrieve all the dogs.
  print(await players()); // Prints a list that include Fido.
}
