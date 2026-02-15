import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/any_files_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/metadata_controller.dart';
import 'package:nc_photos/controller/persons_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/controller/server_controller.dart';
import 'package:nc_photos/controller/sync_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/presenter/factory.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/memory.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/event/event.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/progress_util.dart';
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_extension.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/theme/dimension.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/use_case/any_file/download_any_file.dart';
import 'package:nc_photos/use_case/any_file/upload_any_file.dart';
import 'package:nc_photos/widget/collection_browser/collection_browser.dart';
import 'package:nc_photos/widget/collection_picker/collection_picker.dart';
import 'package:nc_photos/widget/double_tap_exit_container/double_tap_exit_container.dart';
import 'package:nc_photos/widget/finger_listener.dart';
import 'package:nc_photos/widget/home_app_bar.dart';
import 'package:nc_photos/widget/navigation_bar_blur_filter.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:nc_photos/widget/photo_list_util.dart' as photo_list_util;
import 'package:nc_photos/widget/selectable_section_list.dart';
import 'package:nc_photos/widget/selection_app_bar.dart';
import 'package:nc_photos/widget/share_helper/share_helper.dart';
import 'package:nc_photos/widget/sliver_visualized_scale.dart';
import 'package:nc_photos/widget/timeline_viewer/timeline_viewer.dart';
import 'package:nc_photos/widget/upload_dialog/upload_dialog.dart';
import 'package:np_async/np_async.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/unique.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'app_bar.dart';
part 'bloc.dart';
part 'delete_dialog.dart';
part 'home_photos.g.dart';
part 'minimap_view.dart';
part 'state_event.dart';
part 'type.dart';
part 'view.dart';

class HomePhotos2BackToTopEvent {
  const HomePhotos2BackToTopEvent();
}

class HomePhotos2 extends StatelessWidget {
  const HomePhotos2({super.key});

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
                prefController: context.read(),
                accountPrefController: accountController.accountPrefController,
                collectionsController: accountController.collectionsController,
                syncController: accountController.syncController,
                personsController: accountController.personsController,
                metadataController: accountController.metadataController,
                serverController: accountController.serverController,
                bottomAppBarHeight: MediaQuery.paddingOf(context).bottom,
                draggableThumbSize:
                    AppDimension.of(context).timelineDraggableThumbSize,
                dateHeight: AppDimension.of(context).timelineDateItemHeight,
              ),
        ),
        BlocProvider(
          create:
              (_) => ShareBloc(
                KiwiContainer().resolve(),
                account: accountController.account,
              ),
        ),
      ],
      child: const _WrappedHomePhotos(),
    );
  }
}

class _WrappedHomePhotos extends StatefulWidget {
  const _WrappedHomePhotos();

  @override
  State<StatefulWidget> createState() => _WrappedHomePhotosState();
}

