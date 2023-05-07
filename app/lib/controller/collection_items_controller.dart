import 'dart:async';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:mutex/mutex.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/event/event.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/list_extension.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/rx_extension.dart';
import 'package:nc_photos/use_case/collection/add_file_to_collection.dart';
import 'package:nc_photos/use_case/collection/list_collection_item.dart';
import 'package:nc_photos/use_case/collection/remove_from_collection.dart';
import 'package:nc_photos/use_case/collection/update_collection_post_load.dart';
import 'package:nc_photos/use_case/remove.dart';
import 'package:np_codegen/np_codegen.dart';
import 'package:rxdart/rxdart.dart';

part 'collection_items_controller.g.dart';

@genCopyWith
class CollectionItemStreamData {
  const CollectionItemStreamData({
    required this.items,
    required this.hasNext,
  });

  final List<CollectionItem> items;

  /// If true, the results are intermediate values and may not represent the
  /// latest state
  final bool hasNext;
}

@npLog
class CollectionItemsController {
  CollectionItemsController(
    this._c, {
    required this.account,
    required this.collection,
    required this.onCollectionUpdated,
  }) {
    _fileRemovedEventListener.begin();
  }

  /// Dispose this controller and release all internal resources
  ///
  /// MUST be called
  void dispose() {
    _fileRemovedEventListener.end();
    _dataStreamController.close();
  }

  /// Subscribe to collection items in [collection]
  ///
  /// The returned stream will emit new list of items whenever there are changes
  /// to the items (e.g., new item, removed item, etc)
  ///
  /// There's no guarantee that the returned list is always sorted in some ways,
  /// callers must sort it by themselves if the ordering is important
  ValueStream<CollectionItemStreamData> get stream {
    if (!_isDataStreamInited) {
      _isDataStreamInited = true;
      unawaited(_load());
    }
    return _dataStreamController.stream;
  }

  /// Peek the stream and return the current value
  CollectionItemStreamData peekStream() => _dataStreamController.stream.value;

  /// Add list of [files] to [collection]
  Future<void> addFiles(List<FileDescriptor> files) async {
    final isInited = _isDataStreamInited;
    final List<FileDescriptor> toAdd;
    if (isInited) {
      toAdd = files
          .where((a) => _dataStreamController.value.items
              .whereType<CollectionFileItem>()
              .every((b) => !a.compareServerIdentity(b.file)))
          .toList();
      _log.info("[addFiles] Adding ${toAdd.length} non duplicated files");
      if (toAdd.isEmpty) {
        return;
      }
      _dataStreamController.addWithValue((value) => value.copyWith(
            items: [
              ...toAdd.map((f) => NewCollectionFileItem(f)),
              ...value.items,
            ],
          ));
    } else {
      toAdd = files;
      _log.info("[addFiles] Adding ${toAdd.length} files");
      if (toAdd.isEmpty) {
        return;
      }
    }

    ExceptionEvent? error;
    final failed = <FileDescriptor>[];
    await _mutex.protect(() async {
      await AddFileToCollection(_c)(
        account,
        collection,
        toAdd,
        onError: (f, e, stackTrace) {
          _log.severe("[addFiles] Exception: ${logFilename(f.strippedPath)}", e,
              stackTrace);
          error ??= ExceptionEvent(e, stackTrace);
          failed.add(f);
        },
        onCollectionUpdated: (value) {
          collection = value;
          onCollectionUpdated(collection);
        },
      );

      if (isInited) {
        error
            ?.run((e) => _dataStreamController.addError(e.error, e.stackTrace));
        var finalize = _dataStreamController.value.items.toList();
        if (failed.isNotEmpty) {
          // remove failed items
          finalize.removeWhere((r) {
            if (r is CollectionFileItem) {
              return failed.any((f) => r.file.compareServerIdentity(f));
            } else {
              return false;
            }
          });
        }
        // convert intermediate items
        finalize = (await finalize.asyncMap((e) async {
          try {
            if (e is NewCollectionFileItem) {
              return await CollectionAdapter.of(_c, account, collection)
                  .adaptToNewItem(e);
            } else {
              return e;
            }
          } catch (e, stackTrace) {
            _log.severe("[addFiles] Item not found in resulting collection: $e",
                e, stackTrace);
            return null;
          }
        }))
            .whereNotNull()
            .toList();
        _dataStreamController.addWithValue((value) => value.copyWith(
              items: finalize,
            ));
      } else if (isInited != _isDataStreamInited) {
        // stream loaded in between this op, reload
        unawaited(_load());
      }
    });
    error?.throwMe();
  }

