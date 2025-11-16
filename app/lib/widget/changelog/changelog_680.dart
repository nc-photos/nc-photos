part of 'changelog.dart';

class _Changelog680 extends StatelessWidget {
  const _Changelog680();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Fixed some collections not showing up when you are offline",
          ),
        ),
        _bulletGroup(
          const Text("Fixed photos not showing up in a shared album"),
        ),
        _bulletGroup(const Text("Can now tweak the default time range in Map")),
      ],
    );
  }
}
