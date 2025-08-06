import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/mobile/self_signed_cert_manager.dart';

class ServerCertErrorDialog extends StatelessWidget {
  const ServerCertErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().serverCertErrorDialogTitle),
      content: Text(L10n.global().serverCertErrorDialogContent),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(L10n.global().advancedButtonLabel),
        ),
      ],
    );
  }
}

class WhitelistLastBadCertDialog extends StatelessWidget {
  const WhitelistLastBadCertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().whitelistCertDialogTitle),
      content: Text(
        L10n.global().whitelistCertDialogContent(
          SelfSignedCertManager().getLastBadCertHost(),
          SelfSignedCertManager().getLastBadCertFingerprint(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(L10n.global().whitelistCertButtonLabel),
        ),
      ],
    );
  }
}
