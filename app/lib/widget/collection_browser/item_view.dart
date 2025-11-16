part of 'collection_browser.dart';

class _LabelView extends StatelessWidget {
  const _LabelView({required this.text});

  @override
  Widget build(BuildContext context) {
    return PhotoListLabel(text: text);
  }

  final String text;
}

class _EditLabelView extends StatelessWidget {
  const _EditLabelView({required this.text, required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return PhotoListLabelEdit(text: text, onEditPressed: onEditPressed);
  }

  final String text;
  final VoidCallback? onEditPressed;
}

class _MapView extends StatelessWidget {
  const _MapView({required this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilderEx<GpsMapProvider>(
      stream: context.read<PrefController>().gpsMapProvider,
      builder: StreamWidgetBuilder.value(
        (context, gpsMapProvider) => StaticMap(
          key: Key(location.toString()),
          providerHint: gpsMapProvider,
          location: location,
          onTap: onTap,
        ),
      ),
    );
  }

  final CameraPosition location;
  final VoidCallback? onTap;
}

class _EditMapView extends StatelessWidget {
  const _EditMapView({required this.location, required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(absorbing: true, child: _MapView(location: location)),
        Positioned(
          top: 8,
          right: 8,
          child: FloatingActionButton.small(
            onPressed: onEditPressed,
            child: const Icon(Icons.edit_outlined),
          ),
        ),
      ],
    );
  }

  final CameraPosition location;
  final VoidCallback? onEditPressed;
}
