part of 'share_helper.dart';

@npLog
class _Bloc extends Bloc<_Event, _State>
    with BlocLogger, BlocForEachMixin<_Event, _State> {
  _Bloc(this._c, {required this.account}) : super(_State.init()) {
    on<ShareBlocShareFiles>(_onShareFiles);
    on<_SetShareRequestMethod>(_onSetShareRequestMethod);
    on<_SetShareLinkRequestResult>(_onSetShareLinkRequestResult);
  }

  @override
  String get tag => _log.fullName;

  void _onShareFiles(ShareBlocShareFiles ev, _Emitter emit) {
    final isAllRemoteShare = ev.files.every((f) {
      final capability = AnyFileWorkerFactory.capability(f);
      return capability.isPermitted(AnyFileCapability.remoteShare);
    });
    final isAllLocalShare = ev.files.every((f) {
      final capability = AnyFileWorkerFactory.capability(f);
      return capability.isPermitted(AnyFileCapability.localShare);
    });
    if (isAllLocalShare && !isAllRemoteShare) {
      // no more user input needed
      emit(
        state.copyWith(
          doShareRequest: Unique(
            _DoShareRequest(
              ({onProgress, onError, cancelSignal}) => ShareAnyFile(_c).call(
                ev.files,
                account: account,
                method: ShareAnyFileMethod.file,
                onProgress: onProgress,
                onError: onError,
                cancelSignal: cancelSignal,
              ),
            ),
          ),
        ),
      );
    } else {
      final req = _ShareRequest(
        files: ev.files,
        isSupportPerview: ev.files.any((f) {
          final capability = AnyFileWorkerFactory.capability(f);
          return !capability.isPermitted(AnyFileCapability.localShare) &&
              !file_util.isSupportedVideoMime(f.mime ?? "");
        }),
        isSupportRemoteLink: isAllRemoteShare,
      );
      emit(state.copyWith(shareRequest: Unique(req)));
    }
  }

  void _onSetShareRequestMethod(_SetShareRequestMethod ev, _Emitter emit) {
    _log.info(ev);
    switch (ev.method) {
      case ShareMethodDialogResult.file:
        emit(
          state.copyWith(
            doShareRequest: Unique(
              _DoShareRequest(
                ({onProgress, onError, cancelSignal}) => ShareAnyFile(_c).call(
                  ev.request.files,
                  account: account,
                  method: ShareAnyFileMethod.file,
                  onProgress: onProgress,
                  onError: onError,
                  cancelSignal: cancelSignal,
                ),
              ),
            ),
          ),
        );
        break;

      case ShareMethodDialogResult.preview:
        emit(
          state.copyWith(
            doShareRequest: Unique(
              _DoShareRequest(
                ({onProgress, onError, cancelSignal}) => ShareAnyFile(_c).call(
                  ev.request.files,
                  account: account,
                  method: ShareAnyFileMethod.preview,
                  onProgress: onProgress,
                  onError: onError,
                  cancelSignal: cancelSignal,
                ),
              ),
            ),
          ),
        );
        break;

      case ShareMethodDialogResult.publicLink:
        if (ev.request.files.length == 1) {
          emit(
            state.copyWith(
              doShareRequest: Unique(
                _DoShareRequest(
                  ({onProgress, onError, cancelSignal}) =>
                      ShareAnyFile(_c).call(
                        ev.request.files,
                        account: account,
                        method: ShareAnyFileMethod.link,
                        onProgress: onProgress,
                        onError: onError,
                        cancelSignal: cancelSignal,
                      ),
                ),
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(
              shareLinkRequest: Unique(
                _ShareLinkRequest(
                  shareRequest: ev.request,
                  isPasswordProtected: false,
                ),
              ),
            ),
          );
        }
        break;

      case ShareMethodDialogResult.passwordLink:
        emit(
          state.copyWith(
            shareLinkRequest: Unique(
              _ShareLinkRequest(
                shareRequest: ev.request,
                isPasswordProtected: true,
              ),
            ),
          ),
        );
        break;
    }
  }

  void _onSetShareLinkRequestResult(
    _SetShareLinkRequestResult ev,
    _Emitter emit,
  ) {
    _log.info(ev);
    emit(
      state.copyWith(
        doShareRequest: Unique(
          _DoShareRequest(
            ({onProgress, onError, cancelSignal}) => ShareAnyFile(_c).call(
              ev.request.shareRequest.files,
              account: account,
              method: ShareAnyFileMethod.link,
              linkName: ev.name,
              linkPassword: ev.password,
              onProgress: onProgress,
              onError: onError,
              cancelSignal: cancelSignal,
            ),
          ),
        ),
      ),
    );
  }

  final DiContainer _c;
  final Account account;
}
