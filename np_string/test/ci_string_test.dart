// ignore_for_file: unrelated_type_equality_checks

import 'package:np_string/src/ci_string.dart';
import 'package:test/test.dart';

void main() {
  group("CiString", () {
    group("operator==", () {
      test("String w/ different case", () {
        expect(CiString("Alice") == "alice", true);
      });
      test("String w/ different content", () {
        expect(CiString("Alice") == "bob", false);
      });
      test("CiString w/ different case", () {
        expect(CiString("Alice") == CiString("alice"), true);
      });
      test("CiString w/ different content", () {
        expect(CiString("Alice") == CiString("bob"), false);
      });
      test("Unrelated type", () {
        expect(CiString("Alice") == Object(), false);
      });
    });

    group("hashCode", () {
      test("String w/ different case", () {
        expect(CiString("Alice").hashCode, "alice".hashCode);
      });
      test("String w/ different content", () {
        expect(CiString("Alice").hashCode != "bob".hashCode, true);
      });
      test("CiString w/ different case", () {
        expect(CiString("Alice").hashCode, CiString("alice").hashCode);
      });
      test("CiString w/ different content", () {
        expect(CiString("Alice").hashCode != CiString("bob").hashCode, true);
      });
    });

    group("compareTo", () {
      test("String w/ different case", () {
        expect(CiString("Alice").compareTo("alice"), 0);
      });
      test("String w/ different content (greater)", () {
        expect(CiString("Alice").compareTo("bob"), -1);
      });
      test("String w/ different content (less)", () {
        expect(CiString("Alice").compareTo("000"), 1);
      });
      test("CiString w/ different case", () {
        expect(CiString("Alice").compareTo(CiString("alice")), 0);
      });
      test("CiString w/ different content (greater)", () {
        expect(CiString("Alice").compareTo(CiString("bob")), -1);
      });
      test("CiString w/ different content (less)", () {
        expect(CiString("Alice").compareTo(CiString("000")), 1);
      });
      test("Unrelated type", () {
        expect(
          () => CiString("Alice").compareTo(Object()),
          throwsA(const TypeMatcher<TypeError>()),
        );
      });
    });

    group("endsWith", () {
      test("String w/ different case", () {
        expect(CiString("Alice").endsWith("ICE"), true);
      });
      test("String w/ different content", () {
        expect(CiString("Alice").endsWith("bob"), false);
      });
      test("CiString w/ different case", () {
        expect(CiString("Alice").endsWith(CiString("ICE")), true);
      });
      test("CiString w/ different content", () {
        expect(CiString("Alice").endsWith(CiString("bob")), false);
      });
      test("Unrelated type", () {
        expect(
          () => CiString("Alice").endsWith(Object()),
          throwsA(const TypeMatcher<TypeError>()),
        );
      });
    });

    group("startsWith", () {
      test("String w/ different case", () {
        expect(CiString("Alice").startsWith("ALI"), true);
      });
      test("String w/ different content", () {
        expect(CiString("Alice").startsWith("bob"), false);
      });
      test("CiString w/ different case", () {
        expect(CiString("Alice").startsWith(CiString("ALI")), true);
      });
      test("CiString w/ different content", () {
        expect(CiString("Alice").startsWith(CiString("bob")), false);
      });
      test("Unrelated type", () {
        expect(
          () => CiString("Alice").startsWith(Object()),
          throwsA(const TypeMatcher<TypeError>()),
        );
      });
    });

    group("contains", () {
      test("String w/ different case", () {
        expect(CiString("Alice").contains("LIC"), true);
      });
      test("String w/ different content", () {
        expect(CiString("Alice").contains("bob"), false);
      });
      test("Regex w/ different case", () {
        expect(CiString("Alice").contains(RegExp(r"LIC")), true);
      });
      test("Regex w/ different content", () {
        expect(CiString("Alice").contains(RegExp(r"bob")), false);
      });
    });
  });
}
