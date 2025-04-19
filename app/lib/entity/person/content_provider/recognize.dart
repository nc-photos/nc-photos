import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:nc_photos/entity/recognize_face.dart';
import 'package:nc_photos/entity/recognize_face_item.dart';
import 'package:nc_photos/file_view_util.dart';
import 'package:np_common/object_util.dart';
import 'package:np_common/size.dart';
import 'package:to_string/to_string.dart';

part 'recognize.g.dart';

@toString
class PersonRecognizeProvider
    with EquatableMixin
    implements PersonContentProvider {
  PersonRecognizeProvider({
    required this.account,
    required this.face,
    List<RecognizeFaceItem>? items,
  }) : items = items?.sorted((a, b) => b.fileId.compareTo(a.fileId));

  @override
  String toString() => _$toString();

  @override
  String get fourCc => "RCNZ";

  @override
  String get id => face.label;

  @override
  int? get count => items?.length;

  @override
  PersonCoverResult? getCoverUrl(
    int width,
    int height, {
    bool? isKeepAspectRatio,
  }) =>
      items?.firstOrNull?.let((i) => PersonCoverResult(
            url: getStaticViewUrlForImageFile(
              account,
              i.toFile(),
              size: SizeInt(width, height),
              isKeepAspectRatio: isKeepAspectRatio ?? false,
            ),
            mime: i.contentType,
          ));

  @override
  Matrix4? getCoverTransform(int viewportSize, int imgW, int imgH) {
    final detection = items?.firstOrNull?.faceDetections
        ?.firstWhereOrNull((e) => e["title"] == face.label);
    if (detection == null) {
      return null;
    }
    final faceXNorm = (detection["x"] as Object?).as<double>();
    final faceYNorm = (detection["y"] as Object?).as<double>();
    final faceHNorm = (detection["height"] as Object?).as<double>();
    final faceWNorm = (detection["width"] as Object?).as<double>();
    if (faceXNorm == null ||
        faceYNorm == null ||
        faceHNorm == null ||
        faceWNorm == null) {
      return null;
    }

    // move image to the face
    double mx = imgW * -faceXNorm;
    double my = imgH * -faceYNorm;
    // add offset in case image is not a square
    if (imgW > imgH) {
      mx += (imgW - imgH) / 2;
    } else if (imgH > imgW) {
      my += (imgH - imgW) / 2;
    }

    // scale image to focus on the face
    final faceW = imgW * faceWNorm;
    final faceH = imgH * faceHNorm;
    double ms;
    if (faceW > faceH) {
      ms = viewportSize / faceW;
    } else {
      ms = viewportSize / faceH;
    }
    // slightly scale down to include pixels around the face
    ms *= .75;

    // center the scaled image
    final resultFaceW = faceW * ms;
    final resultFaceH = faceH * ms;
    final cx = (viewportSize - resultFaceW) / 2;
    final cy = (viewportSize - resultFaceH) / 2;

    return Matrix4.identity()
      ..translate(cx, cy)
      ..scale(ms)
      ..translate(mx, my);
  }

  @override
  List<Object?> get props => [account, face, items];

  final Account account;
  final RecognizeFace face;
  final List<RecognizeFaceItem>? items;
}
