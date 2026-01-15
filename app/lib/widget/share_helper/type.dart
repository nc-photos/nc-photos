part of 'share_helper.dart';

@toString
class _ShareRequest {
  const _ShareRequest({
    required this.files,
    required this.isSupportPerview,
    required this.isSupportRemoteLink,
  });

  @override
  String toString() => _$toString();

  final List<AnyFile> files;
  final bool isSupportPerview;
  final bool isSupportRemoteLink;
}

@toString
class _ShareLinkRequest {
  const _ShareLinkRequest({
    required this.shareRequest,
    required this.isPasswordProtected,
  });

  @override
  String toString() => _$toString();

  final _ShareRequest shareRequest;
  final bool isPasswordProtected;
}

@toString
class _DoShareRequest {
  const _DoShareRequest(this.functor);

  @override
  String toString() => _$toString();

  final Future<void> Function({
    void Function(ShareAnyFileProgress progress)? onProgress,
    void Function(AnyFile? file, Object error, StackTrace? stackTrace)? onError,
    Stream<void>? cancelSignal,
  })
  functor;
}
