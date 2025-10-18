part of 'viewer_detail_pane.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> {
  _Bloc({
    required this.c,
    required this.collectionsController,
    required this.account,
    required this.file,
    required this.fromCollection,
  }) : super(_State.init()) {
    on<_Init>(_onInit);
    on<_SetAlbumCover>(_onSetAlbumCover);

    add(const _Init());
  }

  Future<void> _onInit(_Init ev, _Emitter emit) async {
    _log.info(ev);
    await Future.wait([
      _initMetadata(emit),
      _initTag(emit),
      _initCapability(emit),
    ]);
  }

  Future<void> _initMetadata(_Emitter emit) async {
    final metadataGetter = AnyFileContentGetterFactory.metadata(
      file,
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

    /// Convert EXIF data to readable format
    size = await tryOrNullFN(() => metadataGetter.size);
    byteSize = await tryOrNullFN(() => metadataGetter.byteSize);
    model = await tryOrNullFN(() async {
      final rawMake = await metadataGetter.make;
      if (rawMake != null) {
        final rawModel = await metadataGetter.model;
        if (rawModel != null) {
          return "$rawMake $rawModel";
        }
      }
      return null;
    });
    fNumber = await tryOrNullFN(
      () => metadataGetter.fNumber.then((e) => e?.toDouble()),
    );
    exposureTime = await tryOrNullFN(
      () async => (await metadataGetter.exposureTime)?.let((e) {
        if (e.denominator == 1) {
          return e.numerator.toString();
        } else {
          return e.toString();
        }
      }),
    );
    focalLength = await tryOrNullFN(
      () => metadataGetter.focalLength.then((e) => e?.toDouble()),
    );
    isoSpeedRatings = await tryOrNullFN(() => metadataGetter.isoSpeedRatings);
    gps = await tryOrNullFN(() => metadataGetter.gpsCoord);
    location = await tryOrNullFN(() => metadataGetter.location);

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
      ),
    );
  }

  Future<void> _initTag(_Emitter emit) async {
    final getter = AnyFileContentGetterFactory.tag(
      file,
      c: c,
      account: account,
    );
    final tags = await getter.get();
    emit(state.copyWith(tags: tags));
  }

  Future<void> _initCapability(_Emitter emit) async {
    final capability = AnyFileWorkerFactory.capability(file);
    final collectionAdapter = fromCollection?.let(
      (e) => CollectionAdapter.of(c, account, e.collection),
    );

    var canRemoveFromAlbum =
        collectionAdapter?.isItemRemovable(fromCollection!.item) ?? false;

    var canSetCover =
        collectionAdapter?.isPermitted(CollectionCapability.manualCover) ??
        false;
    if (canSetCover) {
      canSetCover = switch (file.provider) {
        AnyFileNextcloudProvider _ || AnyFileMergedProvider _ => true,
        AnyFileLocalProvider _ => false,
      };
    }

    var canAddToCollection = capability.isPermitted(
      AnyFileCapability.collection,
    );

    var canDelete = capability.isPermitted(AnyFileCapability.delete);
    if (canDelete && collectionAdapter != null) {
      canDelete =
          collectionAdapter.isPermitted(CollectionCapability.deleteItem) &&
          collectionAdapter.isItemDeletable(fromCollection!.item);
    }

    emit(
      state.copyWith(
        canRemoveFromAlbum: canRemoveFromAlbum,
        canSetCover: canSetCover,
        canAddToCollection: canAddToCollection,
        canSetAs:
            getRawPlatform() == NpPlatform.android &&
            file_util.isSupportedImageMime(file.mime ?? ""),
        canArchive: capability.isPermitted(AnyFileCapability.archive),
        canDelete: canDelete,
      ),
    );
  }

  Future<void> _onSetAlbumCover(_SetAlbumCover ev, _Emitter emit) async {
    assert(fromCollection != null);
    _log.info(
      "[_onSetAlbumCover] Set '${file.displayPath}' as album cover for '${fromCollection!.collection.name}'",
    );
    final f = (file.provider as AnyFileNextcloudProvider).file;
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

  final DiContainer c;
  final CollectionsController collectionsController;
  final Account account;
  final AnyFile file;
  final ViewerSingleCollectionData? fromCollection;
}
