import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/toast.dart';
import 'package:nc_photos/use_case/any_file/share_any_file.dart';
import 'package:nc_photos/widget/download_progress_dialog.dart';
import 'package:nc_photos/widget/processing_dialog.dart';
import 'package:nc_photos/widget/share_link_multiple_files_dialog.dart';
import 'package:nc_photos/widget/share_method_dialog.dart';
import 'package:nc_photos/widget/simple_input_dialog.dart';
import 'package:np_common/unique.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'share_helper.g.dart';
part 'state_event.dart';
part 'type.dart';

typedef ShareBloc = _Bloc;

class ShareBlocListener extends StatelessWidget {
  const ShareBlocListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.shareRequest,
          listener: _onShareRequest,
        ),
        _BlocListenerT(
          selector: (state) => state.shareLinkRequest,
          listener: _onShareLinkRequest,
        ),
        _BlocListenerT(
          selector: (state) => state.doShareRequest,
          listener: _onDoShareRequest,
        ),
      ],
      child: child,
    );
  }

  Future<void> _onShareRequest(
    BuildContext context,
    Unique<_ShareRequest?> shareRequest,
  ) async {
    if (shareRequest.value == null) {
      return;
    }
    final result = await showDialog<ShareMethodDialogResult>(
      context: context,
      builder:
          (context) => ShareMethodDialog(
            isSupportRemoteLink: shareRequest.value!.isRemoteShareOnly,
          ),
    );
    if (result == null || !context.mounted) {
      return;
    }
    context.addEvent(_SetShareRequestMethod(shareRequest.value!, result));
  }

  Future<void> _onShareLinkRequest(
    BuildContext context,
    Unique<_ShareLinkRequest?> shareLinkRequest,
  ) async {
    if (shareLinkRequest.value == null) {
      return;
    }
    // ask for link share details
    if (shareLinkRequest.value!.shareRequest.files.length == 1) {
      final result = await showDialog<String>(
        context: context,
        builder:
            (context) => SimpleInputDialog(
              hintText: L10n.global().passwordInputHint,
              buttonText: MaterialLocalizations.of(context).okButtonLabel,
              validator: (value) {
                if (value?.isNotEmpty != true) {
                  return L10n.global().passwordInputInvalidEmpty;
                }
                return null;
              },
              obscureText: true,
            ),
      );
      if (result == null || !context.mounted) {
        return;
      }
      context.addEvent(
        _SetShareLinkRequestResult(shareLinkRequest.value!, password: result),
      );
    } else {
      final result = await showDialog<ShareLinkMultipleFilesDialogResult>(
        context: context,
        builder:
            (_) => ShareLinkMultipleFilesDialog(
              shouldAskPassword: shareLinkRequest.value!.isPasswordProtected,
            ),
      );
      if (result == null || !context.mounted) {
        return;
      }
      context.addEvent(
        _SetShareLinkRequestResult(
          shareLinkRequest.value!,
          name: result.albumName,
          password: result.password,
        ),
      );
    }
  }

  Future<void> _onDoShareRequest(
    BuildContext context,
    Unique<_DoShareRequest?> doShareRequest,
  ) async {
    if (doShareRequest.value == null) {
      return;
    }
    final controller = StreamController<ShareAnyFileProgress>();
    final cancelSignal = StreamController<void>();
    BuildContext? dialogContext;
    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          dialogContext = context;
          return PopScope(
            canPop: false,
            child: StreamBuilder(
              stream: controller.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ProcessingDialog(
                    text: L10n.global().genericProcessingDialogContent,
                  );
                } else {
                  final progress = snapshot.requireData;
                  return DownloadProgressDialog(
                    max: progress.max,
                    current: progress.current,
                    progress: 0,
                    label: progress.filename,
                    onCancel: () {
                      cancelSignal.add(null);
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
    try {
      var hasShowError = false;
      await doShareRequest.value!.functor(
        onProgress: (progress) {
          controller.add(progress);
        },
        onError: (file, error, stackTrace) {
          if (!hasShowError) {
            hasShowError = true;
            AppToast.showToast(
              context,
              msg: exception_util.toUserString(error),
              duration: k.snackBarDurationNormal,
            );
          }
        },
        cancelSignal: cancelSignal.stream,
      );
    } on InterruptedException {
      // user canceled
    } finally {
      if (dialogContext != null) {
        Navigator.maybeOf(dialogContext!)?.pop();
      }
      unawaited(controller.close());
      unawaited(cancelSignal.close());
    }
  }

  final Widget child;
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
// typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
