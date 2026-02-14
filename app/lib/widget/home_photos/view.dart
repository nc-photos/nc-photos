part of 'home_photos.dart';

class _ContentList extends StatelessWidget {
  const _ContentList();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.zoom != current.zoom ||
              previous.viewWidth != current.viewWidth,
      builder: (context, state) {
        if (state.viewWidth == null) {
          return const SliverFillRemaining();
        }
        final measurement = _measureItem(
          state.viewWidth!,
          photo_list_util.getThumbSize(state.zoom).toDouble(),
        );
        return _ContentListBody(
          itemPerRow: measurement.itemPerRow,
          itemSize: measurement.itemSize,
          isNeedVisibilityInfo: true,
        );
      },
    );
  }
}

class _ScalingList extends StatelessWidget {
  const _ScalingList();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.scale != current.scale ||
              previous.viewWidth != current.viewWidth,
      builder: (context, state) {
        if (state.viewWidth == null || state.scale == null) {
          return const SliverFillRemaining();
        }
        int nextZoom;
        if (state.scale! > 1) {
          nextZoom = state.zoom + 1;
        } else {
          nextZoom = state.zoom - 1;
        }
        nextZoom = nextZoom.clamp(-1, 2);
        final measurement = _measureItem(
          state.viewWidth!,
          photo_list_util.getThumbSize(nextZoom).toDouble(),
        );
        return _ContentListBody(
          itemPerRow: measurement.itemPerRow,
          itemSize: measurement.itemSize,
          isNeedVisibilityInfo: false,
        );
      },
    );
  }
}

@npLog
class _ContentListBody extends StatelessWidget {
  const _ContentListBody({
    required this.itemPerRow,
    required this.itemSize,
    required this.isNeedVisibilityInfo,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.transformedItems != current.transformedItems ||
              previous.selectedItems != current.selectedItems ||
              (previous.itemPerRow == null) != (current.itemPerRow == null) ||
              (previous.itemSize == null) != (current.itemSize == null),
      builder:
          (context, state) =>
              state.itemPerRow == null || state.itemSize == null
                  ? const SliverToBoxAdapter(child: SizedBox.shrink())
                  : SelectableSectionList<_Item>(
                    sections:
                        state.transformedItems
                            .map(
                              (e) => SelectableSection(
                                header: e.first,
                                items: e.sublist(1),
                              ),
                            )
                            .toList(),
                    selectedItems: state.selectedItems,
                    sectionHeaderBuilder:
                        (context, section, item) => item.buildWidget(context),
                    itemBuilder: (context, section, index, item) {
                      final w = item.buildWidget(context);
                      if (isNeedVisibilityInfo) {
                        return _ContentListItemView(
                          key: Key("${_log.fullName}.${item.id}"),
                          item: item,
                          child: w,
                        );
                      } else {
                        return w;
                      }
                    },
                    extentOptimizer: SelectableSectionListExtentOptimizer(
                      itemPerRow: itemPerRow,
                      titleExtentBuilder:
                          (_) =>
                              AppDimension.of(context).timelineDateItemHeight,
                      itemExtentBuilder: (_) => itemSize,
                    ),
                    onSelectionChange: (_, selected) {
                      context.addEvent(
                        _SetSelectedItems(items: selected.cast()),
                      );
                    },
                    onItemTap: (context, section, index, item) {
                      if (item is _FileItem) {
                        Navigator.of(context).pushNamed(
                          TimelineViewer.routeName,
                          arguments: TimelineViewerArguments(
                            initialFile: item.file,
                          ),
                        );
                      }
                    },
                  ),
    );
  }

  final int itemPerRow;
  final double itemSize;
  final bool isNeedVisibilityInfo;
}

