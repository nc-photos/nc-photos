part of 'sharing_browser.dart';

/// List shares to be shown in [SharingBrowser]
@npLog
class _Bloc extends Bloc<_Event, _State> with BlocForEachMixin<_Event, _State> {
  _Bloc({
    required this.account,
    required this.accountPrefController,
    required this.sharingsController,
  }) : super(_State.init()) {
    on<_Init>(_onInit);
    on<_TransformItems>(_onTransformItems);
  }

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    try {
      await _importPotentialSharedAlbum();
    } catch (e, stackTrace) {
      _log.severe(
        "[_onInit] Failed while _importPotentialSharedAlbum",
        e,
        stackTrace,
      );
    }
    unawaited(sharingsController.reload());
    await Future.wait([
      forEach(
        emit,
        sharingsController.stream,
        onData:
            (data) => state.copyWith(items: data.data, isLoading: data.hasNext),
      ),
      forEach(
        emit,
        sharingsController.errorStream,
        onData: (data) => state.copyWith(isLoading: false, error: data),
      ),
    ]);
  }

  Future<void> _onTransformItems(
    _TransformItems ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    // group shares of the same file
    final map = <String, List<SharingStreamShareData>>{};
    for (final i in ev.items) {
      if (i is SharingStreamShareData) {
        final isSharedByMe = (i.share.uidOwner == account.userId);
        final groupKey = "${i.share.path}?$isSharedByMe";
        map[groupKey] ??= <SharingStreamShareData>[];
        map[groupKey]!.add(i);
      }
    }
    final results = <_Item>[];
    // sort and convert the sub-lists
    for (final list in map.values) {
      results.add(
        _Item.fromSharingStreamData(
          account,
          list.sortedBy((e) => e.share.stime).reversed.toList(),
        ),
      );
    }
    // then sort the list itself
    emit(
      state.copyWith(
        transformedItems: results.sortedBy((e) => e.sortTime).reversed.toList(),
      ),
    );
  }

  Future<List<Album>> _importPotentialSharedAlbum() async {
    final c = KiwiContainer().resolve<DiContainer>().copyWith(
      // don't want the potential albums to be cached at this moment
      fileRepo: const OrNull(FileRepo(FileWebdavDataSource())),
      albumRepo: OrNull(AlbumRepo(AlbumRemoteDataSource())),
    );
    try {
      return await ImportPotentialSharedAlbum(c)(
        account,
        accountPrefController.shareFolderValue,
      );
    } catch (e, stackTrace) {
      _log.shout(
        "[_importPotentialSharedAlbum] Failed while ImportPotentialSharedAlbum",
        e,
        stackTrace,
      );
      return [];
    }
  }

  final Account account;
  final AccountPrefController accountPrefController;
  final SharingsController sharingsController;
}
