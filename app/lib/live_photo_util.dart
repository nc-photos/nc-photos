import 'package:nc_photos/entity/any_file.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

LivePhotoType? getLivePhotoTypeFromFile(AnyFile file) {
  final filenameL = file.afName.toLowerCase();
  if (filenameL.startsWith("pxl_") && filenameL.endsWith(".mp.jpg")) {
    return LivePhotoType.googleMp;
  } else if (filenameL.startsWith("pxl_") &&
      filenameL.endsWith(".mp.cover.jpg")) {
    // RAW
    return LivePhotoType.googleMp;
  } else if (filenameL.startsWith("mvimg_") && filenameL.endsWith(".jpg")) {
    return LivePhotoType.googleMvimg;
  } else {
    return null;
  }
}
