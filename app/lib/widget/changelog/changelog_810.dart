part of 'changelog.dart';

class _Changelog810 extends StatelessWidget {
  const _Changelog810();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "App will now ask where to delete a file from if the file exsits on both server and phone",
          ),
        ),
        _bulletGroup(
          const Text("Fixed timezone in metadata not being handled correctly"),
          [const Text("A full resync will be performed as part of the fix")],
        ),
      ],
    );
  }
}
