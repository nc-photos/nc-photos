// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slideshow_viewer.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    bool? hasInit,
    int? page,
    int? nextPage,
    bool? shouldAnimateNextPage,
    Map<String, AnyFile>? anyFiles,
    Map<int, CollectionFileItem>? collectionItems,
    List<AnyFile?>? files,
    AnyFile? currentFile,
    bool? isShowUi,
    bool? isPlay,
    bool? isVideoCompleted,
    bool? hasPrev,
    bool? hasNext,
    bool? isShowTimeline,
    bool? hasShownTimeline,
    bool? hasRequestExit,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic hasInit,
    dynamic page,
    dynamic nextPage,
    dynamic shouldAnimateNextPage,
    dynamic anyFiles,
    dynamic collectionItems = copyWithNull,
    dynamic files,
    dynamic currentFile = copyWithNull,
    dynamic isShowUi,
    dynamic isPlay,
    dynamic isVideoCompleted,
    dynamic hasPrev,
    dynamic hasNext,
    dynamic isShowTimeline,
    dynamic hasShownTimeline,
    dynamic hasRequestExit,
  }) {
    return _State(
      hasInit: hasInit as bool? ?? that.hasInit,
      page: page as int? ?? that.page,
      nextPage: nextPage as int? ?? that.nextPage,
      shouldAnimateNextPage:
          shouldAnimateNextPage as bool? ?? that.shouldAnimateNextPage,
      anyFiles: anyFiles as Map<String, AnyFile>? ?? that.anyFiles,
      collectionItems:
          collectionItems == copyWithNull
              ? that.collectionItems
              : collectionItems as Map<int, CollectionFileItem>?,
      files: files as List<AnyFile?>? ?? that.files,
      currentFile:
          currentFile == copyWithNull
              ? that.currentFile
              : currentFile as AnyFile?,
      isShowUi: isShowUi as bool? ?? that.isShowUi,
      isPlay: isPlay as bool? ?? that.isPlay,
      isVideoCompleted: isVideoCompleted as bool? ?? that.isVideoCompleted,
      hasPrev: hasPrev as bool? ?? that.hasPrev,
      hasNext: hasNext as bool? ?? that.hasNext,
      isShowTimeline: isShowTimeline as bool? ?? that.isShowTimeline,
      hasShownTimeline: hasShownTimeline as bool? ?? that.hasShownTimeline,
      hasRequestExit: hasRequestExit as bool? ?? that.hasRequestExit,
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

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.slideshow_viewer.slideshow_viewer._Bloc");
}

extension _$_BodyNpLog on _Body {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.slideshow_viewer.slideshow_viewer._Body");
}

extension _$_PageViewNpLog on _PageView {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.slideshow_viewer.slideshow_viewer._PageView",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {hasInit: $hasInit, page: $page, nextPage: $nextPage, shouldAnimateNextPage: $shouldAnimateNextPage, anyFiles: {length: ${anyFiles.length}}, collectionItems: ${collectionItems == null ? null : "{length: ${collectionItems!.length}}"}, files: [length: ${files.length}], currentFile: $currentFile, isShowUi: $isShowUi, isPlay: $isPlay, isVideoCompleted: $isVideoCompleted, hasPrev: $hasPrev, hasNext: $hasNext, isShowTimeline: $isShowTimeline, hasShownTimeline: $hasShownTimeline, hasRequestExit: $hasRequestExit}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_MergeFilesToString on _MergeFiles {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_MergeFiles {}";
  }
}

extension _$_ToggleShowUiToString on _ToggleShowUi {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleShowUi {}";
  }
}

extension _$_PreloadSidePagesToString on _PreloadSidePages {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_PreloadSidePages {center: $center}";
  }
}

extension _$_VideoCompletedToString on _VideoCompleted {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_VideoCompleted {}";
  }
}

extension _$_SetPauseToString on _SetPause {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPause {}";
  }
}

extension _$_SetPlayToString on _SetPlay {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetPlay {}";
  }
}

extension _$_RequestPrevPageToString on _RequestPrevPage {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RequestPrevPage {}";
  }
}

extension _$_RequestNextPageToString on _RequestNextPage {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RequestNextPage {}";
  }
}

extension _$_SetCurrentPageToString on _SetCurrentPage {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCurrentPage {value: $value}";
  }
}

extension _$_NextPageToString on _NextPage {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_NextPage {value: $value}";
  }
}

extension _$_ToggleTimelineToString on _ToggleTimeline {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ToggleTimeline {}";
  }
}

extension _$_RequestPageToString on _RequestPage {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RequestPage {value: $value}";
  }
}

extension _$_RequestExitToString on _RequestExit {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_RequestExit {}";
  }
}

extension _$_SetCollectionItemsToString on _SetCollectionItems {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetCollectionItems {value: ${value == null ? null : "[length: ${value!.length}]"}}";
  }
}
