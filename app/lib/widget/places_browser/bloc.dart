part of 'places_browser.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({
    required this.account,
    required this.placesController,
    required this.prefController,
    required this.locale,
  }) : super(_State.init(sort: prefController.placeSortValue)) {
    on<_LoadPlaces>(_onLoad);
    on<_Reload>(_onReload);
    on<_TransformItems>(_onTransformItems);
    on<_SetSort>(_onSetSort);

    _subscriptions.add(
      stream
          .distinct((a, b) => a.places == b.places && a.sort == b.sort)
          .listen((e) {
            add(_TransformItems(state.places));
          }),
    );
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

  Future<void> _onLoad(_LoadPlaces ev, Emitter<_State> emit) {
    _log.info(ev);
    return Future.wait([
      forEach(
        emit,
        placesController.stream,
        onData: (data) =>
            state.copyWith(places: data.data, isLoading: data.hasNext),
      ),
      forEach(
        emit,
        placesController.errorStream,
        onData: (data) => state.copyWith(isLoading: false, error: data),
      ),
    ]);
  }

  void _onReload(_Reload ev, Emitter<_State> emit) {
    _log.info(ev);
    unawaited(placesController.reload());
  }

  Future<void> _onTransformItems(
    _TransformItems ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    final sorter = getPlaceSorter(state.sort);
    final transformedPlaces = ev.places.name
        .sorted((a, b) => sorter(a, b, locale))
        .map((e) => _Item(account: account, place: e))
        .toList();
    final transformedCountries = ev.places.countryCode
        .sorted((a, b) => sorter(a, b, locale))
        .map((e) => _Item(account: account, place: e))
        .toList();
    emit(
      state.copyWith(
        transformedPlaceItems: transformedPlaces,
        transformedCountryItems: transformedCountries,
      ),
    );
  }

  void _onSetSort(_SetSort ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(sort: ev.sort));
    unawaited(prefController.setPlaceSort(ev.sort));
  }

  final Account account;
  final PlacesController placesController;
  final PrefController prefController;
  final Locale locale;

  final _subscriptions = <StreamSubscription>[];
}
