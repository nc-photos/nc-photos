part of 'changelog.dart';

class _Changelog830 extends StatelessWidget {
  const _Changelog830();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Improved UX when adding map to client side album"),
        ),
        _bulletGroup(
          const Text("Fixed unable to edit maps/labels in client side album"),
        ),
        _bulletGroup(
          const Text("Temporarily disabled metadata processing for mp4 files"),
        ),
      ],
    );
  }
}
