import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/stream_util.dart';
import 'package:nc_photos/theme.dart';
import 'package:nc_photos/widget/account_picker_dialog.dart';
import 'package:nc_photos/widget/app_bar_circular_progress_indicator.dart';
import 'package:np_ui/np_ui.dart';

/// AppBar for home screens
class HomeSliverAppBar extends StatelessWidget {
  const HomeSliverAppBar({
    super.key,
    required this.account,
    this.actions,
    this.menuActions,
    this.onSelectedMenuActions,
    this.isShowProgressIcon = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return TranslucentSliverAppBar(
      title: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => const AccountPickerDialog(),
          );
        },
        child: _TitleView(account: account),
      ),
      scrolledUnderBackgroundColor:
          Theme.of(context).homeNavigationBarBackgroundColor,
      blurFilter: Theme.of(context).appBarBlurFilter,
      floating: true,
      automaticallyImplyLeading: false,
      bottom: bottom,
      actions: [
        ...actions ?? [],
        if (menuActions?.isNotEmpty == true)
          PopupMenuButton<int>(
            tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
            itemBuilder: (_) => menuActions!,
            onSelected: (option) {
              if (option >= 0) {
                onSelectedMenuActions?.call(option);
              }
            },
          ),
        _ProfileIconView(
          account: account,
          isProcessing: isShowProgressIcon,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const AccountPickerDialog(),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  final Account account;

  /// Screen specific action buttons
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  /// Screen specific actions under the overflow menu. The value of each item
  /// much >= 0
  final List<PopupMenuEntry<int>>? menuActions;
  final void Function(int)? onSelectedMenuActions;
  final bool isShowProgressIcon;
}

class _TitleView extends StatelessWidget {
  const _TitleView({required this.account});

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder<String?>(
      stream:
          context.read<AccountController>().accountPrefController.accountLabel,
      builder:
          (context, snapshot) => AppBarTitleContainer(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                account.scheme == "http"
                    ? Icon(
                      Icons.no_encryption_outlined,
                      color: Theme.of(context).colorScheme.error,
                      size: 16,
                    )
                    : Icon(
                      Icons.https_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                Text(
                  snapshot.data ?? account.address,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            subtitle: snapshot.data == null ? Text(account.username2) : null,
          ),
    );
  }

  final Account account;
}

class _ProfileIconView extends StatelessWidget {
  const _ProfileIconView({
    required this.account,
    required this.isProcessing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _size,
      child: Stack(
        children: [
          isProcessing
              ? const AppBarProgressIndicator()
              : ClipRRect(
                borderRadius: BorderRadius.circular(_size / 2),
                child: CachedNetworkImage(
                  imageUrl: api_util.getAccountAvatarUrl(account, 64),
                  fadeInDuration: const Duration(),
                  filterQuality: FilterQuality.high,
                ),
              ),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(_size / 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final Account account;
  final bool isProcessing;
  final VoidCallback onTap;

  static const _size = 40.0;
}
