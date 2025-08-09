part of '../changelog.dart';

class _Changelog662 extends StatelessWidget {
  const _Changelog662();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subSection("Changes"),
        _bulletGroup(
          const Text(
            "Fixed not being able to set a biometric app lock with password fallback",
          ),
        ),
        _bulletGroup(const Text("Updated Chinese (Simplified), Turkish")),
        _sectionPadding(),
        _subSection("Contributors"),
        _bulletGroup(
          const Text("Special thanks to the following contributors \u{1f44f}"),
          [const Text("aliyasiny65"), const Text("老兄")],
        ),
      ],
    );
  }
}