class _ContentListItemView extends StatefulWidget {
  const _ContentListItemView({
    required super.key,
    required this.item,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _ContentListItemViewState();

  final _Item item;
  final Widget child;
}

class _ContentListItemViewState extends State<_ContentListItemView> {
  @override
  void initState() {
    super.initState();
    bloc = context.bloc;
  }

  @override
  void dispose() {
    final date = _getDate();
    if (date != null) {
      bloc.add(_RemoveVisibleDate(_VisibleDate(widget.item.id, date)));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.key}.detector"),
      onVisibilityChanged: (info) {
        if (context.mounted) {
          final date = _getDate();
          if (date != null) {
            if (info.visibleFraction >= 0.2) {
              context.addEvent(
                _AddVisibleDate(_VisibleDate(widget.item.id, date)),
              );
            } else {
              context.addEvent(
                _RemoveVisibleDate(_VisibleDate(widget.item.id, date)),
              );
            }
          }
        }
      },
      child: widget.child,
    );
  }

  Date? _getDate() {
    final item = widget.item;
    Date? date;
    if (item is _FileItem) {
      date = item.file.dateTime.toLocal().toDate();
    } else if (item is _SummaryFileItem) {
      date = item.date;
    }
    return date;
  }

  late final _Bloc bloc;
}

class _MemoryCollectionList extends StatelessWidget {
  const _MemoryCollectionList();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: _MemoryCollectionItemView.height,
        child: _BlocSelector<List<Collection>>(
          selector: (state) => state.memoryCollections,
          builder:
              (context, memoryCollections) => ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: memoryCollections.length,
                itemBuilder: (context, index) {
                  final c = memoryCollections[index];
                  final result = c.getCoverUrl(k.coverSize, k.coverSize);
                  final year =
                      (c.contentProvider as CollectionMemoryProvider).year;
                  return _MemoryCollectionItemView(
                    coverUrl: result?.url,
                    coverMime: result?.mime,
                    label: c.name,
                    year: year,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        CollectionBrowser.routeName,
                        arguments: CollectionBrowserArguments(c),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
              ),
        ),
      ),
    );
  }
}

class _MemoryCollectionItemView extends StatefulWidget {
  static const width = 140.0;
  static const height = 190.0;

  const _MemoryCollectionItemView({
    required this.coverUrl,
    required this.coverMime,
    required this.label,
    required this.year,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _MemoryCollectionItemViewState();

  final String? coverUrl;
  final String? coverMime;
  final String label;
  final int year;
  final VoidCallback? onTap;
}

class _MemoryCollectionItemViewState extends State<_MemoryCollectionItemView> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: _MemoryCollectionItemView.width,
        height: _MemoryCollectionItemView.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            OverflowBox(
              maxHeight: _MemoryCollectionItemView.height,
              maxWidth: _MemoryCollectionItemView.height,
              child: SizedBox.square(
                dimension: _MemoryCollectionItemView.height,
                child: PhotoListImageOnly(
                  account: context.bloc.account,
                  previewUrl: widget.coverUrl,
                  mime: widget.coverMime,
                  cacheType: CachedNetworkImageType.cover,
                  onDominantColor: (value) {
                    setState(() {
                      _colorScheme = value;
                    });
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.none,
                child: Text(
                  "${widget.year}".substring(2),
                  style: TextStyle(
                    fontSize: 184,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -8,
                    color:
                        (Theme.of(context).brightness == Brightness.light
                                ? _colorScheme?.primary
                                : _colorScheme?.inversePrimary)
                            ?.withValues(alpha: .26) ??
                        Colors.black12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: (_colorScheme?.primaryContainer ??
                        Theme.of(context).colorScheme.inverseSurface)
                    .withValues(alpha: 0.75),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color:
                        _colorScheme?.onPrimaryContainer ??
                        Theme.of(context).colorScheme.onInverseSurface,
                  ),
                ),
              ),
            ),
            if (widget.onTap != null)
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(onTap: widget.onTap),
                ),
              ),
          ],
        ),
      ),
    );
  }

  ColorScheme? _colorScheme;
}

class _VideoPreviewHintDialog extends StatelessWidget {
  const _VideoPreviewHintDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().missingVideoThumbnailHelpDialogTitle),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            launch(help_util.videoPreviewUrl);
          },
          child: Text(L10n.global().learnMoreButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<PrefController>().setDontShowVideoPreviewHint(true);
          },
          child: Text(L10n.global().dontShowAgain),
        ),
      ],
    );
  }
}

class _DateBar extends StatelessWidget {
  const _DateBar();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.dateBarContent != current.dateBarContent ||
              previous.appBarPosition != current.appBarPosition,
      builder: (context, state) {
        if (state.dateBarContent == null) {
          return const SizedBox.shrink();
        }
        final appBarY = state.appBarPosition?.dy;
        double y = 8;
        if (appBarY != null) {
          y += max(appBarY, MediaQuery.paddingOf(context).top);
        }

        final String datePattern;
        if (context.bloc.prefController.homePhotosZoomLevelValue >= 0) {
          datePattern = DateFormat.YEAR_MONTH_DAY;
        } else {
          datePattern = DateFormat.YEAR_MONTH;
        }
        final text = DateFormat(
          datePattern,
          Localizations.localeOf(context).languageCode,
        ).format(state.dateBarContent!.toLocalDateTime());
        return Padding(
          padding: EdgeInsets.only(top: max(y, 0), left: 16, right: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: .85),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              text,
              style: Theme.of(context).textStyleColored(
                (textTheme) => textTheme.titleMedium,
                (colorScheme) => colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        );
      },
    );
  }
}
