part of 'places_browser.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.account, required this.placesController})
    : super(_State.init()) {
    on<_LoadPlaces>(_onLoad);
    on<_Reload>(_onReload);
    on<_TransformItems>(_onTransformItems);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onLoad(_LoadPlaces ev, Emitter<_State> emit) {
    _log.info(ev);
    return Future.wait([
      forEach(
        emit,
        placesController.stream,
        onData:
            (data) =>
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
    final transformedPlaces =
        ev.places.name
            .sorted(_sorter)
            .map((e) => _Item(account: account, place: e))
            .toList();
    final transformedCountries =
        ev.places.countryCode
            .sorted(_sorter)
            .map((e) => _Item(account: account, place: e))
            .toList();
    emit(
      state.copyWith(
        transformedPlaceItems: transformedPlaces,
        transformedCountryItems: transformedCountries,
      ),
    );
  }

  final Account account;
  final PlacesController placesController;
}

int _sorter(LocationGroup a, LocationGroup b) {
  final compare = b.count.compareTo(a.count);
  if (compare == 0) {
    return a.place.compareTo(b.place);
  } else {
    return compare;
  }
}
