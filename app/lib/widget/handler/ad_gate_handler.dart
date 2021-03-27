import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/widget/ad.dart';
import 'package:np_math/np_math.dart';

class AdGateHandler {
  AdGateHandler() {
    if (features.isSupportAds && !_isCooldown()) {
      _hasLoadedAd = true;
      _adHandler.init();
    } else {
      _hasLoadedAd = false;
    }
  }

  /// Handle ad-gated contents
  ///
  /// Return true if this user can proceed to the contents
  Future<bool> call({
    required BuildContext context,
    required String contentText,
    required String rewardedText,
  }) async {
    // check cooldown again since the ads may get shown in other instances
    if (!_hasLoadedAd || _isCooldown()) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(contentText),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("WATCH AD"),
          ),
          ElevatedButton(
            onPressed: () {
              launch(
                  "https://play.google.com/store/apps/details?id=com.nkming.nc_photos.paid&referrer=utm_source%3Dfreeapp");
            },
            child: const Text("GET PAID VERSION"),
          ),
        ],
      ),
    );
    if (result != true) {
      return false;
    } else {
      return await _showAd(rewardedText);
    }
  }

  bool _isCooldown() =>
      RewardedAdHandler.isCooldownPeriod(const Duration(days: 1));

  Future<bool> _showAd(String rewardedText) async {
    // wait for the ad to finish loading, max 5s
    for (final _ in 0.until(50)) {
      if (_adHandler.isAdReady) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (!_adHandler.isAdReady) {
      _log.shout("[_showAd] Ad failed to load in time");
      SnackBarManager().showSnackBar(const SnackBar(
        content: Text("Failed to load ad"),
        duration: k.snackBarDurationNormal,
      ));
      return false;
    }

    final dismissCompleter = Completer();
    bool isEarned = false;
    _adHandler.show(
      onAdDismissedFullScreenContent: () {
        dismissCompleter.complete();
      },
      onAdFailedToShowFullScreenContent: (_) {
        dismissCompleter.complete();
      },
      onUserEarnedReward: (_) {
        isEarned = true;
      },
    );
    await dismissCompleter.future;
    if (isEarned) {
      await Pref().setLastAdRewardTime(DateTime.now().millisecondsSinceEpoch);
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(rewardedText),
        duration: k.snackBarDurationNormal,
      ));
      return true;
    } else {
      return false;
    }
  }

  final _adHandler = RewardedAdHandler();
  late final bool _hasLoadedAd;

  static final _log = Logger("widget.handler.ad_gate_handler.AdGateHandler");
}
