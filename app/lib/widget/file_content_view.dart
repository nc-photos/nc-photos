import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/live_photo_util.dart';
import 'package:nc_photos/widget/image_viewer.dart';
import 'package:nc_photos/widget/live_photo_viewer.dart';
import 'package:nc_photos/widget/video_viewer.dart';
import 'package:np_common/unique.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

part 'file_content_view.g.dart';
part 'file_content_view/bloc.dart';
part 'file_content_view/state_event.dart';
part 'file_content_view/view.dart';

@npLog
class FileContentView extends StatefulWidget {
  const FileContentView({
    super.key,
    required this.file,
    required this.shouldPlayLivePhoto,
    required this.canZoom,
    required this.canPlay,
    required this.isPlayControlVisible,
    this.onContentHeightChanged,
    this.onZoomChanged,
    this.onVideoPlayingChanged,
    this.onLivePhotoLoadFailue,
  });

  @override
  State<StatefulWidget> createState() => _FileContentViewState();

  final FileDescriptor file;
  final bool shouldPlayLivePhoto;
  final bool canZoom;
  final bool canPlay;
  final bool isPlayControlVisible;
  final void Function(double height)? onContentHeightChanged;
  final void Function(bool isZoomed)? onZoomChanged;
  final void Function(bool isPlaying)? onVideoPlayingChanged;
  final void Function()? onLivePhotoLoadFailue;
}

class _FileContentViewState extends State<FileContentView> {
  @override
  void initState() {
    super.initState();
    _bloc = _Bloc(
      account: context.read<AccountController>().account,
      file: widget.file,
      shouldPlayLivePhoto: widget.shouldPlayLivePhoto,
      canZoom: widget.canZoom,
      canPlay: widget.canPlay,
      isPlayControlVisible: widget.isPlayControlVisible,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: MultiBlocListener(
        listeners: [
          _BlocListenerT(
            selector: (state) => state.contentHeight,
            listener: (context, contentHeight) {
              if (contentHeight != null) {
                widget.onContentHeightChanged?.call(contentHeight);
              }
            },
          ),
          _BlocListenerT(
            selector: (state) => state.isZoomed,
            listener: (context, isZoomed) {
              widget.onZoomChanged?.call(isZoomed);
            },
          ),
          _BlocListenerT(
            selector: (state) => state.isPlaying,
            listener: (context, isPlaying) {
              widget.onVideoPlayingChanged?.call(isPlaying);
            },
          ),
          _BlocListenerT(
            selector: (state) => state.isLivePhotoLoadFailed,
            listener: (context, isLivePhotoLoadFailed) {
              if (isLivePhotoLoadFailed.value) {
                widget.onLivePhotoLoadFailue?.call();
              }
            },
          ),
        ],
        child: const _WrappedFileContentView(),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant FileContentView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldPlayLivePhoto != oldWidget.shouldPlayLivePhoto) {
      _bloc.add(_SetShouldPlayLivePhoto(widget.shouldPlayLivePhoto));
    }
    if (widget.canZoom != oldWidget.canZoom) {
      _bloc.add(_SetCanZoom(widget.canZoom));
    }
    if (widget.canPlay != oldWidget.canPlay) {
      _bloc.add(_SetCanPlay(widget.canPlay));
    }
    if (widget.isPlayControlVisible != oldWidget.isPlayControlVisible) {
      _bloc.add(_SetIsPlayControlVisible(widget.isPlayControlVisible));
    }
  }

  late final _Bloc _bloc;
}

@npLog
class _WrappedFileContentView extends StatelessWidget {
  const _WrappedFileContentView();

  @override
  Widget build(BuildContext context) {
    final file = context.bloc.file;
    if (file_util.isSupportedImageFormat(file)) {
      return _BlocSelector(
        selector: (state) => state.shouldPlayLivePhoto,
        builder: (context, shouldPlayLivePhoto) {
          if (shouldPlayLivePhoto) {
            final livePhotoType = getLivePhotoTypeFromFile(file);
            if (livePhotoType != null) {
              return _LivePhotoPageContentView(
                livePhotoType: livePhotoType,
              );
            } else {
              _log.warning("[build] Not a live photo");
              return const _PhotoPageContentView();
            }
          } else {
            return const _PhotoPageContentView();
          }
        },
      );
    } else if (file_util.isSupportedVideoFormat(file)) {
      return const _VideoPageContentView();
    } else {
      _log.shout("[build] Unknown file format: ${file.fdMime}");
      // _pageStates[index]!.itemHeight = 0;
      return Container();
    }
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
