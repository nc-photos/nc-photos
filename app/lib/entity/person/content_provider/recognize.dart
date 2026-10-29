import 'dart:math' as math;

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
  }) => items?.firstOrNull?.let(
    (i) => PersonCoverResult(
      url: getStaticViewUrlForImageFile(
        account,
        i.toFile(),
        size: SizeInt(width, height),
        isKeepAspectRatio: isKeepAspectRatio ?? false,
      ),
      mime: i.contentType,
    ),
  );

  @override
  Matrix4? getCoverTransform(Size viewportSize, Size imageSize) {
    final detection = items?.firstOrNull?.faceDetections?.firstWhereOrNull(
      (e) => e["title"] == face.label,
    );
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

    if (imageSize.width <= 0 ||
        imageSize.height <= 0 ||
        faceWNorm <= 0 ||
        faceHNorm <= 0) {
      return null;
    }

    final coverScale = math.max(
      viewportSize.width / imageSize.width,
      viewportSize.height / imageSize.height,
    );
    final coverW = imageSize.width * coverScale;
    final coverH = imageSize.height * coverScale;
    final coverDx = (viewportSize.width - coverW) / 2;
    final coverDy = (viewportSize.height - coverH) / 2;

    final faceX = coverDx + coverW * faceXNorm;
    final faceY = coverDy + coverH * faceYNorm;
    final faceW = coverW * faceWNorm;
    final faceH = coverH * faceHNorm;

    // scale image to focus on the face
    final ms = math.max(
      // slightly scale down to include pixels around the face
      math.min(viewportSize.width / faceW, viewportSize.height / faceH) * .75,
      1.0,
    );
    final scaledW = coverW * ms;
    final scaledH = coverH * ms;

    // center the scaled image
    var left = viewportSize.width / 2 - (faceX + faceW / 2) * ms + ms * coverDx;
    var top = viewportSize.height / 2 - (faceY + faceH / 2) * ms + ms * coverDy;
    // keep the whole viewport covered by the image
    left = left.clamp(viewportSize.width - scaledW, 0);
    top = top.clamp(viewportSize.height - scaledH, 0);

    return Matrix4.identity()
      ..translateByDouble(left - ms * coverDx, top - ms * coverDy, 0, 1)
      ..scaleByDouble(ms, ms, ms, 1);
  }

  @override
  List<Object?> get props => [account, face, items];

  final Account account;
  final RecognizeFace face;
  final List<RecognizeFaceItem>? items;
}
