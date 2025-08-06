import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_init.dart' as app_init;
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/photo_list_item.dart';
import 'package:nc_photos/widget/photo_list_util.dart';
import 'package:nc_photos/widget/selectable_item_stream_list_mixin.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';

part 'photo_list_item_builder.g.dart';

/// Arguments to the photo list item builder
///
/// If [smartAlbumConfig] != null, the builder will also build smart albums in
/// the process
class PhotoListItemBuilderArguments {
  const PhotoListItemBuilderArguments(
    this.account,
    this.files, {
    this.isArchived = false,
    required this.sorter,
    this.grouper,
    this.smartAlbumConfig,
    this.shouldShowFavoriteBadge = false,
    required this.locale,
  });

  final Account account;
  final List<FileDescriptor> files;
  final bool isArchived;
  final PhotoListItemSorter? sorter;
  final PhotoListItemGrouper? grouper;
  final PhotoListItemSmartAlbumConfig? smartAlbumConfig;
  final bool shouldShowFavoriteBadge;

  /// Locale is needed to get localized string
  final Locale locale;
}

class PhotoListItemBuilderResult {
  const PhotoListItemBuilderResult(
    this.backingFiles,
    this.listItems, {
    this.smartCollections = const [],
  });

  final List<FileDescriptor> backingFiles;
  final List<SelectableItem> listItems;
  final List<Collection> smartCollections;
}

typedef PhotoListItemSorter = int Function(FileDescriptor, FileDescriptor);

abstract class PhotoListItemGrouper {
  const PhotoListItemGrouper();

  SelectableItem? onFile(FileDescriptor file);
}

class PhotoListFileDateGrouper implements PhotoListItemGrouper {
  PhotoListFileDateGrouper({required this.isMonthOnly})
    : helper = DateGroupHelper(isMonthOnly: isMonthOnly);

  @override
  onFile(FileDescriptor file) => helper
      .onDate(file.fdDateTime.toLocal().toDate())
      ?.run((date) => PhotoListDateItem(date: date, isMonthOnly: isMonthOnly));

  final bool isMonthOnly;
  final DateGroupHelper helper;
}

class PhotoListItemSmartAlbumConfig {
  const PhotoListItemSmartAlbumConfig(this.memoriesDayRange);

  final int memoriesDayRange;
}

int photoListFileDateTimeSorter(FileDescriptor a, FileDescriptor b) =>
    compareFileDescriptorDateTimeDescending(a, b);

int photoListFilenameSorter(FileDescriptor a, FileDescriptor b) =>
    compareNatural(b.filename, a.filename);

PhotoListItemBuilderResult buildPhotoListItem(
  PhotoListItemBuilderArguments arg,
) {
  app_init.initLog();
  return _PhotoListItemBuilder(
    isArchived: arg.isArchived,
    sorter: arg.sorter,
    grouper: arg.grouper,
    smartAlbumConfig: arg.smartAlbumConfig,
    shouldShowFavoriteBadge: arg.shouldShowFavoriteBadge,
    locale: arg.locale,
  )(arg.account, arg.files);
}

@npLog
class _PhotoListItemBuilder {
  const _PhotoListItemBuilder({
    required this.isArchived,
    required this.sorter,
    required this.grouper,
    required this.smartAlbumConfig,
    required this.shouldShowFavoriteBadge,
    required this.locale,
  });

  PhotoListItemBuilderResult call(Account account, List<FileDescriptor> files) {
    final s = Stopwatch()..start();
    try {
      return _fromSortedItems(account, _sortItems(files));
    } finally {
      _log.info("[call] Elapsed time: ${s.elapsedMilliseconds}ms");
    }
  }

  List<FileDescriptor> _sortItems(List<FileDescriptor> files) {
    final filtered = files.where((f) => f.fdIsArchived == isArchived);
    if (sorter == null) {
      return filtered.toList();
    } else {
      return filtered.sorted(sorter!);
    }
  }

  PhotoListItemBuilderResult _fromSortedItems(
    Account account,
    List<FileDescriptor> files,
  ) {
    final today = Date.today();
    final memoryAlbumHelper =
        smartAlbumConfig != null
            ? MemoryCollectionHelper(
              account,
              today: today,
              dayRange: smartAlbumConfig!.memoriesDayRange,
            )
            : null;
    final listItems = <SelectableItem>[];
    for (int i = 0; i < files.length; ++i) {
      final f = files[i];
      final item = _buildListItem(i, account, f);
      if (item != null) {
        grouper?.onFile(f)?.run((item) => listItems.add(item));
        memoryAlbumHelper?.addFile(f);
        listItems.add(item);
      }
    }
    final smartAlbums = memoryAlbumHelper?.build(
      (year) => L10n.of(locale).memoryAlbumName(today.year - year),
    );
    return PhotoListItemBuilderResult(
      files,
      listItems,
      smartCollections: smartAlbums ?? [],
    );
  }

  SelectableItem? _buildListItem(int i, Account account, FileDescriptor file) {
    final previewUrl = NetworkRectThumbnail.imageUrlForFile(account, file);
    if (file_util.isSupportedImageFormat(file)) {
      return PhotoListImageItem(
        fileIndex: i,
        file: file,
        account: account,
        previewUrl: previewUrl,
        shouldShowFavoriteBadge: shouldShowFavoriteBadge,
      );
    } else if (file_util.isSupportedVideoFormat(file)) {
      return PhotoListVideoItem(
        fileIndex: i,
        file: file,
        account: account,
        previewUrl: previewUrl,
        shouldShowFavoriteBadge: shouldShowFavoriteBadge,
      );
    } else {
      _log.shout("[_buildListItem] Unsupported file format: ${file.fdMime}");
      return null;
    }
  }

  final bool isArchived;
  final PhotoListItemSorter? sorter;
  final PhotoListItemGrouper? grouper;
  final PhotoListItemSmartAlbumConfig? smartAlbumConfig;
  final bool shouldShowFavoriteBadge;
  final Locale locale;
}
