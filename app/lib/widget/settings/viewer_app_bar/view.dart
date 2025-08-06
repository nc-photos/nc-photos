part of '../viewer_app_bar_settings.dart';

class _DemoView extends StatelessWidget {
  const _DemoView();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context),
      child: Builder(
        builder:
            (context) => _BlocSelector(
              selector: (state) => state.buttons,
              builder: (context, buttons) {
                final appBar = AppBar(
                  backgroundColor: Colors.black,
                  leading: IgnorePointer(
                    ignoring: true,
                    child: BackButton(onPressed: () {}),
                  ),
                  title: const _DemoAppBarTitle(),
                  actions: [
                    ...buttons.map(
                      (e) => SizedBox.square(
                        dimension: 48,
                        child: my.Draggable<ViewerAppBarButtonType>(
                          data: e,
                          feedback: _DraggingButton(
                            child: _DemoButtonDelegate(e),
                          ),
                          onDropBefore: (data) {
                            context.addEvent(
                              _MoveButton.before(which: data, target: e),
                            );
                          },
                          onDropAfter: (data) {
                            context.addEvent(
                              _MoveButton.after(which: data, target: e),
                            );
                          },
                          child: _DemoButtonDelegate(e),
                        ),
                      ),
                    ),
                    const _DemoMoreButton(),
                  ],
                );
                if (buttons.isEmpty) {
                  return DragTarget<ViewerAppBarButtonType>(
                    builder:
                        (context, candidateData, rejectedData) => SizedBox(
                          height: kToolbarHeight,
                          child: Stack(
                            children: [
                              appBar,
                              IgnorePointer(
                                child: Opacity(
                                  opacity: candidateData.isNotEmpty ? .35 : 0,
                                  child: Container(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    onAcceptWithDetails: (details) {
                      context.addEvent(_MoveButton.first(which: details.data));
                    },
                  );
                } else {
                  return appBar;
                }
              },
            ),
      ),
    );
  }
}

class _DemoAppBarTitle extends StatelessWidget {
  const _DemoAppBarTitle();

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final localTime = DateTime.now();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          getRawPlatform() == NpPlatform.iOs
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
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
}

class _DemoBottomView extends StatelessWidget {
  const _DemoBottomView();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildDarkTheme(context),
      child: Container(
        height: kToolbarHeight,
        alignment: Alignment.center,
        color: Colors.black,
        child: _BlocSelector(
          selector: (state) => state.buttons,
          builder:
              (context, buttons) =>
                  buttons.isEmpty
                      ? DragTarget<ViewerAppBarButtonType>(
                        builder:
                            (context, candidateData, rejectedData) => Opacity(
                              opacity: candidateData.isNotEmpty ? .35 : 0,
                              child: Container(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                        onAcceptWithDetails: (details) {
                          context.addEvent(
                            _MoveButton.first(which: details.data),
                          );
                        },
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children:
                            buttons
                                .map(
                                  (e) => Expanded(
                                    flex: 1,
                                    child: my.Draggable<ViewerAppBarButtonType>(
                                      data: e,
                                      feedback: _DraggingButton(
                                        child: _DemoButtonDelegate(e),
                                      ),
                                      onDropBefore: (data) {
                                        context.addEvent(
                                          _MoveButton.before(
                                            which: data,
                                            target: e,
                                          ),
                                        );
                                      },
                                      onDropAfter: (data) {
                                        context.addEvent(
                                          _MoveButton.after(
                                            which: data,
                                            target: e,
                                          ),
                                        );
                                      },
                                      child: _DemoButtonDelegate(e),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
        ),
      ),
    );
  }
}

class _DemoButtonDelegate extends StatelessWidget {
  const _DemoButtonDelegate(this.type);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ViewerAppBarButtonType.livePhoto:
        return const _DemoLivePhotoButton();
      case ViewerAppBarButtonType.favorite:
        return const _DemoFavoriteButton();
      case ViewerAppBarButtonType.share:
        return const _DemoShareButton();
      case ViewerAppBarButtonType.edit:
        return const _DemoEditButton();
      case ViewerAppBarButtonType.enhance:
        return const _DemoEnhanceButton();
      case ViewerAppBarButtonType.download:
        return const _DemoDownloadButton();
      case ViewerAppBarButtonType.delete:
        return const _DemoDeleteButton();
      case ViewerAppBarButtonType.archive:
        return const _DemoArchiveButton();
      case ViewerAppBarButtonType.slideshow:
        return const _DemoSlideshowButton();
      case ViewerAppBarButtonType.setAs:
        return const _DemoSetAsButton();
    }
  }

  final ViewerAppBarButtonType type;
}

class _CandidateGrid extends StatelessWidget {
  const _CandidateGrid();

  @override
  Widget build(BuildContext context) {
    return DragTarget<ViewerAppBarButtonType>(
      builder:
          (context, candidateData, rejectedData) => Stack(
            children: [
              _BlocSelector(
                selector: (state) => state.buttons,
                builder:
                    (context, buttons) => GridView.extent(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      maxCrossAxisExtent: 72,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      children:
                          ViewerAppBarButtonType.values
                              .where((e) => !buttons.contains(e))
                              .map(
                                (e) => my.Draggable<ViewerAppBarButtonType>(
                                  data: e,
                                  feedback: _DraggingButton(
                                    child: _DemoButtonDelegate(e),
                                  ),
                                  child: _CandidateButtonDelegate(e),
                                ),
                              )
                              .toList(),
                    ),
              ),
              IgnorePointer(
                child: Opacity(
                  opacity: candidateData.isNotEmpty ? .1 : 0,
                  child: Container(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
      onAcceptWithDetails: (details) {
        context.addEvent(_RemoveButton(details.data));
      },
      onWillAcceptWithDetails: (details) {
        // moving down
        return context.state.buttons.contains(details.data);
      },
    );
  }
}

class _CandidateButtonDelegate extends StatelessWidget {
  const _CandidateButtonDelegate(this.type);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ViewerAppBarButtonType.livePhoto:
        return const _GridLivePhotoButton();
      case ViewerAppBarButtonType.favorite:
        return const _GridFavoriteButton();
      case ViewerAppBarButtonType.share:
        return const _GridShareButton();
      case ViewerAppBarButtonType.edit:
        return const _GridEditButton();
      case ViewerAppBarButtonType.enhance:
        return const _GridEnhanceButton();
      case ViewerAppBarButtonType.download:
        return const _GridDownloadButton();
      case ViewerAppBarButtonType.delete:
        return const _GridDeleteButton();
      case ViewerAppBarButtonType.archive:
        return const _GridArchiveButton();
      case ViewerAppBarButtonType.slideshow:
        return const _GridSlideshowButton();
      case ViewerAppBarButtonType.setAs:
        return const _GridSetAsButton();
    }
  }

  final ViewerAppBarButtonType type;
}

class _DraggingButton extends StatelessWidget {
  const _DraggingButton({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 48,
        height: 48,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: child,
      ),
    );
  }

  final Widget child;
}
