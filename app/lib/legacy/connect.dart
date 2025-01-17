import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/legacy/app_password_exchange_bloc.dart';
import 'package:nc_photos/mobile/self_signed_cert_manager.dart';
import 'package:nc_photos/platform/features.dart' as features;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/use_case/ls_single_file.dart';
import 'package:nc_photos/widget/server_cert_error_dialog.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';

part 'connect.g.dart';

class ConnectArguments {
  ConnectArguments(this.account);

  final Account account;
}

/// Legacy sign in support, may be removed any time in the future
class Connect extends StatefulWidget {
  static const routeName = "/connect-legacy";

  static Route buildRoute(ConnectArguments args, RouteSettings settings) =>
      MaterialPageRoute<Account>(
        builder: (context) => Connect.fromArgs(args),
        settings: settings,
      );

  const Connect({
    super.key,
    required this.account,
  });

  Connect.fromArgs(ConnectArguments args, {Key? key})
      : this(
          key: key,
          account: args.account,
        );

  @override
  createState() => _ConnectState();

  final Account account;
}

@npLog
class _ConnectState extends State<Connect> {
  @override
  initState() {
    super.initState();
    _initBloc();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppPasswordExchangeBloc, AppPasswordExchangeBlocState>(
        bloc: _bloc,
        listener: (context, state) => _onStateChange(context, state),
        child: Builder(builder: (context) => _buildContent(context)),
      ),
    );
  }

  void _initBloc() {
    _log.info("[_initBloc] Initialize bloc");
    _connect();
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud,
              size: 128,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text(
              L10n.global().connectingToServer(widget.account.url),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  void _onStateChange(
      BuildContext context, AppPasswordExchangeBlocState state) {
    if (state is AppPasswordExchangeBlocSuccess) {
      final newAccount = widget.account.copyWith(password: state.password);
      _log.info("[_onStateChange] Password exchanged: $newAccount");
      _checkWebDavUrl(context, newAccount);
    } else if (state is AppPasswordExchangeBlocFailure) {
      if (features.isSupportSelfSignedCert &&
          state.exception is HandshakeException) {
        _onSelfSignedCert(context);
      } else if (state.exception is ApiException &&
          (state.exception as ApiException).response.statusCode == 401) {
        SnackBarManager().showSnackBar(SnackBar(
          content: Text(L10n.global().errorWrongPassword),
          duration: k.snackBarDurationNormal,
        ));
        Navigator.of(context).pop(null);
      } else {
        SnackBarManager().showSnackBarForException(state.exception);
        Navigator.of(context).pop(null);
      }
    }
  }

  void _onSelfSignedCert(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const ServerCertErrorDialog(),
    ).then((value) {
      if (value != true) {
        Navigator.of(context).pop();
        return;
      }
      showDialog(
        context: context,
        builder: (context) => const WhitelistLastBadCertDialog(),
      ).then((value) {
        if (value != true) {
          Navigator.of(context).pop();
          return;
        }
        SelfSignedCertManager().whitelistLastBadCert().then((value) {
          Navigator.of(context).pop();
        });
      });
    });
  }

  void _connect() {
    _bloc.add(AppPasswordExchangeBlocConnect(widget.account));
  }

  Future<void> _onCheckWebDavUrlFailed(
      BuildContext context, Account account) async {
    final userId = await _askWebDavUrl(context, account);
    if (userId != null) {
      final newAccount = account.copyWith(
        userId: userId.toCi(),
      );
      return _checkWebDavUrl(context, newAccount);
    }
  }

  Future<void> _checkWebDavUrl(BuildContext context, Account account) async {
    // check the WebDAV URL
    try {
      final c = KiwiContainer().resolve<DiContainer>();
      await LsSingleFile(c.withRemoteFileRepo())(
          account, file_util.unstripPath(account, ""));
      _log.info("[_checkWebDavUrl] Account is good: $account");
      Navigator.of(context).pop(account);
    } on ApiException catch (e) {
      if (e.response.statusCode == 404) {
        return _onCheckWebDavUrlFailed(context, account);
      }
      SnackBarManager().showSnackBarForException(e);
      Navigator.of(context).pop(null);
    } on StateError catch (_) {
      // Nextcloud for some reason doesn't return HTTP error when listing home
      // dir of other users
      return _onCheckWebDavUrlFailed(context, account);
    } catch (e, stackTrace) {
      _log.shout("[_checkWebDavUrl] Failed", e, stackTrace);
      SnackBarManager().showSnackBarForException(e);
      Navigator.of(context).pop(null);
    }
  }

  Future<String?> _askWebDavUrl(BuildContext context, Account account) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _WebDavUrlDialog(account: account),
    );
  }

  final _bloc = AppPasswordExchangeBloc();
}

class _WebDavUrlDialog extends StatefulWidget {
  const _WebDavUrlDialog({
    required this.account,
  });

  @override
  createState() => _WebDavUrlDialogState();

  final Account account;
}

class _WebDavUrlDialogState extends State<_WebDavUrlDialog> {
  @override
  build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().homeFolderNotFoundDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.global().homeFolderNotFoundDialogContent),
            const SizedBox(height: 16),
            Text("${widget.account.url}/remote.php/dav/files/"),
            TextFormField(
              validator: (value) {
                if (value?.trimAny("/").isNotEmpty == true) {
                  return null;
                }
                return L10n.global().homeFolderInputInvalidEmpty;
              },
              onSaved: (value) {
                _formValue.userId = value!.trimAny("/");
              },
              initialValue: widget.account.userId.toString(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onHelpPressed,
          child: Text(L10n.global().helpButtonLabel),
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
      _formKey.currentState!.save();
      Navigator.of(context).pop(_formValue.userId);
    }
  }

  void _onHelpPressed() {
    launch(help_util.homeFolderNotFoundUrl);
  }

  final _formKey = GlobalKey<FormState>();
  final _formValue = _FormValue();
}

class _FormValue {
  late String userId;
}
