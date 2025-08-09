import 'package:flutter/material.dart';
import 'package:nc_photos/theme.dart';

class NavigationBarBlurFilter extends StatelessWidget {
  const NavigationBarBlurFilter({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? NavigationBarTheme.of(context).height,
      child: ClipRect(
        child: BackdropFilter(
          filter: Theme.of(context).appBarBlurFilter,
          child: const ColoredBox(color: Colors.transparent),
        ),
      ),
    );
  }

  /// Height of the navigation bar. Use the value from the current theme if null
  final double? height;
}
