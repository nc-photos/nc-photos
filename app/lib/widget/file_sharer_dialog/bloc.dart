part of 'file_sharer_dialog.dart';

@npLog
class _Bloc extends Bloc<_Event, _State> with BlocLogger {
  _Bloc({
    required DiContainer container,
    required this.account,
    required this.files,
  }) : _c = container,
       super(_State.init()) {
    on<_SetMethod>(_onSetMethod);
    on<_SetResult>(_onSetResult);
    on<_SetPublicLinkDetails>(_onSetPublicLinkDetails);
    on<_SetPasswordLinkDetails>(_onSetPasswordLinkDetails);
    on<_CancelFileDownload>(_onCancelFileDownload);

    on<_SetError>(_onSetError);
  }

  @override
  String get tag => _log.fullName;

  @override
  bool Function(dynamic, dynamic)? get shouldLog => (currentState, nextState) {
    currentState = currentState as _State;
    nextState = nextState as _State;
    if (identical(currentState.fileState, nextState.fileState)) {
      return true;
    }
    // don't log download progress
    if (currentState.fileState?.progress != nextState.fileState?.progress) {
      return false;
    }
    return true;
  };

  @override
  void onError(Object error, StackTrace stackTrace) {
    // we need this to prevent onError being triggered recursively
    if (!isClosed && !_isHandlingError) {
      _isHandlingError = true;
      try {
        add(_SetError(error, stackTrace));
      } catch (_) {}
      _isHandlingError = false;
    }
    super.onError(error, stackTrace);
  }

  Future<void> _onSetMethod(_SetMethod ev, Emitter<_State> emit) async {
    _log.info(ev);
    emit(state.copyWith(method: ev.method));
    switch (ev.method) {
      case ShareMethod.file:
        return _doShareFile(emit);
      case ShareMethod.preview:
        return _doSharePreview(emit);
      case ShareMethod.publicLink:
        return _doSharePublicLink(emit);
      case ShareMethod.passwordLink:
        return _doSharePasswordLink(emit);
    }
  }

