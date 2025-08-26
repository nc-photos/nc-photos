import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/use_case/album/list_album.dart';
import 'package:nc_photos/use_case/ls.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'list_importable_album.g.dart';

class ListImportableAlbumBlocItem {
  ListImportableAlbumBlocItem(this.file, this.photoCount);

  final File file;
  final int photoCount;
}

abstract class ListImportableAlbumBlocEvent {
  const ListImportableAlbumBlocEvent();
}

@toString
class ListImportableAlbumBlocQuery extends ListImportableAlbumBlocEvent {
  const ListImportableAlbumBlocQuery(this.account, this.roots);

  @override
  String toString() => _$toString();

  final Account account;
  @Format(r"${$?.toReadableString()}")
  final List<File> roots;
}

@toString
abstract class ListImportableAlbumBlocState {
  const ListImportableAlbumBlocState(this.items);

  @override
  String toString() => _$toString();

  final List<ListImportableAlbumBlocItem> items;
}

class ListImportableAlbumBlocInit extends ListImportableAlbumBlocState {
  ListImportableAlbumBlocInit() : super(const []);
}

class ListImportableAlbumBlocLoading extends ListImportableAlbumBlocState {
  const ListImportableAlbumBlocLoading(super.items);
}

class ListImportableAlbumBlocSuccess extends ListImportableAlbumBlocState {
  const ListImportableAlbumBlocSuccess(super.items);
}

@toString
class ListImportableAlbumBlocFailure extends ListImportableAlbumBlocState {
  const ListImportableAlbumBlocFailure(super.items, this.exception);

  @override
  String toString() => _$toString();

  final dynamic exception;
}

/// Return all directories that potentially could be a new album
@npLog
class ListImportableAlbumBloc
    extends Bloc<ListImportableAlbumBlocEvent, ListImportableAlbumBlocState> {
  ListImportableAlbumBloc(this._c)
    : assert(require(_c)),
      assert(ListAlbum.require(_c)),
      super(ListImportableAlbumBlocInit()) {
    on<ListImportableAlbumBlocEvent>(_onEvent);
  }

  static bool require(DiContainer c) => DiContainer.has(c, DiType.fileRepo);

  Future<void> _onEvent(
    ListImportableAlbumBlocEvent event,
    Emitter<ListImportableAlbumBlocState> emit,
  ) async {
    _log.info("[_onEvent] $event");
    if (event is ListImportableAlbumBlocQuery) {
      await _onEventQuery(event, emit);
    }
  }

  Future<void> _onEventQuery(
    ListImportableAlbumBlocQuery ev,
    Emitter<ListImportableAlbumBlocState> emit,
  ) async {
    emit(const ListImportableAlbumBlocLoading([]));
    try {
      final albums =
          (await ListAlbum(_c)(
                ev.account,
              ).where((event) => event is Album).toList())
              .cast<Album>();
      final importedDirs = albums
          .map((a) {
            if (a.provider is! AlbumDirProvider) {
              return <File>[];
            } else {
              return (a.provider as AlbumDirProvider).dirs;
            }
          })
          .fold<List<File>>(
            [],
            (previousValue, element) => previousValue + element,
          );

      final products = <ListImportableAlbumBlocItem>[];
      int count = 0;
      for (final r in ev.roots) {
        await for (final ev in _queryDir(ev.account, importedDirs, r)) {
          if (ev is Exception || ev is Error) {
            throw ev;
          } else if (ev is ListImportableAlbumBlocItem) {
            products.add(ev);
            // don't emit events too frequently
            if (++count >= 5) {
              emit(ListImportableAlbumBlocLoading(products.toList()));
            }
          }
        }
      }
      emit(ListImportableAlbumBlocSuccess(products));
    } catch (e) {
      _log.severe("[_onEventQuery] Exception while request", e);
      emit(ListImportableAlbumBlocFailure(state.items, e));
    }
  }

  /// Query [dir] and emit all conforming dirs recursively (including [dir])
  ///
  /// Emit ListImportableAlbumBlocItem or Exception
  Stream<dynamic> _queryDir(
    Account account,
    List<File> importedDirs,
    File dir,
  ) async* {
    try {
      if (importedDirs.containsIf(dir, (a, b) => a.path == b.path)) {
        return;
      }
      final files = await Ls(_c.fileRepo)(account, dir);
      // check number of supported files in this directory
      final count = files.where((f) => file_util.isSupportedFormat(f)).length;
      // arbitrary number
      if (count >= 5) {
        yield ListImportableAlbumBlocItem(dir, count);
      }
      for (final d in files.where(
        (f) =>
            f.isCollection == true &&
            !f.path.endsWith(remote_storage_util.getRemoteStorageDir(account)),
      )) {
        yield* _queryDir(account, importedDirs, d);
      }
    } catch (e, stacktrace) {
      _log.shout(
        "[_queryDir] Failed while listing dir: ${logFilename(dir.path)}",
        e,
        stacktrace,
      );
      yield e;
    }
  }

  final DiContainer _c;
}
