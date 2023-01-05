import 'package:cabo_karte/features/app/data/database_provider.dart';

void dbConnectionTest() async {
  DatabaseProvider().getDatabase();
}
