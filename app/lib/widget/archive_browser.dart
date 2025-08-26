import 'dart:async';

import 'package:collection/collection.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/flutter_util.dart' as flutter_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/collection_viewer/collection_viewer.dart';
import 'package:nc_photos/widget/empty_list_indicator.dart';
import 'package:nc_photos/widget/finger_listener.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:nc_photos/widget/photo_list_util.dart' as photo_list_util;
import 'package:nc_photos/widget/selectable_item_list.dart';
import 'package:nc_photos/widget/selection_app_bar.dart';
import 'package:nc_photos/widget/sliver_visualized_scale.dart';
import 'package:np_async/np_async.dart';
import 'package:np_common/or_null.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'archive_browser.g.dart';
part 'archive_browser/app_bar.dart';
part 'archive_browser/bloc.dart';
part 'archive_browser/state_event.dart';
part 'archive_browser/type.dart';
part 'archive_browser/view.dart';

class ArchiveBrowser extends StatelessWidget {
  static const routeName = "/archive-browser";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (_) => const ArchiveBrowser(),
    settings: settings,
  );

  const ArchiveBrowser({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create:
          (_) => _Bloc(
            account: accountController.account,
            filesController: accountController.filesController,
            prefController: context.read(),
          ),
      child: const _WrappedArchiveBrowser(),
    );
  }
}

class _WrappedArchiveBrowser extends StatefulWidget {
  const _WrappedArchiveBrowser();

  @override
  State<StatefulWidget> createState() => _WrappedArchiveBrowserState();
}

@npLog
class _WrappedArchiveBrowserState extends State<_WrappedArchiveBrowser>
    with RouteAware, PageVisibilityMixin {
  @override
  void initState() {
    super.initState();
    _bloc.add(const _LoadItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          _BlocListenerT<List<FileDescriptor>>(
            selector: (state) => state.files,
            listener: (context, files) {
              _bloc.add(_TransformItems(files));
            },
          ),
          _BlocListenerT<ExceptionEvent?>(
            selector: (state) => state.error,
            listener: (context, error) {
              if (error != null && isPageVisible()) {
                if (error.error is _UnarchiveFailedError) {
                  SnackBarManager().showSnackBar(
                    SnackBar(
                      content: Text(
                        L10n.global().unarchiveSelectedFailureNotification(
                          (error.error as _UnarchiveFailedError).count,
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
        ],
        child: FingerListener(
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
              physics:
                  _finger >= 2 ? const NeverScrollableScrollPhysics() : null,
              slivers: [
                _BlocSelector<bool>(
                  selector: (state) => state.selectedItems.isEmpty,
                  builder:
                      (context, isEmpty) =>
                          isEmpty ? const _AppBar() : const _SelectionAppBar(),
                ),
                SliverToBoxAdapter(
                  child: _BlocSelector<bool>(
                    selector: (state) => state.isLoading,
                    builder:
                        (context, isLoading) =>
                            isLoading
                                ? const LinearProgressIndicator()
                                : const SizedBox(height: 4),
                  ),
                ),
                _BlocBuilder(
                  buildWhen:
                      (previous, current) =>
                          previous.transformedItems.isEmpty !=
                              current.transformedItems.isEmpty ||
                          previous.isLoading != current.isLoading,
                  builder:
                      (context, state) =>
                          state.transformedItems.isEmpty && !state.isLoading
                              ? SliverFillRemaining(
                                hasScrollBody: false,
                                child: EmptyListIndicator(
                                  icon: Icons.archive_outlined,
                                  text: L10n.global().listEmptyText,
                                ),
                              )
                              : _BlocSelector<double?>(
                                selector: (state) => state.scale,
                                builder:
                                    (context, scale) => SliverTransitionedScale(
                                      scale: scale,
                                      baseSliver: const _ContentList(),
                                      overlaySliver: const _ScalingList(),
                                    ),
                              ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  late final _bloc = context.bloc;

  var _finger = 0;
}

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}

@npLog
// ignore: camel_case_types
class __ {}
