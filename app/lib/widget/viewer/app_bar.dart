part of 'viewer.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final isTitleCentered = getRawPlatform() == NpPlatform.iOs;
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.isDetailPaneActive != current.isDetailPaneActive ||
          previous.isZoomed != current.isZoomed ||
          previous.currentFile != current.currentFile ||
          previous.collection != current.collection ||
          previous.appBarButtons != current.appBarButtons,
      builder: (context, state) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _BlocBuilder(
          buildWhen: (previous, current) =>
              previous.isDetailPaneActive != current.isDetailPaneActive ||
              previous.currentFile != current.currentFile,
          builder: (context, state) =>
              !state.isDetailPaneActive && state.currentFile != null
                  ? _AppBarTitle(
                      file: state.currentFile!,
                      isCentered: isTitleCentered,
                    )
                  : const SizedBox.shrink(),
        ),
        titleSpacing: 0,
        centerTitle: isTitleCentered,
        actions: !state.isDetailPaneActive && state.canOpenDetailPane
            ? [
                ...state.appBarButtons
                    .map((e) => _buildAppBarButton(
                          e,
                          currentFile: state.currentFile,
                          collection: state.collection,
                        ))
                    .nonNulls,
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  tooltip: L10n.global().detailsTooltip,
                  onPressed: () {
                    context.addEvent(const _OpenDetailPane(true));
                  },
                ),
              ]
            : null,
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    required this.file,
    required this.isCentered,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final localTime = file.fdDateTime.toLocal();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          (localTime.year == DateTime.now().year
                  ? DateFormat.MMMd(locale)
                  : DateFormat.yMMMd(locale))
              .format(localTime),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          DateFormat.jm(locale).format(localTime),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  final FileDescriptor file;
  final bool isCentered;
}

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, -1),
          end: Alignment(0, 1),
          colors: [
            Color.fromARGB(0, 0, 0, 0),
            Color.fromARGB(192, 0, 0, 0),
          ],
        ),
      ),
      child: _BlocBuilder(
        buildWhen: (previous, current) =>
            previous.currentFile != current.currentFile ||
            previous.collection != current.collection ||
            previous.bottomAppBarButtons != current.bottomAppBarButtons,
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: state.bottomAppBarButtons
              .map((e) => _buildAppBarButton(
                    e,
                    currentFile: state.currentFile,
                    collection: state.collection,
                  ))
              .nonNulls
              .map((e) => Expanded(
                    flex: 1,
                    child: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

/// Build app bar buttons based on [type]. May return null if this button type
/// is not supported in the current context
Widget? _buildAppBarButton(
  ViewerAppBarButtonType type, {
  required FileDescriptor? currentFile,
  required Collection? collection,
}) {
  switch (type) {
    case ViewerAppBarButtonType.livePhoto:
      return currentFile?.let(getLivePhotoTypeFromFile) != null
          ? const _AppBarLivePhotoButton()
          : null;
    case ViewerAppBarButtonType.favorite:
      return const _AppBarFavoriteButton();
    case ViewerAppBarButtonType.share:
      return const _AppBarShareButton();
    case ViewerAppBarButtonType.edit:
      return features.isSupportEnhancement &&
              currentFile?.let(ImageEnhancer.isSupportedFormat) == true
          ? const _AppBarEditButton()
          : null;
    case ViewerAppBarButtonType.enhance:
      return features.isSupportEnhancement &&
              currentFile?.let(ImageEnhancer.isSupportedFormat) == true
          ? const _AppBarEnhanceButton()
          : null;
    case ViewerAppBarButtonType.download:
      return const _AppBarDownloadButton();
    case ViewerAppBarButtonType.delete:
      return collection == null ? const _AppBarDeleteButton() : null;
    case ViewerAppBarButtonType.archive:
      return currentFile?.fdIsArchived == true
          ? const _AppBarUnarchiveButton()
          : const _AppBarArchiveButton();
    case ViewerAppBarButtonType.slideshow:
      return const _AppBarSlideshowButton();
    case ViewerAppBarButtonType.setAs:
      return const _AppBarSetAsButton();
  }
}
