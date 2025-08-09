import 'package:drift/drift.dart' as sql;
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/face_recognition_person.dart';
import 'package:nc_photos/entity/face_recognition_person/data_source.dart';
import 'package:nc_photos/entity/face_recognition_person/repo.dart';
import 'package:nc_photos/use_case/face_recognition_person/sync_face_recognition_person.dart';
import 'package:np_db/np_db.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:test/test.dart';

import '../../mock_type.dart';
import '../../test_util.dart' as util;

void main() {
  group("SyncFaceRecognitionPerson", () {
    test("new", _new);
    test("remove", _remove);
    test("update", _update);
  });
}

/// Sync with remote where there are new persons
///
/// Remote: [test1, test2, test3]
/// Local: [test1]
/// Expect: [test1, test2, test3]
Future<void> _new() async {
  final account = util.buildAccount();
  final c = DiContainer.late();
  c.npDb = util.buildTestDb();
  addTearDown(() => c.sqliteDb.close());
  c.faceRecognitionPersonRepoRemote = MockFaceRecognitionPersonMemoryRepo({
    account.id: [
      const FaceRecognitionPerson(name: "test1", thumbFaceId: 1, count: 1),
      const FaceRecognitionPerson(name: "test2", thumbFaceId: 2, count: 10),
      const FaceRecognitionPerson(name: "test3", thumbFaceId: 3, count: 100),
    ],
  });
  c.faceRecognitionPersonRepoLocal = BasicFaceRecognitionPersonRepo(
    FaceRecognitionPersonSqliteDbDataSource(c.npDb),
  );
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.batch((batch) {
      batch.insert(
        c.sqliteDb.faceRecognitionPersons,
        compat.FaceRecognitionPersonsCompanion.insert(
          account: 1,
          name: "test1",
          thumbFaceId: 1,
          count: 1,
        ),
      );
    });
  });

  await SyncFaceRecognitionPerson(c)(account);
  expect(await _listSqliteDbPersons(c.sqliteDb), {
    account.userId.toCaseInsensitiveString(): {
      const DbFaceRecognitionPerson(name: "test1", thumbFaceId: 1, count: 1),
      const DbFaceRecognitionPerson(name: "test2", thumbFaceId: 2, count: 10),
      const DbFaceRecognitionPerson(name: "test3", thumbFaceId: 3, count: 100),
    },
  });
}

/// Sync with remote where there are removed persons
///
/// Remote: [test1]
/// Local: [test1, test2, test3]
/// Expect: [test1]
Future<void> _remove() async {
  final account = util.buildAccount();
  final c = DiContainer.late();
  c.npDb = util.buildTestDb();
  addTearDown(() => c.sqliteDb.close());
  c.faceRecognitionPersonRepoRemote = MockFaceRecognitionPersonMemoryRepo({
    account.id: [
      const FaceRecognitionPerson(name: "test1", thumbFaceId: 1, count: 1),
    ],
  });
  c.faceRecognitionPersonRepoLocal = BasicFaceRecognitionPersonRepo(
    FaceRecognitionPersonSqliteDbDataSource(c.npDb),
  );
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.batch((batch) {
      batch.insertAll(c.sqliteDb.faceRecognitionPersons, [
        compat.FaceRecognitionPersonsCompanion.insert(
          account: 1,
          name: "test1",
          thumbFaceId: 1,
          count: 1,
        ),
        compat.FaceRecognitionPersonsCompanion.insert(
          account: 1,
          name: "test2",
          thumbFaceId: 2,
          count: 10,
        ),
        compat.FaceRecognitionPersonsCompanion.insert(
          account: 1,
          name: "test3",
          thumbFaceId: 3,
          count: 100,
        ),
      ]);
    });
  });

  await SyncFaceRecognitionPerson(c)(account);
  expect(await _listSqliteDbPersons(c.sqliteDb), {
    account.userId.toCaseInsensitiveString(): {
      const DbFaceRecognitionPerson(name: "test1", thumbFaceId: 1, count: 1),
    },
  });
}

/// Sync with remote where there are updated persons (i.e, same name, different
/// properties)
///
/// Remote: [test1, test2 (face: 3)]
/// Local: [test1, test2 (face: 2)]
/// Expect: [test1, test2 (face: 3)]
Future<void> _update() async {
  final account = util.buildAccount();
  final c = DiContainer.late();
  c.npDb = util.buildTestDb();
  addTearDown(() => c.sqliteDb.close());
  c.faceRecognitionPersonRepoRemote = MockFaceRecognitionPersonMemoryRepo({
    account.id: [
      const FaceRecognitionPerson(name: "test1", thumbFaceId: 1, count: 1),
      const FaceRecognitionPerson(name: "test2", thumbFaceId: 3, count: 10),
    ],
  });
  c.faceRecognitionPersonRepoLocal = BasicFaceRecognitionPersonRepo(
    FaceRecognitionPersonSqliteDbDataSource(c.npDb),
  );
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await c.sqliteDb.batch((batch) {
      batch.insertAll(c.sqliteDb.faceRecognitionPersons, [
        compat.FaceRecognitionPersonsCompanion.insert(
          account: 1,
          name: "test1",
          thumbFaceId: 1,
          count: 1,
        ),
        compat.FaceRecognitionPersonsCompanion.insert(
          account: 1,
          name: "test2",
          thumbFaceId: 2,
          count: 10,
        ),
      ]);
    });
  });

  await SyncFaceRecognitionPerson(c)(account);
  expect(await _listSqliteDbPersons(c.sqliteDb), {
    account.userId.toCaseInsensitiveString(): {
      const DbFaceRecognitionPerson(name: "test1", thumbFaceId: 1, count: 1),
      const DbFaceRecognitionPerson(name: "test2", thumbFaceId: 3, count: 10),
    },
  });
}

Future<Map<String, Set<DbFaceRecognitionPerson>>> _listSqliteDbPersons(
  compat.SqliteDb db,
) async {
  final query = db.select(db.faceRecognitionPersons).join([
    sql.innerJoin(
      db.accounts,
      db.accounts.rowId.equalsExp(db.faceRecognitionPersons.account),
    ),
  ]);
  final result =
      await query
          .map(
            (r) => (
              account: r.readTable(db.accounts),
              faceRecognitionPerson: r.readTable(db.faceRecognitionPersons),
            ),
          )
          .get();
  final product = <String, Set<DbFaceRecognitionPerson>>{};
  for (final r in result) {
    (product[r.account.userId] ??= {}).add(
      compat.FaceRecognitionPersonConverter.fromSql(r.faceRecognitionPerson),
    );
  }
  return product;
}
