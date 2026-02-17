import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';

class SelectionAppBar extends StatelessWidget {
  const SelectionAppBar({
    super.key,
    required this.count,
    this.onClosePressed,
    this.actions,
  });

  @override
  build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        onPressed: onClosePressed,
      ),
      title: Text(L10n.global().selectionAppBarTitle(count)),
      actions: actions,
    );
  }

  final int count;
  final VoidCallback? onClosePressed;
  final List<Widget>? actions;
}

class BoxSelectionAppBar extends StatelessWidget {
  const BoxSelectionAppBar({
    super.key,
    required this.count,
    this.onClosePressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        onPressed: onClosePressed,
      ),
      title: Text(L10n.global().selectionAppBarTitle(count)),
      actions: actions,
    );
  }

  final int count;
  final VoidCallback? onClosePressed;
  final List<Widget>? actions;
}
