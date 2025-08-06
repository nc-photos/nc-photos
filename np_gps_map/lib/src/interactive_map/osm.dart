import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:np_common/object_util.dart';
import 'package:np_gps_map/src/interactive_map.dart';
import 'package:np_gps_map/src/type.dart';
import 'package:rxdart/rxdart.dart';

typedef OsmClusterBuilder =
    Widget Function(BuildContext context, List<DataPoint> dataPoints);

class OsmInteractiveMap extends StatefulWidget {
  const OsmInteractiveMap({
    super.key,
    this.initialPosition,
    this.initialZoom,
    this.dataPoints,
    this.clusterBuilder,
    this.onClusterTap,
    this.contentPadding,
    this.onMapCreated,
    this.onCameraMove,
  });

  @override
  State<StatefulWidget> createState() => _OsmInteractiveMapState();

  final MapCoord? initialPosition;
  final double? initialZoom;
  final List<DataPoint>? dataPoints;
  final OsmClusterBuilder? clusterBuilder;
  final void Function(List<DataPoint> dataPoints)? onClusterTap;
  final EdgeInsets? contentPadding;
  final void Function(InteractiveMapController controller)? onMapCreated;
  final void Function(CameraPosition position)? onCameraMove;
}

class _OsmInteractiveMapState extends State<OsmInteractiveMap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_parentController == null) {
        _parentController = _ParentController(_controller);
        widget.onMapCreated?.call(_parentController!);
        _subscriptions.add(
          _controller.mapEventStream.listen((ev) {
            _mapRotationRadSubject.add(ev.camera.rotationRad);
            widget.onCameraMove?.call(
              CameraPosition(
                center: ev.camera.center.toMapCoord(),
                zoom: ev.camera.zoom,
                rotation: (360 - ev.camera.rotation) % 360,
              ),
            );
          }),
        );
      }
    });
  }

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _mapRotationRadSubject.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: widget.initialPosition?.toLatLng() ?? const LatLng(0, 0),
        initialZoom: max(2.5, widget.initialZoom ?? 2.5),
        minZoom: 2.5,
        interactionOptions: const InteractionOptions(
          enableMultiFingerGestureRace: true,
          pinchZoomThreshold: 0.25,
          rotationThreshold: 15,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        if (widget.dataPoints != null)
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              markers:
                  widget.dataPoints!
                      .map(
                        (e) => _OsmDataPoint(
                          original: e,
                          child: _buildMarker(context, [e]),
                        ),
                      )
                      .toList(),
              builder:
                  (context, markers) => _buildMarker(
                    context,
                    markers
                        .cast<_OsmDataPoint>()
                        .map((e) => e.original)
                        .toList(),
                  ),
              // need to be large enough to contain markers of all size
              size: const Size.square(_markerBoundingBoxSize),
              // disable all tap handlers from package
              zoomToBoundsOnClick: false,
              centerMarkerOnClick: false,
              spiderfyCluster: false,
              markerChildBehavior: true,
            ),
          ),
        Padding(
          padding: widget.contentPadding ?? EdgeInsets.zero,
          child: const SimpleAttributionWidget(
            source: Text("OpenStreetMap contributors"),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              8,
              MediaQuery.of(context).padding.top + 8,
              8,
              0,
            ),
            child: _CompassIcon(
              mapRotationRadSubject: _mapRotationRadSubject,
              onTap: () {
                if (_controller.camera.rotation != 0) {
                  _controller.rotate(0);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarker(BuildContext context, List<DataPoint> dataPoints) {
    if (widget.clusterBuilder == null) {
      return const SizedBox.shrink();
    } else {
      return GestureDetector(
        onTap: widget.onClusterTap?.let((l) => () => l(dataPoints)),
        child: StreamBuilder(
          stream: _mapRotationRadSubject.stream,
          initialData: _mapRotationRadSubject.value,
          builder:
              (context, snapshot) => Transform.rotate(
                angle: -snapshot.requireData,
                child: widget.clusterBuilder!(context, dataPoints),
              ),
        ),
      );
    }
  }

  _ParentController? _parentController;
  late final _controller = MapController();
  final _mapRotationRadSubject = BehaviorSubject.seeded(0.0);
  final _subscriptions = <StreamSubscription>[];
}

class _CompassIcon extends StatelessWidget {
  const _CompassIcon({required this.mapRotationRadSubject, this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: mapRotationRadSubject.stream,
      initialData: mapRotationRadSubject.value,
      builder:
          (context, snapshot) => Transform.rotate(
            angle: snapshot.requireData,
            child: GestureDetector(
              onTap: () {
                onTap?.call();
              },
              child: Opacity(
                opacity: .8,
                child: Image(
                  image:
                      Theme.of(context).brightness == Brightness.light
                          ? const AssetImage(
                            "packages/np_gps_map/assets/map_compass.png",
                          )
                          : const AssetImage(
                            "packages/np_gps_map/assets/map_compass_dark.png",
                          ),
                ),
              ),
            ),
          ),
    );
  }

  final BehaviorSubject<double> mapRotationRadSubject;
  final VoidCallback? onTap;
}

class _OsmDataPoint extends Marker {
  _OsmDataPoint({required this.original, required super.child})
    : super(
        point: original.position.toLatLng(),
        width: _markerBoundingBoxSize,
        height: _markerBoundingBoxSize,
      );

  final DataPoint original;
}

class _ParentController implements InteractiveMapController {
  const _ParentController(this.controller);

  @override
  void setPosition(MapCoord position) {
    controller.move(position.toLatLng(), 10);
  }

  final MapController controller;
}

extension on MapCoord {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

// define the size of each marker's bounding box. This is NOT necessarily the
// size of the marker, it's merely the size of its bounding box and the actual
// size of the content is determined by the child (e.g., the Container widget)
const _markerBoundingBoxSize = 120.0;
