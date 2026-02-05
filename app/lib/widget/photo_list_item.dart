import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/flutter_util.dart' as flutter_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/content_uri_image_provider.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/network_thumbnail.dart';
import 'package:nc_photos/widget/selectable_item_stream_list_mixin.dart';
import 'package:np_common/size.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:to_string/to_string.dart';

part 'photo_list_item.g.dart';

@toString
abstract class PhotoListFileItem extends SelectableItem {
  const PhotoListFileItem({
    required this.fileIndex,
    required this.file,
    required this.shouldShowFavoriteBadge,
  });

  @override
  get isTappable => true;

  @override
  get isSelectable => true;

  @override
  operator ==(Object other) =>
      other is PhotoListFileItem && file.compareServerIdentity(other.file);

  @override
  get hashCode => file.fdPath.hashCode;

  @override
  String toString() => _$toString();

  final int fileIndex;
  final FileDescriptor file;
  final bool shouldShowFavoriteBadge;
}

class PhotoListImageItem extends PhotoListFileItem {
  const PhotoListImageItem({
    required super.fileIndex,
    required super.file,
    required this.account,
    required this.previewUrl,
    required super.shouldShowFavoriteBadge,
  });

  @override
  Widget buildWidget(BuildContext context) => PhotoListImage(
    account: account,
    previewUrl: previewUrl,
    mime: file.fdMime,
    isFavorite: shouldShowFavoriteBadge && file.fdIsFavorite == true,
    heroKey: flutter_util.HeroTag.fromFile(file),
  );

  final Account account;
  final String previewUrl;
}

class PhotoListVideoItem extends PhotoListFileItem {
  const PhotoListVideoItem({
    required super.fileIndex,
    required super.file,
    required this.account,
    required this.previewUrl,
    required super.shouldShowFavoriteBadge,
  });

  @override
  Widget buildWidget(BuildContext context) => PhotoListVideo(
    account: account,
    previewUrl: previewUrl,
    mime: file.fdMime,
    isFavorite: shouldShowFavoriteBadge && file.fdIsFavorite == true,
  );

  final Account account;
  final String previewUrl;
}

class PhotoListDateItem extends SelectableItem {
  const PhotoListDateItem({required this.date, this.isMonthOnly = false});

  @override
  get isTappable => false;

  @override
  get isSelectable => false;

  @override
  get staggeredTile => const StaggeredTile.extent(99, 32);

  @override
  buildWidget(BuildContext context) =>
      PhotoListDate(date: date, isMonthOnly: isMonthOnly);

  final Date date;
  final bool isMonthOnly;
}

abstract class PhotoListLocalFileItem extends SelectableItem {
  const PhotoListLocalFileItem({required this.fileIndex, required this.file});

  @override
  get isTappable => true;

  @override
  get isSelectable => true;

  @override
  operator ==(Object other) =>
      other is PhotoListLocalFileItem && file.compareIdentity(other.file);

  @override
  get hashCode => file.identityHashCode;

  final int fileIndex;
  final LocalFile file;
}

class PhotoListLocalImageItem extends PhotoListLocalFileItem {
  const PhotoListLocalImageItem({
    required super.fileIndex,
    required super.file,
  });

  @override
  Widget buildWidget(BuildContext context) => PhotoListLocalImage(
    file: file,
    backupStatus: PhotoListLocalFileBackupStatus.none,
  );
}

class PhotoListImage extends StatelessWidget {
  const PhotoListImage({
    super.key,
    required this.account,
    required this.previewUrl,
    required this.mime,
    this.padding = const EdgeInsets.all(2),
    this.isFavorite = false,
    this.heroKey,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildPlaceholder() => Padding(
      padding: const EdgeInsets.all(12),
      child: Icon(
        Icons.image_not_supported,
        color: Theme.of(context).listPlaceholderForegroundColor,
      ),
    );
    Widget child;
    if (previewUrl == null) {
      child = FittedBox(child: buildPlaceholder());
    } else {
      child = NetworkRectThumbnail(
        account: account,
        imageUrl: previewUrl!,
        mime: mime,
        errorBuilder: (_) => buildPlaceholder(),
      );
      if (heroKey != null) {
        child = Hero(tag: heroKey!, child: child);
      }
    }

    return IconTheme(
      data: const IconThemeData(color: Colors.white),
      child: Padding(
        padding: padding,
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).listPlaceholderBackgroundColor,
              child: child,
            ),
            const _BottomGradientOverlay(),
            Container(
              alignment: AlignmentDirectional.bottomEnd,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: const Icon(Icons.cloud_done_outlined, size: 16),
            ),
            if (mime == "image/gif")
              Container(
                alignment: AlignmentDirectional.topEnd,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: const Icon(Icons.gif, size: 26),
              ),
            if (isFavorite)
              Container(
                alignment: AlignmentDirectional.bottomStart,
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.star, size: 15),
              ),
          ],
        ),
      ),
    );
  }

  final Account account;
  final String? previewUrl;
  final String? mime;
  final EdgeInsetsGeometry padding;
  final bool isFavorite;
  // if not null, the image will be contained by a Hero widget
  final Object? heroKey;
}

