import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/use_case/list_share.dart';
import 'package:nc_photos/use_case/list_sharee.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'list_album_share_outlier.g.dart';

@toString
class ListAlbumShareOutlierItem with EquatableMixin {
  const ListAlbumShareOutlierItem(this.file, this.shareItems);

  @override
  String toString() => _$toString();

  @override
  List<Object?> get props => [file, shareItems];

  final FileDescriptor file;
  @Format(r"${$?.toReadableString()}")
  final List<ListAlbumShareOutlierShareItem> shareItems;
}

abstract class ListAlbumShareOutlierShareItem with EquatableMixin {
  const ListAlbumShareOutlierShareItem();
}

@toString
class ListAlbumShareOutlierExtraShareItem
    extends ListAlbumShareOutlierShareItem {
  const ListAlbumShareOutlierExtraShareItem(this.share);

  @override
  String toString() => _$toString();

  @override
  get props => [share];

  final Share share;
}

@toString
class ListAlbumShareOutlierMissingShareItem
    extends ListAlbumShareOutlierShareItem {
  const ListAlbumShareOutlierMissingShareItem(
    this.shareWith,
    this.shareWithDisplayName,
  );

  @override
  String toString() => _$toString();

  @override
  get props => [shareWith, shareWithDisplayName];

  final CiString shareWith;
  final String? shareWithDisplayName;
}

abstract class ListAlbumShareOutlierBlocEvent {
  const ListAlbumShareOutlierBlocEvent();
}

@toString
class ListAlbumShareOutlierBlocQuery extends ListAlbumShareOutlierBlocEvent {
  const ListAlbumShareOutlierBlocQuery(this.account, this.album);

  @override
  String toString() => _$toString();

  final Account account;
  final Album album;
}

@toString
abstract class ListAlbumShareOutlierBlocState with EquatableMixin {
  const ListAlbumShareOutlierBlocState(this.account, this.items);

  @override
  String toString() => _$toString();

  @override
  get props => [account, items];

  final Account? account;
  @Format(r"${$?.toReadableString()}")
  final List<ListAlbumShareOutlierItem> items;
}

class ListAlbumShareOutlierBlocInit extends ListAlbumShareOutlierBlocState {
  ListAlbumShareOutlierBlocInit() : super(null, const []);
}

class ListAlbumShareOutlierBlocLoading extends ListAlbumShareOutlierBlocState {
  const ListAlbumShareOutlierBlocLoading(super.account, super.items);
}

class ListAlbumShareOutlierBlocSuccess extends ListAlbumShareOutlierBlocState {
  const ListAlbumShareOutlierBlocSuccess(super.account, super.items);
}

@toString
class ListAlbumShareOutlierBlocFailure extends ListAlbumShareOutlierBlocState {
  const ListAlbumShareOutlierBlocFailure(
    super.account,
    super.items,
    this.exception,
  );

  @override
  String toString() => _$toString();

  @override
  get props => [...super.props, exception];

  final dynamic exception;
}

