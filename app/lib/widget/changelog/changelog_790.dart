part of '../changelog.dart';

class _Changelog790 extends StatelessWidget {
  const _Changelog790();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(const Text("DCIM folder can now be excluded")),
      ],
    );
  }
}
