import 'dart:async';

import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/widget/home.dart';
import 'package:nc_photos/widget/page_visibility_mixin.dart';
import 'package:nc_photos/widget/root_picker.dart';
import 'package:nc_photos/widget/settings/settings_list_caption.dart';
import 'package:nc_photos/widget/share_folder_picker.dart';
import 'package:nc_photos/widget/simple_input_dialog.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:np_ui/np_ui.dart';
import 'package:to_string/to_string.dart';

part 'account/bloc.dart';
part 'account/state_event.dart';
part 'account_settings.g.dart';

// typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;
typedef _BlocSelector<T> = BlocSelector<_Bloc, _State, T>;

enum AccountSettingsOption {
  personProvider,
}

class AccountSettingsArguments {
  const AccountSettingsArguments({
    this.highlight,
  });

  final AccountSettingsOption? highlight;
}

class AccountSettings extends StatelessWidget {
  static const routeName = "/settings/account";

  static Route buildRoute(
          AccountSettingsArguments? args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (_) => AccountSettings.fromArgs(args),
        settings: settings,
      );

  const AccountSettings({
    super.key,
    this.highlight,
  });

  AccountSettings.fromArgs(AccountSettingsArguments? args, {Key? key})
      : this(
          key: key,
          highlight: args?.highlight,
        );

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return BlocProvider(
      create: (_) => _Bloc(
        account: accountController.account,
        prefController: context.read(),
        accountPrefController: accountController.accountPrefController,
        npDb: KiwiContainer().resolve<DiContainer>().npDb,
        highlight: highlight,
      ),
      child: const _WrappedAccountSettings(),
    );
  }

  final AccountSettingsOption? highlight;
}

class _WrappedAccountSettings extends StatefulWidget {
  const _WrappedAccountSettings();

  @override
  State<StatefulWidget> createState() => _WrappedAccountSettingsState();
}

