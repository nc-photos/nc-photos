// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer_detail_pane.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    AnyFile? file,
    bool? isOwned,
    String? owner,
    SizeInt? size,
    int? byteSize,
    String? model,
    double? fNumber,
    String? exposureTime,
    double? focalLength,
    int? isoSpeedRatings,
    MapCoord? gps,
    ImageLocation? location,
    List<AnyFileTag>? tags,
    Duration? offsetTime,
    double? fps,
    Duration? duration,
    bool? canRemoveFromAlbum,
    bool? canSetCover,
    bool? canAddToCollection,
    bool? canSetAs,
    bool? canArchive,
    bool? canDelete,
    _EditMetadataProgress? editMetadataProgress,
    bool? isLoading,
    ExceptionEvent? error,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic file,
    dynamic isOwned = copyWithNull,
    dynamic owner = copyWithNull,
    dynamic size = copyWithNull,
    dynamic byteSize = copyWithNull,
    dynamic model = copyWithNull,
    dynamic fNumber = copyWithNull,
    dynamic exposureTime = copyWithNull,
    dynamic focalLength = copyWithNull,
    dynamic isoSpeedRatings = copyWithNull,
    dynamic gps = copyWithNull,
    dynamic location = copyWithNull,
    dynamic tags = copyWithNull,
    dynamic offsetTime = copyWithNull,
    dynamic fps = copyWithNull,
    dynamic duration = copyWithNull,
    dynamic canRemoveFromAlbum,
    dynamic canSetCover,
    dynamic canAddToCollection,
    dynamic canSetAs,
    dynamic canArchive,
    dynamic canDelete,
    dynamic editMetadataProgress = copyWithNull,
    dynamic isLoading,
    dynamic error = copyWithNull,
  }) {
    return _State(
      file: file as AnyFile? ?? that.file,
      isOwned: isOwned == copyWithNull ? that.isOwned : isOwned as bool?,
      owner: owner == copyWithNull ? that.owner : owner as String?,
      size: size == copyWithNull ? that.size : size as SizeInt?,
      byteSize: byteSize == copyWithNull ? that.byteSize : byteSize as int?,
      model: model == copyWithNull ? that.model : model as String?,
      fNumber: fNumber == copyWithNull ? that.fNumber : fNumber as double?,
      exposureTime: exposureTime == copyWithNull
          ? that.exposureTime
          : exposureTime as String?,
      focalLength: focalLength == copyWithNull
          ? that.focalLength
          : focalLength as double?,
      isoSpeedRatings: isoSpeedRatings == copyWithNull
          ? that.isoSpeedRatings
          : isoSpeedRatings as int?,
      gps: gps == copyWithNull ? that.gps : gps as MapCoord?,
      location: location == copyWithNull
          ? that.location
          : location as ImageLocation?,
      tags: tags == copyWithNull ? that.tags : tags as List<AnyFileTag>?,
      offsetTime: offsetTime == copyWithNull
          ? that.offsetTime
          : offsetTime as Duration?,
      fps: fps == copyWithNull ? that.fps : fps as double?,
      duration: duration == copyWithNull
          ? that.duration
          : duration as Duration?,
      canRemoveFromAlbum:
          canRemoveFromAlbum as bool? ?? that.canRemoveFromAlbum,
      canSetCover: canSetCover as bool? ?? that.canSetCover,
      canAddToCollection:
          canAddToCollection as bool? ?? that.canAddToCollection,
      canSetAs: canSetAs as bool? ?? that.canSetAs,
      canArchive: canArchive as bool? ?? that.canArchive,
      canDelete: canDelete as bool? ?? that.canDelete,
      editMetadataProgress: editMetadataProgress == copyWithNull
          ? that.editMetadataProgress
          : editMetadataProgress as _EditMetadataProgress?,
      isLoading: isLoading as bool? ?? that.isLoading,
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

extension _$_WrappedViewerDetailPaneStateNpLog
    on _WrappedViewerDetailPaneState {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.viewer_detail_pane.viewer_detail_pane._WrappedViewerDetailPaneState",
  );
}

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger(
    "widget.viewer_detail_pane.viewer_detail_pane._Bloc",
  );
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {file: $file, isOwned: $isOwned, owner: $owner, size: $size, byteSize: $byteSize, model: $model, fNumber: ${fNumber == null ? null : "${fNumber!.toStringAsFixed(3)}"}, exposureTime: $exposureTime, focalLength: ${focalLength == null ? null : "${focalLength!.toStringAsFixed(3)}"}, isoSpeedRatings: $isoSpeedRatings, gps: $gps, location: $location, tags: ${tags == null ? null : "[length: ${tags!.length}]"}, offsetTime: $offsetTime, fps: ${fps == null ? null : "${fps!.toStringAsFixed(3)}"}, duration: $duration, canRemoveFromAlbum: $canRemoveFromAlbum, canSetCover: $canSetCover, canAddToCollection: $canAddToCollection, canSetAs: $canSetAs, canArchive: $canArchive, canDelete: $canDelete, editMetadataProgress: $editMetadataProgress, isLoading: $isLoading, error: $error}";
  }
}

extension _$_InitToString on _Init {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_Init {}";
  }
}

extension _$_SetAlbumCoverToString on _SetAlbumCover {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetAlbumCover {}";
  }
}

extension _$_SetFileToString on _SetFile {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetFile {file: $file}";
  }
}

extension _$_FileUpdatedToString on _FileUpdated {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_FileUpdated {}";
  }
}

extension _$_EditDateTimeToString on _EditDateTime {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_EditDateTime {value: $value}";
  }
}

extension _$_EditGpsToString on _EditGps {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_EditGps {value: $value}";
  }
}

extension _$_SetAlbumCoverFailedErrorToString on _SetAlbumCoverFailedError {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetAlbumCoverFailedError {}";
  }
}

extension _$_EditMetadataProgressToString on _EditMetadataProgress {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_EditMetadataProgress {step: ${step.name}, progress: ${progress.toStringAsFixed(3)}}";
  }
}
