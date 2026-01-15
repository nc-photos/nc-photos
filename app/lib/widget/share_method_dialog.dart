import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:np_platform_util/np_platform_util.dart';

enum ShareMethodDialogResult { file, preview, publicLink, passwordLink }

class ShareMethodDialog extends StatelessWidget {
  const ShareMethodDialog({
    super.key,
    required this.isSupportPerview,
    required this.isSupportRemoteLink,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(L10n.global().shareMethodDialogTitle),
      children: [
        if (getRawPlatform() == NpPlatform.android) ...[
          if (isSupportPerview)
            SimpleDialogOption(
              child: ListTile(
                title: Text(L10n.global().shareMethodPreviewTitle),
                subtitle: Text(L10n.global().shareMethodPreviewDescription),
              ),
              onPressed: () {
                Navigator.of(context).pop(ShareMethodDialogResult.preview);
              },
            ),
          SimpleDialogOption(
            child: ListTile(
              title: Text(L10n.global().shareMethodOriginalFileTitle),
              subtitle: Text(L10n.global().shareMethodOriginalFileDescription),
            ),
            onPressed: () {
              Navigator.of(context).pop(ShareMethodDialogResult.file);
            },
          ),
        ],
        if (isSupportRemoteLink) ...[
          SimpleDialogOption(
            child: ListTile(
              title: Text(L10n.global().shareMethodPublicLinkTitle),
              subtitle: Text(L10n.global().shareMethodPublicLinkDescription),
            ),
            onPressed: () {
              Navigator.of(context).pop(ShareMethodDialogResult.publicLink);
            },
          ),
          SimpleDialogOption(
            child: ListTile(
              title: Text(L10n.global().shareMethodPasswordLinkTitle),
              subtitle: Text(L10n.global().shareMethodPasswordLinkDescription),
            ),
            onPressed: () {
              Navigator.of(context).pop(ShareMethodDialogResult.passwordLink);
            },
          ),
        ],
      ],
    );
  }

  final bool isSupportPerview;
  final bool isSupportRemoteLink;
}
