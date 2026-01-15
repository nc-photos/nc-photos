import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_pageview/infinite_pageview.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/asset.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/any_files_controller.dart';
import 'package:nc_photos/controller/collection_items_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/live_photo_util.dart';
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/delete_result_snack_bar.dart';
import 'package:nc_photos/widget/disposable.dart';
import 'package:nc_photos/widget/file_content_view/file_content_view.dart';
import 'package:nc_photos/widget/image_editor/image_editor.dart';
import 'package:nc_photos/widget/image_enhancer.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/png_icon.dart';
import 'package:nc_photos/widget/processing_dialog.dart';
import 'package:nc_photos/widget/share_helper/share_helper.dart';
import 'package:nc_photos/widget/slideshow_dialog.dart';
import 'package:nc_photos/widget/slideshow_viewer/slideshow_viewer.dart';
import 'package:nc_photos/widget/upload_dialog/upload_dialog.dart';
import 'package:nc_photos/widget/viewer_detail_pane/viewer_detail_pane.dart';
import 'package:nc_photos/widget/viewer_mixin.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/unique.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'app_bar.dart';
part 'app_bar_buttons.dart';
part 'bloc.dart';
part 'delete_dialog.dart';
part 'detail_pane.dart';
part 'state_event.dart';
part 'type.dart';
part 'view.dart';
part 'viewer.g.dart';
part 'viewer_content_controller.dart';

@genCopyWith
class ViewerPositionInfo {
  const ViewerPositionInfo({
    required this.pageIndex,
    required this.originalFile,
  });

  final int pageIndex;
  final AnyFile originalFile;
}

@toString
class ViewerContentProviderResult {
  const ViewerContentProviderResult({required this.files});

  @override
  String toString() => _$toString();

  @Format(r"${$?.map((e) => e.id).toReadableString()}")
  final List<AnyFile> files;
}

abstract interface class ViewerContentProvider {
  /// Return a fixed amount of file ids near the file [at].
  ///
  /// [count] could be negative, and the returned list should include files
  /// before [at]. The returned list must be sorted in display order. If [count]
  /// is positive, the first element in the result should be the item right
  /// after [at] then going forward. If [count] is negative, the first element
  /// in the result should be the item right before [at] then going backward.
  ///
  /// Caller is allowed to request files beyond the min/max bound. Say if there
  /// are a total of 10 files, caller is allowed to pass values >10 to [count].
  /// Implementations are required to gracefully handle such case without
  /// throwing any errors.
  ///
  /// It is allowed for implementations to return fewer number of results than
  /// requested, even with an empty list.
  Future<ViewerContentProviderResult> getFiles(
    ViewerPositionInfo at,
    int count,
  );

  /// Return a single file at the specified page
  Future<AnyFile> getFile(int page, String afId);

  /// Called when user removed a file returned from [getFiles]
  void notifyFileRemoved(int page, AnyFile file);

  /// Return all file ids, typically for slideshow
  Future<List<String>> listAfIds();
}

class ViewerArguments {
  const ViewerArguments(
    this.contentProvider,
    this.allFilesCount,
    this.initialFile,
    this.initialIndex, {
    this.collectionId,
  });

  final ViewerContentProvider contentProvider;
  final int allFilesCount;
  final FileDescriptor initialFile;
  final int initialIndex;
  final String? collectionId;
}

class Viewer extends StatelessWidget {
  const Viewer({
    super.key,
    required this.contentProvider,
    required this.initialFile,
    this.collectionId,
  });

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => _Bloc(
                KiwiContainer().resolve(),
                account: accountController.account,
                anyFilesController: accountController.anyFilesController,
                filesController: accountController.filesController,
                localFilesController: context.read(),
                collectionsController: accountController.collectionsController,
                prefController: context.read(),
                accountPrefController: accountController.accountPrefController,
                contentProvider: contentProvider,
                initialFile: initialFile,
                brightness: Theme.of(context).brightness,
                collectionId: collectionId,
              )..add(const _Init()),
        ),
        BlocProvider(
          create:
              (_) => ShareBloc(
                KiwiContainer().resolve(),
                account: accountController.account,
              ),
        ),
      ],
      child: const _WrappedViewer(),
    );
  }

  final ViewerContentProvider contentProvider;
  final AnyFile initialFile;

  /// ID of the collection these files belongs to, or null
  final String? collectionId;
}

class _WrappedViewer extends StatefulWidget {
  const _WrappedViewer();

  @override
  State<StatefulWidget> createState() => _WrappedViewerState();
}

