part of 'map_browser.dart';

class _MapView extends StatefulWidget {
  const _MapView();

  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT<MapCoord?>(
          selector: (state) => state.initialPoint,
          listener: (context, initialPoint) {
            if (initialPoint != null) {
              _controller?.setPosition(initialPoint);
            }
          },
        ),
      ],
      child: _BlocBuilder(
        buildWhen: (previous, current) => previous.data != current.data,
        builder: (context, state) {
          final prevPosition =
              context.read<PrefController>().mapBrowserPrevPositionValue;
          return ValueStreamBuilder<GpsMapProvider>(
            stream: context.bloc.prefController.gpsMapProvider,
            builder:
                (context, gpsMapProvider) => InteractiveMap(
                  providerHint: gpsMapProvider.requireData,
                  initialPosition: prevPosition ?? const MapCoord(0, 0),
                  initialZoom: prevPosition == null ? 2.5 : 10,
                  dataPoints: state.data,
                  onClusterTap: (dataPoints) {
                    final c = Collection(
                      name: "",
                      contentProvider: CollectionAdHocProvider(
                        account: context.bloc.account,
                        fileIds:
                            dataPoints
                                .cast<_DataPoint>()
                                .map((e) => e.fileId)
                                .toList(),
                      ),
                    );
                    Navigator.of(context).pushNamed(
                      CollectionBrowser.routeName,
                      arguments: CollectionBrowserArguments(c),
                    );
                  },
                  googleClusterBuilder:
                      (context, dataPoints) => _GoogleMarkerBuilder(
                        context,
                        account: context.bloc.account,
                      ).build(dataPoints.cast()),
                  osmClusterBuilder:
                      (context, dataPoints) => _OsmMarkerBuilder(
                        context,
                        account: context.bloc.account,
                      ).build(dataPoints.cast()),
                  contentPadding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  onMapCreated: (controller) {
                    _controller = controller;
                    if (state.initialPoint != null) {
                      controller.setPosition(state.initialPoint!);
                    }
                  },
                ),
          );
        },
      ),
    );
  }

  InteractiveMapController? _controller;
}

