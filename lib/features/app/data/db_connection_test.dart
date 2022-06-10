import 'package:cabo_karte/features/app/data/database_provider.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';

void dbConnection() async {
  // Create a Dog and add it to the dogs table
  var fido = Player(
    id: null,
    name: 'Fido',
    overallScore: 35,
  );

  // create new provider instance
  var playerProvider = PlayerProvider();
  // establish and open db connection
  await playerProvider.openDb();
  // insert fide
  fido = await playerProvider.insertPlayer(fido);

  // Now, use the provider above to retrieve all the dawgs.
  print(
      await playerProvider.getAllPlayers()); // Prints a list that include Fido.

  // Update Fido's Score and save it to the database.
  fido = Player(
    id: fido.id,
    name: fido.name,
    overallScore: fido.overallScore! + 7,
  );
  await playerProvider.update(fido);

  // Print the updated results.
  print(await playerProvider.getAllPlayers()); // Prints Fido with Score 42.

  await playerProvider.delete(fido.id!);

  print(await playerProvider.getAllPlayers()); // Should print an empty list
  DatabaseProvider().printTables();
}
