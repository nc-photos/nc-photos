import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/debug_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/adapter.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/entity/exif_util.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/gps_map_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/set_as_handler.dart';
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/use_case/inflate_file_descriptor.dart';
import 'package:nc_photos/use_case/list_file_tag.dart';
import 'package:nc_photos/use_case/update_property.dart';
import 'package:nc_photos/widget/about_geocoding_dialog.dart';
import 'package:nc_photos/widget/handler/add_selection_to_collection_handler.dart';
import 'package:nc_photos/widget/list_tile_center_leading.dart';
import 'package:nc_photos/widget/photo_date_time_edit_dialog.dart';
import 'package:np_common/or_null.dart';
import 'package:np_geocoder/np_geocoder.dart';
import 'package:np_gps_map/np_gps_map.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_util/np_platform_util.dart';
import 'package:np_string/np_string.dart';
import 'package:np_ui/np_ui.dart';
import 'package:path/path.dart' as path_lib;

part 'viewer_detail_pane.g.dart';

class ViewerSingleCollectionData {
  const ViewerSingleCollectionData(this.collection, this.item);

  final Collection collection;
  final CollectionItem item;
}

class ViewerDetailPane extends StatefulWidget {
  const ViewerDetailPane({
    super.key,
    required this.account,
    required this.fd,
    this.fromCollection,
    required this.onRemoveFromCollectionPressed,
    required this.onArchivePressed,
    required this.onUnarchivePressed,
    required this.onDeletePressed,
    this.onSlideshowPressed,
  });

  @override
  createState() => _ViewerDetailPaneState();

  final Account account;
  final FileDescriptor fd;

  /// Data of the collection this file belongs to, or null
  final ViewerSingleCollectionData? fromCollection;

  final void Function(BuildContext context) onRemoveFromCollectionPressed;
  final void Function(BuildContext context) onArchivePressed;
  final void Function(BuildContext context) onUnarchivePressed;
  final void Function(BuildContext context) onDeletePressed;
  final VoidCallback? onSlideshowPressed;
}

@npLog
class _ViewerDetailPaneState extends State<ViewerDetailPane> {
  _ViewerDetailPaneState() {
    final c = KiwiContainer().resolve<DiContainer>();
    assert(require(c));
    assert(InflateFileDescriptor.require(c));
    _c = c;
  }

  static bool require(DiContainer c) =>
      DiContainer.has(c, DiType.fileRepo) &&
      DiContainer.has(c, DiType.albumRepo);

  @override
  void initState() {
    _log.info("[initState] File: ${widget.fd.fdPath}");
    super.initState();
    _dateTime = widget.fd.fdDateTime.toLocal();
    _initFile();

    _buttonScrollController.addListener(
        () => _updateButtonScroll(_buttonScrollController.position));
    _ensureUpdateButtonScroll();
  }

  @override
  void dispose() {
    _buttonScrollController.dispose();
    super.dispose();
  }

