import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc/donation.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/widget/handler/purchase_handler.dart';
import 'package:nc_photos/widget/processing_dialog.dart';

class Donation extends StatefulWidget {
  static const routeName = "/donation";

  static Route buildRoute() => MaterialPageRoute(
        builder: (context) => const Donation(),
      );

  const Donation({Key? key}) : super(key: key);

  @override
  createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  @override
  initState() {
    super.initState();
    _initPurchase();
    _initBloc();
  }

  @override
  dispose() {
    PurchaseHandler()
      ..popOnSuccessListener()
      ..popOnFailureListener()
      ..popOnPurchaseUpdatedListener();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      extendBodyBehindAppBar: true,
      body: BlocListener<DonationBloc, DonationBlocState>(
        bloc: _bloc,
        listener: (context, state) => _onStateChange(context, state),
        child: BlocBuilder<DonationBloc, DonationBlocState>(
          bloc: _bloc,
          builder: (context, state) => _buildContent(context, state),
        ),
      ),
    );
  }

  void _initPurchase() {
    PurchaseHandler()
      ..pushOnSuccessListener(_showSuccessDialog)
      ..pushOnFailureListener(_showFailureDialog)
      ..pushOnPurchaseUpdatedListener(_onPurchaseUpdated);
  }

  void _initBloc() {
    _log.info("[_initBloc] Initialize bloc");
    _reqQuery();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildContent(BuildContext context, DonationBlocState state) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Text("☕", style: TextStyle(fontSize: 56)),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Text(
              L10n.global().donationTitle,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Text(L10n.global().donationThankYouMessage),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            L10n.global().donationLongMessage,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(thickness: 1, height: 1),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: _products.length,
            itemBuilder: _buildItem,
            separatorBuilder: (_, __) => const Divider(height: 1),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            L10n.global().donationBottomMessage,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final p = _products[index];
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(p.title),
      trailing: Text(p.price),
      onTap: () {
        final param = PurchaseParam(productDetails: p.details);
        InAppPurchase.instance.buyConsumable(purchaseParam: param);
      },
    );
  }

  void _onStateChange(BuildContext context, DonationBlocState state) {
    if (state is DonationBlocInit) {
      _products = [];
    } else if (state is DonationBlocSuccess || state is DonationBlocLoading) {
      _products = state.products;
    } else if (state is DonationBlocFailure) {
      _products = state.products;
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(exception_util.toUserString(state.exception)),
        duration: k.snackBarDurationNormal,
      ));
    }
  }

  Future<void> _onPurchaseUpdated(
      Map<PurchaseStatus, List<PurchaseDetails>> details) async {
    if (details[PurchaseStatus.pending]?.isNotEmpty == true) {
      if (!_isPendingDialogVisible) {
        _isPendingDialogVisible = true;
        unawaited(showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              ProcessingDialog(text: L10n.global().donationPendingMessage),
        ));
      }
    } else {
      if (_isPendingDialogVisible) {
        _isPendingDialogVisible = false;
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _showSuccessDialog(List<PurchaseDetails> successes) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(L10n.global().donationSuccessMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _showFailureDialog(List<PurchaseDetails> failures) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(L10n.global().donationFailureMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }

  void _reqQuery() {
    _bloc.add(const DonationBlocQuery());
  }

  late final _bloc = DonationBloc();
  var _products = <StoreProduct>[];

  var _isPendingDialogVisible = false;

  static final _log = Logger("widget.donation._DonationState");
}
