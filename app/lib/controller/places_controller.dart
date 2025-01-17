import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/use_case/list_location_group.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';

part 'places_controller.g.dart';

@genCopyWith
class PlaceStreamEvent {
  const PlaceStreamEvent({
    required this.data,
    required this.hasNext,
  });

  final LocationGroupResult data;

  /// If true, the results are intermediate values and may not represent the
  /// latest state
  final bool hasNext;
}

@npLog
class PlacesController {
  PlacesController(
    this._c, {
    required this.account,
  });

  void dispose() {
    _placeStreamContorller.close();
  }

  /// Return a stream of [Person]s associated with [account]
  ///
  /// There's no guarantee that the returned list is always sorted in some ways,
  /// callers must sort it by themselves if the ordering is important
  ValueStream<PlaceStreamEvent> get stream {
    if (!_isPlaceStreamInited) {
      _isPlaceStreamInited = true;
      unawaited(_load());
    }
    return _placeStreamContorller.stream;
  }

  Stream<ExceptionEvent> get errorStream => _placeErrorStreamController.stream;

  Future<void> reload() async {
    if (_isPlaceStreamInited) {
      return _load();
    } else {
      _log.warning("[reload] Not inited, ignore");
    }
  }

  Future<void> _load() async {
    var lastData = _placeStreamContorller.value.copyWith(hasNext: true);
    _placeStreamContorller.add(lastData);
    final completer = Completer();
    ListLocationGroup(_c.withLocalRepo())(account).asStream().listen(
      (results) {
        lastData = PlaceStreamEvent(
          data: results,
          hasNext: true,
        );
        _placeStreamContorller.add(lastData);
      },
      onError: _placeErrorStreamController.add,
      onDone: () => completer.complete(),
    );
    await completer.future;
    _placeStreamContorller.add(lastData.copyWith(hasNext: false));
  }

  final DiContainer _c;
  final Account account;

  var _isPlaceStreamInited = false;
  final _placeStreamContorller = BehaviorSubject.seeded(
    const PlaceStreamEvent(
      data: LocationGroupResult([], [], [], []),
      hasNext: true,
    ),
  );
  final _placeErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();
}
