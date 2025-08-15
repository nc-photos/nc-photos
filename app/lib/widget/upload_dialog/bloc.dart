part of 'upload_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({required this.account, required this.accountPrefController})
    : super(
        _State.init(
          uploadRelativePath: accountPrefController.uploadRelativePathValue,
        ),
      ) {
    on<_SetUploadRelativePath>(_onSetUploadRelativePath);
    on<_Confirm>(_onConfirm);
  }

  @override
  String get tag => _log.fullName;

  void _onSetUploadRelativePath(_SetUploadRelativePath ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(uploadRelativePath: ev.value));
  }

  void _onConfirm(_Confirm ev, _Emitter emit) {
    _log.info(ev);
    if (state.uploadRelativePath !=
        accountPrefController.uploadRelativePathValue) {
      accountPrefController.setUploadRelativePath(state.uploadRelativePath);
    }
    emit(
      state.copyWith(
        result: UploadConfig(relativePath: state.uploadRelativePath),
      ),
    );
  }

  final Account account;
  final AccountPrefController accountPrefController;
}
