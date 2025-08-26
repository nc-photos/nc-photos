import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:to_string/to_string.dart';

part 'person.g.dart';

enum PersonProvider {
  none,
  faceRecognition,
  recognize;

  static PersonProvider fromValue(int value) => PersonProvider.values[value];
}

class PersonCoverResult {
  const PersonCoverResult({required this.url, required this.mime});

  final String url;
  final String? mime;
}

@genCopyWith
@toString
class Person with EquatableMixin {
  const Person({required this.name, required this.contentProvider});

  @override
  String toString() => _$toString();

  bool compareIdentity(Person other) => other.id == id;

  int get identityHashCode => id.hashCode;

  /// A unique id for each collection. The value is divided into two parts in
  /// the format XXXX-YYY...YYY, where XXXX is a four-character code
  /// representing the content provider type, and YYY is an implementation
  /// detail of each providers
  String get id => "${contentProvider.fourCc}-${contentProvider.id}";

  /// See [PersonContentProvider.count]
  int? get count => contentProvider.count;

  /// See [PersonContentProvider.getCoverUrl]
  PersonCoverResult? getCoverUrl(
    int width,
    int height, {
    bool? isKeepAspectRatio,
  }) => contentProvider.getCoverUrl(
    width,
    height,
    isKeepAspectRatio: isKeepAspectRatio,
  );

  /// See [PersonContentProvider.getCoverTransform]
  Matrix4? getCoverTransform(int viewportSize, int width, int height) =>
      contentProvider.getCoverTransform(viewportSize, width, height);

  @override
  List<Object?> get props => [name, contentProvider];

  final String name;
  final PersonContentProvider contentProvider;
}

abstract class PersonContentProvider with EquatableMixin {
  const PersonContentProvider();

  /// Unique FourCC of this provider type
  String get fourCc;

  /// Return the unique id of this person
  String get id;

  /// Return the number of items in this person, or null if not supported
  int? get count;

  /// Return the URL of the cover image if available
  ///
  /// The [width] and [height] are provided as a hint only, implementations are
  /// free to ignore them if it's not supported
  ///
  /// [isKeepAspectRatio] is only a hint and implementations may ignore it
  PersonCoverResult? getCoverUrl(
    int width,
    int height, {
    bool? isKeepAspectRatio,
  });

  /// Return the transformation matrix to focus the face
  ///
  /// Only viewport in square is supported
  Matrix4? getCoverTransform(int viewportSize, int width, int height);
}
