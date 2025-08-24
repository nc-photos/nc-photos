import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/widget/viewer/viewer.dart';
import 'package:np_collection/np_collection.dart';

class CompatV77 {
  static void migratePref(PrefController prefController) {
    final oldValue = prefController.viewerBottomAppBarButtonsValue;
    final found = oldValue.indexOf(ViewerAppBarButtonType.download);
    final List<ViewerAppBarButtonType> newValue;
    if (found == -1) {
      newValue = oldValue.added(ViewerAppBarButtonType.upload);
    } else {
      newValue =
          oldValue.toList()..insert(found, ViewerAppBarButtonType.upload);
    }
    prefController.setViewerBottomAppBarButtons(newValue);
  }
}
