import 'package:flutter/material.dart';

/// A Scaffold that can be used with dialogs
///
/// Scaffold is needed for [SnackBar] to show correctly on top of a dialog
class DialogScaffold extends StatelessWidget {
  const DialogScaffold({super.key, required this.body, this.canPop = true});

  @override
  build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (canPop) {
          Navigator.of(context).pop();
        }
      },
      child: PopScope(
        canPop: canPop,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(onTap: () {}, child: body),
        ),
      ),
    );
  }

  final Widget body;
  final bool canPop;
}
