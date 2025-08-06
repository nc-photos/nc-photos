import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/throttler.dart';
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:nc_photos/use_case/put_file_binary.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';
import 'package:np_universal_storage/np_universal_storage.dart';
import 'package:path/path.dart' as path_lib;
import 'package:uuid/uuid.dart';

part 'touch_manager.g.dart';

/// Manage touch events for files
///
/// Touch events are used to broadcast file changes that don't trigger an ETag
/// update to other devices. Such changes include custom properties like
/// metadata
@npLog
class TouchManager {
  TouchManager(this._c) : assert(require(_c));

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.fileRepo) &&
      DiContainer.has(c, DiType.fileRepoRemote);

  static String newToken() {
    return const Uuid().v4().replaceAll("-", "");
  }

  /// Clear the cached etags
  ///
  /// You should call this before a complete re-scan
  void clearTouchCache() {
    _log.info("[clearTouchCache]");
    _resultCache.clear();
  }

  /// Compare the remote and local etag
  ///
  /// Return null if the two etags match, otherwise return the remote etag
  Future<String?> checkTouchEtag(Account account, File dir) async {
    if (dir.strippedPathWithEmpty.isNotEmpty) {
      // check parent
      if (await checkTouchEtag(
            account,
            File(path: path_lib.dirname(dir.path)),
          ) ==
          null) {
        // parent ok == child ok
        return null;
      }
    }
    final cacheKey = "${account.url}/${dir.path}";
    final cache = _resultCache[cacheKey];
    if (cache != null) {
      // we checked this dir already, return the cache
      return cache.obj;
    }

    String? remoteToken;
    try {
      remoteToken = await _getRemoteEtag(account, dir);
    } catch (e, stacktrace) {
      _log.shout("[checkTouchEtag] Failed getting remote etag", e, stacktrace);
    }

    String? localToken;
    try {
      localToken = await _getLocalEtag(account, dir);
    } catch (e, stacktrace) {
      _log.shout("[checkTouchEtag] Failed getting local etag", e, stacktrace);
    }

    final isMatch = localToken == remoteToken;
    final result = OrNull(isMatch ? null : remoteToken);
    _resultCache[cacheKey] = result;
    if (!isMatch) {
      _log.info(
        "[checkTouchEtag] Remote and local etag differ, cache outdated: ${dir.strippedPath}",
      );
    } else {
      _log.info("[checkTouchEtag] etags match: ${dir.strippedPath}");
    }
    return result.obj;
  }

  /// Touch a dir
  Future<void> touch(Account account, File dir) async {
    // _log.info("[touch] Touch dir '${dir.path}'");
    // delete the local etag, we'll update it later. If the app is killed, then
    // at least the app will update the cache in next run
    await setLocalEtag(account, dir, null);
    (_throttlers["${account.url}/${dir.path}"] ??= Throttler(
          onTriggered: _triggerTouch,
          logTag: "TouchManager._throttlers",
        ))
        .trigger(
          maxResponceTime: const Duration(seconds: 20),
          maxPendingCount: 20,
          data: _ThrottlerData(account, dir),
        );
  }

  Future<void> flushRemote() async {
    for (final t in _throttlers.values) {
      await t.triggerNow();
    }
  }

  Future<void> setLocalEtag(Account account, File dir, String? etag) {
    final name = _getLocalStorageName(account, dir);
    if (etag == null) {
      return UniversalStorage().remove(name);
    } else {
      _log.info("[setLocalEtag] Set local etag for file '${dir.path}': $etag");
      return UniversalStorage().putString(name, etag);
    }
  }

  Future<void> _triggerTouch(List<_ThrottlerData> data) async {
    try {
      final d = data.last;
      await _touchRemote(d.account, d.dir);
      final etag = await _getRemoteEtag(d.account, d.dir);
      _log.info("[_triggerTouch] Remote etag = $etag");
      if (etag == null) {
        _log.severe("[_triggerTouch] etag == null");
      } else {
        await setLocalEtag(d.account, d.dir, etag);
      }
    } catch (e, stackTrace) {
      _log.shout("[_triggerTouch] Uncaught exception", e, stackTrace);
    }
  }

  /// Update the remote touch dir
  Future<void> _touchRemote(Account account, File dir) async {
    _log.info("[touchRemote] Touch remote dir '${dir.path}'");
    final path = _getRemoteEtagPath(account, dir);
    return PutFileBinary(_c.fileRepo)(
      account,
      "$path/token.txt",
      const Utf8Encoder().convert(newToken()),
      shouldCreateMissingDir: true,
    );
  }

  /// Return the corresponding touch etag for [dir] from remote source, or null
  /// if no such file
  Future<String?> _getRemoteEtag(Account account, File dir) async {
    final path = _getRemoteEtagPath(account, dir);
    try {
      final f = await LsSingleFile(_c)(account, path);
      return f.etag;
    } on ApiException catch (e) {
      if (e.response.statusCode == 404) {
        return null;
      } else {
        rethrow;
      }
    }
  }

  String _getRemoteEtagPath(Account account, File dir) {
    final strippedPath = dir.strippedPath;
    if (strippedPath == ".") {
      return remote_storage_util.getRemoteTouchDir(account);
    } else {
      return "${remote_storage_util.getRemoteTouchDir(account)}/$strippedPath";
    }
  }

  Future<String?> _getLocalEtag(Account account, File file) async {
    final name = _getLocalStorageName(account, file);
    return UniversalStorage().getString(name);
  }

  String _getLocalStorageName(Account account, File file) {
    final strippedPath = file.strippedPath;
    if (strippedPath == ".") {
      return "touch/${account.url.replaceFirst('://', '_')}/${account.userId}/token";
    } else {
      return "touch/${account.url.replaceFirst('://', '_')}/${account.userId}/${file.strippedPath}/token";
    }
  }

  final DiContainer _c;
  final _throttlers = <String, Throttler<_ThrottlerData>>{};
  final _resultCache = <String, OrNull<String>>{};
}

class _ThrottlerData {
  const _ThrottlerData(this.account, this.dir);

  final Account account;
  final File dir;
}
