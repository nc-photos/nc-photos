part of 'share_helper.dart';

@genCopyWith
@toString
class _State {
  const _State({
    required this.shareRequest,
    required this.shareLinkRequest,
    required this.doShareRequest,
  });

  factory _State.init() => _State(
    shareRequest: Unique(null),
    shareLinkRequest: Unique(null),
    doShareRequest: Unique(null),
  );

  @override
  String toString() => _$toString();

  final Unique<_ShareRequest?> shareRequest;
  final Unique<_ShareLinkRequest?> shareLinkRequest;
  final Unique<_DoShareRequest?> doShareRequest;
}

sealed class _Event {}

@toString
class _SetShareRequestMethod implements _Event {
  const _SetShareRequestMethod(this.request, this.method);

  @override
  String toString() => _$toString();

  final _ShareRequest request;
  final ShareMethodDialogResult method;
}

@toString
class _SetShareLinkRequestResult implements _Event {
  const _SetShareLinkRequestResult(this.request, {this.name, this.password});

  @override
  String toString() => _$toString();

  final _ShareLinkRequest request;
  final String? name;
  final String? password;
}

@toString
class ShareBlocShareFiles implements _Event {
  const ShareBlocShareFiles(this.files);

  @override
  String toString() => _$toString();

  final List<AnyFile> files;
}
