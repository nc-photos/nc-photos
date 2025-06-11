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
    final presenter = AnyFilePresenterFactory.imageViewer(
      context.bloc.file,
      account: context.bloc.account,
    );
    return _BlocBuilder(
      buildWhen: (previous, current) => previous.canZoom != current.canZoom,
      builder:
          (context, state) => presenter.buildWidget(
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
