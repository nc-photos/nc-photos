import 'package:np_math/src/num_extension.dart';
import 'package:test/test.dart';

void main() {
  group("NumExtension", () {
    group("inRange", () {
      test("[x, y)", () {
        expect(
          10.inRange(0, 20, isBegInclusive: true, isEndInclusive: false),
          true,
        );
        expect(
          0.inRange(0, 20, isBegInclusive: true, isEndInclusive: false),
          true,
        );
        expect(
          (-1).inRange(0, 20, isBegInclusive: true, isEndInclusive: false),
          false,
        );
        expect(
          20.inRange(0, 20, isBegInclusive: true, isEndInclusive: false),
          false,
        );
        expect(
          21.inRange(0, 20, isBegInclusive: true, isEndInclusive: false),
          false,
        );
      });

      test("[x, y]", () {
        expect(
          10.inRange(0, 20, isBegInclusive: true, isEndInclusive: true),
          true,
        );
        expect(
          0.inRange(0, 20, isBegInclusive: true, isEndInclusive: true),
          true,
        );
        expect(
          (-1).inRange(0, 20, isBegInclusive: true, isEndInclusive: true),
          false,
        );
        expect(
          20.inRange(0, 20, isBegInclusive: true, isEndInclusive: true),
          true,
        );
        expect(
          21.inRange(0, 20, isBegInclusive: true, isEndInclusive: true),
          false,
        );
      });

      test("(x, y)", () {
        expect(
          10.inRange(0, 20, isBegInclusive: false, isEndInclusive: false),
          true,
        );
        expect(
          0.inRange(0, 20, isBegInclusive: false, isEndInclusive: false),
          false,
        );
        expect(
          (-1).inRange(0, 20, isBegInclusive: false, isEndInclusive: false),
          false,
        );
        expect(
          20.inRange(0, 20, isBegInclusive: false, isEndInclusive: false),
          false,
        );
        expect(
          21.inRange(0, 20, isBegInclusive: false, isEndInclusive: false),
          false,
        );
      });

      test("(x, y]", () {
        expect(
          10.inRange(0, 20, isBegInclusive: false, isEndInclusive: true),
          true,
        );
        expect(
          0.inRange(0, 20, isBegInclusive: false, isEndInclusive: true),
          false,
        );
        expect(
          (-1).inRange(0, 20, isBegInclusive: false, isEndInclusive: true),
          false,
        );
        expect(
          20.inRange(0, 20, isBegInclusive: false, isEndInclusive: true),
          true,
        );
        expect(
          21.inRange(0, 20, isBegInclusive: false, isEndInclusive: true),
          false,
        );
      });
    });
  });
}
