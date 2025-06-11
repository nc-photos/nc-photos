part of '../archive_browser.dart';

abstract class _Item implements SelectableItemMetadata {
  const _Item();

  StaggeredTile get staggeredTile;

  Widget buildWidget(BuildContext context);
}

abstract class _FileItem extends _Item {
  const _FileItem({required this.file});

  @override
  bool get isSelectable => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _FileItem && file.compareServerIdentity(other.file));

  @override
  int get hashCode => file.identityHashCode;

  final FileDescriptor file;
}

class _PhotoItem extends _FileItem {
  _PhotoItem({required super.file, required this.account})
    : _previewUrl = NetworkRectThumbnail.imageUrlForFile(account, file);

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return PhotoListImage(
      account: account,
      previewUrl: _previewUrl,
      mime: file.fdMime,
      isFavorite: file.fdIsFavorite,
      heroKey: flutter_util.HeroTag.fromFile(file),
    );
  }

  final Account account;
  final String _previewUrl;
}

class _VideoItem extends _FileItem {
  _VideoItem({required super.file, required this.account})
    : _previewUrl = NetworkRectThumbnail.imageUrlForFile(account, file);

  @override
  StaggeredTile get staggeredTile => const StaggeredTile.count(1, 1);

  @override
  Widget buildWidget(BuildContext context) {
    return PhotoListVideo(
      account: account,
      previewUrl: _previewUrl,
      mime: file.fdMime,
      isFavorite: file.fdIsFavorite,
    );
  }

  final Account account;
  final String _previewUrl;
}

class _VisibleItem implements Comparable<_VisibleItem> {
  const _VisibleItem(this.index, this.item);

  @override
  bool operator ==(Object other) =>
      other is _VisibleItem && index == other.index;

  @override
  int compareTo(_VisibleItem other) => index.compareTo(other.index);

  @override
  int get hashCode => index.hashCode;

  final int index;
  final _Item item;
}

class _ItemTransformerArgument {
  const _ItemTransformerArgument({required this.account, required this.files});

  final Account account;
  final List<FileDescriptor> files;
}

class _ItemTransformerResult {
  const _ItemTransformerResult({required this.items});

  final List<_Item> items;
}
