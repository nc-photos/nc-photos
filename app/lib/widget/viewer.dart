import 'dart:async';
import 'dart:math';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/asset.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/collection_items_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/download_handler.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/flutter_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/live_photo_util.dart';
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/set_as_handler.dart';
import 'package:nc_photos/share_handler.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/disposable.dart';
import 'package:nc_photos/widget/file_content_view.dart';
import 'package:nc_photos/widget/handler/remove_selection_handler.dart';
import 'package:nc_photos/widget/horizontal_page_viewer.dart';
import 'package:nc_photos/widget/image_editor.dart';
import 'package:nc_photos/widget/image_enhancer.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/png_icon.dart';
import 'package:nc_photos/widget/slideshow_dialog.dart';
import 'package:nc_photos/widget/slideshow_viewer.dart';
import 'package:nc_photos/widget/viewer_detail_pane.dart';
import 'package:nc_photos/widget/viewer_mixin.dart';
import 'package:np_codegen/np_codegen.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/unique.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'viewer.g.dart';
part 'viewer/app_bar.dart';
part 'viewer/app_bar_buttons.dart';
part 'viewer/bloc.dart';
part 'viewer/detail_pane.dart';
part 'viewer/state_event.dart';
part 'viewer/type.dart';
part 'viewer/view.dart';

class ViewerArguments {
  const ViewerArguments(
    this.fileIds,
    this.startIndex, {
    this.collectionId,
  });

  final List<int> fileIds;
  final int startIndex;
  final String? collectionId;
}

class Viewer extends StatelessWidget {
  static const routeName = "/viewer";

  static Route buildRoute(ViewerArguments args, RouteSettings settings) =>
      CustomizableMaterialPageRoute(
        transitionDuration: k.heroDurationNormal,
        reverseTransitionDuration: k.heroDurationNormal,
        builder: (_) => Viewer.fromArgs(args),
        settings: settings,
      );

  const Viewer({
    super.key,
    required this.fileIds,
    required this.startIndex,
    this.collectionId,
  });

  Viewer.fromArgs(ViewerArguments args, {Key? key})
      : this(
          key: key,
          fileIds: args.fileIds,
          startIndex: args.startIndex,
          collectionId: args.collectionId,
        );

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create: (_) => _Bloc(
        KiwiContainer().resolve(),
        account: accountController.account,
        filesController: accountController.filesController,
        collectionsController: accountController.collectionsController,
        prefController: context.read(),
        fileIds: fileIds,
        startIndex: startIndex,
        brightness: Theme.of(context).brightness,
        collectionId: collectionId,
      )..add(const _Init()),
      child: const _WrappedViewer(),
    );
  }

  final List<int> fileIds;
  final int startIndex;

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
                  Navigator.of(context).pushNamed(ImageEditor.routeName,
                      arguments: imageEditorRequest.value);
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.imageEnhancerRequest,
              listener: (context, imageEnhancerRequest) {
                if (imageEnhancerRequest.value != null) {
                  Navigator.of(context).pushNamed(ImageEnhancer.routeName,
                      arguments: imageEnhancerRequest.value);
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.shareRequest,
              listener: (context, shareRequest) {
                if (shareRequest.value != null) {
                  ShareHandler(
                    KiwiContainer().resolve<DiContainer>(),
                    context: context,
                  ).shareFiles(
                      context.bloc.account, [shareRequest.value!.file]);
                }
              },
            ),
            _BlocListenerT(
              selector: (state) => state.slideshowRequest,
              listener: _onSlideshowRequest,
            ),
            _BlocListenerT(
              selector: (state) => state.setAsRequest,
              listener: _onSetAsRequest,
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
          child: _BlocBuilder(
            buildWhen: (previous, current) =>
                previous.isShowAppBar != current.isShowAppBar ||
                previous.isDetailPaneActive != current.isDetailPaneActive,
            builder: (context, state) => Scaffold(
              extendBodyBehindAppBar: true,
              extendBody: true,
              appBar: state.isShowAppBar
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight),
                      child: _AppBar(),
                    )
                  : null,
              bottomNavigationBar:
                  state.isShowAppBar && !state.isDetailPaneActive
                      ? const _BottomAppBar()
                      : null,
              body: const _ContentBody(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSlideshowRequest(
    BuildContext context,
    Unique<_SlideshowRequest?> slideshowRequest,
  ) async {
    if (slideshowRequest.value == null) {
      return;
    }
    final result = await showDialog<SlideshowConfig>(
      context: context,
      builder: (_) => SlideshowDialog(
        duration: context.bloc.prefController.slideshowDurationValue,
        isShuffle: context.bloc.prefController.isSlideshowShuffleValue,
        isRepeat: context.bloc.prefController.isSlideshowRepeatValue,
        isReverse: context.bloc.prefController.isSlideshowReverseValue,
      ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    unawaited(
        context.bloc.prefController.setSlideshowDuration(result.duration));
    unawaited(
        context.bloc.prefController.setSlideshowShuffle(result.isShuffle));
    unawaited(context.bloc.prefController.setSlideshowRepeat(result.isRepeat));
    unawaited(
        context.bloc.prefController.setSlideshowReverse(result.isReverse));
    final newIndex = await Navigator.of(context).pushNamed<int>(
      SlideshowViewer.routeName,
      arguments: SlideshowViewerArguments(
        slideshowRequest.value!.fileIds,
        slideshowRequest.value!.startIndex,
        slideshowRequest.value!.collectionId,
        result,
      ),
    );
    _log.info("[_onSlideshowRequest] Slideshow ended, jump to: $newIndex");
    if (newIndex != null && context.mounted) {
      context.addEvent(_RequestPage(newIndex));
    }
  }

  void _onSetAsRequest(
    BuildContext context,
    Unique<_SetAsRequest?> setAsRequest,
  ) {
    if (setAsRequest.value == null) {
      return;
    }
    SetAsHandler(
      KiwiContainer().resolve(),
      context: context,
    ).setAsFile(setAsRequest.value!.account, setAsRequest.value!.file);
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
