part of '../map_browser.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc(this._c, {required this.account, required this.prefController})
    : super(_Bloc._getInitialState(prefController)) {
    on<_LoadData>(_onLoadData);
    on<_OpenDataRangeControlPanel>(_onOpenDataRangeControlPanel);
    on<_CloseControlPanel>(_onCloseControlPanel);
    on<_SetDateRangeType>(_onSetDateRangeType);
    on<_SetLocalDateRange>(_onSetDateRange);
    on<_SetPrefDateRangeType>(_onSetPrefDateRangeType);
    on<_SetAsDefaultRange>(_onSetAsDefaultRange);
    on<_SetError>(_onSetError);

    _subscriptions.add(
      stream.distinctByIgnoreFirst((state) => state.localDateRange).listen((
        state,
      ) {
        add(const _LoadData());
      }),
    );
    _subscriptions.add(
      prefController.mapDefaultRangeTypeChange.listen((state) {
        add(_SetPrefDateRangeType(_DateRangeType.fromPref(state)));
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

  static _State _getInitialState(PrefController prefController) {
    final dateRangeType = _DateRangeType.fromPref(
      prefController.mapDefaultRangeTypeValue,
    );
    if (dateRangeType == _DateRangeType.custom) {
      final today = clock.now().toDate();
      return _State.init(
        dateRangeType: dateRangeType,
        localDateRange: DateRange(
          from: today.add(
            day: -prefController.mapDefaultCustomRangeValue.inDays,
          ),
          to: today,
          toBound: TimeRangeBound.inclusive,
        ),
      );
    } else {
      return _State.init(
        dateRangeType: dateRangeType,
        localDateRange: _calcDateRange(clock.now().toDate(), dateRangeType),
      );
    }
  }

  Future<void> _onLoadData(_LoadData ev, Emitter<_State> emit) async {
    _log.info(ev);
    // convert local DateRange to TimeRange in UTC
    final localTimeRange = state.localDateRange.toLocalTimeRange();
    final utcTimeRange = localTimeRange.copyWith(
      from: localTimeRange.from?.toUtc(),
      to: localTimeRange.to?.toUtc(),
    );
    final raw = await _c.imageLocationRepo.getLocations(account, utcTimeRange);
    _log.info("[_onLoadData] Loaded ${raw.length} markers");
    if (state.initialPoint == null) {
      final initialPoint = raw.firstOrNull?.let(
        (obj) => MapCoord(obj.latitude, obj.longitude),
      );
      if (initialPoint != null) {
        unawaited(prefController.setMapBrowserPrevPosition(initialPoint));
      }
      emit(
        state.copyWith(
          data: raw.map(_DataPoint.fromImageLatLng).toList(),
          initialPoint: initialPoint,
        ),
      );
    } else {
      emit(state.copyWith(data: raw.map(_DataPoint.fromImageLatLng).toList()));
    }
  }

  void _onOpenDataRangeControlPanel(
    _OpenDataRangeControlPanel ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    emit(state.copyWith(isShowDataRangeControlPanel: true));
  }

  void _onCloseControlPanel(_CloseControlPanel ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(isShowDataRangeControlPanel: false));
  }

  void _onSetDateRangeType(_SetDateRangeType ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        dateRangeType: ev.value,
        localDateRange:
            ev.value == _DateRangeType.custom
                ? null
                : _calcDateRange(clock.now().toDate(), ev.value),
      ),
    );
  }

  void _onSetDateRange(_SetLocalDateRange ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        dateRangeType: _DateRangeType.custom,
        localDateRange: ev.value,
      ),
    );
    if (prefController.mapDefaultRangeTypeValue ==
        PrefMapDefaultRangeType.custom) {
      _updatePrefDefaultCustomRange(ev.value);
    }
  }

  void _onSetPrefDateRangeType(_SetPrefDateRangeType ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(prefDateRangeType: ev.value));
  }

  void _onSetAsDefaultRange(_SetAsDefaultRange ev, Emitter<_State> emit) {
    _log.info(ev);
    prefController.setMapDefaultRangeType(state.dateRangeType.toPref());
    if (state.dateRangeType == _DateRangeType.custom) {
      _updatePrefDefaultCustomRange(state.localDateRange);
    }
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  static DateRange _calcDateRange(Date today, _DateRangeType type) {
    assert(type != _DateRangeType.custom);
    switch (type) {
      case _DateRangeType.thisMonth:
        return DateRange(
          from: today.copyWith(day: 1),
          to: today,
          toBound: TimeRangeBound.inclusive,
        );
      case _DateRangeType.prevMonth:
        if (today.month == 1) {
          return DateRange(
            from: Date(today.year - 1, 12, 1),
            to: Date(today.year - 1, 12, 31),
            toBound: TimeRangeBound.inclusive,
          );
        } else {
          return DateRange(
            from: Date(today.year, today.month - 1, 1),
            to: Date(today.year, today.month, 1).add(day: -1),
            toBound: TimeRangeBound.inclusive,
          );
        }
      case _DateRangeType.thisYear:
        return DateRange(
          from: today.copyWith(month: 1, day: 1),
          to: today,
          toBound: TimeRangeBound.inclusive,
        );
      case _DateRangeType.custom:
        return DateRange(
          from: today,
          to: today,
          toBound: TimeRangeBound.inclusive,
        );
    }
  }

  void _updatePrefDefaultCustomRange(DateRange value) {
    final today = clock.now().toDate();
    final diff = today.difference(value.from!);
    prefController.setMapDefaultCustomRange(diff);
  }

  final DiContainer _c;
  final Account account;
  final PrefController prefController;

  final _subscriptions = <StreamSubscription>[];

  var _isHandlingError = false;
}
