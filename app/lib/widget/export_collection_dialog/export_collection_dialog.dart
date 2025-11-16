import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/collections_controller.dart';
import 'package:nc_photos/controller/server_controller.dart';
import 'package:nc_photos/entity/collection.dart';
import 'package:nc_photos/entity/collection/exporter.dart';
import 'package:nc_photos/entity/collection_item.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/toast.dart';
import 'package:nc_photos/widget/processing_dialog.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'export_collection_dialog.g.dart';
part 'state_event.dart';

class ExportCollectionDialog extends StatelessWidget {
  const ExportCollectionDialog({
    super.key,
    required this.account,
    required this.collection,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => _Bloc(
            account: account,
            collectionsController:
                context.read<AccountController>().collectionsController,
            collection: collection,
            items: items,
            supportedProviders: {
              _ProviderOption.appAlbum,
              if (context
                  .read<AccountController>()
                  .serverController
                  .isSupported(ServerFeature.ncAlbum))
                _ProviderOption.ncAlbum,
            },
          ),
      child: const _WrappedExportCollectionDialog(),
    );
  }

  final Account account;
  final Collection collection;
  final List<CollectionItem> items;
}

class _WrappedExportCollectionDialog extends StatefulWidget {
  const _WrappedExportCollectionDialog();

  @override
  State<StatefulWidget> createState() => _WrappedExportCollectionDialogState();
}

@npLog
class _WrappedExportCollectionDialogState
    extends State<_WrappedExportCollectionDialog> {
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
          listener: (_, state) {
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
            (previous, current) => previous.isExporting != current.isExporting,
        builder: (context, state) {
          if (state.isExporting) {
            return ProcessingDialog(
              text: L10n.global().genericProcessingDialogContent,
            );
          } else {
            return AlertDialog(
              title: Text(L10n.global().exportCollectionDialogTitle),
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
                  onPressed: () => _onOkPressed(context),
                  child: Text(MaterialLocalizations.of(context).okButtonLabel),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _onOkPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() == true) {
      _bloc.add(const _SubmitForm());
    }
  }

  void _onResult(BuildContext context, _State state) {
    Navigator.of(context).pop(state.result);
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
      initialValue: context.read<_Bloc>().state.formValue.name,
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
                  context
                      .read<_Bloc>()
                      .supportedProviders
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
  ncAlbum;

  String toValueString(BuildContext context) {
    switch (this) {
      case appAlbum:
        return L10n.global().createCollectionDialogAlbumLabel2;
      case ncAlbum:
        return L10n.global().createCollectionDialogNextcloudAlbumLabel2;
    }
  }

  String toDescription(BuildContext context) {
    switch (this) {
      case appAlbum:
        return L10n.global().createCollectionDialogAlbumDescription2;
      case ncAlbum:
        return L10n.global().createCollectionDialogNextcloudAlbumDescription2;
    }
  }
}
