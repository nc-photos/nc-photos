part of '../people_browser.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc({required this.account, required this.personsController})
    : super(_State.init()) {
    on<_LoadPersons>(_onLoad);
    on<_Reload>(_onReload);
    on<_TransformItems>(_onTransformItems);
  }

  @override
  String get tag => _log.fullName;

  Future<void> _onLoad(_LoadPersons ev, Emitter<_State> emit) {
    _log.info(ev);
    return Future.wait([
      forEach(
        emit,
        personsController.stream,
        onData:
            (data) =>
                state.copyWith(persons: data.data, isLoading: data.hasNext),
      ),
      forEach(
        emit,
        personsController.errorStream,
        onData: (data) => state.copyWith(isLoading: false, error: data),
      ),
    ]);
  }

  void _onReload(_Reload ev, Emitter<_State> emit) {
    _log.info(ev);
    unawaited(personsController.reload());
  }

  Future<void> _onTransformItems(
    _TransformItems ev,
    Emitter<_State> emit,
  ) async {
    _log.info("[_onTransformItems] $ev");
    final transformed =
        ev.persons.sorted(_sorter).map(_Item.fromPerson).toList();
    emit(state.copyWith(transformedItems: transformed));
  }

  final Account account;
  final PersonsController personsController;
}

int _sorter(Person a, Person b) {
  final countCompare = (b.count ?? 0).compareTo(a.count ?? 0);
  if (countCompare == 0) {
    return a.name.compareTo(b.name);
  } else {
    return countCompare;
  }
}
