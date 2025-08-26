import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nc_photos/account.dart';
import 'package:nc_photos/api/api_util.dart' as api_util;
import 'package:nc_photos/entity/face_recognition_person.dart';
import 'package:nc_photos/entity/person.dart';
import 'package:to_string/to_string.dart';

part 'face_recognition.g.dart';

@toString
class PersonFaceRecognitionProvider
    with EquatableMixin
    implements PersonContentProvider {
  const PersonFaceRecognitionProvider({
    required this.account,
    required this.person,
  });

  @override
  String toString() => _$toString();

  @override
  String get fourCc => "FACR";

  @override
  String get id => person.name;

  @override
  int? get count => person.count;

  @override
  PersonCoverResult? getCoverUrl(
    int width,
    int height, {
    bool? isKeepAspectRatio,
  }) => PersonCoverResult(
    url: api_util.getFacePreviewUrl(
      account,
      person.thumbFaceId,
      size: math.max(width, height),
    ),
    mime: null,
  );

  @override
  Matrix4? getCoverTransform(int viewportSize, int width, int height) => null;

  @override
  List<Object?> get props => [account, person];

  final Account account;
  final FaceRecognitionPerson person;
}
