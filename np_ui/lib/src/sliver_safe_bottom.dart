import 'package:flutter/material.dart';

/// Empty space at the end of a CustomScrollView to cover the system ui overlays
/// like the navigation bar
class SliverSafeBottom extends StatelessWidget {
  const SliverSafeBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
    );
  }
}
