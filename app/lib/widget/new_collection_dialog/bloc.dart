part of 'new_collection_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.account,
    required Set<_ProviderOption> supportedProviders,
  }) : super(
         _State.init(account: account, supportedProviders: supportedProviders),
       ) {
    on<_FormEvent>(_onFormEvent);
    on<_HideDialog>(_onHideDialog);

    on<_SetError>(_onSetError);
  }

  @override
  String get tag => _log.fullName;

  @override
  void onError(Object error, StackTrace stackTrace) {
    // we need this to prevent onError being triggered recursively
    if (!isClosed && !_isHandlingError) {
      _isHandlingError = true;
      try {
        add(_SetError(error, stackTrace));
      } catch (_) {}
      _isHandlingError = false;
    }
    super.onError(error, stackTrace);
  }

  void _onFormEvent(_FormEvent ev, Emitter<_State> emit) {
    _log.info("$ev");
    if (ev is _SubmitName) {
      _onSubmitName(ev, emit);
    } else if (ev is _SubmitProvider) {
      _onSubmitProvider(ev, emit);
    } else if (ev is _SubmitDirs) {
      _onSubmitDirs(ev, emit);
    } else if (ev is _SubmitTags) {
      _onSubmitTags(ev, emit);
    } else if (ev is _SubmitForm) {
      _onSubmitForm(ev, emit);
    }
  }

  void _onHideDialog(_HideDialog ev, Emitter<_State> emit) {
    _log.info("$ev");
    emit(state.copyWith(showDialog: false));
  }

  void _onSubmitName(_SubmitName ev, Emitter<_State> emit) {
    emit(state.copyWith(formValue: state.formValue.copyWith(name: ev.value)));
  }

  void _onSubmitProvider(_SubmitProvider ev, Emitter<_State> emit) {
    emit(
      state.copyWith(formValue: state.formValue.copyWith(provider: ev.value)),
    );
  }

  void _onSubmitDirs(_SubmitDirs ev, Emitter<_State> emit) {
    emit(state.copyWith(formValue: state.formValue.copyWith(dirs: ev.value)));
  }

  void _onSubmitTags(_SubmitTags ev, Emitter<_State> emit) {
    emit(state.copyWith(formValue: state.formValue.copyWith(tags: ev.value)));
  }

  void _onSubmitForm(_SubmitForm ev, Emitter<_State> emit) {
    emit(
      state.copyWith(
        result: Collection(
          name: state.formValue.name,
          contentProvider: _buildProvider(),
        ),
      ),
    );
    unawaited(
      AccountPref.of(
        account,
      ).setLastNewCollectionType(state.formValue.provider.index),
    );
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  CollectionContentProvider _buildProvider() {
    switch (state.formValue.provider) {
      case _ProviderOption.appAlbum:
        return CollectionAlbumProvider(
          account: account,
          album: Album(
            name: state.formValue.name,
            provider: AlbumStaticProvider(items: const []),
            coverProvider: const AlbumAutoCoverProvider(),
            sortProvider: const AlbumTimeSortProvider(isAscending: false),
          ),
        );

      case _ProviderOption.dir:
        return CollectionAlbumProvider(
          account: account,
          album: Album(
            name: state.formValue.name,
            provider: AlbumDirProvider(dirs: state.formValue.dirs),
            coverProvider: const AlbumAutoCoverProvider(),
            sortProvider: const AlbumTimeSortProvider(isAscending: false),
          ),
        );

      case _ProviderOption.tag:
        return CollectionAlbumProvider(
          account: account,
          album: Album(
            name: state.formValue.name,
            provider: AlbumTagProvider(tags: state.formValue.tags),
            coverProvider: const AlbumAutoCoverProvider(),
            sortProvider: const AlbumTimeSortProvider(isAscending: false),
          ),
        );

      case _ProviderOption.ncAlbum:
        return CollectionNcAlbumProvider(
          account: account,
          album: NcAlbum.createNew(
            account: account,
            name: state.formValue.name,
          ),
        );
    }
  }

  final Account account;

  var _isHandlingError = false;
}
