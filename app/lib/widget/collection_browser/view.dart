part of '../collection_browser.dart';

class _ContentList extends StatelessWidget {
  const _ContentList();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) => previous.zoom != current.zoom,
      builder:
          (context, state) => _ContentListBody(
            maxCrossAxisExtent:
                photo_list_util.getThumbSize(state.zoom).toDouble(),
          ),
    );
  }
}

class _ScalingList extends StatelessWidget {
  const _ScalingList();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) => previous.scale != current.scale,
      builder: (context, state) {
        if (state.scale == null) {
          return const SizedBox.shrink();
        }
        int nextZoom;
        if (state.scale! > 1) {
          nextZoom = state.zoom + 1;
        } else {
          nextZoom = state.zoom - 1;
        }
        nextZoom = nextZoom.clamp(-1, 2);
        return _ContentListBody(
          maxCrossAxisExtent: photo_list_util.getThumbSize(nextZoom).toDouble(),
        );
      },
    );
  }
}

class _ContentListBody extends StatelessWidget {
  const _ContentListBody({required this.maxCrossAxisExtent});

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.collection != current.collection ||
              previous.transformedItems != current.transformedItems ||
              previous.selectedItems != current.selectedItems,
      builder:
          (context, state) => SelectableItemList<_Item>(
            maxCrossAxisExtent: maxCrossAxisExtent,
            items: state.transformedItems,
            itemBuilder: (context, _, item) => item.buildWidget(context),
            staggeredTileBuilder: (_, item) => item.staggeredTile,
            selectedItems: state.selectedItems,
            onSelectionChange: (_, selected) {
              context.addEvent(_SetSelectedItems(items: selected.cast()));
            },
            onItemTap: (context, index, _) {
              if (state.transformedItems[index] is! _FileItem) {
                return;
              }
              final actualIndex =
                  index -
                  state.transformedItems
                      .sublist(0, index)
                      .where((e) => e is! _FileItem)
                      .length;
              Navigator.of(context).pushNamed(
                CollectionViewer.routeName,
                arguments: CollectionViewerArguments(
                  state.transformedItems
                      .whereType<_FileItem>()
                      .map((e) => e.file)
                      .toList(),
                  actualIndex,
                  context.bloc.isAdHocCollection ? null : state.collection.id,
                ),
              );
            },
          ),
    );
  }

  final double maxCrossAxisExtent;
}

class _EditContentList extends StatelessWidget {
  const _EditContentList();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: context.read<PrefController>().albumBrowserZoomLevelChange,
      initialData: context.read<PrefController>().albumBrowserZoomLevelValue,
      builder: (_, zoomLevel) {
        if (zoomLevel.hasError) {
          context.addEvent(
            _SetMessage(L10n.global().writePreferenceFailureNotification),
          );
        }
        return _BlocBuilder(
          buildWhen:
              (previous, current) =>
                  previous.editTransformedItems != current.editTransformedItems,
          builder: (context, state) {
            if (context.bloc.isCollectionCapabilityPermitted(
              CollectionCapability.manualSort,
            )) {
              return DraggableItemList<_Item>(
                maxCrossAxisExtent:
                    photo_list_util
                        .getThumbSize(zoomLevel.requireData)
                        .toDouble(),
                items: state.editTransformedItems ?? state.transformedItems,
                itemBuilder:
                    (context, _, item) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: item.buildWidget(context),
                    ),
                itemDragFeedbackBuilder:
                    (context, _, item) =>
                        item.buildDragFeedbackWidget(context) ??
                        item.buildWidget(context),
                itemDragFeedbackSize:
                    (_, item) => item.dragFeedbackWidgetSize(),
                staggeredTileBuilder: (_, item) => item.staggeredTile,
                onDragResult: (results) {
                  context.addEvent(_EditManualSort(results));
                },
                onDraggingChanged: (value) {
                  context.addEvent(_SetDragging(value));
                },
              );
            } else {
              return SelectableItemList<_Item>(
                maxCrossAxisExtent:
                    photo_list_util
                        .getThumbSize(zoomLevel.requireData)
                        .toDouble(),
                items: state.editTransformedItems ?? state.transformedItems,
                itemBuilder: (context, _, item) => item.buildWidget(context),
                staggeredTileBuilder: (_, item) => item.staggeredTile,
              );
            }
          },
        );
      },
    );
  }
}

/// Unmodifiable content list under edit mode
class _UnmodifiableEditContentList extends StatelessWidget {
  const _UnmodifiableEditContentList();

  @override
  Widget build(BuildContext context) {
    return SliverIgnorePointer(
      ignoring: true,
      sliver: SliverOpacity(
        opacity: .25,
        sliver: StreamBuilder<int>(
          stream: context.read<PrefController>().albumBrowserZoomLevelChange,
          initialData:
              context.read<PrefController>().albumBrowserZoomLevelValue,
          builder: (_, zoomLevel) {
            if (zoomLevel.hasError) {
              context.addEvent(
                _SetMessage(L10n.global().writePreferenceFailureNotification),
              );
            }
            return _BlocBuilder(
              buildWhen:
                  (previous, current) =>
                      previous.editTransformedItems !=
                      current.editTransformedItems,
              builder: (context, state) {
                return SelectableItemList<_Item>(
                  maxCrossAxisExtent:
                      photo_list_util
                          .getThumbSize(zoomLevel.requireData)
                          .toDouble(),
                  items: state.editTransformedItems ?? state.transformedItems,
                  itemBuilder: (context, _, item) => item.buildWidget(context),
                  staggeredTileBuilder: (_, item) => item.staggeredTile,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
