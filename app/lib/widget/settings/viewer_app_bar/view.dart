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
    return switch (type) {
      ViewerAppBarButtonType.livePhoto => const _DemoLivePhotoButton(),
      ViewerAppBarButtonType.favorite => const _DemoFavoriteButton(),
      ViewerAppBarButtonType.share => const _DemoShareButton(),
      ViewerAppBarButtonType.edit => const _DemoEditButton(),
      ViewerAppBarButtonType.enhance => const _DemoEnhanceButton(),
      ViewerAppBarButtonType.download => const _DemoDownloadButton(),
      ViewerAppBarButtonType.delete => const _DemoDeleteButton(),
      ViewerAppBarButtonType.archive => const _DemoArchiveButton(),
      ViewerAppBarButtonType.slideshow => const _DemoSlideshowButton(),
      ViewerAppBarButtonType.setAs => const _DemoSetAsButton(),
      ViewerAppBarButtonType.upload => const _DemoUploadButton(),
    };
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
    return switch (type) {
      ViewerAppBarButtonType.livePhoto => const _GridLivePhotoButton(),
      ViewerAppBarButtonType.favorite => const _GridFavoriteButton(),
      ViewerAppBarButtonType.share => const _GridShareButton(),
      ViewerAppBarButtonType.edit => const _GridEditButton(),
      ViewerAppBarButtonType.enhance => const _GridEnhanceButton(),
      ViewerAppBarButtonType.download => const _GridDownloadButton(),
      ViewerAppBarButtonType.delete => const _GridDeleteButton(),
      ViewerAppBarButtonType.archive => const _GridArchiveButton(),
      ViewerAppBarButtonType.slideshow => const _GridSlideshowButton(),
      ViewerAppBarButtonType.setAs => const _GridSetAsButton(),
      ViewerAppBarButtonType.upload => const _GridUploadButton(),
    };
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
