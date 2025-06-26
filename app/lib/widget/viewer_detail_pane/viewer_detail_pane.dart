import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/content/factory.dart';
import 'package:nc_photos/entity/any_file/worker/factory.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/gps_map_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/widget/about_geocoding_dialog.dart';
import 'package:nc_photos/widget/handler/add_selection_to_collection_handler.dart';
import 'package:nc_photos/widget/list_tile_center_leading.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/or_null.dart';
import 'package:np_common/size.dart';
import 'package:np_common/try_or_null.dart';
import 'package:np_geocoder/np_geocoder.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:np_string/np_string.dart';
import 'package:np_ui/np_ui.dart';
import 'package:path/path.dart' as path_lib;
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'state_event.dart';
part 'type.dart';
part 'view.dart';
part 'viewer_detail_pane.g.dart';

class ViewerSingleCollectionData {
  const ViewerSingleCollectionData(this.collection, this.item);

  final Collection collection;
  final CollectionItem item;
}

class ViewerDetailPane extends StatelessWidget {
  const ViewerDetailPane({
    super.key,
    required this.file,
    this.fromCollection,
    required this.onRemoveFromCollectionPressed,
    required this.onArchivePressed,
    required this.onUnarchivePressed,
    required this.onDeletePressed,
    this.onSlideshowPressed,
  });

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create:
          (context) => _Bloc(
            c: KiwiContainer().resolve(),
            collectionsController: accountController.collectionsController,
            account: accountController.account,
            file: file,
            fromCollection: fromCollection,
          ),
      child: _WrappedViewerDetailPane(
        onRemoveFromCollectionPressed: onRemoveFromCollectionPressed,
        onArchivePressed: onArchivePressed,
        onUnarchivePressed: onUnarchivePressed,
        onDeletePressed: onDeletePressed,
        onSlideshowPressed: onSlideshowPressed,
      ),
    );
  }

  final AnyFile file;

  /// Data of the collection this file belongs to, or null
  final ViewerSingleCollectionData? fromCollection;

  final void Function(BuildContext context) onRemoveFromCollectionPressed;
  final void Function(BuildContext context) onArchivePressed;
  final void Function(BuildContext context) onUnarchivePressed;
  final void Function(BuildContext context) onDeletePressed;
  final VoidCallback? onSlideshowPressed;
}

class _WrappedViewerDetailPane extends StatefulWidget {
  const _WrappedViewerDetailPane({
    required this.onRemoveFromCollectionPressed,
    required this.onArchivePressed,
    required this.onUnarchivePressed,
    required this.onDeletePressed,
    this.onSlideshowPressed,
  });

  @override
  State<StatefulWidget> createState() => _WrappedViewerDetailPaneState();

  final void Function(BuildContext context) onRemoveFromCollectionPressed;
  final void Function(BuildContext context) onArchivePressed;
  final void Function(BuildContext context) onUnarchivePressed;
  final void Function(BuildContext context) onDeletePressed;
  final VoidCallback? onSlideshowPressed;
}

@npLog
class _WrappedViewerDetailPaneState extends State<_WrappedViewerDetailPane>
    with RouteAware, PageVisibilityMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT<ExceptionEvent?>(
          selector: (state) => state.error,
          listener: (context, error) {
            if (error != null && isPageVisible()) {
              if (error.error is _SetAlbumCoverFailedError) {
                SnackBarManager().showSnackBar(
                  SnackBar(
                    content: Text(
                      L10n.global().setCollectionCoverFailureNotification,
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
      ],
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _ButtonBar(
              onRemoveFromCollectionPressed:
                  widget.onRemoveFromCollectionPressed,
              onArchivePressed: widget.onArchivePressed,
              onUnarchivePressed: widget.onUnarchivePressed,
              onDeletePressed: widget.onDeletePressed,
              onSlideshowPressed: widget.onSlideshowPressed,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Divider(),
            ),
            const _NameItem(),
            const _OwnerItem(),
            const _TagItem(),
            const _DateTimeItem(),
            const _SizeItem(),
            const _ModelItem(),
            const _LocationItem(),
            const _GpsItem(),
          ],
        ),
      ),
    );
  }
}

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
