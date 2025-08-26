part of '../export_collection_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.account,
    required this.collectionsController,
    required this.collection,
    required this.items,
    required this.supportedProviders,
  }) : super(_State.init()) {
    on<_FormEvent>(_onFormEvent);

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

  Future<void> _onFormEvent(_FormEvent ev, Emitter<_State> emit) async {
    _log.info("$ev");
    if (ev is _SubmitName) {
      _onSubmitName(ev, emit);
    } else if (ev is _SubmitProvider) {
      _onSubmitProvider(ev, emit);
    } else if (ev is _SubmitForm) {
      await _onSubmitForm(ev, emit);
    }
  }

  void _onSubmitName(_SubmitName ev, Emitter<_State> emit) {
    emit(state.copyWith(formValue: state.formValue.copyWith(name: ev.value)));
  }

  void _onSubmitProvider(_SubmitProvider ev, Emitter<_State> emit) {
    emit(
      state.copyWith(formValue: state.formValue.copyWith(provider: ev.value)),
    );
  }

  Future<void> _onSubmitForm(_SubmitForm ev, Emitter<_State> emit) async {
    emit(state.copyWith(isExporting: true));
    try {
      final exporter = CollectionExporter(
        account,
        collectionsController,
        collection,
        items,
        state.formValue.name,
      );
      final Collection result;
      switch (state.formValue.provider) {
        case _ProviderOption.appAlbum:
          result = await exporter.asAlbum();
          break;
        case _ProviderOption.ncAlbum:
          result = await exporter.asNcAlbum();
          break;
      }
      emit(state.copyWith(result: result));
    } finally {
      emit(state.copyWith(isExporting: false));
    }
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  final Account account;
  final CollectionsController collectionsController;
  final Collection collection;
  final List<CollectionItem> items;
  @keep
  final Set<_ProviderOption> supportedProviders;

  var _isHandlingError = false;
}
