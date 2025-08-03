part of '../archive_browser.dart';

class _ContentList extends StatelessWidget {
  const _ContentList();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector<int>(
      selector: (state) => state.zoom,
      builder: (context, zoom) => _ContentListBody(
        maxCrossAxisExtent: photo_list_util.getThumbSize(zoom).toDouble(),
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

@npLog
class _ContentListBody extends StatelessWidget {
  const _ContentListBody({
    required this.maxCrossAxisExtent,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen: (previous, current) =>
          previous.transformedItems != current.transformedItems ||
          previous.selectedItems != current.selectedItems,
      builder: (context, state) => SelectableItemList<_Item>(
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
          final actualIndex = index -
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
              null,
            ),
          );
        },
      ),
    );
  }

  final double maxCrossAxisExtent;
}
