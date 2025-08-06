import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Center leading widget in ListTile
///
/// Leading widget in ListTile used to center align vertically, but it was
/// changed in an update later. This widget revert to the old behavior
///
/// This widget is only needed when the content of the ListTile may grow more
/// than 1 line
class ListTileCenterLeading extends StatelessWidget {
  const ListTileCenterLeading({super.key, required this.child});

  @override
  build(BuildContext context) =>
      SizedBox(height: double.infinity, child: child);

  final Widget child;
}