@npLog
class _WrappedHomePhotosState extends State<_WrappedHomePhotos> {
  @override
  void initState() {
    super.initState();
    context.addEvent(const _LoadItems());
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        final isVisible = info.visibleFraction >= 0.2;
        if (isVisible != _isVisible) {
          if (mounted) {
            setState(() {
              _isVisible = isVisible;
            });
          }
        }
      },
      child: MultiBlocListener(
        listeners: [
          _BlocListenerT<bool>(
            selector: (state) => state.hasMissingVideoPreview,
            listener: (context, hasMissingVideoPreview) {
              if (hasMissingVideoPreview) {
                if (!context
                        .read<PrefController>()
                        .isDontShowVideoPreviewHintValue &&
                    !SessionStorage().hasShownVideoPreviewHint) {
                  SessionStorage().hasShownVideoPreviewHint = true;
                  showDialog(
                    context: context,
                    builder: (context) => const _VideoPreviewHintDialog(),
                  );
                }
              }
            },
          ),
          _BlocListenerT(
            selector: (state) => state.shareRequest,
            listener: _onShareRequest,
          ),
          _BlocListenerT(
            selector: (state) => state.uploadRequest,
            listener: _onUploadRequest,
          ),
          _BlocListenerT(
            selector: (state) => state.deleteRequest,
            listener: _onDeleteRequest,
          ),
          _BlocListenerT<ExceptionEvent?>(
            selector: (state) => state.error,
            listener: (context, error) {
              if (error != null && _isVisible == true) {
                if (error.error is AnyFileArchiveFailedError) {
                  SnackBarManager().showSnackBar(
                    SnackBar(
                      content: Text(
                        L10n.global().archiveSelectedFailureNotification(
                          (error.error as AnyFileArchiveFailedError).count,
                        ),
                      ),
                      duration: k.snackBarDurationNormal,
                    ),
                  );
                } else if (error.error is _RemoveFailedError) {
                  SnackBarManager().showSnackBar(
                    SnackBar(
                      content: Text(
                        L10n.global().deleteSelectedFailureNotification(
                          (error.error as _RemoveFailedError).count,
                        ),
                      ),
                      duration: k.snackBarDurationNormal,
                    ),
                  );
                } else {
                  SnackBarManager().showSnackBarForException(error.error);
                }
              }
            },
          ),
          _BlocListenerT(
            selector: (state) => state.shouldShowRemoteOnlyWarning,
            listener: (context, shouldShowRemoteOnlyWarning) {
              if (shouldShowRemoteOnlyWarning.value) {
                SnackBarManager().showSnackBar(
                  SnackBar(
                    content: Text(L10n.global().opOnlySupportRemoteFiles),
                    duration: k.snackBarDurationNormal,
                  ),
                );
              }
            },
          ),
          _BlocListenerT(
            selector: (state) => state.shouldShowLocalOnlyWarning,
            listener: (context, shouldShowLocalOnlyWarning) {
              if (shouldShowLocalOnlyWarning.value) {
                SnackBarManager().showSnackBar(
                  SnackBar(
                    content: Text(L10n.global().opOnlySupportLocalFiles),
                    duration: k.snackBarDurationNormal,
                  ),
                );
              }
            },
          ),
        ],
        child: ShareBlocListener(
          child: _BlocSelector(
            selector: (state) => state.selectedItems.isEmpty,
            builder:
                (context, isSelectedEmpty) =>
                    isSelectedEmpty
                        ? DoubleTapExitContainer(
                          child: _BodyView(key: _bodyKey),
                        )
                        : PopScope(
                          canPop: false,
                          onPopInvokedWithResult: (didPop, result) {
                            context.addEvent(
                              const _SetSelectedItems(items: {}),
                            );
                          },
                          child: _BodyView(key: _bodyKey),
                        ),
          ),
        ),
      ),
    );
  }

  void _onShareRequest(
    BuildContext context,
    Unique<_ShareRequest?> shareRequest,
  ) {
    if (shareRequest.value == null) {
      return;
    }
    context.read<ShareBloc>().add(
      ShareBlocShareFiles(shareRequest.value!.files),
    );
  }

  Future<void> _onUploadRequest(
    BuildContext context,
    Unique<_UploadRequest?> uploadRequest,
  ) async {
    if (uploadRequest.value == null) {
      return;
    }
    final config = await showDialog<UploadConfig>(
      context: context,
      builder: (context) => const UploadDialog(),
    );
    if (config == null || !context.mounted) {
      return;
    }
    context.addEvent(
      _UploadRequestResult(request: uploadRequest.value!, config: config),
    );
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
      _DeleteItemsWithHint(files: deleteRequest.value!.files, hint: result),
    );
  }

  final _key = GlobalKey();
  final _bodyKey = GlobalKey();
  bool? _isVisible;
}

class _BodyView extends StatelessWidget {
  const _BodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return _BlocSelector<bool>(
      selector: (state) => !state.hasRemoteData && state.syncProgress != null,
      builder: (context, isInitialSyncing) {
        if (isInitialSyncing) {
          return const _InitialSyncBody();
        } else {
          return Shimmer(
            linearGradient: Theme.of(context).photoGridShimmerGradient,
            child: const _Body(),
          );
        }
      },
    );
  }
}