  Future<void> _initFile() async {
    _file =
        (await InflateFileDescriptor(_c)(widget.account, [widget.fd])).first;
    _log.fine("[_initFile] File inflated");
    // update file
    if (mounted) {
      setState(() {});
    } else {
      return;
    }
    if (_file!.metadata == null) {
      _log.info("[initState] Metadata missing in File");
    } else {
      _log.info("[initState] Metadata exists in File");
      if (_file!.metadata!.exif != null) {
        _initMetadata();
      }
    }
    await _initTags();
    // update tags
    if (mounted) {
      setState(() {});
    } else {
      return;
    }

    // postpone loading map to improve responsiveness
    unawaited(Future.delayed(const Duration(milliseconds: 750)).then((_) {
      if (mounted) {
        setState(() {
          _shouldBlockGpsMap = false;
        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY,
            Localizations.localeOf(context).languageCode)
        .format(_dateTime);
    final timeStr = DateFormat(DateFormat.HOUR_MINUTE,
            Localizations.localeOf(context).languageCode)
        .format(_dateTime);
    final bool isShowDelete;
    if (widget.fromCollection != null) {
      final collectionAdapter = CollectionAdapter.of(KiwiContainer().resolve(),
          widget.account, widget.fromCollection!.collection);
      isShowDelete =
          collectionAdapter.isPermitted(CollectionCapability.deleteItem) &&
              collectionAdapter.isItemDeletable(widget.fromCollection!.item);
    } else {
      isShowDelete = false;
    }

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_file != null) ...[
            const SizedBox(height: 8),
            Stack(
              children: [
                if (_hasLeftButton)
                  const Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Opacity(
                      opacity: .5,
                      child: Icon(Icons.keyboard_arrow_left),
                    ),
                  ),
                if (_hasRightButton)
                  const Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Opacity(
                      opacity: .5,
                      child: Icon(Icons.keyboard_arrow_right),
                    ),
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _buttonScrollController,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_canRemoveFromAlbum)
                        _DetailPaneButton(
                          icon: Icons.remove_outlined,
                          label: L10n.global().removeFromAlbumTooltip,
                          onPressed: () =>
                              widget.onRemoveFromCollectionPressed(context),
                        ),
                      if (_canSetCover)
                        _DetailPaneButton(
                          icon: Icons.photo_album_outlined,
                          label: L10n.global().useAsAlbumCoverTooltip,
                          onPressed: () => _onSetAlbumCoverPressed(context),
                        ),
                      _DetailPaneButton(
                        icon: Icons.add,
                        label: L10n.global().addItemToCollectionTooltip,
                        onPressed: () => _onAddToAlbumPressed(context),
                      ),
                      if (getRawPlatform() == NpPlatform.android &&
                          file_util.isSupportedImageFormat(_file!))
                        _DetailPaneButton(
                          icon: Icons.launch,
                          label: L10n.global().setAsTooltip,
                          onPressed: () => _onSetAsPressed(context),
                        ),
                      if (widget.fd.fdIsArchived == true)
                        _DetailPaneButton(
                          icon: Icons.unarchive_outlined,
                          label: L10n.global().unarchiveTooltip,
                          onPressed: () => widget.onUnarchivePressed(context),
                        )
                      else
                        _DetailPaneButton(
                          icon: Icons.archive_outlined,
                          label: L10n.global().archiveTooltip,
                          onPressed: () => widget.onArchivePressed(context),
                        ),
                      if (isShowDelete)
                        _DetailPaneButton(
                          icon: Icons.delete_outlined,
                          label: L10n.global().deleteTooltip,
                          onPressed: () => widget.onDeletePressed(context),
                        ),
                      _DetailPaneButton(
                        icon: Icons.slideshow_outlined,
                        label: L10n.global().slideshowTooltip,
                        onPressed: widget.onSlideshowPressed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Divider(),
            ),
          ],
          ListTile(
            leading: const ListTileCenterLeading(
              child: Icon(Icons.image_outlined),
            ),
            title: Text(path_lib.basenameWithoutExtension(widget.fd.fdPath)),
            subtitle: Text(widget.fd.strippedPath),
          ),
          if (_file != null) ...[
            if (!_file!.isOwned(widget.account.userId))
              ListTile(
                leading: const ListTileCenterLeading(
                  child: Icon(
                    Icons.share_outlined,
                  ),
                ),
                title:
                    Text(_file!.ownerDisplayName ?? _file!.ownerId!.toString()),
                subtitle: Text(L10n.global().fileSharedByDescription),
              ),
            if (_tags.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.local_offer_outlined),
                title: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tags.length,
                    itemBuilder: (context, index) => FilterChip(
                      elevation: 1,
                      pressElevation: 1,
                      showCheckmark: false,
                      visualDensity: VisualDensity.compact,
                      selected: true,
                      label: Text(_tags[index]),
                      onSelected: (_) {},
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                  ),
                ),
              ),
          ],
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text("$dateStr $timeStr"),
            trailing: _file == null ? null : const Icon(Icons.edit_outlined),
            onTap: _file == null ? null : () => _onDateTimeTap(context),
          ),
          if (_file != null) ...[
            if (_file!.metadata?.imageWidth != null &&
                _file!.metadata?.imageHeight != null)
              ListTile(
                leading: const ListTileCenterLeading(
                  child: Icon(Icons.aspect_ratio),
                ),
                title: Text(
                    "${_file!.metadata!.imageWidth} x ${_file!.metadata!.imageHeight}"),
                subtitle: Text(_buildSizeSubtitle()),
              )
            else
              ListTile(
                leading: const Icon(Icons.aspect_ratio),
                title: Text(_byteSizeToString(_file!.contentLength ?? 0)),
              ),
            if (_model != null)
              ListTile(
                leading: const ListTileCenterLeading(
                  child: Icon(Icons.camera_outlined),
                ),
                title: Text(_model!),
                subtitle: _buildCameraSubtitle()
                    .run((s) => s.isNotEmpty ? Text(s) : null),
              ),
            if (_location?.name != null)
              ListTile(
                leading: const ListTileCenterLeading(
                  child: Icon(Icons.location_on_outlined),
                ),
                title: Text(L10n.global().gpsPlaceText(_location!.name!)),
                subtitle: _location!.toSubtitle()?.run((obj) => Text(obj)),
                trailing: const Icon(Icons.info_outline),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AboutGeocodingDialog(),
                  );
                },
              ),
            if (features.isSupportMapView && _gps != null)
              AnimatedVisibility(
                opacity: _shouldBlockGpsMap ? 0 : 1,
                curve: Curves.easeInOut,
                duration: k.animationDurationNormal,
                child: SizedBox(
                  height: 256,
                  child: ValueStreamBuilder<GpsMapProvider>(
                    stream: context.read<PrefController>().gpsMapProvider,
                    builder: (context, gpsMapProvider) => StaticMap(
                      providerHint: gpsMapProvider.requireData,
                      location: CameraPosition(center: _gps!, zoom: 16),
                      onTap: () => launchExternalMap(CameraPosition(
                        center: _gps!,
                        zoom: 16,
                      )),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// Convert EXIF data to readable format
  void _initMetadata() {
    assert(_file != null);
    final exif = _file!.metadata!.exif!;
    _log.info("[_initMetadata] $exif");

    if (exif.make != null && exif.model != null) {
      _model = "${exif.make} ${exif.model}";
    }
    if (exif.fNumber != null) {
      _fNumber = exif.fNumber!.toDouble();
    }
    if (exif.exposureTime != null) {
      if (exif.exposureTime!.denominator == 1) {
        _exposureTime = exif.exposureTime!.numerator.toString();
      } else {
        _exposureTime = exif.exposureTime.toString();
      }
    }
    if (exif.focalLength != null) {
      _focalLength = exif.focalLength!.toDouble();
    }
    if (exif.isoSpeedRatings != null) {
      _isoSpeedRatings = exif.isoSpeedRatings!;
    }
    final lat = exif.gpsLatitudeDeg;
    final lng = exif.gpsLongitudeDeg;
    if (lat != null && lng != null) {
      _log.fine("GPS: ($lat, $lng)");
      _gps = MapCoord(lat, lng);
      _location = _file!.location;
    }
  }

  Future<void> _initTags() async {
    assert(_file != null);
    if (file_util.isNcAlbumFile(widget.account, _file!)) {
      // tag is not supported here
      return;
    }
    final c = KiwiContainer().resolve<DiContainer>();
    try {
      final tags = await ListFileTag(c)(widget.account, _file!);
      _tags.addAll(tags.map((t) => t.displayName));
    } catch (e, stackTrace) {
      _log.shout("[_initTags] Failed while ListFileTag", e, stackTrace);
    }
  }

  String _buildSizeSubtitle() {
    String sizeSubStr = "";
    const space = "    ";
    if (_file!.metadata?.imageWidth != null &&
        _file!.metadata?.imageHeight != null) {
      final pixelCount =
          _file!.metadata!.imageWidth! * _file!.metadata!.imageHeight!;
      if (pixelCount >= 500000) {
        final mpCount = pixelCount / 1000000.0;
        sizeSubStr += L10n.global().megapixelCount(mpCount.toStringAsFixed(1));
        sizeSubStr += space;
      }
      sizeSubStr += _byteSizeToString(_file!.contentLength ?? 0);
    }
    return sizeSubStr;
  }

  String _buildCameraSubtitle() {
    String cameraSubStr = "";
    const space = "    ";
    if (_fNumber != null) {
      cameraSubStr += "f/${_fNumber!.toStringAsFixed(1)}$space";
    }
    if (_exposureTime != null) {
      cameraSubStr += L10n.global().secondCountSymbol(_exposureTime!);
      cameraSubStr += space;
    }
    if (_focalLength != null) {
      cameraSubStr += L10n.global()
          .millimeterCountSymbol(_focalLength!.toStringAsFixedTruncated(2));
      cameraSubStr += space;
    }
    if (_isoSpeedRatings != null) {
      cameraSubStr += "ISO$_isoSpeedRatings$space";
    }
    cameraSubStr = cameraSubStr.trim();
    return cameraSubStr;
  }

  Future<void> _onSetAlbumCoverPressed(BuildContext context) async {
    assert(_file != null);
    assert(widget.fromCollection != null);
    _log.info(
        "[_onSetAlbumCoverPressed] Set '${widget.fd.fdPath}' as album cover for '${widget.fromCollection!.collection.name}'");
    try {
      await context.read<AccountController>().collectionsController.edit(
            widget.fromCollection!.collection,
            cover: OrNull(_file!),
          );
    } catch (e, stackTrace) {
      _log.shout("[_onSetAlbumCoverPressed] Failed while updating album", e,
          stackTrace);
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().setCollectionCoverFailureNotification),
        duration: k.snackBarDurationNormal,
      ));
    }
  }

  Future<void> _onAddToAlbumPressed(BuildContext context) {
    assert(_file != null);
    return const AddSelectionToCollectionHandler()(
      context: context,
      selection: [_file!],
      clearSelection: () {},
    );
  }

  void _onSetAsPressed(BuildContext context) {
    assert(_file != null);
    final c = KiwiContainer().resolve<DiContainer>();
    SetAsHandler(c, context: context).setAsFile(widget.account, _file!);
  }

  void _onDateTimeTap(BuildContext context) {
    assert(_file != null);
    showDialog(
      context: context,
      builder: (context) => PhotoDateTimeEditDialog(initialDateTime: _dateTime),
    ).then((value) async {
      if (value == null || value is! DateTime) {
        return;
      }
      try {
        await UpdateProperty(fileRepo: _c.fileRepo2)
            .updateOverrideDateTime(widget.account, _file!, value);
        if (mounted) {
          setState(() {
            _dateTime = value;
          });
        }
      } catch (e, stacktrace) {
        _log.shout(
            "[_onDateTimeTap] Failed while updateOverrideDateTime: ${logFilename(widget.fd.fdPath)}",
            e,
            stacktrace);
        SnackBarManager().showSnackBar(SnackBar(
          content: Text(L10n.global().updateDateTimeFailureNotification),
          duration: k.snackBarDurationNormal,
        ));
      }
    }).catchError((e, stacktrace) {
      _log.shout("[_onDateTimeTap] Failed while showDialog", e, stacktrace);
    });
  }

  bool _updateButtonScroll(ScrollPosition pos) {
    if (!pos.hasContentDimensions || !pos.hasPixels) {
      return false;
    }
    if (pos.pixels <= pos.minScrollExtent) {
      if (_hasLeftButton) {
        setState(() {
          _hasLeftButton = false;
        });
      }
    } else {
      if (!_hasLeftButton) {
        setState(() {
          _hasLeftButton = true;
        });
      }
    }
    if (pos.pixels >= pos.maxScrollExtent) {
      if (_hasRightButton) {
        setState(() {
          _hasRightButton = false;
        });
      }
    } else {
      if (!_hasRightButton) {
        setState(() {
          _hasRightButton = true;
        });
      }
    }
    _hasFirstButtonScrollUpdate = true;
    return true;
  }

  void _ensureUpdateButtonScroll() {
    if (_hasFirstButtonScrollUpdate || !mounted) {
      return;
    }
    if (_buttonScrollController.hasClients) {
      if (_updateButtonScroll(_buttonScrollController.position)) {
        return;
      }
    }
    Timer(const Duration(milliseconds: 100), _ensureUpdateButtonScroll);
  }

  late final DiContainer _c;

  File? _file;
  late DateTime _dateTime;
  // EXIF data
  String? _model;
  double? _fNumber;
  String? _exposureTime;
  double? _focalLength;
  int? _isoSpeedRatings;
  MapCoord? _gps;
  ImageLocation? _location;

  final _tags = <String>[];

  var _shouldBlockGpsMap = true;

  late final bool _canRemoveFromAlbum = widget.fromCollection?.run((d) =>
          CollectionAdapter.of(_c, widget.account, d.collection)
              .isItemRemovable(widget.fromCollection!.item)) ??
      false;

  late final bool _canSetCover = widget.fromCollection?.run((d) =>
          CollectionAdapter.of(_c, widget.account, d.collection)
              .isPermitted(CollectionCapability.manualCover)) ??
      false;

  late final _buttonScrollController = ScrollController();
  var _hasFirstButtonScrollUpdate = false;
  var _hasLeftButton = false;
  var _hasRightButton = false;
}

class _DetailPaneButton extends StatelessWidget {
  const _DetailPaneButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 72,
                minWidth: 72,
                minHeight: 72,
              ),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Icon(icon),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
}

String _byteSizeToString(int byteSize) {
  const units = ["B", "KB", "MB", "GB"];
  var remain = byteSize.toDouble();
  int i = 0;
  while (i < units.length) {
    final next = remain / 1024;
    if (next < 1) {
      break;
    }
    remain = next;
    ++i;
  }
  return "${remain.toStringAsFixed(2)}${units[i]}";
}

extension on ImageLocation {
  String? toSubtitle() {
    if (countryCode == null) {
      return null;
    } else if (admin1 == null) {
      return alpha2CodeToName(countryCode!);
    } else if (admin2 == null) {
      return "$admin1, ${alpha2CodeToName(countryCode!)}";
    } else {
      return "$admin2, $admin1, ${alpha2CodeToName(countryCode!)}";
    }
  }
}
