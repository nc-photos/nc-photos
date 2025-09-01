import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/widget/convert_settings/convert_settings.dart';
import 'package:nc_photos/widget/upload_convert_warning_dialog/upload_convert_warning_dialog.dart';
import 'package:nc_photos/widget/upload_folder_picker.dart';
import 'package:np_log/np_log.dart';
import 'package:np_platform_uploader/np_platform_uploader.dart';
import 'package:to_string/to_string.dart';

part 'bloc.dart';
part 'state_event.dart';
part 'upload_dialog.g.dart';

@toString
class UploadConfig {
  const UploadConfig({required this.relativePath, this.convertConfig});

  @override
  String toString() => _$toString();

  final String relativePath;
  final ConvertConfig? convertConfig;
}

class UploadDialog extends StatelessWidget {
  const UploadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create:
          (context) => _Bloc(
            account: accountController.account,
            prefController: context.read(),
            accountPrefController: accountController.accountPrefController,
          ),
      child: const _WrappedUploadDialog(),
    );
  }
}

class _WrappedUploadDialog extends StatefulWidget {
  const _WrappedUploadDialog();

  @override
  State<StatefulWidget> createState() => _WrappedUploadDialogState();
}

class _WrappedUploadDialogState extends State<_WrappedUploadDialog> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListenerT(
          selector: (state) => state.uploadRelativePath,
          listener: (context, uploadPath) {
            _pathController.text = "/$uploadPath";
          },
        ),
        _BlocListenerT(
          selector: (state) => state.result,
          listener: (context, result) {
            if (result != null) {
              Navigator.of(context).pop(result);
            }
          },
        ),
      ],
      child: AlertDialog(
        title: Text(L10n.global().uploadTooltip),
        // contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.global().uploadDialogPath,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            InkWell(
              onTap: () => _onPathPressed(context),
              child: TextFormField(
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
                enabled: false,
                controller: _pathController,
              ),
            ),
            const SizedBox(height: 16),
            const _BatchConvertOption(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.addEvent(const _Confirm());
            },
            child: Text(L10n.global().uploadTooltip),
          ),
        ],
      ),
    );
  }

  Future<void> _onPathPressed(BuildContext context) async {
    final pick = await Navigator.of(context).pushNamed<String>(
      UploadFolderPicker.routeName,
      arguments: UploadFolderPickerArguments(
        context.bloc.account,
        context.state.uploadRelativePath,
      ),
    );
    if (pick != null && context.mounted) {
      context.addEvent(_SetUploadRelativePath(pick));
    }
  }

  late final _pathController = TextEditingController(
    text: "/${context.state.uploadRelativePath}",
  );
}

class _BatchConvertOption extends StatelessWidget {
  const _BatchConvertOption();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BlocSelector(
          selector: (state) => state.convertConfig,
          builder:
              (context, convertConfig) => CheckboxListTile(
                title: Text(L10n.global().uploadDialogBatchConvert),
                contentPadding: const EdgeInsets.all(0),
                value: convertConfig != null,
                onChanged: (value) {
                  context.addEvent(_SetEnableConvert(value!));
                  if (value) {
                    if (context
                        .bloc
                        .prefController
                        .isShowUploadConvertWarningValue) {
                      showDialog(
                        context: context,
                        builder:
                            (context) => const UploadConvertWarningDialog(),
                      );
                    }
                  }
                },
              ),
        ),
        _BlocSelector(
          selector: (state) => state.convertConfig,
          builder:
              (context, convertConfig) =>
                  convertConfig != null
                      ? ListTile(
                        title: Text(convertConfig.format.toDisplayString()),
                        subtitle: Text(_getDescription(convertConfig)),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(ConvertSettings.routeName);
                        },
                      )
                      : const SizedBox.shrink(),
        ),
      ],
    );
  }

  String _getDescription(ConvertConfig convertConfig) {
    var str = convertConfig.quality.toString();
    if (convertConfig.downsizeMp != null) {
      str =
          "$str | ${L10n.global().megapixelCount(convertConfig.downsizeMp!.toStringAsFixed(1))}";
    }
    return str;
  }
}

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
// typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocListenerT<T> = BlocListenerT<_Bloc, _State, T>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;
typedef _Emitter = Emitter<_State>;

extension on BuildContext {
  _Bloc get bloc => read<_Bloc>();
  _State get state => bloc.state;
  void addEvent(_Event event) => bloc.add(event);
}