class _InitialSyncBody extends StatelessWidget {
  const _InitialSyncBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const _AppBar(),
        _BlocSelector<Progress?>(
          selector: (state) => state.syncProgress,
          builder: (context, syncProgress) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: Theme.of(context).widthLimitedContentMaxWidth,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          L10n.global().initialSyncMessage,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value:
                              (syncProgress?.progress ?? 0) == 0
                                  ? null
                                  : syncProgress!.progress,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          syncProgress?.text ?? "",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<StatefulWidget> createState() => _BodyState();
}

@npLog
class _BodyState extends State<_Body> {
  @override
  void initState() {
    super.initState();
    _onBackToTopListener.begin();
  }

  @override
  void dispose() {
    _onBackToTopListener.end();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FingerListener(
      onFingerChanged: (finger) {
        context.bloc.add(_SetFinger(finger));
      },
      child: GestureDetector(
        onScaleStart: (_) {
          context.bloc.add(const _StartScaling());
        },
        onScaleUpdate: (details) {
          context.bloc.add(_SetScale(details.scale));
        },
        onScaleEnd: (_) {
          context.bloc.add(const _EndScaling());
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.hasBoundedHeight) {
              context.addEvent(
                _SetLayoutConstraint(
                  constraints.maxWidth,
                  constraints.maxHeight,
                  MediaQuery.of(context).padding.top +
                      kToolbarHeight +
                      MediaQuery.paddingOf(context).bottom,
                ),
              );
            }
            return _BlocBuilder(
              buildWhen:
                  (previous, current) =>
                      previous.minimapItems != current.minimapItems ||
                      previous.viewHeight != current.viewHeight ||
                      (previous.isEnableMemoryCollection &&
                              previous.memoryCollections.isNotEmpty) !=
                          (current.isEnableMemoryCollection &&
                              current.memoryCollections.isNotEmpty),
              builder: (context, state) {
                final scrollExtent = _getScrollViewExtent(
                  context: context,
                  hasMemoryCollection:
                      state.isEnableMemoryCollection &&
                      state.memoryCollections.isNotEmpty,
                );
                return Stack(
                  children: [
                    DraggableScrollbar.semicircle(
                      controller: _scrollController,
                      overrideMaxScrollExtent: scrollExtent,
                      // status bar + app bar
                      topOffset: _getAppBarExtent(context),
                      bottomOffset: MediaQuery.paddingOf(context).bottom,
                      onDragBegin: () {
                        context.addEvent(const _SetIsDragging(true));
                      },
                      onDragEnd: () {
                        context.addEvent(const _SetIsDragging(false));
                      },
                      labelPadding: const EdgeInsets.symmetric(horizontal: 40),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                      heightScrollThumb:
                          AppDimension.of(context).timelineDraggableThumbSize,
                      onScrollBegin: () {
                        context.bloc.add(const _StartScrolling());
                      },
                      onScrollEnd: () {
                        context.bloc.add(const _EndScrolling());
                      },
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(scrollbars: false),
                        child: RefreshIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          onRefresh: () async {
                            context.bloc.add(const _RequestRefresh());
                            var hasNotNull = false;
                            await context.bloc.stream.firstWhere((s) {
                              if (s.syncProgress != null) {
                                hasNotNull = true;
                              }
                              return hasNotNull && s.syncProgress == null;
                            });
                          },
                          child: Stack(
                            children: [
                              _BlocSelector<bool>(
                                selector: (state) => state.finger >= 2,
                                builder:
                                    (context, isScaleMode) => CustomScrollView(
                                      controller: _scrollController,
                                      physics:
                                          isScaleMode
                                              ? const NeverScrollableScrollPhysics()
                                              : null,
                                      slivers: [
                                        _BlocSelector<bool>(
                                          selector:
                                              (state) =>
                                                  state.selectedItems.isEmpty,
                                          builder:
                                              (context, isEmpty) =>
                                                  isEmpty
                                                      ? const _AppBar()
                                                      : const _SelectionAppBar(),
                                        ),
                                        _BlocSelector<bool>(
                                          selector:
                                              (state) => state.isScrolling,
                                          builder:
                                              (context, isScrolling) =>
                                                  isScrolling
                                                      ? const SliverPersistentHeader(
                                                        delegate:
                                                            _AppBarAnchorDelegate(),
                                                        pinned: true,
                                                      )
                                                      : const SliverToBoxAdapter(
                                                        child:
                                                            SizedBox.shrink(),
                                                      ),
                                        ),
                                        _BlocBuilder(
                                          buildWhen:
                                              (previous, current) =>
                                                  (previous
                                                          .isEnableMemoryCollection &&
                                                      previous
                                                          .memoryCollections
                                                          .isNotEmpty) !=
                                                  (current.isEnableMemoryCollection &&
                                                      current
                                                          .memoryCollections
                                                          .isNotEmpty),
                                          builder: (context, state) {
                                            if (state
                                                    .isEnableMemoryCollection &&
                                                state
                                                    .memoryCollections
                                                    .isNotEmpty) {
                                              return const _MemoryCollectionList();
                                            } else {
                                              return const SliverToBoxAdapter();
                                            }
                                          },
                                        ),
                                        _BlocSelector<double?>(
                                          selector: (state) => state.scale,
                                          builder:
                                              (context, scale) =>
                                                  SliverTransitionedScale(
                                                    scale: scale,
                                                    baseSliver:
                                                        const _ContentList(),
                                                    overlaySliver:
                                                        const _ScalingList(),
                                                  ),
                                        ),
                                        const SliverSafeBottom(),
                                      ],
                                    ),
                              ),
                              const _DateBar(),
                              _BlocSelector<bool>(
                                selector: (state) => state.isScrolling,
                                builder:
                                    (context, isScrolling) => AnimatedOpacity(
                                      opacity: isScrolling ? 1 : 0,
                                      duration: k.animationDurationNormal,
                                      curve: Curves.fastOutSlowIn,
                                      child: const _MinimapBackground(),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _BlocSelector<bool>(
                      selector: (state) => state.isScrolling,
                      builder:
                          (context, isScrolling) => AnimatedOpacity(
                            opacity: isScrolling ? 1 : 0,
                            duration: k.animationDurationNormal,
                            curve: Curves.fastOutSlowIn,
                            child: const _MinimapPadding(child: _MinimapView()),
                          ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: NavigationBarBlurFilter(
                        height: MediaQuery.paddingOf(context).bottom,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _onBackToTop(HomePhotos2BackToTopEvent ev) {
    _scrollController.jumpTo(0);
  }

  /// Return the estimated scroll extent of the custom scroll view, or null
  double? _getScrollViewExtent({
    required BuildContext context,
    required bool hasMemoryCollection,
  }) {
    if (context.state.minimapItems?.isNotEmpty == true &&
        context.state.viewHeight != null) {
      final contentListMaxExtent = context.state.minimapItems!.fold(
        .0,
        (previousValue, e) => previousValue + e.logicalHeight,
      );
      final appBarExtent = _getAppBarExtent(context);
      final bottomAppBarExtent = MediaQuery.paddingOf(context).bottom;
      // final metadataTaskHeaderExtent = _web?.getHeaderHeight() ?? 0;
      final smartAlbumListHeight =
          hasMemoryCollection ? _MemoryCollectionItemView.height : 0;
      // scroll extent = list height - widget viewport height
      // + sliver app bar height + bottom app bar height
      // + metadata task header height + smart album list height
      final scrollExtent =
          contentListMaxExtent -
          context.state.viewHeight! +
          appBarExtent +
          bottomAppBarExtent +
          // metadataTaskHeaderExtent +
          smartAlbumListHeight;
      _log.info(
        "[_getScrollViewExtent] $contentListMaxExtent "
        "- ${context.state.viewHeight} "
        "+ $appBarExtent "
        "+ $bottomAppBarExtent "
        // "+ $metadataTaskHeaderExtent "
        "+ $smartAlbumListHeight "
        "= $scrollExtent",
      );
      return scrollExtent;
    } else {
      return null;
    }
  }

  double _getAppBarExtent(BuildContext context) =>
      MediaQuery.of(context).padding.top + kToolbarHeight;

  final _scrollController = ScrollController();

  late final _onBackToTopListener = AppEventListener<HomePhotos2BackToTopEvent>(
    _onBackToTop,
  );
}

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}

@npLog
// ignore: camel_case_types
class __ {}
