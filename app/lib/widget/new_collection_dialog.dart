import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/server_controller.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/cover_provider.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/album/sort_provider.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/content_provider/album.dart';
import 'package:nc_photos/entity/collection/content_provider/nc_album.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/nc_album.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/entity/tag.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/toast.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/widget/album_dir_picker.dart';
import 'package:nc_photos/widget/processing_dialog.dart';
import 'package:nc_photos/widget/tag_picker_dialog.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'new_collection_dialog.g.dart';
part 'new_collection_dialog/bloc.dart';
part 'new_collection_dialog/state_event.dart';

/// Dialog to create a new collection
///
/// Return the created collection, or null if user cancelled
class NewCollectionDialog extends StatelessWidget {
  const NewCollectionDialog({
    super.key,
    required this.account,
    this.isAllowDynamic = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => _Bloc(
            account: account,
            supportedProviders: {
              _ProviderOption.appAlbum,
              if (context
                  .read<AccountController>()
                  .serverController
                  .isSupported(ServerFeature.ncAlbum))
                _ProviderOption.ncAlbum,
              if (isAllowDynamic) ...{_ProviderOption.dir, _ProviderOption.tag},
            },
          ),
      child: const _WrappedNewCollectionDialog(),
    );
  }

  final Account account;
  final bool isAllowDynamic;
}

class _WrappedNewCollectionDialog extends StatefulWidget {
  const _WrappedNewCollectionDialog();

  @override
  State<StatefulWidget> createState() => _WrappedNewCollectionDialogState();
}

@npLog
class _WrappedNewCollectionDialogState
    extends State<_WrappedNewCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<_Bloc, _State>(
          listenWhen:
              (previous, current) =>
                  previous.result != current.result && current.result != null,
          listener: _onResult,
        ),
        BlocListener<_Bloc, _State>(
          listenWhen: (previous, current) => previous.error != current.error,
          listener: (context, state) {
            if (state.error != null) {
              AppToast.showToast(
                context,
                msg: exception_util.toUserString(state.error!.error),
                duration: k.snackBarDurationNormal,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<_Bloc, _State>(
        buildWhen:
            (previous, current) =>
                previous.result != current.result ||
                previous.showDialog != current.showDialog,
        builder:
            (context, state) => Visibility(
              visible: state.result == null && state.showDialog,
              child: AlertDialog(
                title: Text(L10n.global().createCollectionTooltip),
                content: Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints.tightFor(width: 280),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _NameTextField(),
                        _ProviderDropdown(),
                        SizedBox(height: 8),
                        _ProviderDescription(),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      launch(help_util.collectionTypesUrl);
                    },
                    child: Text(L10n.global().learnMoreButtonLabel),
                  ),
                  TextButton(
                    onPressed: () => _onOkPressed(context),
                    child: Text(
                      MaterialLocalizations.of(context).okButtonLabel,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Future<void> _onOkPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() == true) {
      if (_bloc.state.formValue.provider == _ProviderOption.dir) {
        _bloc.add(const _HideDialog());
        final dirs = await Navigator.of(context).pushNamed<List<File>>(
          AlbumDirPicker.routeName,
          arguments: AlbumDirPickerArguments(_bloc.account),
        );
        if (dirs == null) {
          Navigator.of(context).pop();
          return;
        }
        _bloc
          ..add(_SubmitDirs(dirs))
          ..add(const _SubmitForm());
      } else if (_bloc.state.formValue.provider == _ProviderOption.tag) {
        _bloc.add(const _HideDialog());
        final tags = await showDialog<List<Tag>>(
          context: context,
          builder: (_) => TagPickerDialog(account: _bloc.account),
        );
        if (tags == null || tags.isEmpty) {
          Navigator.of(context).pop();
          return;
        }
        _bloc
          ..add(_SubmitTags(tags))
          ..add(const _SubmitForm());
      } else {
        _bloc.add(const _SubmitForm());
      }
    }
  }

  Future<void> _onResult(BuildContext context, _State state) async {
    unawaited(
      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (_) => ProcessingDialog(
              text: L10n.global().genericProcessingDialogContent,
            ),
      ),
    );
    try {
      final collection = await context
          .read<AccountController>()
          .collectionsController
          .createNew(state.result!);
      Navigator.of(context)
        ..pop()
        ..pop(collection);
    } catch (e, stackTrace) {
      _log.shout("[_onResult] Failed", e, stackTrace);
      unawaited(
        AppToast.showToast(
          context,
          msg: exception_util.toUserString(e),
          duration: k.snackBarDurationNormal,
        ),
      );
      Navigator.of(context)
        ..pop()
        ..pop();
    }
  }

  late final _bloc = context.read<_Bloc>();

  final _formKey = GlobalKey<FormState>();
}

class _NameTextField extends StatelessWidget {
  const _NameTextField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: L10n.global().nameInputHint),
      validator: (value) {
        if (value!.isEmpty) {
          return L10n.global().nameInputInvalidEmpty;
        }
        return null;
      },
      onChanged: (value) {
        context.read<_Bloc>().add(_SubmitName(value));
      },
    );
  }
}

class _ProviderDropdown extends StatelessWidget {
  const _ProviderDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_Bloc, _State>(
      buildWhen:
          (previous, current) =>
              previous.formValue.provider != current.formValue.provider,
      builder:
          (context, state) => DropdownButtonHideUnderline(
            child: DropdownButtonFormField<_ProviderOption>(
              value: state.formValue.provider,
              items:
                  state.supportedProviders
                      .map(
                        (e) => DropdownMenuItem<_ProviderOption>(
                          value: e,
                          child: Text(e.toValueString(context)),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                context.read<_Bloc>().add(_SubmitProvider(value!));
              },
            ),
          ),
    );
  }
}

class _ProviderDescription extends StatelessWidget {
  const _ProviderDescription();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_Bloc, _State>(
      buildWhen:
          (previous, current) =>
              previous.formValue.provider != current.formValue.provider,
      builder:
          (context, state) => Text(
            state.formValue.provider.toDescription(context),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
    );
  }
}

enum _ProviderOption {
  appAlbum,
  dir,
  tag,
  ncAlbum;

  String toValueString(BuildContext context) {
    switch (this) {
      case appAlbum:
        return L10n.global().createCollectionDialogAlbumLabel2;
      case dir:
        return L10n.global().createCollectionDialogFolderLabel;
      case tag:
        return L10n.global().createCollectionDialogTagLabel;
      case ncAlbum:
        return L10n.global().createCollectionDialogNextcloudAlbumLabel2;
    }
  }

  String toDescription(BuildContext context) {
    switch (this) {
      case appAlbum:
        return L10n.global().createCollectionDialogAlbumDescription2;
      case dir:
        return L10n.global().createCollectionDialogFolderDescription;
      case tag:
        return L10n.global().createCollectionDialogTagDescription;
      case ncAlbum:
        return L10n.global().createCollectionDialogNextcloudAlbumDescription2;
    }
  }
}
