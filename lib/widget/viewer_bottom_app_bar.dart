import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Button bar near the bottom of viewer
///
/// Buttons are spread evenly across the horizontal axis
class ViewerBottomAppBar extends StatelessWidget {
  ViewerBottomAppBar({
    required this.children,
  });

  @override
  build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, -1),
          end: const Alignment(0, 1),
          colors: [
            Color.fromARGB(0, 0, 0, 0),
            Color.fromARGB(192, 0, 0, 0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: children
            .map((e) => Expanded(
                  flex: 1,
                  child: e,
                ))
            .toList(),
      ),
    );
  }

  final List<Widget> children;
}