// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_picker.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<Collection>? collections,
    bool? isLoading,
    List<_Item>? transformedItems,
    Collection? result,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic collections,
    dynamic isLoading,
    dynamic transformedItems,
    dynamic result = copyWithNull,
    dynamic error = copyWithNull,
  }) {
    return _State(
      collections: collections as List<Collection>? ?? that.collections,
      isLoading: isLoading as bool? ?? that.isLoading,
      transformedItems:
          transformedItems as List<_Item>? ?? that.transformedItems,
      result: result == copyWithNull ? that.result : result as Collection?,
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

extension _$_WrappedCollectionPickerStateNpLog
    on _WrappedCollectionPickerState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.collection_picker.collection_picker._WrappedCollectionPickerState",
  );
}

extension _$_NewAlbumViewNpLog on _NewAlbumView {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.collection_picker.collection_picker._NewAlbumView",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.collection_picker.collection_picker._Bloc");
}

extension _$_ItemNpLog on _Item {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.collection_picker.collection_picker._Item");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {collections: [length: ${collections.length}], isLoading: $isLoading, transformedItems: [length: ${transformedItems.length}], result: $result, error: $error}";
  }
}

extension _$_LoadCollectionsToString on _LoadCollections {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadCollections {}";
  }
}

extension _$_TransformItemsToString on _TransformItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformItems {collections: [length: ${collections.length}]}";
  }
}

extension _$_SelectCollectionToString on _SelectCollection {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SelectCollection {collection: $collection}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
