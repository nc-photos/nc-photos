import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/use_case/restore_trashbin.dart';
import 'package:nc_photos/widget/app_intermediate_circular_progress_indicator.dart';
import 'package:nc_photos/widget/file_content_view.dart';
import 'package:nc_photos/widget/handler/remove_selection_handler.dart';
import 'package:nc_photos/widget/horizontal_page_viewer.dart';
import 'package:nc_photos/widget/image_viewer.dart';
import 'package:np_log/np_log.dart';

part 'trashbin_viewer.g.dart';

class TrashbinViewerArguments {
  TrashbinViewerArguments(this.account, this.streamFiles, this.startIndex);

  final Account account;
  final List<File> streamFiles;
  final int startIndex;
}

class TrashbinViewer extends StatefulWidget {
  static const routeName = "/trashbin-viewer";

  static Route buildRoute(
    TrashbinViewerArguments args,
    RouteSettings settings,
  ) => MaterialPageRoute(
    builder: (context) => TrashbinViewer.fromArgs(args),
    settings: settings,
  );

  const TrashbinViewer({
    super.key,
    required this.account,
    required this.streamFiles,
    required this.startIndex,
  });

  TrashbinViewer.fromArgs(TrashbinViewerArguments args, {Key? key})
    : this(
        key: key,
        account: args.account,
        streamFiles: args.streamFiles,
        startIndex: args.startIndex,
      );

  @override
  createState() => _TrashbinViewerState();

  final Account account;
  final List<File> streamFiles;
  final int startIndex;
}

@npLog
class _TrashbinViewerState extends State<TrashbinViewer> {
  @override
  build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context),
      child: Scaffold(body: Builder(builder: _buildContent)),
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
                  icon: const Icon(Icons.restore_outlined),
                  tooltip: L10n.global().restoreTooltip,
                  onPressed: _onRestorePressed,
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
                  onSelected: (option) {
                    switch (option) {
                      case _AppBarMenuOption.delete:
                        _onDeletePressed(context);
                        break;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onRestorePressed() async {
    final file = widget.streamFiles[_viewerController.currentPage];
    _log.info("[_onRestorePressed] Restoring file: ${file.path}");
    SnackBarManager().showSnackBar(
      SnackBar(
        content: Text(L10n.global().restoreProcessingNotification),
        duration: k.snackBarDurationShort,
      ),
      canBeReplaced: true,
    );
    try {
      await RestoreTrashbin(KiwiContainer().resolve<DiContainer>())(
        widget.account,
        file,
      );
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(L10n.global().restoreSuccessNotification),
          duration: k.snackBarDurationNormal,
        ),
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e, stacktrace) {
      _log.shout(
        "Failed while restore trashbin: ${logFilename(file.path)}",
        e,
        stacktrace,
      );
      SnackBarManager().showSnackBar(
        SnackBar(
          content: Text(
            "${L10n.global().restoreFailureNotification}: "
            "${exception_util.toUserString(e)}",
          ),
          duration: k.snackBarDurationNormal,
        ),
      );
    }
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final file = widget.streamFiles[_viewerController.currentPage];
    _log.info("[_onDeletePressed] Deleting file permanently: ${file.path}");
    unawaited(
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text(
                L10n.global().deletePermanentlyConfirmationDialogTitle,
              ),
              content: Text(
                L10n.global().deletePermanentlyConfirmationDialogContent,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _delete(context);
                  },
                  child: Text(L10n.global().confirmButtonLabel),
                ),
              ],
            ),
      ),
    );
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
    if (file_util.isSupportedImageFormat(file)) {
      return _buildImageView(context, index);
    } else if (file_util.isSupportedVideoFormat(file)) {
      return _buildVideoView(context, index);
    } else {
      _log.shout("[_buildItemView] Unknown file format: ${file.contentType}");
      return Container();
    }
  }

  Widget _buildImageView(BuildContext context, int index) {
    return RemoteImageViewer(
      account: widget.account,
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
  }

  Widget _buildVideoView(BuildContext context, int index) {
    return FileContentView(
      file: widget.streamFiles[index].toAnyFile(),
      shouldPlayLivePhoto: false,
      isPlayControlVisible: _isShowVideoControl,
      onZoomChanged: (isZoomed) {
        setState(() {
          _isZoomed = isZoomed;
        });
      },
      onVideoPlayingChanged: (isPlaying) {
        if (isPlaying) {
          _onVideoPlay();
        } else {
          _onVideoPause();
        }
      },
      onLoaded: () => _onVideoLoaded(index),
    );
  }

  void _onImageLoaded(int index) {
    // currently pageview doesn't pre-load pages, we do it manually
    // don't pre-load if user already navigated away
    if (_viewerController.currentPage == index &&
        !_pageStates[index]!.hasLoaded) {
      _log.info("[_onImageLoaded] Pre-loading nearby images");
      if (index > 0) {
        final prevFile = widget.streamFiles[index - 1];
        if (file_util.isSupportedImageFormat(prevFile)) {
          RemoteImageViewer.preloadImage(widget.account, prevFile);
        }
      }
      if (index + 1 < widget.streamFiles.length) {
        final nextFile = widget.streamFiles[index + 1];
        if (file_util.isSupportedImageFormat(nextFile)) {
          RemoteImageViewer.preloadImage(widget.account, nextFile);
        }
      }
      setState(() {
        _pageStates[index]!.hasLoaded = true;
        _isViewerLoaded = true;
      });
    }
  }

  void _onVideoLoaded(int index) {
    if (_viewerController.currentPage == index &&
        !_pageStates[index]!.hasLoaded) {
      setState(() {
        _pageStates[index]!.hasLoaded = true;
        _isViewerLoaded = true;
      });
    }
  }

  void _onVideoPlay() {
    setState(() {
      _isShowVideoControl = false;
    });
  }

  void _onVideoPause() {
    setState(() {
      _isShowVideoControl = true;
    });
  }

  Future<void> _delete(BuildContext context) async {
    final file = widget.streamFiles[_viewerController.currentPage];
    _log.info("[_delete] Removing file: ${file.path}");
    final count = await RemoveSelectionHandler(
      filesController: context.read<AccountController>().filesController,
    )(
      account: widget.account,
      selection: [file],
      shouldCleanupAlbum: false,
      isRemoveOpened: true,
    );
    if (count > 0 && mounted) {
      Navigator.of(context).pop();
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
