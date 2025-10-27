import 'package:nc_photos/entity/any_file_util.dart';
import 'package:test/test.dart';

void main() {
  group("any_file_util", () {
    group(
      "deconstructedAnyFileMergeSorter",
      _testDeconstructedAnyFileMergeSorter,
    );
  });
}

void _testDeconstructedAnyFileMergeSorter() {
  test("normal", () {
    expect(
      [
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "b.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
      ]..sort(deconstructedAnyFileMergeSorter),
      [
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "b.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
      ],
    );
  });

  test("same name, slightly off time", () {
    expect(
      [
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "b.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 7)),
      ]..sort(deconstructedAnyFileMergeSorter),
      [
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 7)),
        (filename: "b.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
      ],
    );
  });

  test("same name, diff extension", () {
    expect(
      [
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "b.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "a.jxl", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
      ]..sort(deconstructedAnyFileMergeSorter),
      [
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "a.jxl", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "b.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
      ],
    );
  });

  test("same name, big time difference", () {
    expect(
      [
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "b.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "a.jpg", dateTime: DateTime(2001, 1, 2, 3, 4, 5)),
      ]..sort(deconstructedAnyFileMergeSorter),
      [
        (filename: "a.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "b.jpg", dateTime: DateTime(2000, 1, 2, 3, 4, 5)),
        (filename: "a.jpg", dateTime: DateTime(2001, 1, 2, 3, 4, 5)),
      ],
    );
  });
}
