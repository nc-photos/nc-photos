import 'package:np_collection/src/list_extension.dart';
import 'package:test/test.dart';

void main() {
  group("ListExtension", () {
    test("takeIndex", () {
      expect([1, 2, 3, 4, 5, 6].takeIndex([5, 4, 3, 1, 0]), [6, 5, 4, 2, 1]);
    });

    group("pySlice", () {
      // [1, ..., 9]
      final list = List.generate(9, (i) => i + 1);

      /// Expected: [4, ..., 9]
      test("+start", () {
        expect(list.pySlice(3), List.generate(6, (i) => i + 4));
      });

      /// Expected: []
      test("+start > length", () {
        expect(list.pySlice(999), const []);
      });

      /// Expected: [4, 5]
      test("+start +stop", () {
        expect(list.pySlice(3, 5), const [4, 5]);
      });

      /// Expected: [4, ..., 9]
      test("+start +stop > length", () {
        expect(list.pySlice(3, 999), List.generate(6, (i) => i + 4));
      });

      /// Expected: []
      test("+start > +stop", () {
        expect(list.pySlice(5, 3), const []);
      });

      /// Expected: [5, ..., 9]
      test("-start", () {
        expect(list.pySlice(-5), List.generate(5, (i) => i + 5));
      });

      /// Expected: [1, ..., 9]
      test("-start < -length", () {
        expect(list.pySlice(-999), List.generate(9, (i) => i + 1));
      });

      /// Expected: [5, 6]
      test("-start -stop", () {
        expect(list.pySlice(-5, -3), const [5, 6]);
      });

      /// Expected: []
      test("-start -stop < -length", () {
        expect(list.pySlice(-5, -999), const []);
      });

      /// Expected: []
      test("-start < -stop", () {
        expect(list.pySlice(-3, -5), const []);
      });

      /// Expected: [4]
      test("+start -stop", () {
        expect(list.pySlice(3, -5), [4]);
      });

      /// Expected: [5, ..., 9]
      test("-start +stop", () {
        expect(list.pySlice(-5, 9), List.generate(5, (i) => i + 5));
      });

      /// Expected: [2, 4, 6, 8]
      test("step = 2", () {
        expect(list.pySlice(1, 9, 2), [2, 4, 6, 8]);
      });

      /// Expected: [1]
      test("step = 10", () {
        expect(list.pySlice(1, 9, 9), [2]);
      });
    });
  });
}
