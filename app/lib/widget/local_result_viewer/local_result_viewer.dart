import 'dart:async';
import 'dart:io';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/mobile/share.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/image_viewer.dart';
import 'package:nc_photos_plugin/nc_photos_plugin.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'local_result_viewer.g.dart';

class LocalResultViewerArguments {
  const LocalResultViewerArguments(this.file);

  final File file;
}

class LocalResultViewer extends StatelessWidget {
  static const routeName = "/local-result-viewer";

  const LocalResultViewer({super.key, required this.file});

  LocalResultViewer.fromArgs(LocalResultViewerArguments args, {Key? key})
    : this(key: key, file: args.file);

  static Route buildRoute(
    LocalResultViewerArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute(
    builder: (_) => LocalResultViewer.fromArgs(args),
    settings: settings,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _LrvBloc(file: file),
      child: const _WrappedLocalResultViewer(),
    );
  }

  final File file;
}

class _WrappedLocalResultViewer extends StatelessWidget {
  const _WrappedLocalResultViewer();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context),
      child: _BlocBuilder(
        buildWhen:
            (previous, current) =>
                previous.isShowAppBar != current.isShowAppBar,
        builder:
            (context, state) => Scaffold(
              extendBodyBehindAppBar: true,
              extendBody: true,
              appBar:
                  state.isShowAppBar
                      ? const PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: _AppBar(),
                      )
                      : null,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  systemNavigationBarColor: Colors.black,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
                child: GestureDetector(
                  onTap: () {
                    context.addEvent(const _ToggleAppBar());
                  },
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: ColoredBox(color: Colors.black),
                      ),
                      IoFileImageViewer(file: context.bloc.file, canZoom: true),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          tooltip: L10n.global().shareTooltip,
          onPressed: () {
            context.addEvent(const _Share());
          },
        ),
      ],
    );
  }
}

typedef _BlocBuilder = BlocBuilder<_LrvBloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
// typedef _BlocListenerT<T> = BlocListenerT<_RvBloc, _State, T>;
// typedef _BlocSelector<T> = BlocSelector<_RvBloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _LrvBloc get bloc => read();
  // _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