  /// Remove list of [items] from [collection]
  ///
  /// The items are compared with [identical], so it's required that all the
  /// item instances come from the value stream
  Future<void> removeItems(List<CollectionItem> items) async {
    final isInited = _isDataStreamInited;
    if (isInited) {
      _dataStreamController.addWithValue((value) => value.copyWith(
            items: value.items
                .where((a) => !items.any((b) => identical(a, b)))
                .toList(),
          ));
    }

    ExceptionEvent? error;
    final failed = <CollectionItem>[];
    await _mutex.protect(() async {
      await RemoveFromCollection(_c)(
        account,
        collection,
        items,
        onError: (_, item, e, stackTrace) {
          _log.severe("[removeItems] Exception: $item", e, stackTrace);
          error ??= ExceptionEvent(e, stackTrace);
          failed.add(item);
        },
        onCollectionUpdated: (value) {
          collection = value;
          onCollectionUpdated(collection);
        },
      );

      if (isInited) {
        error
            ?.run((e) => _dataStreamController.addError(e.error, e.stackTrace));
        if (failed.isNotEmpty) {
          _dataStreamController.addWithValue((value) => value.copyWith(
                items: value.items + failed,
              ));
        }
      } else if (isInited != _isDataStreamInited) {
        // stream loaded in between this op, reload
        unawaited(_load());
      }
    });
    error?.throwMe();
  }

  /// Delete list of [files] from your server
  ///
  /// This is a temporary workaround and will be moved away
  Future<void> deleteItems(List<FileDescriptor> files) async {
    final isInited = _isDataStreamInited;
    final List<FileDescriptor> toDelete;
    List<CollectionFileItem>? toDeleteItem;
    if (isInited) {
      final groups = _dataStreamController.value.items.groupListsBy((i) {
        if (i is CollectionFileItem) {
          return !files.any((f) => i.file.compareServerIdentity(f));
        } else {
          return true;
        }
      });
      final retain = groups[true] ?? const [];
      toDeleteItem = groups[false]?.cast<CollectionFileItem>() ?? const [];
      if (toDeleteItem.isEmpty) {
        return;
      }
      _dataStreamController.addWithValue((value) => value.copyWith(
            items: retain,
          ));
      toDelete = toDeleteItem.map((e) => e.file).toList();
    } else {
      toDelete = files;
    }

    ExceptionEvent? error;
    final failed = <CollectionItem>[];
    await _mutex.protect(() async {
      await Remove(_c)(
        account,
        toDelete,
        onError: (i, f, e, stackTrace) {
          _log.severe("[deleteItems] Exception: ${logFilename(f.strippedPath)}",
              e, stackTrace);
          error ??= ExceptionEvent(e, stackTrace);
          if (isInited) {
            failed.add(toDeleteItem![i]);
          }
        },
      );

      if (isInited) {
        error
            ?.run((e) => _dataStreamController.addError(e.error, e.stackTrace));
        if (failed.isNotEmpty) {
          _dataStreamController.addWithValue((value) => value.copyWith(
                items: value.items + failed,
              ));
        }
      } else if (isInited != _isDataStreamInited) {
        // stream loaded in between this op, reload
        unawaited(_load());
      }
    });
    error?.throwMe();
  }

  /// Replace items in the stream, for internal use only
  void forceReplaceItems(List<CollectionItem> items) {
    _dataStreamController.addWithValue((v) => v.copyWith(items: items));
  }

  Future<void> _load() async {
    try {
      List<CollectionItem>? items;
      await for (final r in ListCollectionItem(_c)(account, collection)) {
        items = r;
        _dataStreamController.add(CollectionItemStreamData(
          items: r,
          hasNext: true,
        ));
      }
      if (items != null) {
        _dataStreamController.add(CollectionItemStreamData(
          items: items,
          hasNext: false,
        ));
        final newCollection =
            await UpdateCollectionPostLoad(_c)(account, collection, items);
        if (newCollection != null) {
          onCollectionUpdated(newCollection);
        }
      }
    } catch (e, stackTrace) {
      _dataStreamController
        ..addError(e, stackTrace)
        ..addWithValue((v) => v.copyWith(hasNext: false));
    }
  }

  void _onFileRemovedEvent(FileRemovedEvent ev) {
    // if (account != ev.account) {
    //   return;
    // }
    // final newItems = _dataStreamController.value.items.where((e) {
    //   if (e is CollectionFileItem) {
    //     return !e.file.compareServerIdentity(ev.file);
    //   } else {
    //     return true;
    //   }
    // }).toList();
    // if (newItems.length != _dataStreamController.value.items.length) {
    //   // item of interest
    //   _dataStreamController.addWithValue((value) => value.copyWith(
    //         items: newItems,
    //       ));
    // }
  }

  final DiContainer _c;
  final Account account;
  Collection collection;
  ValueChanged<Collection> onCollectionUpdated;

  var _isDataStreamInited = false;
  final _dataStreamController = BehaviorSubject.seeded(
    const CollectionItemStreamData(
      items: [],
      hasNext: true,
    ),
  );

  late final _fileRemovedEventListener =
      AppEventListener<FileRemovedEvent>(_onFileRemovedEvent);

  final _mutex = Mutex();
}