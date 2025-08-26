import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/use_case/person/list_person.dart';
import 'package:np_log/np_log.dart';
import 'package:rxdart/rxdart.dart';

part 'persons_controller.g.dart';

@genCopyWith
class PersonStreamEvent {
  const PersonStreamEvent({required this.data, required this.hasNext});

  final List<Person> data;

  /// If true, the results are intermediate values and may not represent the
  /// latest state
  final bool hasNext;
}

@npLog
class PersonsController {
  PersonsController(
    this._c, {
    required this.account,
    required this.accountPrefController,
  }) {
    _subscriptions.add(
      accountPrefController.personProvider.distinct().listen((event) {
        reload();
      }),
    );
  }

  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _personStreamContorller.close();
  }

  /// Return a stream of [Person]s associated with [account]
  ///
  /// There's no guarantee that the returned list is always sorted in some ways,
  /// callers must sort it by themselves if the ordering is important
  ValueStream<PersonStreamEvent> get stream {
    if (!_isPersonStreamInited) {
      _isPersonStreamInited = true;
      unawaited(_load());
    }
    return _personStreamContorller.stream;
  }

  Stream<ExceptionEvent> get errorStream => _personErrorStreamController.stream;

  Future<void> reload() async {
    if (_isPersonStreamInited) {
      return _load();
    } else {
      _log.warning("[reload] Not inited, ignore");
    }
  }

  Future<void> _load() async {
    var lastData = _personStreamContorller.value.copyWith(hasNext: true);
    _personStreamContorller.add(lastData);
    final completer = Completer();
    ListPerson(_c.withLocalRepo())(
      account,
      accountPrefController.personProviderValue,
    ).listen(
      (results) {
        lastData = PersonStreamEvent(data: results, hasNext: true);
        _personStreamContorller.add(lastData);
      },
      onError: _personErrorStreamController.add,
      onDone: () => completer.complete(),
    );
    await completer.future;
    _personStreamContorller.add(lastData.copyWith(hasNext: false));
  }

  final DiContainer _c;
  final Account account;
  final AccountPrefController accountPrefController;

  final _subscriptions = <StreamSubscription>[];

  var _isPersonStreamInited = false;
  final _personStreamContorller = BehaviorSubject.seeded(
    const PersonStreamEvent(data: [], hasNext: true),
  );
  final _personErrorStreamController =
      StreamController<ExceptionEvent>.broadcast();
}
