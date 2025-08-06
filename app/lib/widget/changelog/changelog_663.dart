part of '../changelog.dart';

class _Changelog663 extends StatelessWidget {
  const _Changelog663();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text("Fixed collections not being sorted correctly"),
        ),
      ],
    );
  }
}
