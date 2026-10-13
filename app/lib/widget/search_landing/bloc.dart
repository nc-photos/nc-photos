part of 'search_landing.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({
    required this.account,
    required this.personsController,
    required this.placesController,
    required this.accountPrefController,
    required this.serverController,
    required this.prefController,
    required this.locale,
  }) : super(_State.init()) {
    on<_LoadPersons>(_onLoadPersons);
    on<_TransformPersonItems>(_onTransformPersonItems);
    on<_LoadPlaces>(_onLoadPlaces);
    on<_TransformPlaceItems>(_onTransformPlaceItems);
    on<_SetError>(_onSetError);

    _subscriptions.add(
      prefController.placeSortChange.listen((_) {
        add(_TransformPlaceItems(state.places));
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

  Future<void> _onLoadPersons(_LoadPersons ev, Emitter<_State> emit) {
    _log.info(ev);
    CheckPersonSupport(
      account: account,
      accountPrefController: accountPrefController,
      serverController: serverController,
    ).check().then((e) {
      if (!isClosed) {
        switch (e) {
          case CheckPersonSupportResult.ok:
          case CheckPersonSupportResult.noop:
            break;
          case CheckPersonSupportResult.noServerApp:
            add(const _SetError(ServerAppNotInstalledError()));
            break;
        }
      }
    });
    return Future.wait([
      forEach(
        emit,
        personsController.stream,
        onData: (data) =>
            state.copyWith(persons: data.data, isPersonsLoading: data.hasNext),
      ),
      forEach(
        emit,
        personsController.errorStream,
        onData: (data) => state.copyWith(isPersonsLoading: false, error: data),
      ),
    ]);
  }

  Future<void> _onTransformPersonItems(
    _TransformPersonItems ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    final transformed = ev.persons
        .sorted((a, b) {
          final countCompare = (b.count ?? 0).compareTo(a.count ?? 0);
          if (countCompare == 0) {
            return a.name.compareTo(b.name);
          } else {
            return countCompare;
          }
        })
        .take(10)
        .map(_PersonItem.fromPerson)
        .toList();
    emit(state.copyWith(transformedPersonItems: transformed));
  }

  Future<void> _onLoadPlaces(_LoadPlaces ev, Emitter<_State> emit) {
    _log.info(ev);
    return Future.wait([
      forEach(
        emit,
        placesController.stream,
        onData: (data) =>
            state.copyWith(places: data.data, isPlacesLoading: data.hasNext),
      ),
      forEach(
        emit,
        placesController.errorStream,
        onData: (data) => state.copyWith(isPlacesLoading: false, error: data),
      ),
    ]);
  }

  Future<void> _onTransformPlaceItems(
    _TransformPlaceItems ev,
    Emitter<_State> emit,
  ) async {
    _log.info(ev);
    final sorter = getPlaceSorter(prefController.placeSortValue);
    final transformed = ev.places.name
        .sorted((a, b) => sorter(a, b, locale))
        .take(10)
        .map((e) => _PlaceItem(account: account, place: e))
        .toList();
    emit(state.copyWith(transformedPlaceItems: transformed));
  }

  void _onSetError(_SetError ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error)));
  }

  final Account account;
  final PersonsController personsController;
  final PlacesController placesController;
  final AccountPrefController accountPrefController;
  final ServerController serverController;
  final PrefController prefController;
  final Locale locale;

  final _subscriptions = <StreamSubscription>[];
}
