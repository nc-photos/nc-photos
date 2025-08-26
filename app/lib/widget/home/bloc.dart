part of 'home.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocErrorCatcher<_Event, _State> {
  _Bloc({required this.accountController, required this.account})
    : super(_State.init()) {
    on<_Init>(_onInit);
    on<_ChangePage>(_onChangePage);
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

    try {
      unawaited(
        _importPotentialSharedAlbum().then((value) {
          if (value.isNotEmpty) {
            // check if account changed
            if (accountController.account.compareServerIdentity(account)) {
              accountController.accountPrefController.setNewSharedAlbum(true);
            } else {
              AccountPref.of(account).setNewSharedAlbum(true);
            }
          }
        }),
      );

      // call once to pre-cache the value
      unawaited(
        accountController.serverController.status.first.then((value) {
          _log.info("Server status: $value");
        }),
      );

      if (getRawPlatform() == NpPlatform.android) {
        if (AndroidInfo().sdkInt >= AndroidVersion.TIRAMISU) {
          if (!await Permission.hasReadMedia()) {
            await requestReadMediaForResult();
          }
        }
      }
    } finally {
      emit(state.copyWith(isInitDone: true));
    }
  }

  void _onChangePage(_ChangePage ev, _Emitter emit) {
    _log.info(ev);
    if (ev.value == state.page) {
      if (ev.value == 0) {
        KiwiContainer().resolve<EventBus>().fire(
          const HomePhotos2BackToTopEvent(),
        );
      }
      return;
    }
    emit(state.copyWith(page: ev.value));
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
        accountController.accountPrefController.shareFolderValue,
      );
    } catch (e, stacktrace) {
      _log.shout(
        "[_importPotentialSharedAlbum] Failed while ImportPotentialSharedAlbum",
        e,
        stacktrace,
      );
      return [];
    }
  }

  final AccountController accountController;
  final Account account;

  final _subscriptions = <StreamSubscription>[];
}
