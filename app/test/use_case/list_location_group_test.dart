import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/use_case/list_location_group.dart';
import 'package:np_db_sqlite/np_db_sqlite_compat.dart' as compat;
import 'package:test/test.dart';

import '../test_util.dart' as util;

void main() {
  group("ListLocationGroup", () {
    test("empty", _empty);
    test("no location", _noLocation);
    test("N File to 1 Location", _nFile1Location);
    test("N File to N Location", _nFileNLocation);
    test("multiple roots", _multipleRoots);
  });
}

/// List and group locations for files in DB
///
/// DB: []
/// Expect: []
Future<void> _empty() async {
  final account = util.buildAccount();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
  });

  final result = await ListLocationGroup(c)(account);
  expect(result.name.toSet(), <LocationGroup>{});
  expect(result.admin1.toSet(), <LocationGroup>{});
  expect(result.admin2.toSet(), <LocationGroup>{});
  expect(result.countryCode.toSet(), <LocationGroup>{});
}

/// List and group locations for files in DB
///
/// DB: [File(test1, location: null)]
/// Expect: []
Future<void> _noLocation() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg"))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  final result = await ListLocationGroup(c)(account);
  expect(result.name.toSet(), <LocationGroup>{});
  expect(result.admin1.toSet(), <LocationGroup>{});
  expect(result.admin2.toSet(), <LocationGroup>{});
  expect(result.countryCode.toSet(), <LocationGroup>{});
}

/// List and group locations for files in DB
///
/// DB: [
///   File(test1, location: "Some place"),
///   File(test2, location: "Some place"),
/// ]
/// Expect: ["Some place"]
Future<void> _nFile1Location() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            ))
        ..addJpeg("admin/test2.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            )))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  final result = await ListLocationGroup(c)(account);
  expect(result.name.toSet(), {
    LocationGroup("Some place", "AD", 2, 2,
        DateTime.utc(2020, 1, 2, 3, 4, 5 + 2), "image/jpeg", "test2.jpg"),
  });
  expect(result.admin1.toSet(), <LocationGroup>{});
  expect(result.admin2.toSet(), <LocationGroup>{});
  expect(result.countryCode.toSet(), {
    LocationGroup("Andorra", "AD", 2, 2, DateTime.utc(2020, 1, 2, 3, 4, 5 + 2),
        "image/jpeg", "test2.jpg"),
  });
}

/// List and group locations for files in DB
///
/// DB: [
///   File(test1, location: "Some place"),
///   File(test2, location: "Some place"),
///   File(test3, location: "Another place"),
///   File(test4, location: "Another place"),
/// ]
/// Expect: ["Some place", "Another place"]
Future<void> _nFileNLocation() async {
  final account = util.buildAccount();
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addJpeg("admin/test1.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            ))
        ..addJpeg("admin/test2.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            ))
        ..addJpeg("admin/test3.jpg",
            location: const ImageLocation(
              name: "Another place",
              latitude: 4.3,
              longitude: 2.1,
              countryCode: "ZW",
            ))
        ..addJpeg("admin/test4.jpg",
            location: const ImageLocation(
              name: "Another place",
              latitude: 4.3,
              longitude: 2.1,
              countryCode: "ZW",
            )))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  final result = await ListLocationGroup(c)(account);
  expect(result.name.toSet(), {
    LocationGroup("Some place", "AD", 2, 2,
        DateTime.utc(2020, 1, 2, 3, 4, 5 + 2), "image/jpeg", "test2.jpg"),
    LocationGroup("Another place", "ZW", 2, 4,
        DateTime.utc(2020, 1, 2, 3, 4, 5 + 4), "image/jpeg", "test4.jpg"),
  });
  expect(result.admin1.toSet(), <LocationGroup>{});
  expect(result.admin2.toSet(), <LocationGroup>{});
  expect(result.countryCode.toSet(), {
    LocationGroup("Andorra", "AD", 2, 2, DateTime.utc(2020, 1, 2, 3, 4, 5 + 2),
        "image/jpeg", "test2.jpg"),
    LocationGroup("Zimbabwe", "ZW", 2, 4, DateTime.utc(2020, 1, 2, 3, 4, 5 + 4),
        "image/jpeg", "test4.jpg"),
  });
}

/// List and group locations for files in DB
///
/// DB: [
///   File(test1/test1, location: "Some place"),
///   File(test1/test2, location: "Some place"),
///   File(test2/test3, location: "Some place"),
///   File(test2/test4, location: "Some place"),
/// ]
/// Expect: ["Some place"]
Future<void> _multipleRoots() async {
  final account = util.buildAccount(
    roots: ["test1", "test2"],
  );
  final files = (util.FilesBuilder()
        ..addDir("admin")
        ..addDir("admin/test1")
        ..addDir("admin/test2")
        ..addDir("admin/test3")
        ..addJpeg("admin/test1/test1.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            ))
        ..addJpeg("admin/test1/test2.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            ))
        ..addJpeg("admin/test2/test3.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            ))
        ..addJpeg("admin/test2/test4.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            ))
        ..addJpeg("admin/test3/test5.jpg",
            location: const ImageLocation(
              name: "Some place",
              latitude: 1.2,
              longitude: 3.4,
              countryCode: "AD",
            )))
      .build();
  final c = DiContainer(
    npDb: util.buildTestDb(),
  );
  addTearDown(() => c.sqliteDb.close());
  await c.sqliteDb.transaction(() async {
    await c.sqliteDb.insertAccounts([account.toDb()]);
    await util.insertFiles(c.sqliteDb, account, files);
  });

  final result = await ListLocationGroup(c)(account);
  expect(result.name.toSet(), {
    LocationGroup("Some place", "AD", 4, 7,
        DateTime.utc(2020, 1, 2, 3, 4, 5 + 7), "image/jpeg", "test2/test4.jpg"),
  });
  expect(result.admin1.toSet(), <LocationGroup>{});
  expect(result.admin2.toSet(), <LocationGroup>{});
  expect(result.countryCode.toSet(), {
    LocationGroup("Andorra", "AD", 4, 7, DateTime.utc(2020, 1, 2, 3, 4, 5 + 7),
        "image/jpeg", "test2/test4.jpg"),
  });
}
