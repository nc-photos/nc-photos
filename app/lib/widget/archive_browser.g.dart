// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_browser.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    List<FileDescriptor>? files,
    bool? isLoading,
    List<_Item>? transformedItems,
    Set<_Item>? selectedItems,
    Set<_VisibleItem>? visibleItems,
    int? zoom,
    double? scale,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic files,
    dynamic isLoading,
    dynamic transformedItems,
    dynamic selectedItems,
    dynamic visibleItems,
    dynamic zoom,
    dynamic scale = copyWithNull,
    dynamic error = copyWithNull,
  }) {
    return _State(
      files: files as List<FileDescriptor>? ?? that.files,
      isLoading: isLoading as bool? ?? that.isLoading,
      transformedItems:
          transformedItems as List<_Item>? ?? that.transformedItems,
      selectedItems: selectedItems as Set<_Item>? ?? that.selectedItems,
      visibleItems: visibleItems as Set<_VisibleItem>? ?? that.visibleItems,
      zoom: zoom as int? ?? that.zoom,
      scale: scale == copyWithNull ? that.scale : scale as double?,
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

extension _$_WrappedArchiveBrowserStateNpLog on _WrappedArchiveBrowserState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.archive_browser._WrappedArchiveBrowserState",
  );
}

extension _$__NpLog on __ {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.archive_browser.__");
}

extension _$_SelectionAppBarNpLog on _SelectionAppBar {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.archive_browser._SelectionAppBar");
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.archive_browser._Bloc");
}

extension _$_ContentListBodyNpLog on _ContentListBody {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.archive_browser._ContentListBody");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_UnarchiveFailedErrorToString on _UnarchiveFailedError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UnarchiveFailedError {count: $count}";
  }
}

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {files: [length: ${files.length}], isLoading: $isLoading, transformedItems: [length: ${transformedItems.length}], selectedItems: {length: ${selectedItems.length}}, visibleItems: {length: ${visibleItems.length}}, zoom: $zoom, scale: ${scale == null ? null : "${scale!.toStringAsFixed(3)}"}, error: $error}";
  }
}

extension _$_LoadItemsToString on _LoadItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_LoadItems {}";
  }
}

extension _$_ReloadToString on _Reload {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Reload {}";
  }
}

extension _$_TransformItemsToString on _TransformItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_TransformItems {items: [length: ${items.length}]}";
  }
}

extension _$_OnItemTransformedToString on _OnItemTransformed {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_OnItemTransformed {items: [length: ${items.length}]}";
  }
}

extension _$_SetSelectedItemsToString on _SetSelectedItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetSelectedItems {items: {length: ${items.length}}}";
  }
}

extension _$_UnarchiveSelectedItemsToString on _UnarchiveSelectedItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_UnarchiveSelectedItems {}";
  }
}

extension _$_StartScalingToString on _StartScaling {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_StartScaling {}";
  }
}

extension _$_EndScalingToString on _EndScaling {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_EndScaling {}";
  }
}

extension _$_SetScaleToString on _SetScale {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetScale {scale: ${scale.toStringAsFixed(3)}}";
  }
}

extension _$_SetErrorToString on _SetError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetError {error: $error, stackTrace: $stackTrace}";
  }
}
