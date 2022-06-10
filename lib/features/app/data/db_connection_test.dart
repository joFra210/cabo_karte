import 'package:cabo_karte/features/app/data/database_provider.dart';
import 'package:cabo_karte/features/player/data/player_provider.dart';
import 'package:cabo_karte/features/player/domain/player.dart';

void dbConnectionTest() async {
  DatabaseProvider().printTables();
}
