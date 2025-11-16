// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_browser.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<SharingStreamData>? items,
    bool? isLoading,
    List<_Item>? transformedItems,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic items,
    dynamic isLoading,
    dynamic transformedItems,
    dynamic error = copyWithNull,
  }) {
    return _State(
      items: items as List<SharingStreamData>? ?? that.items,
      isLoading: isLoading as bool? ?? that.isLoading,
      transformedItems:
          transformedItems as List<_Item>? ?? that.transformedItems,
      error: error == copyWithNull ? that.error : error as ExceptionEvent?,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_WrappedSharingBrowserStateNpLog on _WrappedSharingBrowserState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.sharing_browser.sharing_browser._WrappedSharingBrowserState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.sharing_browser.sharing_browser._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {items: [length: ${items.length}], isLoading: $isLoading, transformedItems: [length: ${transformedItems.length}], error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_TransformItemsToString on _TransformItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformItems {items: [length: ${items.length}]}";
  }
}

extension _$_ListSharingBlocShareRemovedToString
    on _ListSharingBlocShareRemoved {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ListSharingBlocShareRemoved {shares: ${shares.toReadableString()}}";
  }
}

extension _$_ListSharingBlocPendingSharedAlbumMovedToString
    on _ListSharingBlocPendingSharedAlbumMoved {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ListSharingBlocPendingSharedAlbumMoved {account: $account, file: ${file.path}, destination: $destination}";
  }
}
