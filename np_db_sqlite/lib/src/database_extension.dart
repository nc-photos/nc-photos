import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:np_async/np_async.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/np_db.dart';
import 'package:np_db_sqlite/src/converter.dart';
import 'package:np_db_sqlite/src/database.dart';
import 'package:np_db_sqlite/src/files_query_builder.dart';
import 'package:np_db_sqlite/src/isolate_util.dart';
import 'package:np_db_sqlite/src/k.dart' as k;
import 'package:np_db_sqlite/src/table.dart';
import 'package:np_db_sqlite/src/util.dart';
import 'package:np_geocoder/np_geocoder.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_lock/np_platform_lock.dart';
import 'package:np_platform_util/np_platform_util.dart';

part 'database/account_extension.dart';
part 'database/album_extension.dart';
part 'database/compat_extension.dart';
part 'database/face_recognition_person_extension.dart';
part 'database/file_extension.dart';
part 'database/image_location_extension.dart';
part 'database/nc_album_extension.dart';
part 'database/nc_album_item_extension.dart';
part 'database/recognize_face_extension.dart';
part 'database/recognize_face_item_extension.dart';
part 'database/tag_extension.dart';
part 'database_extension.g.dart';

class ByAccount {
  const ByAccount._({this.sqlAccount, this.dbAccount})
    : assert((sqlAccount != null) != (dbAccount != null));

  const ByAccount.sql(Account account) : this._(sqlAccount: account);

  const ByAccount.db(DbAccount account) : this._(dbAccount: account);

  final Account? sqlAccount;
  final DbAccount? dbAccount;
}

class AccountFileRowIds {
  const AccountFileRowIds({
    required this.accountFileRowId,
    required this.accountRowId,
    required this.fileRowId,
  });

  final int accountFileRowId;
  final int accountRowId;
  final int fileRowId;
}

extension SqliteDbExtension on SqliteDb {
  /// Start a transaction and run [block]
  ///
  /// The [db] argument passed to [block] is identical to this
  ///
  /// Do NOT call this when using [isolate], call [useInIsolate] instead
  Future<T> use<T>(Future<T> Function(SqliteDb db) block) async {
    return await PlatformLock.synchronized(k.appDbLockId, () async {
      return await transaction(() async {
        return await block(this);
      });
    });
  }

  /// Run [block] after acquiring the database
  ///
  /// The [db] argument passed to [block] is identical to this
  ///
  /// This function does not start a transaction, see [use] instead
  Future<T> useNoTransaction<T>(Future<T> Function(SqliteDb db) block) async {
    return await PlatformLock.synchronized(k.appDbLockId, () async {
      return await block(this);
    });
  }

  /// Start an isolate and run [callback] there, with access to the
  /// SQLite database
  Future<U> isolate<T, U>(T args, ComputeWithDbCallback<T, U> callback) async {
    // we need to acquire the lock here as method channel is not supported in
    // background isolates
    return await PlatformLock.synchronized(k.appDbLockId, () async {
      // in unit tests we use an in-memory db, which mean there's no way to
      // access it in other isolates
      if (isUnitTest) {
        return await callback(this, args);
      } else {
        return await computeWithDb(callback, args, this);
      }
    });
  }

  /// Start a transaction and run [block], this version is suitable to be called
  /// in [isolate]
  ///
  /// See: [use]
  Future<T> useInIsolate<T>(Future<T> Function(SqliteDb db) block) async {
    return await transaction(() async {
      return await block(this);
    });
  }

  Future<void> truncate() async {
    await delete(servers).go();
    // technically deleting Servers table is enough to clear the followings, but
    // just in case
    await delete(accounts).go();
    await delete(files).go();
    await delete(images).go();
    await delete(imageLocations).go();
    await delete(trashes).go();
    await delete(accountFiles).go();
    await delete(dirFiles).go();
    await delete(albums).go();
    await delete(albumShares).go();
    await delete(tags).go();
    await delete(faceRecognitionPersons).go();
    await delete(ncAlbums).go();
    await delete(ncAlbumItems).go();
    await delete(recognizeFaces).go();
    await delete(recognizeFaceItems).go();

    // reset the auto increment counter
    await customStatement("UPDATE sqlite_sequence SET seq=0;");
  }

  Future<Account> accountOf(ByAccount account) {
    if (account.sqlAccount != null) {
      return Future.value(account.sqlAccount!);
    } else {
      final query =
          select(accounts).join([
              innerJoin(
                servers,
                servers.rowId.equalsExp(accounts.server),
                useColumns: false,
              ),
            ])
            ..where(servers.address.equals(account.dbAccount!.serverAddress))
            ..where(
              accounts.userId.equals(
                account.dbAccount!.userId.toCaseInsensitiveString(),
              ),
            )
            ..limit(1);
      return query.map((r) => r.readTable(accounts)).getSingle();
    }
  }

  /// Query AccountFiles, Accounts and Files row ID by file key
  Future<AccountFileRowIds?> _accountFileRowIdsOfSingle(
    ByAccount account,
    DbFileKey key,
  ) {
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(
          FilesQueryMode.expression,
          expressions: [
            accountFiles.rowId,
            accountFiles.account,
            accountFiles.file,
          ],
        )
        ..setAccount(account);
      if (key.fileId != null) {
        q.byFileId(key.fileId!);
      } else {
        q.byRelativePath(key.relativePath!);
      }
      return q.build()..limit(1);
    });
    return query
        .map(
          (r) => AccountFileRowIds(
            accountFileRowId: r.read(accountFiles.rowId)!,
            accountRowId: r.read(accountFiles.account)!,
            fileRowId: r.read(accountFiles.file)!,
          ),
        )
        .getSingleOrNull();
  }

  /// Query AccountFiles, Accounts and Files row ID by file keys
  Future<Map<int, AccountFileRowIds>> _accountFileRowIdsOf(
    ByAccount account,
    List<DbFileKey> keys,
  ) {
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(
          FilesQueryMode.expression,
          expressions: [
            files.fileId,
            accountFiles.relativePath,
            accountFiles.rowId,
            accountFiles.account,
            accountFiles.file,
          ],
        )
        ..setAccount(account);
      return q.build();
    });
    final fileIds = keys.map((k) => k.fileId).nonNulls;
    final relativePaths = keys.map((k) => k.relativePath).nonNulls;
    query.where(
      files.fileId.isIn(fileIds) |
          accountFiles.relativePath.isIn(relativePaths),
    );
    return query
        .map(
          (r) => MapEntry(
            r.read(files.fileId)!,
            AccountFileRowIds(
              accountFileRowId: r.read(accountFiles.rowId)!,
              accountRowId: r.read(accountFiles.account)!,
              fileRowId: r.read(accountFiles.file)!,
            ),
          ),
        )
        .get()
        .then((e) => e.toMap());
  }

  FilesQueryBuilder _queryFiles() => FilesQueryBuilder(this);
}

@npLog
// ignore: camel_case_types
class __ {}

final Logger _log = _$__NpLog.log;

const _maxByFileIdsSize = 30000;
