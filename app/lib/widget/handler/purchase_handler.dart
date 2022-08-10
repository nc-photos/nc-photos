import 'dart:async';

import 'package:collection/collection.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:logging/logging.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_platform_util/np_platform_util.dart';

class PurchaseHandler {
  factory PurchaseHandler() => _inst;

  PurchaseHandler._() {
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (e) {
        _log.severe("[PurchaseHandler] purchaseStream erred", e);
      },
    );
    Future.delayed(const Duration(seconds: 10)).then((_) async {
      await InAppPurchase.instance.restorePurchases();
    });
  }

  void pushOnSuccessListener(void Function(List<PurchaseDetails> details) l) {
    _onSuccessListeners.add(l);
  }

  void popOnSuccessListener() {
    _onSuccessListeners.removeLast();
  }

  void pushOnFailureListener(void Function(List<PurchaseDetails> details) l) {
    _onFailureListeners.add(l);
  }

  void popOnFailureListener() {
    _onFailureListeners.removeLast();
  }

  /// PurchaseUpdatedListeners are called after other status listeners
  void pushOnPurchaseUpdatedListener(
      void Function(Map<PurchaseStatus, List<PurchaseDetails>> details) l) {
    _onPurchaseUpdatedListeners.add(l);
  }

  void popOnPurchaseUpdatedListener() {
    _onPurchaseUpdatedListeners.removeLast();
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> details) async {
    _log.info(
        "[_onPurchaseUpdated] ${details.map((d) => d.toStringEx()).toReadableString()}");
    final statusMap = details.groupBy(key: (d) => d.status);
    if (statusMap[PurchaseStatus.error]?.isNotEmpty == true) {
      final failures = statusMap[PurchaseStatus.error]!;
      _log.warning(
          "[_onPurchaseUpdated] Error: ${failures.map((e) => "${e.error!.code}: ${e.error!.message}").toReadableString()}");
      try {
        _onFailureListeners.lastOrNull?.call(failures);
      } catch (e, stackTrace) {
        _log.severe("[_onPurchaseUpdated] Uncaught exception", e, stackTrace);
      }
    }
    if (statusMap[PurchaseStatus.purchased]?.isNotEmpty == true ||
        statusMap[PurchaseStatus.restored]?.isNotEmpty == true) {
      final successes = (statusMap[PurchaseStatus.purchased] ?? []) +
          (statusMap[PurchaseStatus.restored] ?? []);
      try {
        _onSuccessListeners.lastOrNull?.call(successes);
      } catch (e, stackTrace) {
        _log.severe("[_onPurchaseUpdated] Uncaught exception", e, stackTrace);
      }
    }

    for (final d in details.where((d) =>
        d.pendingCompletePurchase || d.status == PurchaseStatus.restored)) {
      try {
        _log.info("[_onPurchaseUpdated] Complete purchase: ${d.toStringEx()}");
        await InAppPurchase.instance.completePurchase(d);
        if (d.status == PurchaseStatus.restored) {
          // restored purchases are not automatically consumed
          _log.info(
              "[_onPurchaseUpdated] Consume restored purchase: ${d.purchaseID}");
          if (getRawPlatform() == NpPlatform.android) {
            final addition = InAppPurchase.instance
                .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await addition.consumePurchase(d);
          }
        }
      } catch (e, stackTrace) {
        _log.severe("[_onPurchaseUpdated] Failed while completePurchase", e,
            stackTrace);
      }
    }

    for (final l in _onPurchaseUpdatedListeners) {
      l(statusMap);
    }
  }

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final _onSuccessListeners = <void Function(List<PurchaseDetails>)>[];
  final _onFailureListeners = <void Function(List<PurchaseDetails>)>[];
  final _onPurchaseUpdatedListeners =
      <void Function(Map<PurchaseStatus, List<PurchaseDetails>>)>[];

  static final _inst = PurchaseHandler._();

  static final _log = Logger("widget.handler.purchase_handler.PurchaseHandler");
}

extension on PurchaseDetails {
  toStringEx() => "PurchaseDetails {"
      "purchaseID: $purchaseID, "
      "productID: $productID, "
      "transactionDate: $transactionDate, "
      "status: ${status.name}, "
      "}";
}
