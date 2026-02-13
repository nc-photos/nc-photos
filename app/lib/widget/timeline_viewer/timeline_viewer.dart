import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/controller/account_controller.dart';
import 'package:nc_photos/controller/account_pref_controller.dart';
import 'package:nc_photos/controller/any_files_controller.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/any_file_util.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/file_util.dart' as file_util;
import 'package:nc_photos/entity/local_file.dart';
import 'package:nc_photos/exception_util.dart';
import 'package:nc_photos/flutter_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/use_case/any_file/find_any_file.dart';
import 'package:nc_photos/use_case/any_file/list_any_file_id_with_timestamp.dart';
import 'package:nc_photos/use_case/file/list_file.dart';
import 'package:nc_photos/use_case/local_file/list_local_file.dart';
import 'package:nc_photos/widget/viewer/viewer.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/exception.dart';
import 'package:np_common/object_util.dart';
import 'package:np_datetime/np_datetime.dart';
import 'package:np_log/np_log.dart';

part 'timeline_viewer.g.dart';

class TimelineViewerArguments {
  const TimelineViewerArguments({required this.initialFile});

  final AnyFile initialFile;
}

class TimelineViewer extends StatelessWidget {
  static const routeName = "/timeline-viewer";

  static Route buildRoute(
    TimelineViewerArguments args,
    RouteSettings settings,
  ) => CustomizableMaterialPageRoute(
    transitionDuration: k.heroDurationNormal,
    reverseTransitionDuration: k.heroDurationNormal,
    builder: (_) => TimelineViewer.fromArgs(args),
    settings: settings,
  );

  const TimelineViewer({super.key, required this.initialFile});

  TimelineViewer.fromArgs(TimelineViewerArguments args, {Key? key})
    : this(key: key, initialFile: args.initialFile);

  @override
  Widget build(BuildContext context) {
    final accountController = context.read<AccountController>();
    return Viewer(
      contentProvider: _TimelineViewerContentProvider(
        KiwiContainer().resolve(),
        anyFilesController: accountController.anyFilesController,
        account: accountController.account,
        shareDirPath: file_util.unstripPath(
          accountController.account,
          accountController.accountPrefController.shareFolderValue,
        ),
        prefController: context.read(),
      ),
      initialFile: initialFile,
    );
  }

  final AnyFile initialFile;
}

@npLog
class _TimelineViewerContentProvider implements ViewerContentProvider {
  const _TimelineViewerContentProvider(
    this.c, {
    required this.anyFilesController,
    required this.prefController,
    required this.account,
    required this.shareDirPath,
  });

  @override
  Future<ViewerContentProviderResult> getFiles(
    ViewerPositionInfo at,
    int count,
  ) async {
    _log.info("[getFiles] count: $count");
    // we don't know how many files will come from remote vs local, so we need
    // to query them both. Luckily, count is likely to be small here :D
    final List<AnyFile> remote;
    final List<AnyFile> local;
    try {
      (remote, local) =
          await (_getRemoteFiles(at, count), _getLocalFiles(at, count)).wait;
    } on ParallelWaitError catch (pe) {
      _log.severe(
        "[getFiles] Exceptions, 1: ${pe.errors.$1}, 2: ${pe.errors.$2}",
      );
      final (e, stackTrace) = firstErrorOf2(pe);
      Error.throwWithStackTrace(e, stackTrace);
    }
    if (remote.isEmpty && local.isEmpty) {
      return const ViewerContentProviderResult(files: []);
    }
    final files = _mergeSortedFileList(remote, local, count < 0);
    // because more than 1 photos may share the same date time, we need to
    // manually filter out those before us
    final pos = files.indexWhere((e) => e.id == at.originalFile.id);
    if (pos == -1) {
      // ???
      _log.severe("[getFiles] No results");
      return const ViewerContentProviderResult(files: []);
    }
    // results after [count] could be wrong due to potential buffer underrun in
    // one of the source
    final results = files.pySlice(pos + 1, count.abs());
    return ViewerContentProviderResult(files: results);
  }

  @override
  Future<AnyFile> getFile(int page, String afId) async {
    final results = await FindAnyFile(c, prefController: prefController)(
      account,
      [afId],
    );
    return results.first;
  }

  @override
  void notifyFileRemoved(int page, AnyFile file) {
    // we always query the latest data from db
  }

  @override
  Future<List<String>> listAfIds() async {
    final results = await ListAnyFileIdWithTimestamp(
      fileRepo: c.fileRepo2,
      localFileRepo: c.localFileRepo,
      prefController: prefController,
    )(
      account,
      shareDirPath,
      localDirWhitelist: prefController.localDirsValue,
      isArchived: false,
    );
    return results.map((e) => e.afId).toList();
  }

  Future<List<AnyFile>> _getRemoteFiles(
    ViewerPositionInfo at,
    int count,
  ) async {
    // we need this because the remote and local file may share a different
    // dateTime due to lower precision in Android's media store
    final originalFile =
        at.originalFile.provider.as<AnyFileMergedProvider>()?.asRemoteFile() ??
        at.originalFile;
    final raw = await ListFile(c)(
      account,
      shareDirPath,
      isArchived: false,
      timeRange:
          count < 0
              ? TimeRange(from: originalFile.dateTime)
              : TimeRange(
                to: originalFile.dateTime,
                toBound: TimeRangeBound.inclusive,
              ),
      isAscending: count < 0,
      limit: count.abs(),
    );
    return raw.map((e) => e.toAnyFile()).toList();
  }

  Future<List<AnyFile>> _getLocalFiles(ViewerPositionInfo at, int count) async {
    // we need this because the remote and local file may share a different
    // dateTime due to lower precision in Android's media store
    final originalFile =
        at.originalFile.provider.as<AnyFileMergedProvider>()?.asLocalFile() ??
        at.originalFile;
    try {
      final raw = await ListLocalFile(
        localFileRepo: c.localFileRepo,
        prefController: prefController,
      )(
        timeRange:
            count < 0
                ? TimeRange(from: originalFile.dateTime)
                : TimeRange(
                  to: originalFile.dateTime,
                  toBound: TimeRangeBound.inclusive,
                ),
        dirWhitelist: prefController.localDirsValue,
        isAscending: count < 0,
        limit: count.abs(),
      );
      return raw.map((e) => e.toAnyFile()).toList();
    } on PermissionException {
      // ignore permission not granted
      return [];
    }
  }

  List<AnyFile> _mergeSortedFileList(
    List<AnyFile> a,
    List<AnyFile> b,
    bool isAscending,
  ) {
    final sorted = [...a, ...b]..sort(anyFileMergeSorter);
    final merged = <AnyFile>[];
    for (final e in sorted) {
      if (merged.isEmpty) {
        merged.add(e);
        continue;
      }
      if (isAnyFileMergeable(merged.last, e)) {
        // merge
        final replace = merged.removeLast();
        final remote =
            replace.provider is AnyFileNextcloudProvider ? replace : e;
        final local = replace.provider is AnyFileLocalProvider ? replace : e;
        merged.add(
          AnyFile(
            provider: AnyFileMergedProvider(
              remote: remote.provider.cast(),
              local: local.provider.cast(),
            ),
          ),
        );
      } else {
        merged.add(e);
      }
    }

    if (isAscending) {
      merged.sort(anyFileDateTimeAscSorter);
    } else {
      merged.sort(anyFileDateTimeDescSorter);
    }
    return merged;
  }

  final DiContainer c;
  final AnyFilesController anyFilesController;
  final PrefController prefController;
  final Account account;
  final String shareDirPath;
}
