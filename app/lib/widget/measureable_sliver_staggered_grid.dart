import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// ignore: must_be_immutable
class MeasurableSliverStaggeredGrid extends SliverStaggeredGrid {
  MeasurableSliverStaggeredGrid.extentBuilder({
    super.key,
    required double maxCrossAxisExtent,
    required IndexedStaggeredTileBuilder staggeredTileBuilder,
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    double mainAxisSpacing = 0,
    double crossAxisSpacing = 0,
  }) : super(
         gridDelegate: SliverStaggeredGridDelegateWithMaxCrossAxisExtent(
           maxCrossAxisExtent: maxCrossAxisExtent,
           mainAxisSpacing: mainAxisSpacing,
           crossAxisSpacing: crossAxisSpacing,
           staggeredTileBuilder: staggeredTileBuilder,
           staggeredTileCount: itemCount,
         ),
         delegate: SliverChildBuilderDelegate(
           itemBuilder,
           childCount: itemCount,
         ),
       );

  @override
  createRenderObject(BuildContext context) {
    final element = context as SliverVariableSizeBoxAdaptorElement;
    _renderObject = RenderMeasurableSliverStaggeredGrid(
      childManager: element,
      gridDelegate: gridDelegate,
    );
    return _renderObject!;
  }

  RenderMeasurableSliverStaggeredGrid? get renderObject => _renderObject;

  RenderMeasurableSliverStaggeredGrid? _renderObject;
}

class RenderMeasurableSliverStaggeredGrid extends RenderSliverStaggeredGrid
    with WidgetsBindingObserver {
  RenderMeasurableSliverStaggeredGrid({
    required super.childManager,
    required super.gridDelegate,
  });

  /// Calculate the height of this staggered grid view
  ///
  /// This basically requires a complete layout of every child, so only call
  /// when necessary
  double calculateExtent() {
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    double product = 0;
    final configuration = gridDelegate.getConfiguration(constraints);
    final mainAxisOffsets = configuration.generateMainAxisOffsets();

    // Iterate through all children
    for (var index = 0; true; index++) {
      var geometry = RenderSliverStaggeredGrid.getSliverStaggeredGeometry(
        index,
        configuration,
        mainAxisOffsets,
      );
      if (geometry == null) {
        // There are either no children, or we are past the end of all our children.
        break;
      }

      final bool hasTrailingScrollOffset = geometry.hasTrailingScrollOffset;
      RenderBox? child;
      if (!hasTrailingScrollOffset) {
        // Layout the child to compute its tailingScrollOffset.
        final constraints = BoxConstraints.tightFor(
          width: geometry.crossAxisExtent,
        );
        child = addAndLayoutChild(index, constraints, parentUsesSize: true);
        geometry = geometry.copyWith(mainAxisExtent: paintExtentOf(child!));
      }

      if (child != null) {
        final childParentData =
            child.parentData as SliverVariableSizeBoxAdaptorParentData;
        childParentData.layoutOffset = geometry.scrollOffset;
        childParentData.crossAxisOffset = geometry.crossAxisOffset;
        assert(childParentData.index == index);
      }

      final double endOffset =
          geometry.trailingScrollOffset + configuration.mainAxisSpacing;
      for (var i = 0; i < geometry.crossAxisCellCount; i++) {
        mainAxisOffsets[i + geometry.blockIndex] = endOffset;
      }
      if (endOffset > product) {
        product = endOffset;
      }
    }
    childManager.didFinishLayout();
    return product;
  }
}
