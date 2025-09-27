part of 'viewer_detail_pane.dart';

class _ButtonBar extends StatefulWidget {
  const _ButtonBar({
    required this.onRemoveFromCollectionPressed,
    required this.onArchivePressed,
    required this.onUnarchivePressed,
    required this.onDeletePressed,
    this.onSlideshowPressed,
  });

  @override
  State<StatefulWidget> createState() => _ButtonBarState();

  final void Function(BuildContext context) onRemoveFromCollectionPressed;
  final void Function(BuildContext context) onArchivePressed;
  final void Function(BuildContext context) onUnarchivePressed;
  final void Function(BuildContext context) onDeletePressed;
  final VoidCallback? onSlideshowPressed;
}

class _ButtonBarState extends State<_ButtonBar> {
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () => _updateButtonScroll(_scrollController.position),
    );
    _ensureUpdateButtonScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_hasLeftButton)
          const Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Opacity(opacity: .5, child: Icon(Icons.keyboard_arrow_left)),
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
          controller: _scrollController,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BlocSelector(
                selector: (state) => state.canRemoveFromAlbum,
                builder:
                    (context, canRemoveFromAlbum) =>
                        canRemoveFromAlbum
                            ? _DetailPaneButton(
                              icon: Icons.remove_outlined,
                              label: L10n.global().removeFromAlbumTooltip,
                              onPressed:
                                  () => widget.onRemoveFromCollectionPressed(
                                    context,
                                  ),
                            )
                            : const SizedBox.shrink(),
              ),
              _BlocSelector(
                selector: (state) => state.canSetCover,
                builder:
                    (context, canSetCover) =>
                        canSetCover
                            ? _DetailPaneButton(
                              icon: Icons.photo_album_outlined,
                              label: L10n.global().useAsAlbumCoverTooltip,
                              onPressed: () {
                                context.addEvent(const _SetAlbumCover());
                              },
                            )
                            : const SizedBox.shrink(),
              ),
              _BlocSelector(
                selector: (state) => state.canAddToCollection,
                builder:
                    (context, canAddToCollection) =>
                        canAddToCollection
                            ? _DetailPaneButton(
                              icon: Icons.add,
                              label: L10n.global().addItemToCollectionTooltip,
                              onPressed: () => _onAddToAlbumPressed(context),
                            )
                            : const SizedBox.shrink(),
              ),
              _BlocSelector(
                selector: (state) => state.canSetAs,
                builder:
                    (context, canSetAs) =>
                        canSetAs
                            ? _DetailPaneButton(
                              icon: Icons.launch,
                              label: L10n.global().setAsTooltip,
                              onPressed: () => _onSetAsPressed(context),
                            )
                            : const SizedBox.shrink(),
              ),
              _BlocSelector(
                selector: (state) => state.canArchive,
                builder: (context, canArchive) {
                  if (canArchive) {
                    if ((context.bloc.file.provider as ArchivableAnyFile)
                        .isArchived) {
                      return _DetailPaneButton(
                        icon: Icons.unarchive_outlined,
                        label: L10n.global().unarchiveTooltip,
                        onPressed: () => widget.onUnarchivePressed(context),
                      );
                    } else {
                      return _DetailPaneButton(
                        icon: Icons.archive_outlined,
                        label: L10n.global().archiveTooltip,
                        onPressed: () => widget.onArchivePressed(context),
                      );
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              _BlocSelector(
                selector: (state) => state.canDelete,
                builder:
                    (context, canDelete) =>
                        canDelete
                            ? _DetailPaneButton(
                              icon: Icons.delete_outlined,
                              label: L10n.global().deleteTooltip,
                              onPressed: () => widget.onDeletePressed(context),
                            )
                            : const SizedBox.shrink(),
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
    );
  }

  void _ensureUpdateButtonScroll() {
    if (_hasFirstScrollUpdate || !mounted) {
      return;
    }
    if (_scrollController.hasClients) {
      if (_updateButtonScroll(_scrollController.position)) {
        return;
      }
    }
    Timer(const Duration(milliseconds: 100), _ensureUpdateButtonScroll);
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
    _hasFirstScrollUpdate = true;
    return true;
  }

  Future<void> _onAddToAlbumPressed(BuildContext context) {
    if (context.bloc.file.provider is! AnyFileNextcloudProvider) {
      throw UnsupportedError("File not supported");
    }
    final provider = context.bloc.file.provider as AnyFileNextcloudProvider;
    return const AddSelectionToCollectionHandler()(
      context: context,
      selection: [provider.file],
      clearSelection: () {},
    );
  }

  void _onSetAsPressed(BuildContext context) {
    final c = KiwiContainer().resolve<DiContainer>();
    final worker = AnyFileWorkerFactory.setAs(
      context.bloc.file,
      account: context.bloc.account,
      c: c,
    );
    worker.setAs(context);
  }

  final _scrollController = ScrollController();
  var _hasFirstScrollUpdate = false;
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

class _NameItem extends StatelessWidget {
  const _NameItem();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.size,
      builder:
          (context, size) => ListTile(
            leading: const ListTileCenterLeading(
              child: Icon(Icons.image_outlined),
            ),
            title: Text(
              path_lib.basenameWithoutExtension(context.bloc.file.name),
            ),
            subtitle: size?.let((e) => Text(_buildSizeSubtitle(e))),
          ),
    );
  }

  static String _buildSizeSubtitle(SizeInt size) {
    var sizeSubStr = "";
    const space = "    ";

    final pixelCount = size.width * size.height;
    if (pixelCount >= 500000) {
      final mpCount = pixelCount / 1000000.0;
      sizeSubStr += L10n.global().megapixelCount(mpCount.toStringAsFixed(1));
      sizeSubStr += space;
    }
    sizeSubStr += "${size.width} x ${size.height}";
    return sizeSubStr;
  }
}

class _OwnerItem extends StatelessWidget {
  const _OwnerItem();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.isOwned != current.isOwned ||
              previous.owner != current.owner,
      builder: (context, state) {
        if (state.isOwned == false && state.owner != null) {
          return ListTile(
            leading: const ListTileCenterLeading(
              child: Icon(Icons.share_outlined),
            ),
            title: Text(state.owner!),
            subtitle: Text(L10n.global().fileSharedByDescription),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _TagItem extends StatelessWidget {
  const _TagItem();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.tags,
      builder:
          (context, tags) =>
              tags != null && tags.isNotEmpty
                  ? ListTile(
                    leading: const Icon(Icons.local_offer_outlined),
                    title: SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: tags.length,
                        itemBuilder:
                            (context, index) => FilterChip(
                              elevation: 1,
                              pressElevation: 1,
                              showCheckmark: false,
                              visualDensity: VisualDensity.compact,
                              selected: true,
                              label: Text(tags[index].name),
                              onSelected: (_) {},
                            ),
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 8),
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
    );
  }
}

class _DateTimeItem extends StatelessWidget {
  const _DateTimeItem();

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat(
      DateFormat.YEAR_ABBR_MONTH_DAY,
      Localizations.localeOf(context).languageCode,
    ).format(context.bloc.file.dateTime.toLocal());
    final timeStr = DateFormat(
      DateFormat.HOUR_MINUTE,
      Localizations.localeOf(context).languageCode,
    ).format(context.bloc.file.dateTime.toLocal());
    return ListTile(
      leading: const Icon(Icons.calendar_today_outlined),
      title: Text("$dateStr $timeStr"),
      // trailing: _file == null ? null : const Icon(Icons.edit_outlined),
      // onTap: _file == null ? null : () => _onDateTimeTap(context),
    );
  }
}

class _SizeItem extends StatelessWidget {
  const _SizeItem();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.byteSize,
      builder: (context, byteSize) {
        final IconData icon;
        String title;
        switch (context.bloc.file.provider) {
          case AnyFileNextcloudProvider _:
            icon = Icons.cloud_outlined;
            title = L10n.global().fileOnCloud;
            break;
          case AnyFileLocalProvider _:
            icon = Icons.phone_android_outlined;
            title = L10n.global().fileOnDevice;
            break;
        }
        if (byteSize != null) {
          title += " (${_byteSizeToString(byteSize)})";
        }
        return ListTile(
          leading: ListTileCenterLeading(child: Icon(icon)),
          title: Text(title),
          subtitle: context.bloc.file.displayPath?.let(Text.new),
        );
      },
    );
  }
}

