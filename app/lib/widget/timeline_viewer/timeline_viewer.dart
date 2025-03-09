import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/db/entity_converter.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/flutter_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/remote_storage_util.dart' as remote_storage_util;
import 'package:nc_photos/widget/viewer/viewer.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';

part 'timeline_viewer.g.dart';

class TimelineViewerArguments {
  const TimelineViewerArguments({
    required this.initialFile,
    required this.initialIndex,
    required this.allFilesCount,
  });

  final FileDescriptor initialFile;
  final int initialIndex;
  final int allFilesCount;
}

class TimelineViewer extends StatelessWidget {
  static const routeName = "/timeline-viewer";

  static Route buildRoute(
          TimelineViewerArguments args, RouteSettings settings) =>
      CustomizableMaterialPageRoute(
        transitionDuration: k.heroDurationNormal,
        reverseTransitionDuration: k.heroDurationNormal,
        builder: (_) => TimelineViewer.fromArgs(args),
        settings: settings,
      );

  const TimelineViewer({
    super.key,
    required this.initialFile,
    required this.initialIndex,
    required this.allFilesCount,
  });

  TimelineViewer.fromArgs(TimelineViewerArguments args, {Key? key})
      : this(
          key: key,
          initialFile: args.initialFile,
          initialIndex: args.initialIndex,
          allFilesCount: args.allFilesCount,
        );

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return Viewer(
      contentProvider: _TimelineViewerContentProvider(
        KiwiContainer().resolve(),
        account: accountController.account,
        shareDirPath: file_util.unstripPath(accountController.account,
            accountController.accountPrefController.shareFolderValue),
      ),
      allFilesCount: allFilesCount,
      initialFile: initialFile,
      initialIndex: initialIndex,
    );
  }

  final FileDescriptor initialFile;
  final int initialIndex;
  final int allFilesCount;
}

@npLog
class _TimelineViewerContentProvider implements ViewerContentProvider {
  const _TimelineViewerContentProvider(
    this.c, {
    required this.account,
    required this.shareDirPath,
  });

  @override
  Future<ViewerContentProviderResult> getFiles(
      ViewerPositionInfo at, int count) async {
    _log.info("[getFiles] at: ${at.pageIndex}, count: $count");
    final files = await c.npDb.getFileDescriptors(
      account: account.toDb(),
      // need this because this arg expect empty string for root instead of "."
      includeRelativeRoots: account.roots
          .map((e) => File(path: file_util.unstripPath(account, e))
              .strippedPathWithEmpty)
          .toList(),
      includeRelativeDirs: [File(path: shareDirPath).strippedPathWithEmpty],
      excludeRelativeRoots: [remote_storage_util.remoteStorageDirRelativePath],
      isArchived: false,
      mimes: file_util.supportedFormatMimes,
      timeRange: count < 0
          ? TimeRange(from: at.originalFile.fdDateTime)
          : TimeRange(
              to: at.originalFile.fdDateTime,
              toBound: TimeRangeBound.inclusive),
      isAscending: count < 0,
      limit: count.abs(),
    );
    // because more than 1 photos may share the same date time, we need to
    // manually filter out those before us
    final pos = files.indexWhere((e) => e.fileId == at.originalFile.fdId);
    if (pos == -1) {
      // ???
      _log.severe("[getFiles] No results");
      return const ViewerContentProviderResult(files: []);
    }
    final results = files
        .pySlice(pos + 1)
        .map((e) =>
            DbFileDescriptorConverter.fromDb(account.userId.toString(), e))
        .toList();
    if (results.isEmpty) {
      return const ViewerContentProviderResult(files: []);
    }
    return ViewerContentProviderResult(files: results);
  }

  @override
  void notifyFileRemoved(int page, FileDescriptor file) {
    // we always query the latest data from db
  }

  final DiContainer c;
  final Account account;
  final String shareDirPath;
}
