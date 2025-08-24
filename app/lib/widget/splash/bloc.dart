part of '../splash.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({required this.prefController, required this.npDb})
    : super(_State.init()) {
    on<_Init>(_onInit);
    on<_ChangelogDismissed>(_onChangelogDismissed);
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

  Future<void> _onInit(_Init ev, Emitter<_State> emit) async {
    _log.info(ev);
    await Future.wait([
      _initNotification(),
      _initFirstRun(),
      _migrateApp(emit),
    ]);
    emit(state.copyWith(isDone: true));
  }

  void _onChangelogDismissed(_ChangelogDismissed ev, Emitter<_State> emit) {
    _log.info(ev);
    _changelogCompleter.complete();
  }

  Future<void> _initNotification() async {
    if (!await Permission.hasPostNotifications()) {
      await requestPostNotificationsForResult();
    }
  }

  Future<void> _initFirstRun() async {
    if (prefController.firstRunTimeValue == null) {
      await prefController.setFirstRunTime(clock.now().toUtc());
    }
  }

  Future<void> _migrateApp(Emitter<_State> emit) async {
    if (_shouldUpgrade()) {
      await _handleUpgrade(emit);
    }
  }

  bool _shouldUpgrade() {
    final lastVersion = prefController.lastVersionValue;
    return lastVersion < k.version;
  }

  Future<void> _handleUpgrade(Emitter<_State> emit) async {
    try {
      final lastVersion = prefController.lastVersionValue;
      unawaited(_showChangelogIfAvailable(lastVersion, emit));
      // begin upgrade while showing the changelog
      try {
        _log.info("[_handleUpgrade] Upgrade: $lastVersion -> ${k.version}");
        await _upgrade(lastVersion, emit);
        _log.info("[_handleUpgrade] Upgrade done");
      } finally {
        // ensure user has closed the changelog
        await _changelogCompleter.future;
      }
    } catch (e, stackTrace) {
      _log.shout("[_handleUpgrade] Failed while upgrade", e, stackTrace);
    } finally {
      await prefController.setLastVersion(k.version);
    }
  }

  Future<void> _showChangelogIfAvailable(
    int lastVersion,
    Emitter<_State> emit,
  ) async {
    if (Changelog.hasContent(lastVersion)) {
      emit(state.copyWith(changelogFromVersion: lastVersion));
    } else {
      _changelogCompleter.complete();
    }
  }

  Future<void> _upgrade(int lastVersion, Emitter<_State> emit) async {
    if (lastVersion < 290) {
      await _upgrade29(lastVersion);
    }
    if (lastVersion < 460) {
      await _upgrade46(lastVersion);
    }
    if (lastVersion < 550) {
      await _upgrade55(lastVersion, emit);
    }
    if (lastVersion < 750) {
      await _upgrade75(lastVersion, emit);
    }
    if (lastVersion < 7700) {
      _upgrade77(lastVersion);
    }
  }

  Future<void> _upgrade29(int lastVersion) async {
    try {
      _log.info("[_upgrade29] clearDefaultCache");
      await CompatV29.clearDefaultCache();
    } catch (e, stackTrace) {
      _log.shout("[_upgrade29] Failed while clearDefaultCache", e, stackTrace);
      // just leave the cache then
    }
  }

  Future<void> _upgrade46(int lastVersion) async {
    try {
      _log.info("[_upgrade46] insertDbAccounts");
      await CompatV46.insertDbAccounts(prefController, npDb);
    } catch (e, stackTrace) {
      _log.shout("[_upgrade46] Failed while clearDefaultCache", e, stackTrace);
      unawaited(prefController.setAccounts(null));
      unawaited(prefController.setCurrentAccountIndex(null));
    }
  }

  Future<void> _upgrade55(int lastVersion, Emitter<_State> emit) async {
    try {
      _log.info("[_upgrade55] migrate DB");
      await CompatV55.migrateDb(
        npDb,
        onProgress: (current, count) {
          if (!isClosed) {
            emit(
              state.copyWith(
                upgradeProgress: current / count,
                upgradeText:
                    L10n.global().migrateDatabaseProcessingNotification,
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      _log.shout("[_upgrade55] Failed while migrateDb", e, stackTrace);
      final accounts = prefController.accountsValue;
      await npDb.clearAndInitWithAccounts(accounts.toDb());
    }
    if (!isClosed) {
      emit(state.copyWith(upgradeProgress: null, upgradeText: null));
    }
  }

  Future<void> _upgrade75(int lastVersion, Emitter<_State> emit) async {
    _log.info("[_upgrade75] migrate DB");
    emit(
      state.copyWith(
        upgradeText: L10n.global().migrateDatabaseProcessingNotification,
      ),
    );
    try {
      await CompatV75.migrateDb(npDb);
    } catch (e, stackTrace) {
      _log.shout("[_upgrade75] Failed while migrateDb", e, stackTrace);
      final accounts = prefController.accountsValue;
      await npDb.clearAndInitWithAccounts(accounts.toDb());
    }
    if (!isClosed) {
      emit(state.copyWith(upgradeText: null));
    }
  }

  void _upgrade77(int lastVersion) {
    _log.info("[_upgrade77] migrate pref");
    try {
      CompatV77.migratePref(prefController);
    } catch (e, stackTrace) {
      _log.shout("[_upgrade77] Failed while migratePref", e, stackTrace);
    }
  }

  final PrefController prefController;
  final NpDb npDb;

  final _subscriptions = <StreamSubscription>[];
  final _changelogCompleter = Completer();
}