@npLog
class _WrappedAccountSettingsState extends State<_WrappedAccountSettings>
    with RouteAware, PageVisibilityMixin, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _accountController = context.read();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    if (_bloc.state.shouldResync &&
        _bloc.state.personProvider != PersonProvider.none) {
      _log.fine("[dispose] Requesting to resync account");
      _accountController.syncController.requestResync(
        account: _bloc.state.account,
        filesController: _accountController.filesController,
        personsController: _accountController.personsController,
        personProvider: _bloc.state.personProvider,
      );
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          _BlocListener(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              if (state.error != null && isPageVisible()) {
                if (state.error is _AccountConflictError) {
                  SnackBarManager().showSnackBar(SnackBar(
                    content: Text(
                        L10n.global().editAccountConflictFailureNotification),
                    duration: k.snackBarDurationNormal,
                  ));
                } else if (state.error is _WritePrefError) {
                  SnackBarManager().showSnackBar(SnackBar(
                    content:
                        Text(L10n.global().writePreferenceFailureNotification),
                    duration: k.snackBarDurationNormal,
                  ));
                } else {
                  SnackBarManager()
                      .showSnackBarForException(state.error!.error);
                }
              }
            },
          ),
        ],
        child: _BlocSelector<bool>(
          selector: (state) => state.shouldReload,
          builder: (_, shouldReload) => PopScope(
            canPop: !shouldReload,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: Text(L10n.global().settingsAccountTitle),
                  leading:
                      shouldReload ? const _DoneButton() : const BackButton(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _BlocSelector<String?>(
                        selector: (state) => state.label,
                        builder: (context, state) => ListTile(
                          title: Text(L10n.global().settingsAccountLabelTitle),
                          subtitle: Text(state ??
                              L10n.global().settingsAccountLabelDescription),
                          onTap: () => _onLabelPressed(context),
                        ),
                      ),
                      _BlocSelector<Account>(
                        selector: (state) => state.account,
                        builder: (context, state) => ListTile(
                          title:
                              Text(L10n.global().settingsIncludedFoldersTitle),
                          subtitle:
                              Text(state.roots.map((e) => "/$e").join("; ")),
                          onTap: () => _onIncludedFoldersPressed(context),
                        ),
                      ),
                      _BlocSelector<String>(
                        selector: (state) => state.shareFolder,
                        builder: (context, state) => ListTile(
                          title: Text(L10n.global().settingsShareFolderTitle),
                          subtitle: Text("/$state"),
                          onTap: () => _onShareFolderPressed(context),
                        ),
                      ),
                      SettingsListCaption(
                        label: L10n.global().settingsServerAppSectionTitle,
                      ),
                      _BlocSelector<PersonProvider>(
                        selector: (state) => state.personProvider,
                        builder: (context, state) {
                          if (_bloc.highlight ==
                              AccountSettingsOption.personProvider) {
                            return AnimatedBuilder(
                              animation: _highlightAnimation,
                              builder: (context, child) => ListTile(
                                title: Text(
                                    L10n.global().settingsPersonProviderTitle),
                                subtitle: Text(state.toUserString()),
                                onTap: () => _onPersonProviderPressed(context),
                                tileColor: _highlightAnimation.value,
                              ),
                            );
                          } else {
                            return ListTile(
                              title: Text(
                                  L10n.global().settingsPersonProviderTitle),
                              subtitle: Text(state.toUserString()),
                              onTap: () => _onPersonProviderPressed(context),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLabelPressed(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleInputDialog(
        titleText: L10n.global().settingsAccountLabelTitle,
        buttonText: MaterialLocalizations.of(context).okButtonLabel,
        initialText: _bloc.state.label ?? "",
      ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    _bloc.add(_SetLabel(result.isEmpty ? null : result));
  }

  Future<void> _onIncludedFoldersPressed(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed<Account>(
      RootPicker.routeName,
      arguments: RootPickerArguments(_bloc.state.account),
    );
    if (result == null) {
      return;
    }
    if (result == _bloc.state.account) {
      // no changes, do nothing
      _log.fine("[_onIncludedFoldersPressed] No changes");
      return;
    }
    _bloc.add(_SetAccount(result));
  }

  Future<void> _onShareFolderPressed(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => _ShareFolderDialog(
        account: _bloc.state.account,
        initialValue: _bloc.state.shareFolder,
      ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    _bloc.add(_SetShareFolder(result));
  }

  Future<void> _onPersonProviderPressed(BuildContext context) async {
    final result = await showDialog<PersonProvider>(
      context: context,
      builder: (_) => _PersonProviderDialog(
        initialValue: _bloc.state.personProvider,
      ),
    );
    if (!context.mounted || result == null) {
      return;
    }
    _bloc.add(_SetPersonProvider(result));
  }

  late final _bloc = context.read<_Bloc>();
  late final AccountController _accountController;

  late final _animationController = AnimationController(
    vsync: this,
    duration: k.settingsHighlightDuration,
  );
  late final _highlightAnimation = ColorTween(
    end: Theme.of(context).colorScheme.primaryContainer,
  ).animate(_animationController);
}

class _DoneButton extends StatelessWidget {
  const _DoneButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.check),
      tooltip: L10n.global().doneButtonTooltip,
      onPressed: () {
        final newAccount = context.read<_Bloc>().state.account;
        context.read<AccountController>().setCurrentAccount(newAccount);
        Navigator.of(context).pushNamedAndRemoveUntil(
          Home.routeName,
          (_) => false,
          arguments: HomeArguments(newAccount),
        );
      },
    );
  }
}

class _ShareFolderDialog extends StatefulWidget {
  const _ShareFolderDialog({
    required this.account,
    required this.initialValue,
  });

  @override
  State<StatefulWidget> createState() => _ShareFolderDialogState();

  final Account account;
  final String initialValue;
}

class _ShareFolderDialogState extends State<_ShareFolderDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L10n.global().settingsShareFolderDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.global().settingsShareFolderDialogDescription),
            const SizedBox(height: 8),
            InkWell(
              onTap: _onTextFieldPressed,
              child: TextFormField(
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
                enabled: false,
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onOkPressed,
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }

  Future<void> _onTextFieldPressed() async {
    final pick = await Navigator.of(context).pushNamed<String>(
      ShareFolderPicker.routeName,
      arguments: ShareFolderPickerArguments(widget.account, _path),
    );
    if (pick != null) {
      _path = pick;
      _controller.text = "/$pick";
    }
  }

  void _onOkPressed() {
    Navigator.of(context).pop(_path);
  }

  final _formKey = GlobalKey<FormState>();
  late final _controller =
      TextEditingController(text: "/${widget.initialValue}");
  late String _path = widget.initialValue;
}

@npLog
class _PersonProviderDialog extends StatelessWidget {
  const _PersonProviderDialog({
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return FancyOptionPicker(
      title: Row(
        children: [
          Expanded(
            child: Text(L10n.global().settingsPersonProviderTitle),
          ),
          IconButton(
            onPressed: () {
              launch(help_util.peopleUrl);
            },
            tooltip: L10n.global().helpTooltip,
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      items: PersonProvider.values
          .map((provider) => FancyOptionPickerItem(
                label: provider.toUserString(),
                isSelected: provider == initialValue,
                onSelect: () {
                  _log.info("[build] Set provider: ${provider.toUserString()}");
                  Navigator.of(context).pop(provider);
                },
              ))
          .toList(),
    );
  }

  final PersonProvider initialValue;
}

extension on PersonProvider {
  String toUserString() {
    switch (this) {
      case PersonProvider.none:
        return "n/a";
      case PersonProvider.faceRecognition:
        return "Face Recognition";
      case PersonProvider.recognize:
        return "Recognize";
    }
  }
}
