import 'dart:async';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/event/event.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/rx_extension.dart';
import 'package:nc_photos/use_case/list_share_with_me.dart';
import 'package:nc_photos/use_case/list_sharing.dart';
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';

part 'sharings_controller.g.dart';

abstract class SharingStreamData {
  static SharingStreamData _fromListSharingData(ListSharingData src) {
    if (src is ListSharingFileData) {
      return SharingStreamFileData(src.share, src.file);
    } else if (src is ListSharingAlbumData) {
      return SharingStreamAlbumData(src.share, src.album);
    } else {
      throw ArgumentError("Unsupported type: ${src.runtimeType}");
    }
  }
}

class SharingStreamShareData implements SharingStreamData {
  const SharingStreamShareData(this.share);

  final Share share;
}

class SharingStreamFileData extends SharingStreamShareData {
  const SharingStreamFileData(super.share, this.file);

  final File file;
}

class SharingStreamAlbumData extends SharingStreamShareData {
  const SharingStreamAlbumData(super.share, this.album);

  final Album album;
}

@genCopyWith
class SharingStreamEvent {
  const SharingStreamEvent({
    required this.data,
    required this.hasNext,
  });

  final List<SharingStreamData> data;

  /// If true, the results are intermediate values and may not represent the
  /// latest state
  final bool hasNext;
}

@npLog
class SharingsController {
  SharingsController(
    this._c, {
    required this.account,
  });

  void dispose() {
    _sharingStreamContorller.close();

    _shareRemovedListener?.end();
    _fileMovedEventListener?.end();
  }

  /// Return a stream of curated shares associated with [account]
  ///
  /// There's no guarantee that the returned list is always sorted in some ways,
  /// callers must sort it by themselves if the ordering is important
  ValueStream<SharingStreamEvent> get stream {
    if (!_isSharingStreamInited) {
      _isSharingStreamInited = true;
      unawaited(_load(isReload: false));
    }
    return _sharingStreamContorller.stream;
  }

  Stream<ExceptionEvent> get errorStream =>
      _sharingErrorStreamController.stream;

  /// In the future we need to get rid of the listeners and this reload function
  /// and move all manipulations to this controller
  Future<void> reload() async {
    if (_isSharingStreamInited) {
      return _load(isReload: true);
    } else {
      _log.warning("[reload] Not inited, ignore");
    }
  }

  Future<void> _load({required bool isReload}) async {
    var lastData = _sharingStreamContorller.value.copyWith(hasNext: true);
    _sharingStreamContorller.add(lastData);
    final completer = Completer();
    ListSharing(_c)(account).listen(
      (c) {
        lastData = SharingStreamEvent(
          data: c.map(SharingStreamData._fromListSharingData).toList(),
          hasNext: true,
        );
        if (!isReload) {
          _sharingStreamContorller.add(lastData);
        }
      },
      onError: _sharingErrorStreamController.add,
      onDone: () => completer.complete(),
    );
    await completer.future;
    _sharingStreamContorller.add(lastData.copyWith(hasNext: false));

    _shareRemovedListener =
        AppEventListener<ShareRemovedEvent>(_onShareRemovedEvent)..begin();
    _fileMovedEventListener =
        AppEventListener<FileMovedEvent>(_onFileMovedEvent)..begin();
  }

  void _onShareRemovedEvent(ShareRemovedEvent ev) {
    if (!_isAccountOfInterest(ev.account)) {
      return;
    }
    _sharingStreamContorller.addWithValue((value) => value.copyWith(
          data: value.data.where((e) {
            if (e is SharingStreamShareData) {
              return e.share.id != ev.share.id;
            } else {
              return true;
            }
          }).toList(),
        ));
  }

  Future<void> _onFileMovedEvent(FileMovedEvent ev) async {
    if (!_isAccountOfInterest(ev.account)) {
      return;
    }
    if (ev.destination
            .startsWith(remote_storage_util.getRemoteAlbumsDir(ev.account)) &&
        ev.file.path.startsWith(
            remote_storage_util.getRemotePendingSharedAlbumsDir(ev.account))) {
      // moving from pending dir to album dir
    } else if (ev.destination.startsWith(
            remote_storage_util.getRemotePendingSharedAlbumsDir(ev.account)) &&
        ev.file.path
            .startsWith(remote_storage_util.getRemoteAlbumsDir(ev.account))) {
      // moving from album dir to pending dir
    } else {
      // unrelated file
      return;
    }
    _log.info("[_onFileMovedEvent] ${ev.file.path} -> ${ev.destination}");
    final newShares =
        await ListShareWithMe(_c)(ev.account, File(path: ev.destination));
    final newAlbumFile = await LsSingleFile(_c)(ev.account, ev.destination);
    final newAlbum = await _c.albumRepo.get(ev.account, newAlbumFile);
    if (_sharingStreamContorller.isClosed) {
      return;
    }
    _sharingStreamContorller.addWithValue((value) => value.copyWith(
          data: value.data
              .whereNot((e) =>
                  e is SharingStreamAlbumData &&
                  e.share.path == ev.file.strippedPath)
              .toList()
            ..addAll(newShares.map((s) => SharingStreamAlbumData(s, newAlbum))),
        ));
  }

  bool _isAccountOfInterest(Account account) =>
      this.account.compareServerIdentity(account);

  final DiContainer _c;
  final Account account;

  var _isSharingStreamInited = false;
  final _sharingStreamContorller = BehaviorSubject.seeded(
    const SharingStreamEvent(data: [], hasNext: true),
  );
  final _sharingErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();

  AppEventListener<ShareRemovedEvent>? _shareRemovedListener;
  AppEventListener<FileMovedEvent>? _fileMovedEventListener;
}
