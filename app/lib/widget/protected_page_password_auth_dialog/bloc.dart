part of 'protected_page_password_auth_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({required this.password}) : _hasher = sha256, super(_State.init()) {
    on<_Submit>(_onSubmit);
  }

  void _onSubmit(_Submit ev, Emitter<_State> emit) {
    _log.info(ev);
    final hash = _hasher.convert(ev.value.codeUnits);
    if (password == null) {
      emit(state.copyWith(setupResult: hash.toString().toCi()));
    } else {
      final isAuth = hash.toString().toCi() == password;
      emit(state.copyWith(isAuthorized: Unique(isAuth)));
    }
  }

  final CiString? password;

  final Hash _hasher;
}
