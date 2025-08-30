part of 'convert_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.format,
    required this.quality,
    required this.downsizeMp,
  });

  factory _State.init({
    required ConvertFormat format,
    required int quality,
    required double? downsizeMp,
  }) {
    return _State(format: format, quality: quality, downsizeMp: downsizeMp);
  }

  @override
  String toString() => _$toString();

  final ConvertFormat format;
  final int quality;
  final double? downsizeMp;
}

sealed class _Event {}

@toString
class _SetFormat implements _Event {
  const _SetFormat(this.value);

  @override
  String toString() => _$toString();

  final ConvertFormat value;
}

@toString
class _SetQuality implements _Event {
  const _SetQuality(this.value);

  @override
  String toString() => _$toString();

  final int value;
}

@toString
class _SetDownsizeMp implements _Event {
  const _SetDownsizeMp(this.value);

  @override
  String toString() => _$toString();

  final double? value;
}

@toString
class _Save implements _Event {
  const _Save();

  @override
  String toString() => _$toString();
}

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({required this.prefController})
    : super(
        _State.init(
          format: prefController.uploadConvertFormatValue,
          quality: prefController.uploadConvertQualityValue,
          downsizeMp: prefController.uploadConvertDownsizeMpValue,
        ),
      ) {
    on<_SetFormat>(_onSetFormat);
    on<_SetQuality>(_onSetQuality);
    on<_SetDownsizeMp>(_onSetDownsizeMp);
    on<_Save>(_onSave);
  }

  void _onSetFormat(_SetFormat ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(format: ev.value));
  }

  void _onSetQuality(_SetQuality ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(quality: ev.value));
  }

  void _onSetDownsizeMp(_SetDownsizeMp ev, _Emitter emit) {
    _log.info(ev);
    emit(state.copyWith(downsizeMp: ev.value));
  }

  void _onSave(_Save ev, _Emitter emit) {
    _log.info(ev);
    prefController
      ..setUploadConvertFormat(state.format)
      ..setUploadConvertQuality(state.quality)
      ..setUploadConvertDownsizeMp(state.downsizeMp);
  }

  final PrefController prefController;

  final formKey = GlobalKey<FormState>();
}
