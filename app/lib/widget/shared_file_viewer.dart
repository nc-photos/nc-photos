import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/cache_manager_util.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/share.dart';
import 'package:nc_photos/entity/share/data_source.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/snack_bar_manager.dart';
import 'package:nc_photos/use_case/remove.dart';
import 'package:nc_photos/use_case/remove_share.dart';
import 'package:nc_photos/widget/list_tile_center_leading.dart';
import 'package:np_log/np_log.dart';
import 'package:path/path.dart' as path_lib;

part 'shared_file_viewer.g.dart';

class SharedFileViewerArguments {
  SharedFileViewerArguments(this.account, this.file, this.shares);

  final Account account;
  final File file;
  final List<Share> shares;
}

/// Handle shares associated with a [File]
class SharedFileViewer extends StatefulWidget {
  static const routeName = "/shared-file-viewer";

  static Route buildRoute(
          SharedFileViewerArguments args, RouteSettings settings) =>
      MaterialPageRoute(
        builder: (context) => SharedFileViewer.fromArgs(args),
        settings: settings,
      );

  const SharedFileViewer({
    super.key,
    required this.account,
    required this.file,
    required this.shares,
  });

  SharedFileViewer.fromArgs(SharedFileViewerArguments args, {Key? key})
      : this(
          key: key,
          account: args.account,
          file: args.file,
          shares: args.shares,
        );

  @override
  createState() => _SharedFileViewerState();

  final Account account;
  final File file;
  final List<Share> shares;
}

@npLog
class _SharedFileViewerState extends State<SharedFileViewer> {
  @override
  build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(path_lib.withoutExtension(widget.file.filename)),
          pinned: true,
        ),
        if (widget.file.isCollection != true)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 256,
              child: FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImageBuilder(
                  type: CachedNetworkImageType.largeImage,
                  imageUrl:
                      getViewerUrlForImageFile(widget.account, widget.file),
                  mime: widget.file.fdMime,
                  account: widget.account,
                  errorWidget: (context, url, error) {
                    // just leave it empty
                    return Container();
                  },
                ).build(),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              L10n.global().locationLabel,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ListTile(
            title: Text(widget.file.strippedPath),
          ),
        ),
        if (widget.shares.first.uidOwner == widget.account.userId) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                L10n.global().sharedWithLabel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildShareItem(context, _shares[index]),
              childCount: _shares.length,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildShareItem(BuildContext context, Share share) {
    final dateStr = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY,
            Localizations.localeOf(context).languageCode)
        .format(share.stime.toLocal());
    return ListTile(
      title: Text(_getShareTitle(share)),
      subtitle: Text(dateStr),
      leading: ListTileCenterLeading(
        child: Icon(_getShareIcon(share)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (share.shareType == ShareType.publicLink)
            IconButton(
              onPressed: () => _onItemCopyPressed(share),
              icon: Tooltip(
                message: MaterialLocalizations.of(context).copyButtonLabel,
                child: const Icon(Icons.copy_outlined),
              ),
            ),
          PopupMenuButton<_ItemMenuOption>(
            tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _ItemMenuOption.unshare,
                child: Text(L10n.global().unshareTooltip),
              ),
            ],
            onSelected: (option) =>
                _onItemMenuOptionSelected(context, share, option),
          ),
        ],
      ),
    );
  }

  Future<void> _onItemCopyPressed(Share share) async {
    await Clipboard.setData(ClipboardData(text: share.url!));
    SnackBarManager().showSnackBar(SnackBar(
      content: Text(L10n.global().linkCopiedNotification),
      duration: k.snackBarDurationNormal,
    ));
  }

  void _onItemMenuOptionSelected(
      BuildContext context, Share share, _ItemMenuOption option) {
    switch (option) {
      case _ItemMenuOption.unshare:
        _onItemUnsharePressed(context, share);
        break;
    }
  }

  Future<void> _onItemUnsharePressed(BuildContext context, Share share) async {
    final shareRepo = ShareRepo(ShareRemoteDataSource());
    try {
      await RemoveShare(shareRepo)(widget.account, share);
      SnackBarManager().showSnackBar(SnackBar(
        content: Text(L10n.global().unshareSuccessNotification),
        duration: k.snackBarDurationNormal,
      ));
      if (_shares.length == 1) {
        // removing last share
        try {
          if (widget.file.path.startsWith(
              remote_storage_util.getRemoteLinkSharesDir(widget.account) +
                  "/")) {
            // file is a link share dir created by us
            if (await _askDeleteLinkShareDir()) {
              await _deleteLinkShareDir();
            }
          }
        } finally {
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      } else {
        setState(() {
          _shares.remove(share);
        });
      }
    } catch (e, stackTrace) {
      _log.shout(
          "[_onItemUnsharePressed] Failed while RemoveShare", e, stackTrace);
      SnackBarManager().showSnackBarForException(e);
    }
  }

  Future<bool> _askDeleteLinkShareDir() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(L10n.global().unshareLinkShareDirDialogTitle),
        content: Text(L10n.global().unshareLinkShareDirDialogContent),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(MaterialLocalizations.of(context).okButtonLabel)),
        ],
      ),
    );
    return result == true;
  }

  Future<void> _deleteLinkShareDir() {
    // the upper dir is also part of this link share dir
    var dirPath = path_lib.dirname(widget.file.path);
    // make sure we are not accidentally deleting other dirs
    if (!dirPath.startsWith(
        remote_storage_util.getRemoteLinkSharesDir(widget.account) + "/")) {
      _log.shout(
          "[_deleteLinkShareDir] Invalid upper dir to be deleted: $dirPath");
      dirPath = widget.file.path;
    }

    return Remove(KiwiContainer().resolve<DiContainer>())(
      widget.account,
      [widget.file.copyWith(path: dirPath)],
      shouldCleanUp: false,
    );
  }

  IconData? _getShareIcon(Share share) {
    switch (share.shareType) {
      case ShareType.user:
      case ShareType.email:
      case ShareType.federatedCloudShare:
        return Icons.person_outlined;
      case ShareType.group:
      case ShareType.circle:
        return Icons.group_outlined;
      case ShareType.publicLink:
        return Icons.link_outlined;
      case ShareType.talk:
        return Icons.sms_outlined;
      default:
        return null;
    }
  }

  String _getShareTitle(Share share) {
    if (share.shareType == ShareType.publicLink) {
      if (share.url!.startsWith(widget.account.url)) {
        return share.url!.substring(widget.account.url.length);
      } else {
        return share.url!;
      }
    } else {
      return share.shareWithDisplayName;
    }
  }

  late final List<Share> _shares = List.of(widget.shares);
}

enum _ItemMenuOption {
  unshare,
}
