import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/flutter_util.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/widget/viewer/viewer.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_log/np_log.dart';

part 'collection_viewer.g.dart';

class CollectionViewerArguments {
  const CollectionViewerArguments(
    this.files,
    this.initialIndex,
    this.collectionId,
  );

  final List<FileDescriptor> files;
  final int initialIndex;
  final String? collectionId;
}

class CollectionViewer extends StatelessWidget {
  static const routeName = "/collection-viewer";

  static Route buildRoute(
          CollectionViewerArguments args, RouteSettings settings) =>
      CustomizableMaterialPageRoute(
        transitionDuration: k.heroDurationNormal,
        reverseTransitionDuration: k.heroDurationNormal,
        builder: (_) => CollectionViewer.fromArgs(args),
        settings: settings,
      );

  const CollectionViewer({
    super.key,
    required this.files,
    required this.initialIndex,
    required this.collectionId,
  });

  CollectionViewer.fromArgs(CollectionViewerArguments args, {Key? key})
      : this(
          key: key,
          files: args.files,
          initialIndex: args.initialIndex,
          collectionId: args.collectionId,
        );

  @override
  Widget build(BuildContext context) {
    return Viewer(
      contentProvider: _CollectionViewerContentProvider(files),
      allFilesCount: files.length,
      initialFile: files[initialIndex],
      initialIndex: initialIndex,
      collectionId: collectionId,
    );
  }

  final List<FileDescriptor> files;
  final int initialIndex;

  /// ID of the collection these files belongs to, or null
  final String? collectionId;
}

@npLog
class _CollectionViewerContentProvider implements ViewerContentProvider {
  const _CollectionViewerContentProvider(this.files);

  @override
  Future<ViewerContentProviderResult> getFiles(
      ViewerPositionInfo at, int count) async {
    if (count > 0) {
      final results = files.pySlice(at.pageIndex + 1, at.pageIndex + 1 + count);
      return ViewerContentProviderResult(files: results);
    } else {
      final results =
          files.pySlice(max(at.pageIndex - count.abs(), 0), at.pageIndex);
      return ViewerContentProviderResult(files: results.reversed.toList());
    }
  }

  @override
  void notifyFileRemoved(int page, FileDescriptor file) {
    if (files[page].fdId != file.fdId) {
      _log.warning(
          "[notifyFileRemoved] Removed file does not match record, page: $page, expected: ${files[page].fdId}, actual: ${file.fdId}");
    }
    files.removeAt(page);
  }

  final List<FileDescriptor> files;
}
