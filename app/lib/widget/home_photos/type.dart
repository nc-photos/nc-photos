part of '../home_photos2.dart';

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

abstract class _NextcloudFileItem extends _FileItem {
  _NextcloudFileItem({required this.remoteFile})
    : super(file: remoteFile.toAnyFile());

  final FileDescriptor remoteFile;
}

class _NextcloudPhotoItem extends _NextcloudFileItem {
  _NextcloudPhotoItem({required super.remoteFile, required this.account})
    : _previewUrl = NetworkRectThumbnail.imageUrlForFile(account, remoteFile);

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return PhotoListImage(
      account: account,
      previewUrl: _previewUrl,
      mime: file.mime,
      isFavorite: remoteFile.fdIsFavorite,
      heroKey: flutter_util.HeroTag.fromAnyFile(file),
    );
  }

  final Account account;
  final String _previewUrl;
}

class _NextcloudVideoItem extends _NextcloudFileItem {
  _NextcloudVideoItem({required super.remoteFile, required this.account})
    : _previewUrl = NetworkRectThumbnail.imageUrlForFile(account, remoteFile);

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return PhotoListVideo(
      account: account,
      previewUrl: _previewUrl,
      mime: file.mime,
      isFavorite: remoteFile.fdIsFavorite,
      onError: () {
        context.addEvent(const _TripMissingVideoPreview());
      },
    );
  }

  final Account account;
  final String _previewUrl;
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

abstract class _LocalFileItem extends _FileItem {
  _LocalFileItem({required this.localFile})
    : super(file: localFile.toAnyFile());

  final LocalFile localFile;
}

class _LocalPhotoItem extends _LocalFileItem {
  _LocalPhotoItem({required super.localFile});

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return PhotoListLocalImage(file: localFile);
  }
}

class _LocalVideoItem extends _LocalFileItem {
  _LocalVideoItem({required super.localFile});

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return PhotoListLocalVideo(file: localFile);
  }
}

class _ItemTransformerArgument {
  const _ItemTransformerArgument({
    required this.account,
    required this.files,
    required this.summary,
    required this.localFiles,
    required this.localSummary,
    this.itemPerRow,
    this.itemSize,
    required this.isGroupByDay,
  });

  final Account account;
  final List<FileDescriptor> files;
  final DbFilesSummary summary;
  final List<LocalFile> localFiles;
  final LocalFilesSummary localSummary;
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
class _ArchiveFailedError implements Exception {
  const _ArchiveFailedError(this.count);

  @override
  String toString() => _$toString();

  final int count;
}

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

@toString
class _ShareRequest {
  const _ShareRequest({
    required this.files,
    required this.isRemoteShareOnly,
    required this.isLocalShareOnly,
  });

  @override
  String toString() => _$toString();

  final List<AnyFile> files;
  final bool isRemoteShareOnly;
  final bool isLocalShareOnly;
}

class _UploadRequest {
  const _UploadRequest({required this.files});

  final List<AnyFile> files;
}
