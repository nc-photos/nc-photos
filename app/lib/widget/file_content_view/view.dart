part of '../file_content_view.dart';

class _LivePhotoPageContentView extends StatelessWidget {
  const _LivePhotoPageContentView({
    required this.livePhotoType,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) => previous.canPlay != current.canPlay,
      builder: (context, state) => LivePhotoViewer(
        account: context.bloc.account,
        file: context.bloc.file,
        livePhotoType: livePhotoType,
        canPlay: state.canPlay,
        onLoaded: () {
          context.addEvent(const _SetLoaded());
        },
        onHeightChanged: (height) {
          context.addEvent(_SetContentHeight(height));
        },
        onLoadFailure: () {
          context.addEvent(const _SetLivePhotoLoadFailed());
        },
      ),
    );
  }

  final LivePhotoType livePhotoType;
}

class _PhotoPageContentView extends StatelessWidget {
  const _PhotoPageContentView();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) => previous.canZoom != current.canZoom,
      builder: (context, state) => RemoteImageViewer(
        account: context.bloc.account,
        file: context.bloc.file,
        canZoom: state.canZoom,
        onLoaded: () {
          context.addEvent(const _SetLoaded());
        },
        onHeightChanged: (height) {
          context.addEvent(_SetContentHeight(height));
        },
        onZoomStarted: () {
          context.addEvent(const _SetIsZoomed(true));
        },
        onZoomEnded: () {
          context.addEvent(const _SetIsZoomed(false));
        },
      ),
    );
  }
}

class _VideoPageContentView extends StatelessWidget {
  const _VideoPageContentView();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.canZoom != current.canZoom ||
          previous.isPlayControlVisible != current.isPlayControlVisible ||
          previous.canPlay != current.canPlay,
      builder: (context, state) => VideoViewer(
        account: context.bloc.account,
        file: context.bloc.file,
        canZoom: state.canZoom,
        canPlay: state.canPlay,
        isControlVisible: state.isPlayControlVisible,
        onLoaded: () {
          context.addEvent(const _SetLoaded());
        },
        onHeightChanged: (height) {
          context.addEvent(_SetContentHeight(height));
        },
        onZoomStarted: () {
          context.addEvent(const _SetIsZoomed(true));
        },
        onZoomEnded: () {
          context.addEvent(const _SetIsZoomed(false));
        },
        onPlay: () {
          context.addEvent(const _SetPlaying());
        },
        onPause: () {
          context.addEvent(const _SetPause());
        },
      ),
    );
  }
}
