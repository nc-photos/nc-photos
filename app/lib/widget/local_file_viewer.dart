import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/share_handler.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/handler/delete_local_selection_handler.dart';
import 'package:nc_photos/widget/horizontal_page_viewer.dart';
import 'package:nc_photos/widget/image_viewer.dart';
import 'package:np_log/np_log.dart';

part 'local_file_viewer.g.dart';

class LocalFileViewerArguments {
  LocalFileViewerArguments(this.streamFiles, this.startIndex);

  final List<LocalFile> streamFiles;
  final int startIndex;
}

class LocalFileViewer extends StatefulWidget {
  static const routeName = "/local-file-viewer";

  static Route buildRoute(
    LocalFileViewerArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute(
    builder: (context) => LocalFileViewer.fromArgs(args),
    settings: settings,
  );

  const LocalFileViewer({
    super.key,
    required this.streamFiles,
    required this.startIndex,
  });

  LocalFileViewer.fromArgs(LocalFileViewerArguments args, {Key? key})
    : this(
        key: key,
        streamFiles: args.streamFiles,
        startIndex: args.startIndex,
      );

  @override
  createState() => _LocalFileViewerState();

  final List<LocalFile> streamFiles;
  final int startIndex;
}

@npLog
class _LocalFileViewerState extends State<LocalFileViewer> {
  @override
  build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(body: Builder(builder: _buildContent)),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isShowVideoControl = !_isShowVideoControl;
        });
      },
      child: Stack(
        children: [
          Container(color: Colors.black),
          if (!_isViewerLoaded ||
              !_pageStates[_viewerController.currentPage]!.hasLoaded)
            const Align(
              alignment: Alignment.center,
              child: AppIntermediateCircularProgressIndicator(),
            ),
          HorizontalPageViewer(
            pageCount: widget.streamFiles.length,
            pageBuilder: _buildPage,
            initialPage: widget.startIndex,
            controller: _viewerController,
            viewportFraction: _viewportFraction,
            canSwitchPage: _canSwitchPage,
          ),
          _buildAppBar(context),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Wrap(
      children: [
        Stack(
          children: [
            Container(
              // + status bar height
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0, -1),
                  end: Alignment(0, 1),
                  colors: [
                    Color.fromARGB(192, 0, 0, 0),
                    Color.fromARGB(0, 0, 0, 0),
                  ],
                ),
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  tooltip: L10n.global().shareTooltip,
                  onPressed: () {
                    _onSharePressed(context);
                  },
                ),
                PopupMenuButton<_AppBarMenuOption>(
                  tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: _AppBarMenuOption.delete,
                          child: Text(L10n.global().deletePermanentlyTooltip),
                        ),
                      ],
                  onSelected: (option) => _onMenuSelected(context, option),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onSharePressed(BuildContext context) async {
    final c = KiwiContainer().resolve<DiContainer>();
    final file = widget.streamFiles[_viewerController.currentPage];
    _log.info("[_onSharePressed] Sharing file: ${file.logTag}");
    await ShareHandler(c, context: context).shareLocalFiles([file]);
  }

  void _onMenuSelected(BuildContext context, _AppBarMenuOption option) {
    switch (option) {
      case _AppBarMenuOption.delete:
        _onDeletePressed(context);
        break;
    }
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final file = widget.streamFiles[_viewerController.currentPage];
    _log.info("[_onDeletePressed] Deleting file: ${file.logTag}");
    final count = await const DeleteLocalSelectionHandler()(
      selectedFiles: [file],
      isRemoveOpened: true,
    );
    if (count > 0) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildPage(BuildContext context, int index) {
    if (_pageStates[index] == null) {
      _pageStates[index] = _PageState();
    }
    return FractionallySizedBox(
      widthFactor: 1 / _viewportFraction,
      child: _buildItemView(context, index),
    );
  }

  Widget _buildItemView(BuildContext context, int index) {
    final file = widget.streamFiles[index];
    if (file_util.isSupportedImageMime(file.mime ?? "")) {
      return _buildImageView(context, index);
    } else {
      _log.shout("[_buildItemView] Unknown file format: ${file.mime}");
      return Container();
    }
  }

  Widget _buildImageView(BuildContext context, int index) => LocalImageViewer(
    file: widget.streamFiles[index],
    canZoom: true,
    onLoaded: () => _onImageLoaded(index),
    onZoomStarted: () {
      setState(() {
        _isZoomed = true;
      });
    },
    onZoomEnded: () {
      setState(() {
        _isZoomed = false;
      });
    },
  );

  void _onImageLoaded(int index) {
    if (_viewerController.currentPage == index &&
        !_pageStates[index]!.hasLoaded) {
      setState(() {
        _pageStates[index]!.hasLoaded = true;
        _isViewerLoaded = true;
      });
    }
  }

  bool get _canSwitchPage => !_isZoomed;

  var _isShowVideoControl = true;
  var _isZoomed = false;

  final _viewerController = HorizontalPageViewerController();
  bool _isViewerLoaded = false;
  final _pageStates = <int, _PageState>{};

  static const _viewportFraction = 1.05;
}

class _PageState {
  bool hasLoaded = false;
}

enum _AppBarMenuOption { delete }
