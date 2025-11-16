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
                  final result = c.getCoverUrl(
                    k.photoThumbSize,
                    k.photoThumbSize,
                    isKeepAspectRatio: true,
                  );
                  return _MemoryCollectionItemView(
                    coverUrl: result?.url,
                    coverMime: result?.mime,
                    label: c.name,
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

class _MemoryCollectionItemView extends StatelessWidget {
  static const width = 96.0;
  static const height = 128.0;

  const _MemoryCollectionItemView({
    required this.coverUrl,
    required this.coverMime,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              OverflowBox(
                maxHeight: height,
                maxWidth: height,
                child: SizedBox.square(
                  dimension: height,
                  child: PhotoListImage(
                    account: context.bloc.account,
                    previewUrl: coverUrl,
                    mime: coverMime,
                    padding: const EdgeInsets.all(0),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).onDarkSurface,
                      ),
                    ),
                  ),
                ),
              ),
              if (onTap != null)
                Positioned.fill(
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(onTap: onTap),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  final String? coverUrl;
  final String? coverMime;
  final String label;
  final VoidCallback? onTap;
}

class _ScrollLabel extends StatelessWidget {
  const _ScrollLabel();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector<Date?>(
      selector: (state) => state.scrollDate,
      builder: (context, scrollDate) {
        if (scrollDate == null) {
          return const SizedBox.shrink();
        }
        final text = DateFormat(
          DateFormat.YEAR_ABBR_MONTH,
          Localizations.localeOf(context).languageCode,
        ).format(scrollDate.toUtcDateTime());
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DefaultTextStyle(
            style:
                Theme.of(context).textStyleColored(
                  (textTheme) => textTheme.titleMedium,
                  (colorScheme) => colorScheme.onSecondaryContainer,
                )!,
            child: Text(text),
          ),
        );
      },
    );
  }
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
