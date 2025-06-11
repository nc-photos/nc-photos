part of '../slideshow_viewer.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.hasInit,
    required this.page,
    required this.nextPage,
    required this.shouldAnimateNextPage,
    required this.remoteFiles,
    required this.localFiles,
    this.collectionItems,
    required this.files,
    this.currentFile,
    required this.isShowUi,
    required this.isPlay,
    required this.isVideoCompleted,
    required this.hasPrev,
    required this.hasNext,
    required this.isShowTimeline,
    required this.hasShownTimeline,
    required this.hasRequestExit,
  });

  factory _State.init() => const _State(
    hasInit: false,
    page: 0,
    nextPage: 0,
    shouldAnimateNextPage: true,
    remoteFiles: [],
    localFiles: [],
    files: [],
    isShowUi: false,
    isPlay: true,
    isVideoCompleted: false,
    hasPrev: false,
    hasNext: false,
    isShowTimeline: false,
    hasShownTimeline: false,
    hasRequestExit: false,
  );

  @override
  String toString() => _$toString();

  final bool hasInit;
  final int page;
  final int nextPage;
  final bool shouldAnimateNextPage;
  final List<FileDescriptor> remoteFiles;
  final List<LocalFile> localFiles;
  final Map<int, CollectionFileItem>? collectionItems;
  final List<AnyFile?> files;
  final AnyFile? currentFile;

  final bool isShowUi;
  final bool isPlay;
  final bool isVideoCompleted;
  final bool hasPrev;
  final bool hasNext;
  final bool isShowTimeline;
  final bool hasShownTimeline;
  final bool hasRequestExit;
}

abstract class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
/// Merge regular files with collection items. The point of doing this is to
/// support shared files in an server side shared album, as these files do not
/// have a record in filesController
class _MergeFiles implements _Event {
  const _MergeFiles();

  @override
  String toString() => _$toString();
}

@toString
class _ToggleShowUi implements _Event {
  const _ToggleShowUi();

  @override
  String toString() => _$toString();
}

@toString
class _PreloadSidePages implements _Event {
  const _PreloadSidePages(this.center);

  @override
  String toString() => _$toString();

  final int center;
}

@toString
class _VideoCompleted implements _Event {
  const _VideoCompleted();

  @override
  String toString() => _$toString();
}

@toString
class _SetPause implements _Event {
  const _SetPause();

  @override
  String toString() => _$toString();
}

@toString
class _SetPlay implements _Event {
  const _SetPlay();

  @override
  String toString() => _$toString();
}

@toString
class _RequestPrevPage implements _Event {
  const _RequestPrevPage();

  @override
  String toString() => _$toString();
}

@toString
class _RequestNextPage implements _Event {
  const _RequestNextPage();

  @override
  String toString() => _$toString();
}

@toString
class _SetCurrentPage implements _Event {
  const _SetCurrentPage(this.value);

  @override
  String toString() => _$toString();

  final int value;
}

@toString
class _NextPage implements _Event {
  const _NextPage(this.value);

  @override
  String toString() => _$toString();

  final int value;
}

@toString
class _ToggleTimeline implements _Event {
  const _ToggleTimeline();

  @override
  String toString() => _$toString();
}

@toString
class _RequestPage implements _Event {
  const _RequestPage(this.value);

  @override
  String toString() => _$toString();

  final int value;
}

@toString
class _RequestExit implements _Event {
  const _RequestExit();

  @override
  String toString() => _$toString();
}

@toString
class _SetCollectionItems implements _Event {
  const _SetCollectionItems(this.value);

  @override
  String toString() => _$toString();

  final List<CollectionItem>? value;
}
