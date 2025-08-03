import 'dart:async';

import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:mutex/mutex.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_init.dart' as app_init;
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/persons_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/use_case/person/sync_person.dart';
import 'package:nc_photos/use_case/sync_favorite.dart';
import 'package:nc_photos/use_case/sync_tag.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/type.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'startup_sync.g.dart';

/// Sync various properties with server during startup
@npLog
class StartupSync {
  StartupSync(this._c) : assert(require(_c));

  static bool require(DiContainer c) => SyncFavorite.require(c);

  /// Sync in a background isolate
  static Future<SyncResult> runInIsolate(
    Account account,
    FilesController filesController,
    PersonsController personsController,
    PersonProvider personProvider,
  ) async {
    return _mutex.protect(() async {
      if (getRawPlatform() == NpPlatform.web) {
        // not supported on web
        final c = KiwiContainer().resolve<DiContainer>();
        return await StartupSync(c)(account, personProvider);
      } else {
        // we can't use regular isolate here because self-signed cert support
        // requires native plugins
        final resultJson = await flutterCompute(
            _isolateMain, _IsolateMessage(account, personProvider).toJson());
        final result = SyncResult.fromJson(resultJson);
        // events fired in background isolate won't be noticed by the main isolate,
        // so we fire them again here
        _broadcastResult(account, filesController, personsController, result);
        return result;
      }
    });
  }

  Future<SyncResult> call(
      Account account, PersonProvider personProvider) async {
    _log.info("[_run] Begin sync");
    final stopwatch = Stopwatch()..start();
    DbSyncIdResult? syncFavoriteResult;
    DbSyncIdResult? syncTagResult;
    var isSyncPersonUpdated = false;
    try {
      syncFavoriteResult = await SyncFavorite(_c)(account);
    } catch (e, stackTrace) {
      _log.shout("[_run] Failed while SyncFavorite", e, stackTrace);
    }
    try {
      syncTagResult = await SyncTag(_c)(account);
    } catch (e, stackTrace) {
      _log.shout("[_run] Failed while SyncTag", e, stackTrace);
    }
    try {
      isSyncPersonUpdated = await SyncPerson(_c)(account, personProvider);
    } catch (e, stackTrace) {
      _log.shout("[_run] Failed while SyncPerson", e, stackTrace);
    }
    _log.info("[_run] Elapsed time: ${stopwatch.elapsedMilliseconds}ms");
    return SyncResult(
      syncFavoriteResult: syncFavoriteResult,
      syncTagResult: syncTagResult,
      isSyncPersonUpdated: isSyncPersonUpdated,
    );
  }

  static void _broadcastResult(
    Account account,
    FilesController filesController,
    PersonsController personsController,
    SyncResult result,
  ) {
    _$StartupSyncNpLog.log.info('[_broadcastResult] $result');
    if (result.syncFavoriteResult != null) {
      filesController.applySyncResult(favorites: result.syncFavoriteResult!);
    }
    if (result.isSyncPersonUpdated) {
      personsController.reload();
    }
  }

  final DiContainer _c;

  static final _mutex = Mutex();
}

@toString
class SyncResult {
  const SyncResult({
    required this.syncFavoriteResult,
    required this.syncTagResult,
    required this.isSyncPersonUpdated,
  });

  factory SyncResult.fromJson(JsonObj json) => SyncResult(
        syncFavoriteResult: (json["syncFavoriteResult"] as Map?)
            ?.cast<String, dynamic>()
            .let(DbSyncIdResult.fromJson),
        syncTagResult: (json["syncTagResult"] as Map?)
            ?.cast<String, dynamic>()
            .let(DbSyncIdResult.fromJson),
        isSyncPersonUpdated: json["isSyncPersonUpdated"],
      );

  JsonObj toJson() => {
        "syncFavoriteResult": syncFavoriteResult?.toJson(),
        "syncTagResult": syncTagResult?.toJson(),
        "isSyncPersonUpdated": isSyncPersonUpdated,
      };

  @override
  String toString() => _$toString();

  final DbSyncIdResult? syncFavoriteResult;
  final DbSyncIdResult? syncTagResult;
  final bool isSyncPersonUpdated;
}

class _IsolateMessage {
  const _IsolateMessage(this.account, this.personProvider);

  factory _IsolateMessage.fromJson(JsonObj json) => _IsolateMessage(
        Account.fromJson(
          json["account"].cast<String, dynamic>(),
          upgraderV1: const AccountUpgraderV1(),
        )!,
        PersonProvider.fromValue(json["personProvider"]),
      );

  JsonObj toJson() => <String, dynamic>{
        "account": account.toJson(),
        "personProvider": personProvider.index,
      };

  final Account account;
  final PersonProvider personProvider;
}

@pragma("vm:entry-point")
Future<JsonObj> _isolateMain(JsonObj messageJson) async {
  final message = _IsolateMessage.fromJson(messageJson);
  await app_init.init(app_init.InitIsolateType.flutterIsolate);

  final c = KiwiContainer().resolve<DiContainer>();
  final result = await StartupSync(c)(message.account, message.personProvider);
  return result.toJson();
}
