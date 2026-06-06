part of 'viewer_detail_pane.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.c,
    required this.collectionsController,
    required this.anyFilesController,
    required this.prefController,
    required this.account,
    required AnyFile initialFile,
    required this.fromCollection,
  }) : super(_State.init(file: initialFile)) {
    on<_Init>(_onInit);
    on<_SetAlbumCover>(_onSetAlbumCover);
    on<_SetFile>(_onSetFile);
    on<_FileUpdated>(_onFileUpdated);
    on<_EditDateTime>(_onEditDateTime);
    on<_EditGps>(_onEditGps);

    _subscriptions.add(
      anyFilesController.stream.listen((event) {
        final f = event.data[initialFile.id];
        if (f != null) {
          add(_SetFile(f));
        }
      }),
    );
    _subscriptions.add(
      stream.distinctBy((e) => e.file).skip(1).listen((e) {
        add(const _FileUpdated());
      }),
    );

    add(const _Init());
  }

  @override
  Future<void> close() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    return super.close();
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onInit(_Init ev, _Emitter emit) async {
    _log.info(ev);
    emit(state.copyWith(isLoading: true));
    unawaited(_initCapability(emit));
    unawaited(_initTag(emit));
    try {
      await _initMetadata(emit);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _initMetadata(_Emitter emit) async {
    final metadataGetter = AnyFileContentGetterFactory.metadata(
      state.file,
      c: c,
      account: account,
    );
    SizeInt? size;
    int? byteSize;
    String? model;
    double? fNumber;
    String? exposureTime;
    double? focalLength;
    int? isoSpeedRatings;
    MapCoord? gps;
    ImageLocation? location;
    Duration? offsetTime;
    double? fps;
    Duration? duration;

    /// Convert EXIF data to readable format
    size = await tryOrNullFN(() => metadataGetter.size);
    byteSize = await tryOrNullFN(() => metadataGetter.byteSize);
    model = await tryOrNullFN(() async {
      final rawMake = await metadataGetter.make;
      if (rawMake != null) {
        final rawModel = await metadataGetter.model;
        if (rawModel != null) {
          // some phones also write its make to the model string
          if (rawModel.contains(rawMake)) {
            return rawModel;
          } else {
            return "$rawMake $rawModel";
          }
        }
      }
      return null;
    });
    fNumber = await tryOrNullFN(
      () => metadataGetter.fNumber.then((e) => e?.toDouble()),
    );
    exposureTime = await tryOrNullFN(
      () async => (await metadataGetter.exposureTime)?.let((e) {
        if (e.toDouble() >= 1) {
          return e.toDouble().toStringAsFixedTruncated(1);
        } else {
          final x = e.denominator / e.numerator;
          return "1/${x.toInt()}";
        }
      }),
    );
    focalLength = await tryOrNullFN(
      () => metadataGetter.focalLength.then((e) => e?.toDouble()),
    );
    isoSpeedRatings = await tryOrNullFN(() => metadataGetter.isoSpeedRatings);
    gps = await tryOrNullFN(() => metadataGetter.gpsCoord);
    location = await tryOrNullFN(() => metadataGetter.location);
    offsetTime = await tryOrNullFN(() => metadataGetter.offsetTime);
    fps = await tryOrNullFN(() => metadataGetter.fps);
    duration = await tryOrNullFN(() => metadataGetter.duration);

    emit(
      state.copyWith(
        size: size,
        byteSize: byteSize,
        model: model,
        fNumber: fNumber,
        exposureTime: exposureTime,
        focalLength: focalLength,
        isoSpeedRatings: isoSpeedRatings,
        gps: gps,
        location: location,
        offsetTime: offsetTime,
        fps: fps,
        duration: duration,
      ),
    );
  }

  Future<void> _initTag(_Emitter emit) async {
    final getter = AnyFileContentGetterFactory.tag(
      state.file,
      c: c,
      account: account,
    );
    final tags = await getter.get();
    emit(state.copyWith(tags: tags));
  }

  Future<void> _initCapability(_Emitter emit) async {
    final capability = AnyFileWorkerFactory.capability(state.file);
    var canRemoveFromAlbum =
        fromCollection?.let(
          (e) => CollectionWorkerFactory.isItemRemovable(
            c,
            account,
            e.collection,
          ).isItemRemovable(e.item),
        ) ??
        false;

    var canSetCover =
        fromCollection?.let(
          (e) => CollectionWorkerFactory.isPermitted(
            c,
            account,
            e.collection,
          ).isPermitted(CollectionCapability.manualCover),
        ) ??
        false;
    if (canSetCover) {
      canSetCover = switch (state.file.provider) {
        AnyFileNextcloudProvider _ || AnyFileMergedProvider _ => true,
        AnyFileLocalProvider _ => false,
      };
    }

    var canAddToCollection = capability.isPermitted(
      AnyFileCapability.collection,
    );

    var canDelete = capability.isPermitted(AnyFileCapability.delete);
    if (canDelete && fromCollection != null) {
      canDelete =
          CollectionWorkerFactory.isPermitted(
            c,
            account,
            fromCollection!.collection,
          ).isPermitted(CollectionCapability.deleteItem) &&
          CollectionWorkerFactory.isItemDeletable(
            c,
            account,
            fromCollection!.collection,
          ).isItemDeletable(fromCollection!.item);
    }

    emit(
      state.copyWith(
        canRemoveFromAlbum: canRemoveFromAlbum,
        canSetCover: canSetCover,
        canAddToCollection: canAddToCollection,
        canSetAs:
            getRawPlatform() == NpPlatform.android &&
            file_util.isSupportedImageMime(state.file.mime ?? ""),
        canArchive: capability.isPermitted(AnyFileCapability.archive),
        canDelete: canDelete,
      ),
    );
  }

  Future<void> _onSetAlbumCover(_SetAlbumCover ev, _Emitter emit) async {
    assert(fromCollection != null);
    _log.info(
      "[_onSetAlbumCover] Set '${state.file.displayPath}' as album cover for '${fromCollection!.collection.name}'",
    );
    final f = (state.file.provider as AnyFileNextcloudProvider).file;
    try {
      await collectionsController.edit(
        fromCollection!.collection,
        cover: OrNull(f),
      );
    } catch (e, stackTrace) {
      _log.shout(
        "[_onSetAlbumCover] Failed while updating album",
        e,
        stackTrace,
      );
      emit(
        state.copyWith(
          error: const ExceptionEvent(_SetAlbumCoverFailedError()),
        ),
      );
    }
  }

  void _onSetFile(_SetFile ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(file: ev.file));
  }

  Future<void> _onFileUpdated(_FileUpdated ev, _Emitter emit) async {
    _log.info(ev);
    await _initMetadata(emit);
  }

  Future<void> _onEditDateTime(_EditDateTime ev, _Emitter emit) async {
    _log.info(ev);
    try {
      await UpdateAnyFileMetadata(
        c,
        filesController: anyFilesController.filesController,
        prefController: prefController,
      ).setDateTimeOriginal(
        state.file,
        ev.value,
        account: account,
        onProgress: (step, progress) {
          emit(
            state.copyWith(
              editMetadataProgress: _EditMetadataProgress(
                step: step,
                progress: progress,
              ),
            ),
          );
        },
        onBackedUp: (backupFilename) {
          emit(state.copyWith(editBackupFilename: Unique(backupFilename)));
        },
      );
      emit(state.copyWith(editMetadataProgress: null));
    } catch (e, stackTrace) {
      _log.severe(
        "[_onEditDateTime] Failed while setDateTimeOriginal",
        e,
        stackTrace,
      );
      emit(state.copyWith(editMetadataProgress: null));
      emit(state.copyWith(error: ExceptionEvent(e, stackTrace)));
    }
  }

  Future<void> _onEditGps(_EditGps ev, _Emitter emit) async {
    _log.info(ev);
    try {
      await UpdateAnyFileMetadata(
        c,
        filesController: anyFilesController.filesController,
        prefController: prefController,
      ).setGps(
        state.file,
        ev.value,
        account: account,
        onProgress: (step, progress) {
          emit(
            state.copyWith(
              editMetadataProgress: _EditMetadataProgress(
                step: step,
                progress: progress,
              ),
            ),
          );
        },
        onBackedUp: (backupFilename) {
          emit(state.copyWith(editBackupFilename: Unique(backupFilename)));
        },
      );
      emit(state.copyWith(editMetadataProgress: null));
    } catch (e, stackTrace) {
      _log.severe("[_onEditGps] Failed while setGps", e, stackTrace);
      emit(state.copyWith(editMetadataProgress: null));
      emit(state.copyWith(error: ExceptionEvent(e, stackTrace)));
    }
  }

  final DiContainer c;
  final CollectionsController collectionsController;
  final AnyFilesController anyFilesController;
  final PrefController prefController;
  final Account account;
  final ViewerSingleCollectionData? fromCollection;

  final _subscriptions = <StreamSubscription>[];
}