class PhotoListVideo extends StatelessWidget {
  const PhotoListVideo({
    super.key,
    required this.account,
    required this.previewUrl,
    required this.mime,
    this.isFavorite = false,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: const IconThemeData(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).listPlaceholderBackgroundColor,
              child: NetworkRectThumbnail(
                account: account,
                imageUrl: previewUrl,
                mime: mime,
                errorBuilder: (context) {
                  onError?.call();
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Theme.of(context).listPlaceholderForegroundColor,
                    ),
                  );
                },
              ),
            ),
            const _BottomGradientOverlay(),
            Container(
              alignment: AlignmentDirectional.bottomEnd,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: const Icon(Icons.cloud_done_outlined, size: 16),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              top: 5,
              end: 5,
              child: const Icon(Icons.play_circle_outlined, size: 17),
            ),
            if (isFavorite)
              Positioned.directional(
                textDirection: Directionality.of(context),
                bottom: 6,
                start: 6,
                child: const Icon(Icons.star, size: 15),
              ),
          ],
        ),
      ),
    );
  }

  final Account account;
  final String previewUrl;
  final String? mime;
  final bool isFavorite;
  final VoidCallback? onError;
}

class PhotoListLabel extends StatelessWidget {
  const PhotoListLabel({super.key, required this.text});

  @override
  build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  final String text;
}

class PhotoListLabelEdit extends PhotoListLabel {
  const PhotoListLabelEdit({
    super.key,
    required super.text,
    required this.onEditPressed,
  });

  @override
  build(BuildContext context) {
    return Stack(
      children: [
        // needed to expand the touch sensitive area to the whole row
        Container(color: Colors.transparent),
        super.build(context),
        PositionedDirectional(
          top: 0,
          bottom: 0,
          end: 0,
          child: IconButton(
            icon: const Icon(Icons.edit),
            tooltip: L10n.global().editTooltip,
            onPressed: onEditPressed,
          ),
        ),
      ],
    );
  }

  final VoidCallback? onEditPressed;
}

class PhotoListDate extends StatelessWidget {
  const PhotoListDate({
    super.key,
    required this.date,
    this.isMonthOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final pattern =
        isMonthOnly ? DateFormat.YEAR_MONTH : DateFormat.YEAR_MONTH_DAY;
    final subtitle = DateFormat(
      pattern,
      Localizations.localeOf(context).languageCode,
    ).format(date.toUtcDateTime());
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }

  final Date date;
  final bool isMonthOnly;
}

enum PhotoListLocalFileBackupStatus { none, backedUp }

class PhotoListLocalImage extends StatelessWidget {
  const PhotoListLocalImage({
    super.key,
    required this.file,
    required this.backupStatus,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider provider;
    if (file is LocalUriFile) {
      provider = ContentUriImage(
        (file as LocalUriFile).uri,
        thumbnailSizeHint: SizeInt.square(k.photoThumbSize),
      );
    } else {
      throw ArgumentError("Invalid file");
    }

    return IconTheme(
      data: const IconThemeData(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: FittedBox(
          clipBehavior: Clip.hardEdge,
          fit: BoxFit.cover,
          child: Stack(
            children: [
              Container(
                // arbitrary size here
                constraints: BoxConstraints.tight(const Size(128, 128)),
                color: Theme.of(context).listPlaceholderBackgroundColor,
                child: Hero(
                  tag: flutter_util.HeroTag.fromLocalFile(file),
                  child: Image(
                    image: provider,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color:
                              Theme.of(context).listPlaceholderForegroundColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (backupStatus != PhotoListLocalFileBackupStatus.none) ...[
                ConstrainedBox(
                  constraints: BoxConstraints.tight(const Size(128, 128)),
                  child: const _BottomGradientOverlay(),
                ),
                Container(
                  // arbitrary size here
                  constraints: BoxConstraints.tight(const Size(128, 128)),
                  alignment: AlignmentDirectional.bottomEnd,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: const Icon(Icons.cloud_done_outlined, size: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  final LocalFile file;
  final PhotoListLocalFileBackupStatus backupStatus;
}

class PhotoListLocalVideo extends StatelessWidget {
  const PhotoListLocalVideo({
    super.key,
    required this.file,
    required this.backupStatus,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider provider;
    if (file is LocalUriFile) {
      provider = ContentUriImage(
        (file as LocalUriFile).uri,
        thumbnailSizeHint: SizeInt.square(k.photoThumbSize),
      );
    } else {
      throw ArgumentError("Invalid file");
    }

    return IconTheme(
      data: const IconThemeData(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: FittedBox(
          clipBehavior: Clip.hardEdge,
          fit: BoxFit.cover,
          child: Stack(
            children: [
              Container(
                // arbitrary size here
                constraints: BoxConstraints.tight(const Size(128, 128)),
                color: Theme.of(context).listPlaceholderBackgroundColor,
                child: Hero(
                  tag: flutter_util.HeroTag.fromLocalFile(file),
                  child: Image(
                    image: ResizeImage.resizeIfNeeded(
                      k.photoThumbSize,
                      null,
                      provider,
                    ),
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color:
                              Theme.of(context).listPlaceholderForegroundColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (backupStatus != PhotoListLocalFileBackupStatus.none) ...[
                ConstrainedBox(
                  constraints: BoxConstraints.tight(const Size(128, 128)),
                  child: const _BottomGradientOverlay(),
                ),
                Container(
                  // arbitrary size here
                  constraints: BoxConstraints.tight(const Size(128, 128)),
                  alignment: AlignmentDirectional.bottomEnd,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: const Icon(Icons.cloud_done_outlined, size: 20),
                ),
              ],
              Container(
                // arbitrary size here
                constraints: BoxConstraints.tight(const Size(128, 128)),
                alignment: AlignmentDirectional.topEnd,
                padding: const EdgeInsets.all(7),
                child: const Icon(Icons.play_circle_outlined, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final LocalFile file;
  final PhotoListLocalFileBackupStatus backupStatus;
}

class _BottomGradientOverlay extends StatelessWidget {
  const _BottomGradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black12, Colors.transparent],
          begin: Alignment(0, .75),
          end: Alignment(0, .5),
        ),
      ),
    );
  }
}
