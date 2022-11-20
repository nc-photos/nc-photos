import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/album.dart';
import 'package:nc_photos/entity/album/item.dart';
import 'package:nc_photos/entity/album/provider.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/notified_action.dart';
import 'package:nc_photos/use_case/add_to_album.dart';
import 'package:nc_photos/use_case/inflate_file_descriptor.dart';
import 'package:nc_photos/widget/album_picker.dart';

class AddSelectionToAlbumHandler {
  AddSelectionToAlbumHandler(this._c)
      : assert(require(_c)),
        assert(InflateFileDescriptor.require(_c));

  static bool require(DiContainer c) => true;

  Future<void> call({
    required BuildContext context,
    required Account account,
    required List<FileDescriptor> selection,
    required VoidCallback clearSelection,
  }) async {
    try {
      final value = await Navigator.of(context).pushNamed<Album>(
          AlbumPicker.routeName,
          arguments: AlbumPickerArguments(account));
      if (value == null) {
        // user cancelled the dialog
        return;
      }

      _log.info("[call] Album picked: ${value.name}");
      await NotifiedAction(
        () async {
          assert(value.provider is AlbumStaticProvider);
          final selectedFiles =
              await InflateFileDescriptor(_c)(account, selection);
          final selected = selectedFiles
              .map((f) => AlbumFileItem(
                    addedBy: account.userId,
                    addedAt: DateTime.now(),
                    file: f,
                  ))
              .toList();
          clearSelection();
          await AddToAlbum(KiwiContainer().resolve<DiContainer>())(
              account, value, selected);
        },
        null,
        L10n.global().addSelectedToAlbumSuccessNotification(value.name),
        failureText: L10n.global().addSelectedToAlbumFailureNotification,
      )();
    } catch (e, stackTrace) {
      _log.shout("[call] Exception", e, stackTrace);
    }
  }

  final DiContainer _c;

  static final _log = Logger(
      "widget.handler.add_selection_to_album_handler.AddSelectionToAlbumHandler");
}
