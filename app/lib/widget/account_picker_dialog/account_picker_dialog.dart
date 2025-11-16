import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:mutex/mutex.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/bloc_util.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/entity/server_status.dart';
import 'package:nc_photos/exception_event.dart';
import 'package:nc_photos/exception_util.dart' as exception_util;
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/toast.dart';
import 'package:nc_photos/url_launcher_util.dart';
import 'package:nc_photos/widget/home/home.dart';
import 'package:nc_photos/widget/settings/account_settings.dart';
import 'package:nc_photos/widget/settings/settings.dart';
import 'package:nc_photos/widget/sign_in/sign_in.dart';
import 'package:np_db/np_db.dart';
import 'package:np_log/np_log.dart';
import 'package:to_string/to_string.dart';

part 'account_picker_dialog.g.dart';
part 'bloc.dart';
part 'state_event.dart';

typedef _BlocBuilder = BlocBuilder<_Bloc, _State>;
typedef _BlocListener = BlocListener<_Bloc, _State>;

class AccountPickerDialog extends StatelessWidget {
  const AccountPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => _Bloc(
            accountController: context.read(),
            prefController: context.read(),
            db: context.read(),
          ),
      child: const _WrappedAccountPickerDialog(),
    );
  }
}

class _WrappedAccountPickerDialog extends StatelessWidget {
  const _WrappedAccountPickerDialog();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        _BlocListener(
          listenWhen:
              (previous, current) =>
                  previous.newSelectAccount != current.newSelectAccount,
          listener: (context, state) {
            if (state.newSelectAccount != null) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                Home.routeName,
                (_) => false,
                arguments: HomeArguments(state.newSelectAccount!),
              );
            }
          },
        ),
        _BlocListener(
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
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            L10n.global().appTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        ValueStreamBuilder<bool>(
                          stream:
                              context
                                  .read<PrefController>()
                                  .isFollowSystemTheme,
                          builder: (_, isFollowSystemTheme) {
                            if (!isFollowSystemTheme.requireData) {
                              return Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: _DarkModeSwitch(
                                  onChanged: (value) {
                                    context.read<_Bloc>().add(
                                      _SetDarkTheme(value),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Material(
                          type: MaterialType.transparency,
                          child: _BlocBuilder(
                            buildWhen:
                                (previous, current) =>
                                    previous.isOpenDropdown !=
                                        current.isOpenDropdown ||
                                    previous.accounts != current.accounts,
                            builder: (context, state) {
                              final bloc = context.read<_Bloc>();
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const _AccountDropdown(),
                                  if (state.isOpenDropdown) ...[
                                    ...state.accounts
                                        .where(
                                          (a) => a.id != bloc.activeAccount.id,
                                        )
                                        .map((a) => _AccountView(account: a)),
                                    const _NewAccountView(),
                                  ] else
                                    const _AccountSettingsView(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    _IconTile(
                      icon: const Icon(Icons.settings_outlined),
                      title: Text(L10n.global().settingsMenuLabel),
                      isCircularSplash: true,
                      onTap: () {
                        Navigator.of(context)
                          ..pop()
                          ..pushNamed(Settings.routeName);
                      },
                    ),
                    _IconTile(
                      icon: const Icon(Icons.groups_outlined),
                      title: Text(L10n.global().contributorsTooltip),
                      isCircularSplash: true,
                      onTap: () {
                        Navigator.of(context).pop();
                        launch(help_util.contributorsUrl);
                      },
                    ),
                    _IconTile(
                      icon: const Icon(Icons.help_outline),
                      title: Text(L10n.global().helpTooltip),
                      isCircularSplash: true,
                      onTap: () {
                        Navigator.of(context).pop();
                        launch(help_util.mainUrl);
                      },
                    ),
                    const _AboutChin(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DarkModeSwitch extends StatelessWidget {
  const _DarkModeSwitch({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DarkModeSwitchTheme(
      child: Switch(
        value: Theme.of(context).brightness == Brightness.dark,
        onChanged: onChanged,
        activeThumbImage: const AssetImage(
          "assets/ic_dark_mode_switch_24dp.png",
        ),
        inactiveThumbImage: const AssetImage(
          "assets/ic_dark_mode_switch_24dp.png",
        ),
      ),
    );
  }

  final ValueChanged<bool>? onChanged;
}

class _AccountDropdown extends StatelessWidget {
  const _AccountDropdown();

  @override
  Widget build(BuildContext context) {
    return _AccountTile(
      account: context.read<_Bloc>().activeAccount,
      trailing: _BlocBuilder(
        builder: (_, state) {
          return AnimatedRotation(
            turns: state.isOpenDropdown ? .5 : 0,
            duration: k.animationDurationShort,
            child: IgnorePointer(
              ignoring: true,
              child: IconButton(
                onPressed: () {},
                color:
                    state.isOpenDropdown
                        ? Theme.of(context).colorScheme.primary
                        : null,
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
              ),
            ),
          );
        },
      ),
      onTap: () {
        context.read<_Bloc>().add(const _ToggleDropdown());
      },
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({required this.account, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final accountLabel = AccountPref.of(account).getAccountLabel();
    return ListTile(
      dense: true,
      leading: SizedBox.square(
        dimension: 40,
        child: Center(child: _AccountIcon(account)),
      ),
      title:
          accountLabel != null
              ? SizedBox(
                height: 64,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    accountLabel,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              )
              : Text(account.address, maxLines: 1, overflow: TextOverflow.clip),
      subtitle: accountLabel == null ? Text(account.username2) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  final Account account;
  final Widget? trailing;
  final VoidCallback? onTap;
}

class _AccountIcon extends StatelessWidget {
  const _AccountIcon(this.account);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: CachedNetworkImage(
        imageUrl: api_util.getAccountAvatarUrl(account, 64),
        fadeInDuration: const Duration(),
        filterQuality: FilterQuality.high,
      ),
    );
  }

  final Account account;
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.isCircularSplash = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = ListTile(
      dense: true,
      leading: SizedBox.square(dimension: 40, child: Center(child: icon)),
      title: title,
      onTap: onTap,
    );
    if (isCircularSplash) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(type: MaterialType.transparency, child: content),
      );
    } else {
      return content;
    }
  }

  final Widget icon;
  final Widget title;
  final VoidCallback? onTap;
  final bool isCircularSplash;
}

class _AccountView extends StatelessWidget {
  const _AccountView({required this.account});

  @override
  Widget build(BuildContext context) {
    final accountLabel = AccountPref.of(account).getAccountLabel();
    return _AccountTile(
      account: account,
      trailing: IconButton(
        icon: const Icon(Icons.logout_outlined),
        tooltip: L10n.global().deleteTooltip,
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder:
                (_) => _DeleteAccountConfirmDialog(
                  accountLabel: accountLabel ?? account.address,
                ),
          );
          if (!context.mounted || result != true) {
            return;
          }
          context.read<_Bloc>().add(_DeleteAccount(account));
        },
      ),
      onTap: () {
        context.read<_Bloc>().add(_SwitchAccount(account));
      },
    );
  }

  final Account account;
}

class _AccountSettingsView extends StatelessWidget {
  const _AccountSettingsView();

  @override
  Widget build(BuildContext context) {
    return _IconTile(
      icon: const Icon(Icons.manage_accounts_outlined),
      title: Text(L10n.global().accountSettingsTooltip),
      onTap: () {
        Navigator.of(context)
          ..pop()
          ..pushNamed(AccountSettings.routeName);
      },
    );
  }
}

class _NewAccountView extends StatelessWidget {
  const _NewAccountView();

  @override
  Widget build(BuildContext context) {
    return _IconTile(
      icon: const Icon(Icons.add_outlined),
      title: Text(L10n.global().addServerTooltip),
      onTap: () {
        Navigator.of(context)
          ..pop()
          ..pushNamed(SignIn.routeName);
      },
    );
  }
}

class _AboutChin extends StatelessWidget {
  const _AboutChin();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ServerStatus?>(
      stream: context.read<_Bloc>().accountController.serverController.status,
      initialData:
          context
              .read<_Bloc>()
              .accountController
              .serverController
              .status
              .valueOrNull,
      builder: (context, snapshot) {
        var text = "${L10n.global().appTitle} ${k.versionStr}";
        if (snapshot.hasData) {
          final status = snapshot.requireData!;
          text +=
              "  ${_getSymbol()}  ${status.productName} ${status.versionName}";
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        );
      },
    );
  }

  String _getSymbol() {
    final today = clock.now();
    if (today.month == 1 && today.day == 1) {
      // firework
      return "\u{1f386}";
    } else if (today.month == 4 && today.day == 10) {
      // initial commit!
      return "\u{1f382}";
    } else {
      const symbols = [
        // cloud
        "\u2601",
        // heart
        "\u2665",
        // star
        "\u2b50",
        // rainbow
        "\u{1f308}",
        // clover
        "\u{1f340}",
        // watermelon
        "\u{1f349}",
        // beach
        "\u{1f3d6}",
        // robot
        "\u{1f916}",
      ];
      return symbols[Random(_seed).nextInt(symbols.length)];
    }
  }

  static final _seed = Random().nextInt(65536);
}

class _DeleteAccountConfirmDialog extends StatelessWidget {
  const _DeleteAccountConfirmDialog({required this.accountLabel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(L10n.global().deleteAccountConfirmDialogText(accountLabel)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }

  final String accountLabel;
}