class _ModelItem extends StatelessWidget {
  const _ModelItem();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.model != current.model ||
              previous.fNumber != current.fNumber ||
              previous.exposureTime != current.exposureTime ||
              previous.focalLength != current.focalLength ||
              previous.isoSpeedRatings != current.isoSpeedRatings,
      builder:
          (context, state) =>
              state.model != null
                  ? ListTile(
                    leading: const ListTileCenterLeading(
                      child: Icon(Icons.camera_outlined),
                    ),
                    title: Text(state.model!),
                    subtitle: _buildCameraSubtitle(
                      fNumber: state.fNumber,
                      exposureTime: state.exposureTime,
                      focalLength: state.focalLength,
                      isoSpeedRatings: state.isoSpeedRatings,
                    )?.let(Text.new),
                  )
                  : const SizedBox.shrink(),
    );
  }

  static String? _buildCameraSubtitle({
    double? fNumber,
    String? exposureTime,
    double? focalLength,
    int? isoSpeedRatings,
  }) {
    String cameraSubStr = "";
    const space = "    ";
    if (fNumber != null) {
      cameraSubStr += "f/${fNumber.toStringAsFixed(1)}$space";
    }
    if (exposureTime != null) {
      cameraSubStr += L10n.global().secondCountSymbol(exposureTime);
      cameraSubStr += space;
    }
    if (focalLength != null) {
      cameraSubStr += L10n.global().millimeterCountSymbol(
        focalLength.toStringAsFixedTruncated(2),
      );
      cameraSubStr += space;
    }
    if (isoSpeedRatings != null) {
      cameraSubStr += "ISO$isoSpeedRatings$space";
    }
    cameraSubStr = cameraSubStr.trim();
    return cameraSubStr.isEmpty ? null : cameraSubStr;
  }
}