@npLog
class _WrappedViewerState extends State<_WrappedViewer>
    with
        DisposableManagerMixin<_WrappedViewer>,
        ViewerControllersMixin<_WrappedViewer>,
        RouteAware,
        PageVisibilityMixin {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MultiBlocListener(
          listeners: [
            _BlocListenerT(
              selector: (state) => state.imageEditorRequest,
              listener: (context, imageEditorRequest) {
                if (imageEditorRequest.value != null) {
                  Navigator.of(context).pushNamed(
                    ImageEditor.routeName,
                    arguments: imageEditorRequest.value,
                  );
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.imageEnhancerRequest,
              listener: (context, imageEnhancerRequest) {
                if (imageEnhancerRequest.value != null) {
                  Navigator.of(context).pushNamed(
                    ImageEnhancer.routeName,
                    arguments: imageEnhancerRequest.value,
                  );
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.shareRequest,
              listener: _onShareRequest,
            ),
            _BlocListenerT(
              selector: (state) => state.startSlideshowRequest,
              listener: (context, startSlideshowRequest) {
                if (startSlideshowRequest.value != null) {
                  _onStartSlideshowRequest(
                    context,
                    startSlideshowRequest.value!,
                  );
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.slideshowRequest,
              listener: (context, slideshowRequest) {
                if (slideshowRequest.value != null) {
                  _onSlideshowRequest(context, slideshowRequest.value!);
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.setAsRequest,
              listener: _onSetAsRequest,
            ),
            _BlocListenerT(
              selector: (state) => state.uploadRequest,
              listener: _onUploadRequest,
            ),
            _BlocListenerT(
              selector: (state) => state.deleteRequest,
              listener: _onDeleteRequest,
            ),
            _BlocListenerT(
              selector: (state) => state.error,
              listener: (context, error) {
                if (error != null && isPageVisible()) {
                  SnackBarManager().showSnackBarForException(error.error);
                }
              },
            ),
          ],
          child: ShareBlocListener(
            child: _BlocSelector(
              selector: (state) => state.isBusy,
              builder:
                  (context, isBusy) => PopScope(
                    canPop: !isBusy,
                    child: _BlocBuilder(
                      buildWhen:
                          (previous, current) =>
                              previous.isShowAppBar != current.isShowAppBar ||
                              previous.isDetailPaneActive !=
                                  current.isDetailPaneActive,
                      builder:
                          (context, state) => Scaffold(
                            extendBodyBehindAppBar: true,
                            extendBody: true,
                            appBar:
                                state.isShowAppBar
                                    ? const PreferredSize(
                                      preferredSize: Size.fromHeight(
                                        kToolbarHeight,
                                      ),
                                      child: _AppBar(),
                                    )
                                    : null,
                            bottomNavigationBar:
                                state.isShowAppBar && !state.isDetailPaneActive
                                    ? const _BottomAppBar()
                                    : null,
                            body: Stack(
                              children: [
                                OrientationBuilder(
                                  builder:
                                      (context, orientation) => _ContentBody(
                                        key: Key(
                                          "viewer._ContentBody.${orientation.name}",
                                        ),
                                      ),
                                ),
                                _BlocSelector(
                                  selector: (state) => state.isBusy,
                                  builder:
                                      (context, isBusy) =>
                                          isBusy
                                              ? AbsorbPointer(
                                                child: ProcessingOverlay(
                                                  text:
                                                      L10n.global()
                                                          .genericProcessingDialogContent,
                                                ),
                                              )
                                              : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onStartSlideshowRequest(
    BuildContext context,
    _StartSlideshowRequest startSlideshowRequest,
  ) async {
    final result = await showDialog<SlideshowConfig>(
      context: context,
      builder:
          (_) => SlideshowDialog(
            duration: context.bloc.prefController.slideshowDurationValue,
            isShuffle: context.bloc.prefController.isSlideshowShuffleValue,
            isRepeat: context.bloc.prefController.isSlideshowRepeatValue,
            isReverse: context.bloc.prefController.isSlideshowReverseValue,
          ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    context.addEvent(_StartSlideshowResult(startSlideshowRequest, result));
  }

  Future<void> _onSlideshowRequest(
    BuildContext context,
    _SlideshowRequest slideshowRequest,
  ) async {
    final newIndex = await Navigator.of(context).pushNamed<int>(
      SlideshowViewer.routeName,
      arguments: SlideshowViewerArguments(
        slideshowRequest.afIds,
        slideshowRequest.startIndex,
        slideshowRequest.collectionId,
        slideshowRequest.config,
      ),
    );
    final relIndex = newIndex?.let(
      (e) => e - slideshowRequest.startIndex + slideshowRequest.fromPage,
    );
    _log.info(
      "[_onSlideshowRequest] Slideshow ended, jump to: $newIndex ($relIndex)",
    );
    if (relIndex != null && context.mounted) {
      context.addEvent(
        _JumpToLastSlideshow(
          index: relIndex,
          afId: slideshowRequest.afIds[newIndex!],
        ),
      );
    }
  }

  void _onShareRequest(
    BuildContext context,
    Unique<_ShareRequest?> shareRequest,
  ) {
    if (shareRequest.value == null) {
      return;
    }
    context.read<ShareBloc>().add(
      ShareBlocShareFiles([shareRequest.value!.file]),
    );
  }

  void _onSetAsRequest(
    BuildContext context,
    Unique<_SetAsRequest?> setAsRequest,
  ) {
    if (setAsRequest.value == null) {
      return;
    }
    final f = setAsRequest.value!.file;
    AnyFileWorkerFactory.setAs(
      f,
      account: context.bloc.account,
      c: context.bloc._c,
    ).setAs(context);
  }

  Future<void> _onUploadRequest(
    BuildContext context,
    Unique<_UploadRequest?> uploadRequest,
  ) async {
    if (uploadRequest.value == null) {
      return;
    }
    final f = uploadRequest.value!.file;
    final config = await showDialog<UploadConfig>(
      context: context,
      builder: (context) => const UploadDialog(),
    );
    if (config == null || !context.mounted) {
      return;
    }
    AnyFileWorkerFactory.upload(
      f,
      account: context.bloc.account,
    ).upload(config.relativePath, convertConfig: config.convertConfig);
  }

  Future<void> _onDeleteRequest(
    BuildContext context,
    Unique<_DeleteRequest?> deleteRequest,
  ) async {
    if (deleteRequest.value == null) {
      return;
    }
    final result = await showDialog<AnyFileRemoveHint>(
      context: context,
      builder: (context) => const _DeleteDialog(),
    );
    if (result == null || !context.mounted) {
      return;
    }
    context.addEvent(
      _DeleteWithHint(file: deleteRequest.value!.file, hint: result),
    );
  }
}

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
