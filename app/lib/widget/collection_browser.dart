import 'dart:async';
import 'dart:collection';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/asset.dart' as asset;
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/collection_items_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/download_handler.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection/content_provider/album.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/collection_item/new_item.dart';
import 'package:nc_photos/entity/collection_item/sorter.dart';
import 'package:nc_photos/entity/collection_item/util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/flutter_util.dart' as flutter_util;
import 'package:nc_photos/gps_map_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/session_storage.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/widget/album_share_outlier_browser.dart';
import 'package:nc_photos/widget/app_bar_circular_progress_indicator.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/collection_picker.dart';
import 'package:nc_photos/widget/collection_viewer/collection_viewer.dart';
import 'package:nc_photos/widget/draggable_item_list.dart';
import 'package:nc_photos/widget/export_collection_dialog.dart';
import 'package:nc_photos/widget/file_sharer_dialog.dart';
import 'package:nc_photos/widget/finger_listener.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:nc_photos/widget/photo_list_util.dart' as photo_list_util;
import 'package:nc_photos/widget/place_picker/place_picker.dart';
import 'package:nc_photos/widget/selectable_item_list.dart';
import 'package:nc_photos/widget/selection_app_bar.dart';
import 'package:nc_photos/widget/share_collection_dialog.dart';
import 'package:nc_photos/widget/shared_album_info_dialog.dart';
import 'package:nc_photos/widget/simple_input_dialog.dart';
import 'package:nc_photos/widget/sliver_visualized_scale.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/size.dart';
import 'package:np_common/unique.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_db/np_db.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'collection_browser.g.dart';
part 'collection_browser/app_bar.dart';
part 'collection_browser/bloc.dart';
part 'collection_browser/item_view.dart';
part 'collection_browser/state_event.dart';
part 'collection_browser/type.dart';
part 'collection_browser/view.dart';

class CollectionBrowserArguments {
  const CollectionBrowserArguments(this.collection);

  final Collection collection;
}

/// Browse the content of a collection
class CollectionBrowser extends StatelessWidget {
  static const routeName = "/collection-browser";

  static Route buildRoute(
          CollectionBrowserArguments args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => CollectionBrowser.fromArgs(args),
        settings: settings,
      );

  const CollectionBrowser({
    super.key,
    required this.collection,
  });

  CollectionBrowser.fromArgs(
    CollectionBrowserArguments args, {
    Key? key,
  }) : this(
          key: key,
          collection: args.collection,
        );

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create: (_) => _Bloc(
        container: KiwiContainer().resolve(),
        account: accountController.account,
        prefController: context.read(),
        collectionsController: accountController.collectionsController,
        filesController: accountController.filesController,
        db: context.read(),
        collection: collection,
      ),
      child: const _WrappedCollectionBrowser(),
    );
  }

  final Collection collection;
}

class _WrappedCollectionBrowser extends StatefulWidget {
  const _WrappedCollectionBrowser();

  @override
  State<StatefulWidget> createState() => _WrappedCollectionBrowserState();
}

