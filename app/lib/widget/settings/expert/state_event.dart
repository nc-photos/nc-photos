part of 'expert_settings.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.isNewHttpEngine,
    required this.isViewerUseOriginalImage,
    this.lastSuccessful,
    this.error,
  });

  factory _State.init({
    required bool isNewHttpEngine,
    required bool isViewerUseOriginalImage,
  }) {
    return _State(
      isNewHttpEngine: isNewHttpEngine,
      isViewerUseOriginalImage: isViewerUseOriginalImage,
    );
  }

  @override
  String toString() => _$toString();

  final bool isNewHttpEngine;
  final bool isViewerUseOriginalImage;
  final _Event? lastSuccessful;

  final ExceptionEvent? error;
}

sealed class _Event {}

@toString
class _Init implements _Event {
  const _Init();

  @override
  String toString() => _$toString();
}

@toString
class _SetError implements _Event {
  const _SetError(this.error, [this.stackTrace]);

  @override
  String toString() => _$toString();

  final Object error;
  final StackTrace? stackTrace;
}

@toString
class _ClearCacheDatabase implements _Event {
  const _ClearCacheDatabase();

  @override
  String toString() => _$toString();
}

@toString
class _SetNewHttpEngine implements _Event {
  const _SetNewHttpEngine(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}

@toString
class _SetViewerUseOriginalImage implements _Event {
  const _SetViewerUseOriginalImage(this.value);

  @override
  String toString() => _$toString();

  final bool value;
}
