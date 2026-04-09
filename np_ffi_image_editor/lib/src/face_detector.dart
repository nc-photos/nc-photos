import 'dart:math';
import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'
    as mlkit;
import 'package:logging/logging.dart';
import 'package:np_common/object_util.dart';
import 'package:np_platform_raw_image/np_platform_raw_image.dart';

class FaceDetectorResult {
  const FaceDetectorResult({
    required this.boundingBox,
    required this.face,
    required this.leftEye,
    required this.rightEye,
    required this.noseBridge,
    required this.noseBottom,
  });

  final Rect boundingBox;
  final List<Point<double>>? face;
  final List<Point<double>>? leftEye;
  final List<Point<double>>? rightEye;
  final List<Point<double>>? noseBridge;
  final List<Point<double>>? noseBottom;
}

class FaceDetector {
  Future<List<FaceDetectorResult>> detect(Rgba8Image image) async {
    // stupid mlkit doesn't support getting multiple face contours. so we need
    // to run it multiple times with different cropping to get all faces
    final facesBBoxes = await _detectBBox(image);
    _log.info("[detect] Detected ${facesBBoxes.length} faces");
    final results = <FaceDetectorResult>[];
    for (final bBox in facesBBoxes) {
      _log.info(
        "[detect] Face bbox: {l: ${bBox.left}, t: ${bBox.top}, r: ${bBox.right}, b: ${bBox.bottom}}",
      );
      var roi = bBox
          .inflate(bBox.longestSide * .12)
          .let(
            (e) => Rect.fromLTRB(
              e.left.clamp(0, image.width.toDouble()),
              e.top.clamp(0, image.height.toDouble()),
              e.right.clamp(0, image.width.toDouble()),
              e.bottom.clamp(0, image.height.toDouble()),
            ),
          );
      final roiImg = await image.crop(roi);
      final f = await _detectSingleFace(roiImg);
      if (f == null) {
        _log.warning("[detect] Face not found in 2nd pass");
        continue;
      }

      // convert the points to make it closer to those from MARS/VNN, and thus
      // easier to port the shaders in gpupixel
      final face = f.contours[mlkit.FaceContourType.face]?.points.let(
        (points) => _convertFace(image, _roiToGlobal(points, roi)),
      );
      final leftEye = f.contours[mlkit.FaceContourType.leftEye]?.points.let(
        (points) => _convertEye(image, _roiToGlobal(points, roi)),
      );
      final rightEye = f.contours[mlkit.FaceContourType.rightEye]?.points.let(
        (points) => _convertEye(image, _roiToGlobal(points, roi)),
      );
      final noseBridge = f.contours[mlkit.FaceContourType.noseBridge]?.points
          .let(
            (points) => _convertNoseBridge(image, _roiToGlobal(points, roi)),
          );
      final noseBottom = f.contours[mlkit.FaceContourType.noseBottom]?.points
          .let(
            (points) => _convertNoseBottom(image, _roiToGlobal(points, roi)),
          );
      results.add(
        FaceDetectorResult(
          boundingBox: bBox,
          face: face,
          leftEye: leftEye,
          rightEye: rightEye,
          noseBridge: noseBridge,
          noseBottom: noseBottom,
        ),
      );
    }
    return results;
  }

  Future<List<Rect>> _detectBBox(Rgba8Image image) async {
    final input = mlkit.InputImage.fromBitmap(
      bitmap: image.pixel,
      width: image.width,
      height: image.height,
    );
    final opts = mlkit.FaceDetectorOptions(
      performanceMode: mlkit.FaceDetectorMode.accurate,
    );
    final faceDetector = mlkit.FaceDetector(options: opts);
    final faces = await faceDetector.processImage(input);
    return faces.map((e) => e.boundingBox).toList();
  }

  Future<mlkit.Face?> _detectSingleFace(Rgba8Image image) async {
    final input = mlkit.InputImage.fromBitmap(
      bitmap: image.pixel,
      width: image.width,
      height: image.height,
    );
    final opts = mlkit.FaceDetectorOptions(
      enableContours: true,
      performanceMode: mlkit.FaceDetectorMode.fast,
    );
    final faceDetector = mlkit.FaceDetector(options: opts);
    final faces = await faceDetector.processImage(input);
    return faces
        .where((f) => f.contours.values.any((e) => e != null))
        .firstOrNull;
  }

  List<Point<int>> _roiToGlobal(List<Point<int>> points, Rect roi) {
    return points
        .map((e) => Point(e.x + roi.left.round(), e.y + roi.top.round()))
        .toList();
  }

  List<Point<double>> _convertFace(Rgba8Image image, List<Point<int>> points) {
    final results = points
        .map((e) => Point(e.x / image.width, e.y / image.height))
        .toList();
    return results;
  }

  List<Point<double>> _convertEye(Rgba8Image image, List<Point<int>> points) {
    final results = points
        .map((e) => Point(e.x / image.width, e.y / image.height))
        .toList();
    results.add(
      Point(
        (results[4].x + results[12].x) / 2,
        (results[4].y + results[12].y) / 2,
      ),
    );
    return results;
  }

  List<Point<double>> _convertNoseBridge(
    Rgba8Image image,
    List<Point<int>> points,
  ) {
    final beg = Point(
      points.first.x / image.width,
      points.first.y / image.height,
    );
    final end = Point(
      points.last.x / image.width,
      points.last.y / image.height,
    );
    return [
      beg,
      Point(beg.x + (end.x - beg.x) / 3, beg.y + (end.y - beg.y) / 3),
      Point(beg.x + 2 * (end.x - beg.x) / 3, beg.y + 2 * (end.y - beg.y) / 3),
      end,
    ];
  }

  List<Point<double>> _convertNoseBottom(
    Rgba8Image image,
    List<Point<int>> points,
  ) {
    final beg = Point(
      points.first.x / image.width,
      points.first.y / image.height,
    );
    final mid = Point(points[1].x / image.width, points[1].y / image.height);
    final end = Point(
      points.last.x / image.width,
      points.last.y / image.height,
    );
    return [
      beg,
      Point(beg.x + (mid.x - beg.x) / 3, beg.y + (mid.y - beg.y) / 3),
      Point(beg.x + 2 * (mid.x - beg.x) / 3, beg.y + 2 * (mid.y - beg.y) / 3),
      mid,
      Point(mid.x + (end.x - mid.x) / 3, mid.y + (end.y - mid.y) / 3),
      Point(mid.x + 2 * (end.x - mid.x) / 3, mid.y + 2 * (end.y - mid.y) / 3),
      end,
    ];
  }

  static final _log = Logger("np_ffi_image_editor.FaceDetector");
}
