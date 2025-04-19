part of '../collection_picker.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({
    required this.account,
    required this.controller,
  }) : super(_State.init()) {
    on<_LoadCollections>(_onLoad);
    on<_TransformItems>(_onTransformItems);
    on<_SelectCollection>(_onSelectCollection);

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

  Future<void> _onLoad(_LoadCollections ev, Emitter<_State> emit) {
    _log.info(ev);
    return Future.wait([
      forEach(
        emit,
        controller.stream,
        onData: (data) => state.copyWith(
          collections: data.data.map((e) => e.collection).toList(),
          isLoading: data.hasNext,
        ),
      ),
      forEach(
        emit,
        controller.errorStream,
        onData: (data) => state.copyWith(
          isLoading: false,
          error: data,
        ),
      ),
    ]);
  }

  void _onTransformItems(_TransformItems ev, Emitter<_State> emit) {
    _log.info(ev);
    final transformed = _transformCollections(ev.collections);
    emit(state.copyWith(transformedItems: transformed));
  }

  void _onSelectCollection(_SelectCollection ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(result: ev.collection));
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  List<_Item> _transformCollections(List<Collection> collections) {
    final sorted = collections
        .where((c) => CollectionAdapter.of(
                KiwiContainer().resolve<DiContainer>(), account, c)
            .isPermitted(CollectionCapability.manualItem))
        .sortedBy(collection_util.CollectionSort.dateDescending);
    return sorted.map(_Item.fromCollection).toList();
  }

  final Account account;
  final CollectionsController controller;

  var _isHandlingError = false;
}
