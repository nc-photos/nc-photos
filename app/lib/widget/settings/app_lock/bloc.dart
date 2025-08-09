part of '../app_lock_settings.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({required this.securePrefController})
    : super(
        _State.init(
          appLockType: securePrefController.protectedPageAuthTypeValue,
        ),
      ) {
    on<_SetAppLockType>(_onSetAppLockType);
  }

  @override
  String get tag => _log.fullName;

  void _onSetAppLockType(_SetAppLockType ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(appLockType: ev.value));
  }

  final SecurePrefController securePrefController;
}
