import 'dart:async';

import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/any_files_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/controller/local_files_controller.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file/presenter/factory.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/disposable.dart';
import 'package:nc_photos/widget/file_content_view.dart';
import 'package:nc_photos/widget/horizontal_page_viewer.dart';
import 'package:nc_photos/widget/slideshow_dialog.dart';
import 'package:nc_photos/widget/viewer_mixin.dart';
import 'package:nc_photos/widget/wakelock_util.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/object_util.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'slideshow_viewer.g.dart';
part 'slideshow_viewer/bloc.dart';
part 'slideshow_viewer/state_event.dart';
part 'slideshow_viewer/timeline.dart';
part 'slideshow_viewer/view.dart';

class SlideshowViewerArguments {
  const SlideshowViewerArguments(
    this.afIds,
    this.startIndex,
    this.collectionId,
    this.config,
  );

  final List<String> afIds;
  final int startIndex;
  final String? collectionId;
  final SlideshowConfig config;
}

// fix for shared files
class SlideshowViewer extends StatelessWidget {
  static const routeName = "/slideshow-viewer";

  static Route buildRoute(
    SlideshowViewerArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute<int>(
    builder: (context) => SlideshowViewer.fromArgs(args),
    settings: settings,
  );

  const SlideshowViewer({
    super.key,
    required this.afIds,
    required this.startIndex,
    required this.collectionId,
    required this.config,
  });

  SlideshowViewer.fromArgs(SlideshowViewerArguments args, {Key? key})
    : this(
        key: key,
        afIds: args.afIds,
        startIndex: args.startIndex,
        collectionId: args.collectionId,
        config: args.config,
      );

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create:
          (context) => _Bloc(
            account: accountController.account,
            anyFilesController: accountController.anyFilesController,
            filesController: accountController.filesController,
            localFilesController: context.read(),
            collectionsController: accountController.collectionsController,
            afIds: afIds,
            startIndex: startIndex,
            collectionId: collectionId,
            config: config,
          )..add(const _Init()),
      child: const _WrappedSlideshowViewer(),
    );
  }

  final List<String> afIds;
  final int startIndex;
  final String? collectionId;
  final SlideshowConfig config;
}

class _WrappedSlideshowViewer extends StatefulWidget {
  const _WrappedSlideshowViewer();

  @override
  State<StatefulWidget> createState() => _WrappedSlideshowViewerState();
}

class _WrappedSlideshowViewerState extends State<_WrappedSlideshowViewer>
    with
        DisposableManagerMixin<_WrappedSlideshowViewer>,
        ViewerControllersMixin<_WrappedSlideshowViewer> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  List<Disposable> initDisposables() {
    return [...super.initDisposables(), WakelockControllerDisposable()];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT<bool>(
          selector: (state) => state.hasRequestExit,
          listener: (context, hasRequestExit) {
            if (hasRequestExit) {
              final pageIndex = context.state.page;
              final fileIndex = context.bloc.convertPageToFileIndex(pageIndex);
              Navigator.of(context).pop(fileIndex);
            }
          },
        ),
      ],
      child: Theme(
        data: buildDarkTheme(context),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                context.addEvent(const _RequestExit());
              },
              child: _BlocSelector<bool>(
                selector: (state) => state.hasInit,
                builder:
                    (context, hasInit) =>
                        hasInit ? const _Body() : const _InitBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
