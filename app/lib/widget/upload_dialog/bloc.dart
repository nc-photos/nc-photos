part of 'upload_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required this.account,
    required this.prefController,
    required this.accountPrefController,
  }) : super(
         _State.init(
           uploadRelativePath: accountPrefController.uploadRelativePathValue,
           convertConfig:
               prefController.isEnableUploadConvertValue
                   ? ConvertConfig(
                     format: prefController.uploadConvertFormatValue,
                     quality: prefController.uploadConvertQualityValue,
                     downsizeMp: prefController.uploadConvertDownsizeMpValue,
                   )
                   : null,
         ),
       ) {
    on<_SetUploadRelativePath>(_onSetUploadRelativePath);
    on<_SetEnableConvert>(_onSetEnableConvert);
    on<_SetConvertFormat>(_onSetConvertFormat);
    on<_SetConvertQuality>(_onSetConvertQuality);
    on<_SetConvertDownsizeMp>(_onSetConvertDownsizeMp);
    on<_Confirm>(_onConfirm);

    _subscriptions.add(
      prefController.uploadConvertFormatChange.listen((e) {
        add(_SetConvertFormat(e));
      }),
    );
    _subscriptions.add(
      prefController.uploadConvertQualityChange.listen((e) {
        add(_SetConvertQuality(e));
      }),
    );
    _subscriptions.add(
      prefController.uploadConvertDownsizeMpChange.listen((e) {
        add(_SetConvertDownsizeMp(e));
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

  void _onSetUploadRelativePath(_SetUploadRelativePath ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(uploadRelativePath: ev.value));
  }

  void _onSetEnableConvert(_SetEnableConvert ev, _Emitter emit) {
    _log.info(ev);
    emit(
      state.copyWith(
        convertConfig:
            ev.value
                ? ConvertConfig(
                  format: prefController.uploadConvertFormatValue,
                  quality: prefController.uploadConvertQualityValue,
                  downsizeMp: prefController.uploadConvertDownsizeMpValue,
                )
                : null,
      ),
    );
  }

  void _onSetConvertFormat(_SetConvertFormat ev, _Emitter emit) {
    _log.info(ev);
    if (state.convertConfig != null) {
      emit(
        state.copyWith(
          convertConfig: state.convertConfig!.copyWith(format: ev.value),
        ),
      );
    }
  }

  void _onSetConvertQuality(_SetConvertQuality ev, _Emitter emit) {
    _log.info(ev);
    if (state.convertConfig != null) {
      emit(
        state.copyWith(
          convertConfig: state.convertConfig!.copyWith(quality: ev.value),
        ),
      );
    }
  }

  void _onSetConvertDownsizeMp(_SetConvertDownsizeMp ev, _Emitter emit) {
    _log.info(ev);
    if (state.convertConfig != null) {
      emit(
        state.copyWith(
          convertConfig: state.convertConfig!.copyWith(downsizeMp: ev.value),
        ),
      );
    }
  }

  void _onConfirm(_Confirm ev, _Emitter emit) {
    _log.info(ev);
    if (state.uploadRelativePath !=
        accountPrefController.uploadRelativePathValue) {
      accountPrefController.setUploadRelativePath(state.uploadRelativePath);
    }
    if ((state.convertConfig != null) !=
        prefController.isEnableUploadConvertValue) {
      prefController.setEnableUploadConvert(state.convertConfig != null);
    }
    emit(
      state.copyWith(
        result: UploadConfig(
          relativePath: state.uploadRelativePath,
          convertConfig: state.convertConfig,
        ),
      ),
    );
  }

  final Account account;
  final PrefController prefController;
  final AccountPrefController accountPrefController;

  final _subscriptions = <StreamSubscription>[];
}