class _OsmMarker extends StatelessWidget {
  const _OsmMarker({
    required this.account,
    required this.fileId,
    required this.fileRelativePath,
    required this.mime,
    required this.size,
    required this.color,
    required this.text,
    required this.textSize,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .3),
              blurRadius: 2,
              offset: const Offset(1, 1),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: .75),
            width: 2,
          ),
          color: color,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Stack(
            children: [
              NetworkRectThumbnail(
                account: account,
                imageUrl: NetworkRectThumbnail.imageUrlForFile(
                  account,
                  FileDescriptor(
                    fdPath: file_util.unstripPath(account, fileRelativePath),
                    fdId: fileId,
                    fdMime: mime,
                    fdIsArchived: false,
                    fdIsFavorite: false,
                    fdDateTime: clock.now(),
                  ),
                ),
                mime: mime,
                errorBuilder: (_) => const SizedBox.shrink(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                  color: color,
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: textSize, color: textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final Account account;
  final int fileId;
  final String fileRelativePath;
  final String? mime;
  final double size;
  final Color color;
  final String text;
  final double textSize;
  final Color textColor;
}

class _PanelContainer extends StatefulWidget {
  const _PanelContainer({required this.isShow, required this.child});

  @override
  State<StatefulWidget> createState() => _PanelContainerState();

  final bool isShow;
  final Widget child;
}

class _PanelContainerState extends State<_PanelContainer>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: k.animationDurationNormal,
      vsync: this,
      value: 0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _PanelContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isShow != widget.isShow) {
      if (widget.isShow) {
        _animationController.animateTo(1);
      } else {
        _animationController.animateBack(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MatrixTransition(
      animation: _animation,
      onTransform:
          (animationValue) =>
              Matrix4.identity()
                ..translate(
                  0.0,
                  -(_size.height / 2) * (1 - animationValue),
                  0.0,
                )
                ..scale(1.0, animationValue, 1.0),
      child: MeasureSize(
        onChange:
            (size) => setState(() {
              _size = size;
            }),
        child: widget.child,
      ),
    );
  }

  late AnimationController _animationController;
  late Animation<double> _animation;
  var _size = Size.zero;
}

class _DateRangeToggle extends StatelessWidget {
  const _DateRangeToggle();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () {
        context.addEvent(const _OpenDataRangeControlPanel());
      },
      child: const Icon(Icons.date_range_outlined),
    );
  }
}

class _DateRangeControlPanel extends StatelessWidget {
  const _DateRangeControlPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.elevate(theme.colorScheme.surface, 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 4, offset: Offset(0, 2), color: Colors.black26),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      L10n.global().mapBrowserDateRangeLabel,
                      style: Theme.of(context).listTileTheme.titleTextStyle,
                    ),
                  ),
                  Expanded(
                    child: _BlocSelector<_DateRangeType>(
                      selector: (state) => state.dateRangeType,
                      builder:
                          (context, dateRangeType) =>
                              DropdownButtonFormField<_DateRangeType>(
                                items:
                                    _DateRangeType.values
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.toDisplayString()),
                                          ),
                                        )
                                        .toList(),
                                value: dateRangeType,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.addEvent(_SetDateRangeType(value));
                                  }
                                },
                              ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: _BlocSelector<DateRange>(
                      selector: (state) => state.localDateRange,
                      builder:
                          (context, localDateRange) => _DateField(
                            localDateRange.from!,
                            onChanged: (value) {
                              context.addEvent(
                                _SetLocalDateRange(
                                  localDateRange.copyWith(from: value.toDate()),
                                ),
                              );
                            },
                          ),
                    ),
                  ),
                  const Text(" - "),
                  Expanded(
                    child: _BlocSelector<DateRange>(
                      selector: (state) => state.localDateRange,
                      builder:
                          (context, localDateRange) => _DateField(
                            localDateRange.to!,
                            onChanged: (value) {
                              context.addEvent(
                                _SetLocalDateRange(
                                  localDateRange.copyWith(to: value.toDate()),
                                ),
                              );
                            },
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: _SetAsDefaultSwitch(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatefulWidget {
  const _DateField(this.date, {this.onChanged});

  @override
  State<StatefulWidget> createState() => _DateFieldState();

  final Date date;
  final ValueChanged<DateTime>? onChanged;
}

class _DateFieldState extends State<_DateField> {
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(covariant _DateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != oldWidget.date) {
      _controller.text = _stringify(widget.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () async {
          final result = await showDatePicker(
            context: context,
            firstDate: DateTime.fromMillisecondsSinceEpoch(0),
            lastDate: clock.now(),
            currentDate: widget.date.toLocalDateTime(),
          );
          if (result == null) {
            return;
          }
          widget.onChanged?.call(result);
        },
        child: IgnorePointer(
          child: ExcludeFocus(child: TextFormField(controller: _controller)),
        ),
      ),
    );
  }

  String _stringify(Date date) {
    if (date == clock.now().toDate()) {
      return L10n.global().todayText;
    } else {
      return intl.DateFormat(
        intl.DateFormat.YEAR_ABBR_MONTH_DAY,
        Localizations.localeOf(context).languageCode,
      ).format(date.toLocalDateTime());
    }
  }

  late final _controller = TextEditingController(text: _stringify(widget.date));
}

class _SetAsDefaultSwitch extends StatelessWidget {
  const _SetAsDefaultSwitch();

  @override
  Widget build(BuildContext context) {
    return _BlocBuilder(
      buildWhen:
          (previous, current) =>
              previous.dateRangeType != current.dateRangeType ||
              previous.prefDateRangeType != current.prefDateRangeType ||
              previous.localDateRange != current.localDateRange,
      builder: (context, state) {
        final isChecked = state.dateRangeType == state.prefDateRangeType;
        final isEnabled =
            state.dateRangeType != _DateRangeType.custom ||
            state.localDateRange.to == clock.now().toDate();
        return InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64),
          ),
          onTap:
              isEnabled && !isChecked
                  ? () {
                    if (!isChecked) {
                      context.addEvent(const _SetAsDefaultRange());
                    }
                  }
                  : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16),
              Text(
                L10n.global().mapBrowserSetDefaultDateRangeButton,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isEnabled ? null : Theme.of(context).disabledColor,
                ),
              ),
              IgnorePointer(
                child: Checkbox(
                  value: isChecked,
                  onChanged: isEnabled ? (_) {} : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
