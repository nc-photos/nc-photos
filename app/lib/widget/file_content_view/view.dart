part of '../file_content_view.dart';

class _LivePhotoPageContentView extends StatelessWidget {
  const _LivePhotoPageContentView({required this.livePhotoType});

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) => previous.canPlay != current.canPlay,
      builder:
          (context, state) => LivePhotoViewer(
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
            onLoadFailure: (e, stackTrace) {
              context.addEvent(
                _SetLivePhotoLoadFailed(e ?? Object(), stackTrace),
              );
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
    if (context.bloc.file is FileDescriptor) {
      return _BlocBuilder(
        buildWhen: (previous, current) => previous.canZoom != current.canZoom,
        builder:
            (context, state) => RemoteImageViewer(
              account: context.bloc.account,
              file: context.bloc.file as FileDescriptor,
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
    } else if (context.bloc.file is LocalFile) {
      return _BlocBuilder(
        buildWhen: (previous, current) => previous.canZoom != current.canZoom,
        builder:
            (context, state) => LocalImageViewer(
              file: context.bloc.file as LocalFile,
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
    } else {
      return Container();
    }
  }
}
