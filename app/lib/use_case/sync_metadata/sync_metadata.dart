import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/server_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file/file_cache_manager.dart';
import 'package:nc_photos/entity/file/repo.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/geocoder_util.dart';
import 'package:nc_photos/service/service.dart';
import 'package:nc_photos/use_case/battery_ensurer.dart';
import 'package:nc_photos/use_case/get_file_binary.dart';
import 'package:nc_photos/use_case/load_metadata.dart';
import 'package:nc_photos/use_case/update_property.dart';
import 'package:nc_photos/use_case/wifi_ensurer.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/or_null.dart';
import 'package:np_db/np_db.dart';
import 'package:np_geocoder/np_geocoder.dart';
import 'package:np_log/np_log.dart';
import 'package:path/path.dart';

part 'sync_by_app.dart';
part 'sync_by_server.dart';
part 'sync_metadata.g.dart';

@npLog
class SyncMetadata {
  const SyncMetadata({
    required this.fileRepo,
    required this.fileRepo2,
    required this.fileRepoRemote,
    required this.db,
    this.interrupter,
    required this.wifiEnsurer,
    required this.batteryEnsurer,
  });

  Stream<File> syncAccount(
    Account account,
    AccountPrefController accountPrefController,
  ) async* {
    final bool isNcMetadataSupported;
    try {
      isNcMetadataSupported =
          (await _isNcMetadataSupported(account, accountPrefController))!;
    } catch (e) {
      _log.severe("[syncAccount] Failed to get server version", e);
      return;
    }
    final files = await db.getFilesByMissingMetadata(
      account: account.toDb(),
      mimes: file_util.supportedFormatMimes,
      ownerId: account.userId.toCaseInsensitiveString(),
    );
    _log.info("[syncAccount] Missing count: ${files.items.length}");
    if (isNcMetadataSupported) {
      yield* _doWithServer(account, files);
    } else {
      yield* _doWithApp(account, files);
    }
  }

  Stream<File> _doWithApp(
    Account account,
    DbFileMissingMetadataResult files,
  ) async* {
    final op = _SyncByApp(
      account: account,
      fileRepo: fileRepo,
      fileRepo2: fileRepo2,
      db: db,
      interrupter: interrupter,
      wifiEnsurer: wifiEnsurer,
      batteryEnsurer: batteryEnsurer,
    );
    await op.init();
    final stream = op.syncFiles(
      fileIds: files.items.map((e) => e.fileId).toList(),
    );
    yield* stream;
  }

  Stream<File> _doWithServer(
    Account account,
    DbFileMissingMetadataResult files,
  ) async* {
    final fallback = _SyncByApp(
      account: account,
      fileRepo: fileRepo,
      fileRepo2: fileRepo2,
      db: db,
      interrupter: interrupter,
      wifiEnsurer: wifiEnsurer,
      batteryEnsurer: batteryEnsurer,
    );
    await fallback.init();
    final op = _SyncByServer(
      account: account,
      fileRepoRemote: fileRepoRemote,
      fileRepo2: fileRepo2,
      db: db,
      interrupter: interrupter,
      fallback: fallback,
    );
    await op.init();
    final fileIds = <int>[];
    final relativePaths = <String>[];
    for (final f in files.items) {
      fileIds.add(f.fileId);
      relativePaths.add(f.relativePath);
    }
    final stream = op.syncFiles(fileIds: fileIds, relativePaths: relativePaths);
    yield* stream;
  }

  Future<bool?> _isNcMetadataSupported(
    Account account,
    AccountPrefController accountPrefController,
  ) async {
    final serverController = ServerController(
      account: account,
      accountPrefController: accountPrefController,
    );
    await serverController.status.first.timeout(const Duration(seconds: 15));
    return serverController.isSupported(ServerFeature.ncMetadata);
  }

  final FileRepo fileRepo;
  final FileRepo2 fileRepo2;
  final FileRepo fileRepoRemote;
  final NpDb db;
  final Stream<void>? interrupter;
  final WifiEnsurer wifiEnsurer;
  final BatteryEnsurer batteryEnsurer;
}
