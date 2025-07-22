import 'dart:async';

import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/find_file.dart';
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_log/np_log.dart';
import 'package:path/path.dart' as path_lib;

part 'list_sharing.g.dart';

abstract class ListSharingData {}

class ListSharingFileData implements ListSharingData {
  const ListSharingFileData(this.share, this.file);

  final Share share;
  final File file;
}

class ListSharingAlbumData implements ListSharingData {
  const ListSharingAlbumData(this.share, this.album);

  final Share share;
  final Album album;
}

@npLog
class ListSharing {
  ListSharing(this._c);

  Stream<List<ListSharingData>> call(Account account) async* {
    final sharedAlbumFiles = await Ls(_c.fileRepo)(
      account,
      File(
        path: remote_storage_util.getRemoteAlbumsDir(account),
      ),
    );

    final controller = StreamController<List<ListSharingData>>();
    var byMe = <ListSharingData>[];
    var isByMeDone = false;
    var withMe = <ListSharingData>[];
    var isWithMeDone = false;

    void notify() {
      controller.add([
        ...byMe,
        ...withMe,
      ]);
    }

    void onDone() {
      if (isByMeDone && isWithMeDone) {
        controller.close();
      }
    }

    unawaited(_querySharesByMe(account, sharedAlbumFiles).then((value) {
      byMe = value;
      notify();
    }).catchError((e, stackTrace) {
      controller.addError(e, stackTrace);
    }).whenComplete(() {
      isByMeDone = true;
      onDone();
    }));
    unawaited(_querySharesWithMe(account, sharedAlbumFiles).then((value) {
      withMe = value;
      notify();
    }).catchError((e, stackTrace) {
      controller.addError(e, stackTrace);
    }).whenComplete(() {
      isWithMeDone = true;
      onDone();
    }));
    yield* controller.stream;
  }

  Future<List<ListSharingData>> _querySharesByMe(
      Account account, List<File> sharedAlbumFiles) async {
    final shares = await _c.shareRepo.listAll(account);
    final futures = shares.map((s) async {
      final webdavPath = file_util.unstripPath(account, s.path);
      // include link share dirs
      if (s.itemType == ShareItemType.folder) {
        if (webdavPath
            .startsWith(remote_storage_util.getRemoteLinkSharesDir(account))) {
          return ListSharingFileData(
            s,
            File(
              path: webdavPath,
              fileId: s.itemSource,
              isCollection: true,
            ),
          );
        }
      }
      // include shared albums
      if (path_lib.dirname(webdavPath) ==
          remote_storage_util.getRemoteAlbumsDir(account)) {
        try {
          final file = sharedAlbumFiles
              .firstWhere((element) => element.fileId == s.itemSource);
          return await _querySharedAlbum(account, s, file);
        } catch (e, stackTrace) {
          _log.severe(
              "[_querySharesWithMe] Shared album not found: ${s.itemSource}",
              e,
              stackTrace);
          return null;
        }
      }

      if (!file_util.isSupportedMime(s.mimeType)) {
        return null;
      }
      // show only link shares
      if (s.url == null) {
        return null;
      }
      if (account.roots
          .every((r) => r.isNotEmpty && !s.path.startsWith("$r/"))) {
        // ignore files not under root dirs
        return null;
      }

      try {
        final file = (await FindFile(_c)(account, [s.itemSource])).first;
        return ListSharingFileData(s, file);
      } catch (e, stackTrace) {
        _log.severe("[_querySharesByMe] File not found: ${s.itemSource}", e,
            stackTrace);
        return null;
      }
    });
    return (await Future.wait(futures)).nonNulls.toList();
  }

  Future<List<ListSharingData>> _querySharesWithMe(
      Account account, List<File> sharedAlbumFiles) async {
    final pendingSharedAlbumFiles = await Ls(_c.fileRepo)(
      account,
      File(
        path: remote_storage_util.getRemotePendingSharedAlbumsDir(account),
      ),
    );

    final shares = await _c.shareRepo.reverseListAll(account);
    final futures = shares.map((s) async {
      final webdavPath = file_util.unstripPath(account, s.path);
      // include pending shared albums
      if (path_lib.dirname(webdavPath) ==
          remote_storage_util.getRemotePendingSharedAlbumsDir(account)) {
        try {
          final file = pendingSharedAlbumFiles
              .firstWhere((element) => element.fileId == s.itemSource);
          return await _querySharedAlbum(account, s, file);
        } catch (e, stackTrace) {
          _log.severe(
              "[_querySharesWithMe] Pending shared album not found: ${s.itemSource}",
              e,
              stackTrace);
          return null;
        }
      }
      // include shared albums
      if (path_lib.dirname(webdavPath) ==
          remote_storage_util.getRemoteAlbumsDir(account)) {
        try {
          final file = sharedAlbumFiles
              .firstWhere((element) => element.fileId == s.itemSource);
          return await _querySharedAlbum(account, s, file);
        } catch (e, stackTrace) {
          _log.severe(
              "[_querySharesWithMe] Shared album not found: ${s.itemSource}",
              e,
              stackTrace);
          return null;
        }
      }
    });
    return (await Future.wait(futures)).nonNulls.toList();
  }

  Future<ListSharingData?> _querySharedAlbum(
      Account account, Share share, File albumFile) async {
    try {
      final album = await _c.albumRepo.get(account, albumFile);
      return ListSharingAlbumData(share, album);
    } catch (e, stackTrace) {
      _log.shout(
          "[_querySharedAlbum] Failed while getting album", e, stackTrace);
      return null;
    }
  }

  final DiContainer _c;
}
