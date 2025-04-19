import 'package:np_db/np_db.dart';

class CompatV75 {
  static Future<void> migrateDb(NpDb db) {
    return db.migrateV75();
  }
}
