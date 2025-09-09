import 'package:nc_photos/controller/pref_controller.dart';

class CompatV79 {
  static void migratePref(PrefController prefController) {
    if (prefController.hasLocalDirs()) {
      prefController.setLocalDirs(["DCIM", ...prefController.localDirsValue]);
    }
  }
}
