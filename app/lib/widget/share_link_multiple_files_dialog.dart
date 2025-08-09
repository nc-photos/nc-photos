import 'package:flutter/material.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/app_localizations.dart';

class ShareLinkMultipleFilesDialogResult {
  ShareLinkMultipleFilesDialogResult(this.albumName, this.password);

  final String albumName;
  final String? password;
}

class ShareLinkMultipleFilesDialog extends StatefulWidget {
  const ShareLinkMultipleFilesDialog({
    super.key,
    this.shouldAskPassword = false,
  });

  @override
  createState() => _ShareLinkMultipleFilesDialogState();

  final bool shouldAskPassword;
}

class _ShareLinkMultipleFilesDialogState
    extends State<ShareLinkMultipleFilesDialog> {
  @override
  build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.global().multipleFilesLinkShareDialogContent),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                hintText: L10n.global().folderNameInputHint,
              ),
              validator: (value) {
                if (value?.isNotEmpty != true) {
                  return L10n.global().folderNameInputInvalidEmpty;
                }
                if (value!.contains(api_util.reservedFilenameChars)) {
                  return L10n.global().folderNameInputInvalidCharacters;
                }
                return null;
              },
              onSaved: (value) {
                _formValue.name = value!;
              },
            ),
            if (widget.shouldAskPassword == true) const SizedBox(height: 8),
            if (widget.shouldAskPassword == true)
              TextFormField(
                decoration: InputDecoration(
                  hintText: L10n.global().passwordInputHint,
                ),
                validator: (value) {
                  if (value?.isNotEmpty != true) {
                    return L10n.global().passwordInputInvalidEmpty;
                  }
                  return null;
                },
                onSaved: (value) {
                  _formValue.password = value!;
                },
                obscureText: true,
              ),
          ],
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
          onPressed: _onOkPressed,
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }

  void _onOkPressed() {
    if (_formKey.currentState?.validate() == true) {
      _formValue = _FormValue();
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        ShareLinkMultipleFilesDialogResult(
          _formValue.name,
          _formValue.password,
        ),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  var _formValue = _FormValue();
}

class _FormValue {
  late String name;
  String? password;
}