@npLog
class _WrappedCollectionBrowserState extends State<_WrappedCollectionBrowser>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _LoadItems());

    if (_bloc.state.collection.shares.isNotEmpty &&
        _bloc.state.collection.contentProvider is CollectionAlbumProvider) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSharedAlbumInfoDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.isEditMode != current.isEditMode ||
          previous.selectedItems.isEmpty != current.selectedItems.isEmpty,
      builder: (context, state) => PopScope(
        canPop: !state.isEditMode && state.selectedItems.isEmpty,
        onPopInvokedWithResult: (didPop, result) {
          if (state.isEditMode) {
            _bloc.add(const _CancelEdit());
          } else if (state.selectedItems.isNotEmpty) {
            _bloc.add(const _SetSelectedItems(items: {}));
          }
        },
        child: Scaffold(
          body: MultiBlocListener(
            listeners: [
              _BlocListener(
                listenWhen: (previous, current) =>
                    previous.items != current.items,
                listener: (context, state) {
                  _bloc.add(_TransformItems(
                    items: state.items,
                  ));
                },
              ),
              _BlocListener(
                listenWhen: (previous, current) =>
                    previous.editItems != current.editItems,
                listener: (context, state) {
                  if (state.editItems != null) {
                    _bloc.add(_TransformEditItems(
                      items: state.editItems!,
                    ));
                  }
                },
              ),
              _BlocListener(
                listenWhen: (previous, current) =>
                    previous.importResult != current.importResult,
                listener: (context, state) {
                  if (state.importResult != null) {
                    Navigator.of(context).pushReplacementNamed(
                      CollectionBrowser.routeName,
                      arguments:
                          CollectionBrowserArguments(state.importResult!),
                    );
                  }
                },
              ),
              _BlocListener(
                listenWhen: (previous, current) =>
                    previous.isEditMode != current.isEditMode,
                listener: (context, state) {
                  final c = KiwiContainer().resolve<DiContainer>();
                  final bloc = context.read<_Bloc>();
                  final canSort =
                      CollectionAdapter.of(c, bloc.account, state.collection)
                          .isPermitted(CollectionCapability.manualSort);
                  if (canSort &&
                      !SessionStorage().hasShowDragRearrangeNotification) {
                    SnackBarManager().showSnackBar(SnackBar(
                      content: Text(
                          L10n.global().albumEditDragRearrangeNotification),
                      duration: k.snackBarDurationNormal,
                    ));
                    SessionStorage().hasShowDragRearrangeNotification = true;
                  }
                },
              ),
              _BlocListenerT(
                selector: (state) => state.placePickerRequest,
                listener: (context, placePickerRequest) async {
                  if (placePickerRequest.value != null) {
                    final result =
                        await Navigator.of(context).pushNamed<CameraPosition>(
                      PlacePicker.routeName,
                      arguments: PlacePickerArguments(
                        initialPosition:
                            placePickerRequest.value!.initialPosition,
                        initialZoom:
                            placePickerRequest.value!.initialPosition == null
                                ? null
                                : 15.5,
                      ),
                    );
                    if (result == null) {
                      return;
                    }
                    context.read<_Bloc>().add(_AddMapToCollection(result));
                  }
                },
              ),
              _BlocListenerT<ExceptionEvent?>(
                selector: (state) => state.error,
                listener: (context, error) {
                  if (error != null && isPageVisible()) {
                    if (error.error is _ArchiveFailedError) {
                      SnackBarManager().showSnackBar(SnackBar(
                        content: Text(L10n.global()
                            .archiveSelectedFailureNotification(
                                (error.error as _ArchiveFailedError).count)),
                        duration: k.snackBarDurationNormal,
                      ));
                    } else if (error.error is _RemoveFailedError) {
                      SnackBarManager().showSnackBar(SnackBar(
                        content: Text(L10n.global()
                            .deleteSelectedFailureNotification(
                                (error.error as _RemoveFailedError).count)),
                        duration: k.snackBarDurationNormal,
                      ));
                    } else {
                      SnackBarManager().showSnackBarForException(error.error);
                    }
                  }
                },
              ),
              _BlocListener(
                listenWhen: (previous, current) =>
                    previous.message != current.message,
                listener: (context, state) {
                  if (state.message != null && isPageVisible()) {
                    SnackBarManager().showSnackBar(SnackBar(
                      content: Text(state.message!),
                      duration: k.snackBarDurationNormal,
                    ));
                  }
                },
              ),
            ],
            child: Stack(
              fit: StackFit.expand,
              children: [
                FingerListener(
                  onPointerMove: (event) => _onPointerMove(context, event),
                  onFingerChanged: (finger) {
                    setState(() {
                      _finger = finger;
                    });
                  },
                  child: GestureDetector(
                    onScaleStart: (_) {
                      _bloc.add(const _StartScaling());
                    },
                    onScaleUpdate: (details) {
                      _bloc.add(_SetScale(details.scale));
                    },
                    onScaleEnd: (_) {
                      _bloc.add(const _EndScaling());
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: _finger >= 2
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      slivers: [
                        _BlocBuilder(
                          buildWhen: (previous, current) =>
                              previous.selectedItems.isEmpty !=
                                  current.selectedItems.isEmpty ||
                              previous.isEditMode != current.isEditMode,
                          builder: (context, state) {
                            if (state.isEditMode) {
                              return const _EditAppBar();
                            } else if (state.selectedItems.isNotEmpty) {
                              return const _SelectionAppBar();
                            } else {
                              return const _AppBar();
                            }
                          },
                        ),
                        SliverToBoxAdapter(
                          child: _BlocBuilder(
                            buildWhen: (previous, current) =>
                                previous.isLoading != current.isLoading,
                            builder: (context, state) => state.isLoading
                                ? const LinearProgressIndicator()
                                : const SizedBox(height: 4),
                          ),
                        ),
                        _BlocBuilder(
                          buildWhen: (previous, current) =>
                              previous.isEditMode != current.isEditMode ||
                              previous.scale != current.scale,
                          builder: (context, state) {
                            if (!state.isEditMode) {
                              return SliverTransitionedScale(
                                scale: state.scale,
                                baseSliver: const _ContentList(),
                                overlaySliver: const _ScalingList(),
                              );
                            } else {
                              if (context.bloc.isCollectionCapabilityPermitted(
                                  CollectionCapability.manualSort)) {
                                return const _EditContentList();
                              } else {
                                return const _UnmodifiableEditContentList();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                _BlocBuilder(
                  buildWhen: (previous, current) =>
                      previous.isEditBusy != current.isEditBusy,
                  builder: (context, state) {
                    if (state.isEditBusy) {
                      return Container(
                        color: Colors.black.withValues(alpha: .5),
                        alignment: Alignment.center,
                        child: const AppIntermediateCircularProgressIndicator(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPointerMove(BuildContext context, PointerMoveEvent event) {
    if (!context.state.isDragging) {
      return;
    }
    if (event.position.dy >= MediaQuery.of(context).size.height - 100) {
      // near bottom of screen
      if (_isDragScrollingDown == true) {
        return;
      }
      // using an arbitrary big number to save time needed to calculate the
      // actual extent
      const maxExtent = 1000000000.0;
      _log.fine("[_onPointerMove] Begin scrolling down");
      if (_scrollController.offset <
          _scrollController.position.maxScrollExtent) {
        _scrollController.animateTo(maxExtent,
            duration: Duration(
                milliseconds:
                    ((maxExtent - _scrollController.offset) * 1.6).round()),
            curve: Curves.linear);
        _isDragScrollingDown = true;
      }
    } else if (event.position.dy <= 100) {
      // near top of screen
      if (_isDragScrollingDown == false) {
        return;
      }
      _log.fine("[_onPointerMove] Begin scrolling up");
      if (_scrollController.offset > 0) {
        _scrollController.animateTo(0,
            duration: Duration(
                milliseconds: (_scrollController.offset * 1.6).round()),
            curve: Curves.linear);
        _isDragScrollingDown = false;
      }
    } else if (_isDragScrollingDown != null) {
      _log.fine("[_onPointerMove] Stop scrolling");
      _scrollController.jumpTo(_scrollController.offset);
      _isDragScrollingDown = null;
    }
  }

  Future<void> _showSharedAlbumInfoDialog() async {
    final pref = KiwiContainer().resolve<DiContainer>().pref;
    if (!pref.hasShownSharedAlbumInfoOr(false)) {
      return showDialog(
        context: context,
        builder: (_) => const SharedAlbumInfoDialog(),
        barrierDismissible: false,
      );
    }
  }

  late final _bloc = context.bloc;
  final _scrollController = ScrollController();
  bool? _isDragScrollingDown;
  var _finger = 0;
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