/// List the outliers in a shared album
///
/// An outlier is a file where its shares are different to the album's that it
/// belongs, e.g., an unshared item in a shared album, or vice versa.
///
/// Different users are responsible to manage shares for different files. For
/// the owner of the album, they are responsible to manage:
/// 1. files added by yourself
/// 2. files added by other users: for each participants, any files that are
/// added before the album share for him/her was created
///
/// For other users, they are responsible to manage:
/// 1. shares between you and the owner for all files added by you
/// 2. files added by you: for each participants, any files that are
/// added on or after the album share for him/her was created
@npLog
class ListAlbumShareOutlierBloc
    extends
        Bloc<ListAlbumShareOutlierBlocEvent, ListAlbumShareOutlierBlocState> {
  ListAlbumShareOutlierBloc(this._c)
    : assert(require(_c)),
      super(ListAlbumShareOutlierBlocInit()) {
    on<ListAlbumShareOutlierBlocEvent>(_onEvent);
  }

  static bool require(DiContainer c) => DiContainer.has(c, DiType.shareeRepo);

  Future<void> _onEvent(
    ListAlbumShareOutlierBlocEvent event,
    Emitter<ListAlbumShareOutlierBlocState> emit,
  ) async {
    _log.info("[_onEvent] $event");
    if (event is ListAlbumShareOutlierBlocQuery) {
      await _onEventQuery(event, emit);
    }
  }

  Future<void> _onEventQuery(
    ListAlbumShareOutlierBlocQuery ev,
    Emitter<ListAlbumShareOutlierBlocState> emit,
  ) async {
    try {
      assert(ev.album.provider is AlbumStaticProvider);
      emit(ListAlbumShareOutlierBlocLoading(ev.account, state.items));

      final albumShares = await () async {
        var temp =
            (ev.album.shares ?? [])
                .where((s) => s.userId != ev.account.userId)
                .toList();
        if (ev.album.albumFile!.ownerId != ev.account.userId) {
          // add owner if the album is not owned by this account
          final ownerSharee = (await ListSharee(_c.shareeRepo)(
            ev.account,
          )).firstWhere((s) => s.shareWith == ev.album.albumFile!.ownerId);
          temp.add(
            AlbumShare(
              userId: ownerSharee.shareWith,
              displayName: ownerSharee.label,
            ),
          );
        }
        return Map.fromEntries(temp.map((as) => MapEntry(as.userId, as)));
      }();

      final products = <ListAlbumShareOutlierItem>[];
      final errors = <Object>[];
      products.addAll(
        await _processAlbumFile(ev.account, ev.album, albumShares, errors),
      );
      products.addAll(
        await _processAlbumItems(ev.account, ev.album, albumShares, errors),
      );

      if (errors.isEmpty) {
        emit(ListAlbumShareOutlierBlocSuccess(ev.account, products));
      } else {
        emit(
          ListAlbumShareOutlierBlocFailure(ev.account, products, errors.first),
        );
      }
    } catch (e, stackTrace) {
      _log.severe("[_onEventQuery] Exception while request", e, stackTrace);
      emit(ListAlbumShareOutlierBlocFailure(ev.account, state.items, e));
    }
  }

  Future<List<ListAlbumShareOutlierItem>> _processAlbumFile(
    Account account,
    Album album,
    Map<CiString, AlbumShare> albumShares,
    List<Object> errors,
  ) async {
    if (!album.albumFile!.isOwned(account.userId)) {
      // album file is always managed by the owner
      return [];
    }

    final shareItems = <ListAlbumShareOutlierShareItem>[];
    try {
      final albumSharees = albumShares.values.map((s) => s.userId).toSet();
      final shares =
          (await ListShare(_c)(
            account,
            album.albumFile!,
          )).where((element) => element.shareType == ShareType.user).toList();
      final sharees = shares.map((s) => s.shareWith!).toSet();
      final missings = albumSharees.difference(sharees);
      _log.info(
        "[_processAlbumFile] Missing shares: ${missings.toReadableString()}",
      );
      shareItems.addAll(
        missings
            .map((e) => albumShares[e]!)
            .map(
              (s) => ListAlbumShareOutlierMissingShareItem(
                s.userId,
                s.displayName,
              ),
            ),
      );
      final extras = sharees.difference(albumSharees);
      _log.info(
        "[_processAlbumFile] Extra shares: ${extras.toReadableString()}",
      );
      shareItems.addAll(
        extras
            .map((e) => shares.firstWhere((s) => s.shareWith == e))
            .map((s) => ListAlbumShareOutlierExtraShareItem(s)),
      );
    } catch (e, stackTrace) {
      _log.severe(
        "[_processAlbumFile] Exception: ${logFilename(album.albumFile?.path)}",
        e,
        stackTrace,
      );
      errors.add(e);
      return [];
    }

    if (shareItems.isNotEmpty) {
      return [ListAlbumShareOutlierItem(album.albumFile!, shareItems)];
    } else {
      return [];
    }
  }

  Future<List<ListAlbumShareOutlierItem>> _processAlbumItems(
    Account account,
    Album album,
    Map<CiString, AlbumShare> albumShares,
    List<Object> errors,
  ) async {
    final products = <ListAlbumShareOutlierItem>[];
    final fileItems =
        AlbumStaticProvider.of(album).items.whereType<AlbumFileItem>().toList();
    for (final fi in fileItems) {
      try {
        (await _processSingleFileItem(
          account,
          album,
          fi,
          albumShares,
          errors,
        ))?.also((item) {
          products.add(item);
        });
      } catch (e, stackTrace) {
        _log.severe(
          "[_processAlbumItems] Failed while _processSingleFile: ${logFilename(fi.file.fdPath)}",
          e,
          stackTrace,
        );
        errors.add(e);
      }
    }
    return products;
  }

  Future<ListAlbumShareOutlierItem?> _processSingleFileItem(
    Account account,
    Album album,
    AlbumFileItem fileItem,
    Map<CiString, AlbumShare> albumShares,
    List<Object> errors,
  ) async {
    final shareItems = <ListAlbumShareOutlierShareItem>[];
    final shares =
        (await ListShare(_c)(
          account,
          fileItem.file,
          isIncludeReshare: true,
        )).where((s) => s.shareType == ShareType.user).toList();
    final albumSharees = albumShares.keys.toSet();
    final managedAlbumSharees =
        albumShares.values
            .where(
              (s) => _isItemSharePairOfInterest(account, album, fileItem, s),
            )
            .map((s) => s.userId)
            .toSet();
    _log.info(
      "[_processSingleFileItem] Sharees: ${albumSharees.map((s) => managedAlbumSharees.contains(s) ? "(managed)$s" : s).toReadableString()} for file: ${logFilename(fileItem.file.fdPath)}",
    );

    // check all shares (including reshares) against sharees that are managed by
    // us
    final allSharees = shares.map((s) => s.shareWith!).toSet();
    var missings =
        managedAlbumSharees
            .difference(allSharees)
            // Can't share to ourselves or the file owner
            .where((s) => s != account.userId && s != fileItem.ownerId)
            .toList();
    _log.info(
      "[_processSingleFileItem] Missing shares: ${missings.toReadableString()} for file: ${logFilename(fileItem.file.fdPath)}",
    );
    for (final m in missings) {
      final as = albumShares[m]!;
      shareItems.add(
        ListAlbumShareOutlierMissingShareItem(as.userId, as.displayName),
      );
    }

    // check owned shares against all album sharees. Use all album sharees such
    // that non-managed sharees will not be listed
    final ownedSharees =
        shares
            .where((s) => s.uidOwner == account.userId)
            .map((s) => s.shareWith!)
            .toSet();
    final extras = ownedSharees.difference(albumSharees);
    _log.info(
      "[_processSingleFileItem] Extra shares: ${extras.toReadableString()} for file: ${logFilename(fileItem.file.fdPath)}",
    );
    for (final e in extras) {
      try {
        shareItems.add(
          ListAlbumShareOutlierExtraShareItem(
            shares.firstWhere((s) => s.shareWith == e),
          ),
        );
      } catch (e, stackTrace) {
        _log.severe(
          "[_processSingleFileItem] Failed while processing extra share for file: ${logFilename(fileItem.file.fdPath)}",
          e,
          stackTrace,
        );
        errors.add(e);
      }
    }
    if (shareItems.isNotEmpty) {
      return ListAlbumShareOutlierItem(fileItem.file, shareItems);
    } else {
      return null;
    }
  }

  bool _isItemSharePairOfInterest(
    Account account,
    Album album,
    AlbumItem item,
    AlbumShare share,
  ) {
    if (album.albumFile!.isOwned(account.userId)) {
      // album owner
      return item.addedBy == account.userId ||
          item.addedAt.isBefore(share.sharedAt);
    } else {
      // non album owner
      if (item.addedBy != account.userId) {
        return false;
      } else {
        return share.userId == album.albumFile!.ownerId ||
            !item.addedAt.isBefore(share.sharedAt);
      }
    }
  }

  final DiContainer _c;
}
