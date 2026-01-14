// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_helper.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $_StateCopyWithWorker {
  _State call({
    Unique<_ShareRequest?>? shareRequest,
    Unique<_ShareLinkRequest?>? shareLinkRequest,
    Unique<_DoShareRequest?>? doShareRequest,
  });
}

class _$_StateCopyWithWorkerImpl implements $_StateCopyWithWorker {
  _$_StateCopyWithWorkerImpl(this.that);

  @override
  _State call({
    dynamic shareRequest,
    dynamic shareLinkRequest,
    dynamic doShareRequest,
  }) {
    return _State(
      shareRequest:
          shareRequest as Unique<_ShareRequest?>? ?? that.shareRequest,
      shareLinkRequest:
          shareLinkRequest as Unique<_ShareLinkRequest?>? ??
          that.shareLinkRequest,
      doShareRequest:
          doShareRequest as Unique<_DoShareRequest?>? ?? that.doShareRequest,
    );
  }

  final _State that;
}

extension $_StateCopyWith on _State {
  $_StateCopyWithWorker get copyWith => _$copyWith;
  $_StateCopyWithWorker get _$copyWith => _$_StateCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$_BlocNpLog on _Bloc {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("widget.share_helper.share_helper._Bloc");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$_StateToString on _State {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_State {shareRequest: $shareRequest, shareLinkRequest: $shareLinkRequest, doShareRequest: $doShareRequest}";
  }
}

extension _$_SetShareRequestMethodToString on _SetShareRequestMethod {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetShareRequestMethod {request: $request, method: ${method.name}}";
  }
}

extension _$_SetShareLinkRequestResultToString on _SetShareLinkRequestResult {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_SetShareLinkRequestResult {request: $request, name: $name, password: $password}";
  }
}

extension _$ShareBlocShareFilesToString on ShareBlocShareFiles {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "ShareBlocShareFiles {files: [length: ${files.length}]}";
  }
}

extension _$_ShareRequestToString on _ShareRequest {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ShareRequest {files: [length: ${files.length}], isRemoteShareOnly: $isRemoteShareOnly}";
  }
}

extension _$_ShareLinkRequestToString on _ShareLinkRequest {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_ShareLinkRequest {shareRequest: $shareRequest, isPasswordProtected: $isPasswordProtected}";
  }
}

extension _$_DoShareRequestToString on _DoShareRequest {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "_DoShareRequest {functor: $functor}";
  }
}
