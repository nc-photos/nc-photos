part of 'viewer.dart';

enum ViewerAppBarButtonType {
  // the order must not be changed
  livePhoto,
  favorite,
  share,
  edit,
  enhance,
  download,
  delete,
  archive,
  slideshow,
  setAs,
  ;

  static ViewerAppBarButtonType fromValue(int value) =>
      ViewerAppBarButtonType.values[value];
}

class _AppBarLivePhotoButton extends StatelessWidget {
  const _AppBarLivePhotoButton();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.currentFile != current.currentFile ||
          previous.currentFileState != current.currentFileState,
      builder: (context, state) {
        if (state.currentFile?.let(getLivePhotoTypeFromFile) != null) {
          if (state.currentFileState?.shouldPlayLivePhoto ?? false) {
            return IconButton(
              icon: const Icon(Icons.motion_photos_pause_outlined),
              onPressed: () {
                context.state.currentFile?.fdId
                    .let((id) => context.addEvent(_PauseLivePhoto(id)));
              },
            );
          } else {
            return IconButton(
              icon: const PngIcon(icMotionPhotosPlay24dp),
              onPressed: () {
                context.state.currentFile?.fdId
                    .let((id) => context.addEvent(_PlayLivePhoto(id)));
              },
            );
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _AppBarFavoriteButton extends StatelessWidget {
  const _AppBarFavoriteButton();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.currentFile,
      builder: (context, currentFile) => currentFile?.fdIsFavorite == true
          ? IconButton(
              icon: const Icon(Icons.star),
              tooltip: L10n.global().unfavoriteTooltip,
              onPressed: () {
                context.state.currentFile?.fdId
                    .let((id) => context.addEvent(_Unfavorite(id)));
              },
            )
          : IconButton(
              icon: const Icon(Icons.star_border),
              tooltip: L10n.global().favoriteTooltip,
              onPressed: () {
                context.state.currentFile?.fdId
                    .let((id) => context.addEvent(_Favorite(id)));
              },
            ),
    );
  }
}

class _AppBarShareButton extends StatelessWidget {
  const _AppBarShareButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share_outlined),
      tooltip: L10n.global().shareTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_Share(id)));
      },
    );
  }
}

class _AppBarEditButton extends StatelessWidget {
  const _AppBarEditButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.tune_outlined),
      tooltip: L10n.global().editTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_Edit(id)));
      },
    );
  }
}

class _AppBarEnhanceButton extends StatelessWidget {
  const _AppBarEnhanceButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.auto_fix_high_outlined),
      tooltip: L10n.global().enhanceTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_Enhance(id)));
      },
    );
  }
}

class _AppBarDownloadButton extends StatelessWidget {
  const _AppBarDownloadButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.download_outlined),
      tooltip: L10n.global().downloadTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_Download(id)));
      },
    );
  }
}

class _AppBarDeleteButton extends StatelessWidget {
  const _AppBarDeleteButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outlined),
      tooltip: L10n.global().deleteTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_Delete(id)));
      },
    );
  }
}

class _AppBarUnarchiveButton extends StatelessWidget {
  const _AppBarUnarchiveButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.unarchive_outlined),
      tooltip: L10n.global().unarchiveTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_Unarchive(id)));
      },
    );
  }
}

class _AppBarArchiveButton extends StatelessWidget {
  const _AppBarArchiveButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.archive_outlined),
      tooltip: L10n.global().archiveTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_Archive(id)));
      },
    );
  }
}

class _AppBarSlideshowButton extends StatelessWidget {
  const _AppBarSlideshowButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.slideshow_outlined),
      tooltip: L10n.global().slideshowTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_StartSlideshow(id)));
      },
    );
  }
}

class _AppBarSetAsButton extends StatelessWidget {
  const _AppBarSetAsButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.launch),
      tooltip: L10n.global().setAsTooltip,
      onPressed: () {
        context.state.currentFile?.fdId
            .let((id) => context.addEvent(_SetAs(id)));
      },
    );
  }
}
