import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';

class DonationDialogHandler {
  Future<void> showIfNeeded(BuildContext context) async {
    final prefController = context.read<PrefController>();
    final lastMs = Pref().getLastDonationDialogTime();
    if (lastMs == null) {
      // first time
      final firstRun = prefController.firstRunTimeValue ?? clock.now().toUtc();
      final now = clock.now().toUtc();
      if (now.isAfter(firstRun) &&
          now.difference(firstRun) < const Duration(days: 7)) {
        // unnecessary
        return;
      } else {
        return _show(context);
      }
    } else {
      final last = DateTime.fromMillisecondsSinceEpoch(lastMs, isUtc: true);
      final now = clock.now().toUtc();
      if (now.isAfter(last) &&
          now.difference(last) < const Duration(days: 365)) {
        return;
      } else {
        // 1 year later...
        return _show(context);
      }
    }
  }

  Future<void> _show(BuildContext context) async {
    SnackBarManager().showSnackBar(
      SnackBar(
        content: Text(L10n.global().donationShortMessage),
        action: SnackBarAction(
          label: L10n.global().donationButtonLabel,
          onPressed: () {},
        ),
        duration: k.snackBarDurationNormal,
      ),
    );
    await Pref().setLastDonationDialogTime(
      clock.now().toUtc().millisecondsSinceEpoch,
    );
  }
}