class _LocationItem extends StatelessWidget {
  const _LocationItem();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.location,
      builder:
          (context, location) =>
              location?.name != null
                  ? ListTile(
                    leading: const ListTileCenterLeading(
                      child: Icon(Icons.location_on_outlined),
                    ),
                    title: Text(L10n.global().gpsPlaceText(location!.name!)),
                    subtitle: _toSubtitle(location)?.let(Text.new),
                    trailing: const Icon(Icons.info_outline),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const AboutGeocodingDialog(),
                      );
                    },
                  )
                  : const SizedBox.shrink(),
    );
  }

  static String? _toSubtitle(ImageLocation location) {
    if (location.countryCode == null) {
      return null;
    } else if (location.admin1 == null) {
      return alpha2CodeToName(location.countryCode!);
    } else if (location.admin2 == null) {
      return "${location.admin1}, ${alpha2CodeToName(location.countryCode!)}";
    } else {
      return "${location.admin2}, ${location.admin1}, ${alpha2CodeToName(location.countryCode!)}";
    }
  }
}

class _GpsItem extends StatefulWidget {
  const _GpsItem();

  @override
  State<StatefulWidget> createState() => _GpsItemState();
}

class _GpsItemState extends State<_GpsItem> {
  @override
  Widget build(BuildContext context) {
    return _BlocListenerT(
      selector: (state) => state.gps,
      listener: (context, gps) {
        if (gps != null) {
          _timer ??= Timer(const Duration(milliseconds: 750), () {
            if (mounted) {
              setState(() {
                _shouldBlockGpsMap = false;
              });
            }
          });
        }
      },
      child: _BlocSelector(
        selector: (state) => state.gps,
        builder:
            (context, gps) =>
                features.isSupportMapView && gps != null
                    ? AnimatedVisibility(
                      opacity: _shouldBlockGpsMap ? 0 : 1,
                      curve: Curves.easeInOut,
                      duration: k.animationDurationNormal,
                      child: SizedBox(
                        height: 256,
                        child: ValueStreamBuilder<GpsMapProvider>(
                          stream: context.read<PrefController>().gpsMapProvider,
                          builder:
                              (context, gpsMapProvider) => StaticMap(
                                providerHint: gpsMapProvider.requireData,
                                location: CameraPosition(center: gps, zoom: 16),
                                onTap:
                                    () => launchExternalMap(
                                      CameraPosition(center: gps, zoom: 16),
                                    ),
                              ),
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
      ),
    );
  }

  Timer? _timer;
  var _shouldBlockGpsMap = true;
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
