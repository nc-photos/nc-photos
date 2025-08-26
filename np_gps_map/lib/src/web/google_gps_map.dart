// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:np_gps_map/src/ui_hack.dart'
    if (dart.library.html) 'dart:ui'
    as ui;

class GoogleGpsMap extends StatefulWidget {
  const GoogleGpsMap({
    super.key,
    required this.center,
    required this.zoom,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _GoogleGpsMapState();

  final ({double lat, double lng}) center;
  final double zoom;
  final void Function()? onTap;
}

class _GoogleGpsMapState extends State<GoogleGpsMap> {
  @override
  void initState() {
    super.initState();
    final iframe =
        IFrameElement()
          ..src =
              "https://www.google.com/maps/embed/v1/place?key=$_apiKey"
              "&q=${widget.center.lat},${widget.center.lng}"
              "&zoom=${widget.zoom}"
          ..style.border = "none";
    ui.platformViewRegistry.registerViewFactory(viewType, (_) => iframe);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: viewType);
  }

  static const _apiKey = "";

  String get viewType =>
      "googleMapIframe(${widget.center.lat},${widget.center.lng})";
}
