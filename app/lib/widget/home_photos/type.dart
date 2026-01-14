part of 'home_photos.dart';

abstract class _Item implements SelectableItemMetadata {
  const _Item();

  /// Unique id used to identify this item
  String get id;

  StaggeredTile get staggeredTile;

  Widget buildWidget(BuildContext context);
}

abstract class _FileItem extends _Item {
  const _FileItem({required this.file});

  @override
  String get id => "file-${file.id}";

  @override
  bool get isSelectable => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _FileItem && file.compareIdentity(other.file));

  @override
  int get hashCode => file.identityHashCode;

  final AnyFile file;
}

class _PhotoItem extends _FileItem {
  const _PhotoItem({required super.file, required this.account});

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return AnyFilePresenterFactory.photoListImage(
      file,
      account: account,
      shouldShowFavorite: true,
      shouldUseHero: true,
    ).buildWidget();
  }

  final Account account;
}

class _VideoItem extends _FileItem {
  const _VideoItem({required super.file, required this.account});

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return AnyFilePresenterFactory.photoListVideo(
      file,
      account: account,
      shouldShowFavorite: true,
      onError: () {
        context.addEvent(const _TripMissingVideoPreview());
      },
    ).buildWidget();
  }

  final Account account;
}

class _DateItem extends _Item {
  const _DateItem({required this.date, required this.isMonthOnly});

  @override
  String get id => "date-$date";

  @override
  bool get isSelectable => false;

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.extent(99, 32);

  @override
  Widget buildWidget(BuildContext context) {
    return SizedBox(
      height: AppDimension.of(context).timelineDateItemHeight,
      child: PhotoListDate(date: date, isMonthOnly: isMonthOnly),
    );
  }

  final Date date;
  final bool isMonthOnly;
}

class _ItemTransformerArgument {
  const _ItemTransformerArgument({
    required this.account,
    required this.anyFiles,
    required this.summary,
    required this.mergedCounts,
    this.itemPerRow,
    this.itemSize,
    required this.isGroupByDay,
  });

  final Account account;
  final List<AnyFile> anyFiles;
  final AnyFilesSummary summary;
  final Map<Date, int> mergedCounts;
  final int? itemPerRow;
  final double? itemSize;
  final bool isGroupByDay;
}

class _ItemTransformerResult {
  const _ItemTransformerResult({required this.items, required this.dates});

  final List<List<_Item>> items;
  final Set<Date> dates;
}

@toString
class _VisibleDate implements Comparable<_VisibleDate> {
  const _VisibleDate(this.id, this.date);

  @override
  bool operator ==(Object other) => other is _VisibleDate && id == other.id;

  @override
  int compareTo(_VisibleDate other) => id.compareTo(other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => _$toString();

  final String id;
  final Date date;
}

enum _SelectionMenuOption { archive, delete, download }

@toString
class _RemoveFailedError implements Exception {
  const _RemoveFailedError(this.count);

  @override
  String toString() => _$toString();

  final int count;
}

class _SummaryFileItem extends _Item {
  const _SummaryFileItem({required this.date, required this.index});

  @override
  String get id => "summary-file-$date-$index";

  @override
  bool get isSelectable => false;

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return ShimmerLoading(
      isLoading: true,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).listPlaceholderBackgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  final Date date;
  final int index;
}

class _ShareRequest {
  const _ShareRequest({required this.files});

  final List<AnyFile> files;
}

class _UploadRequest {
  const _UploadRequest({required this.files});

  final List<AnyFile> files;
}

@toString
class _DeleteRequest {
  const _DeleteRequest({required this.files});

  @override
  String toString() => _$toString();

  final List<AnyFile> files;
}