  void _onSetResult(_SetResult ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(result: ev.result));
  }

  Future<void> _onSetPublicLinkDetails(
    _SetPublicLinkDetails ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    return _doShareLink(emit, albumName: ev.albumName, password: null);
  }

  Future<void> _onSetPasswordLinkDetails(
    _SetPasswordLinkDetails ev,
    Emitter<_State> emit,
  ) {
    _log.info(ev);
    return _doShareLink(emit, albumName: ev.albumName, password: ev.password);
  }

  void _onCancelFileDownload(_CancelFileDownload ev, Emitter<_State> emit) {
    _log.info(ev);
    state.fileState?.download?.cancel();
    emit(
      state.copyWith(fileState: state.fileState?.copyWith(shouldRun: false)),
    );
  }

  void _onSetError(_SetError ev, Emitter<_State> emit) {
    _log.info(ev);
    emit(state.copyWith(error: ExceptionEvent(ev.error, ev.stackTrace)));
  }

  Future<void> _doShareFile(Emitter<_State> emit) async {
    assert(getRawPlatform() == NpPlatform.android);
    emit(state.copyWith(fileState: _FileState.init(count: files.length)));
    final results = <({FileDescriptor file, dynamic result})>[];
    for (final (:i, e: f) in files.withIndex()) {
      emit(
        state.copyWith(
          fileState: state.fileState?.copyWith(index: i, progress: null),
        ),
      );
      try {
        final download = DownloadFile().build(
          account,
          f,
          shouldNotify: false,
          onProgress: (progress) {
            emit(
              state.copyWith(
                fileState: state.fileState?.copyWith(progress: progress),
              ),
            );
          },
        );
        emit(
          state.copyWith(
            fileState: state.fileState?.copyWith(download: download),
          ),
        );
        final result = await download();
        if (state.fileState?.shouldRun == false) {
          throw const JobCanceledException();
        }
        results.add((file: f, result: result));
      } on PermissionException catch (e, stackTrace) {
        _log.warning("[_doShareFile] Permission not granted");
        emit(state.copyWith(error: ExceptionEvent(e, stackTrace)));
        emit(state.copyWith(result: false));
        return;
      } on JobCanceledException catch (_) {
        _log.info("[_doShareFile] Job canceled");
        emit(state.copyWith(result: false));
        return;
      } catch (e, stackTrace) {
        _log.shout("[_doShareFile] Failed while DownloadFile", e, stackTrace);
        emit(state.copyWith(error: ExceptionEvent(e, stackTrace)));
      }
    }
    if (results.isNotEmpty) {
      final share = AndroidFileShare(
        results
            .map((e) => AndroidFileShareFile(e.result as String, e.file.fdMime))
            .toList(),
      );
      unawaited(share.share());
    }
    emit(state.copyWith(result: true));
  }

  Future<void> _doSharePreview(Emitter<_State> emit) async {
    assert(getRawPlatform() == NpPlatform.android);
    emit(
      state.copyWith(
        previewState: _PreviewState(index: 0, count: files.length),
      ),
    );
    final results = <({FileDescriptor file, dynamic result})>[];
    for (final (:i, e: f) in files.withIndex()) {
      emit(
        state.copyWith(previewState: state.previewState?.copyWith(index: i)),
      );
      try {
        final dynamic uri;
        if (file_util.isSupportedImageFormat(f) && f.fdMime != "image/gif") {
          uri = await DownloadPreview()(account, f);
        } else {
          uri = await DownloadFile()(account, f, shouldNotify: false);
        }
        results.add((file: f, result: uri));
      } catch (e, stackTrace) {
        _log.shout(
          "[_doSharePreview] Failed while DownloadPreview",
          e,
          stackTrace,
        );
        emit(state.copyWith(error: ExceptionEvent(e, stackTrace)));
      }
    }
    if (results.isNotEmpty) {
      final share = AndroidFileShare(
        results
            .map((e) => AndroidFileShareFile(e.result as String, e.file.fdMime))
            .toList(),
      );
      unawaited(share.share());
    }
    emit(state.copyWith(result: true));
  }

  Future<void> _doSharePublicLink(Emitter<_State> emit) async {
    emit(state.copyWith(publicLinkState: const _PublicLinkState()));
  }

  void _doSharePasswordLink(Emitter<_State> emit) {
    emit(state.copyWith(passwordLinkState: const _PasswordLinkState()));
  }

  Future<void> _doShareLink(
    Emitter<_State> emit, {
    required String? albumName,
    String? password,
  }) async {
    try {
      final files = await InflateFileDescriptor(_c)(account, this.files);
      final File fileToShare;
      if (files.length == 1) {
        fileToShare = files.first;
      } else {
        _log.info("[_doShareLink] Share as folder: $albumName");
        final path = await _createDir(account, albumName!);
        final count = await _copyFilesToDir(account, files, path);
        if (count != files.length) {
          emit(
            state.copyWith(
              message: L10n.global().copyItemsFailureNotification(
                files.length - count,
              ),
            ),
          );
        }
        final dir = File(path: path, isCollection: true);
        fileToShare = dir;
      }
      await _shareFileAsLink(account, fileToShare, password);
      emit(state.copyWith(message: L10n.global().linkCopiedNotification));
      emit(state.copyWith(result: true));
    } catch (e, stackTrace) {
      _log.severe("[_doShareLink] Uncaught exception", e, stackTrace);
      emit(state.copyWith(error: ExceptionEvent(e, stackTrace)));
      emit(state.copyWith(result: false));
    }
  }

  Future<void> _shareFileAsLink(
    Account account,
    File file,
    String? password,
  ) async {
    final share = await CreateLinkShare(_c.shareRepo)(
      account,
      file,
      password: password,
    );
    await Clipboard.setData(ClipboardData(text: share.url!));

    if (getRawPlatform() == NpPlatform.android) {
      final textShare = AndroidTextShare(share.url!);
      unawaited(textShare.share());
    }
  }

  Future<String> _createDir(Account account, String name) async {
    // add a intermediate dir to allow shared dirs having the same name. Since
    // the dir names are public, we can't add random pre/suffix
    final timestamp = clock.now().millisecondsSinceEpoch;
    final random = Random().nextInt(0xFFFFFF);
    final dirName =
        "${timestamp.toRadixString(16)}-${random.toRadixString(16).padLeft(6, "0")}";
    final path =
        "${remote_storage_util.getRemoteLinkSharesDir(account)}/$dirName/$name";
    await CreateDir(_c.fileRepo)(account, path);
    return path;
  }

  /// Copy [files] to dir and return the copied count
  Future<int> _copyFilesToDir(
    Account account,
    List<File> files,
    String dirPath,
  ) async {
    var count = 0;
    for (final f in files) {
      try {
        await Copy(_c.fileRepo)(account, f, "$dirPath/${f.filename}");
        ++count;
      } catch (e, stackTrace) {
        _log.severe(
          "[_copyFilesToDir] Failed while copying file: $f",
          e,
          stackTrace,
        );
      }
    }
    return count;
  }

  final DiContainer _c;
  final Account account;
  final List<FileDescriptor> files;

  var _isHandlingError = false;
}
